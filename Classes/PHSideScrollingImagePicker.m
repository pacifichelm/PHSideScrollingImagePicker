//
//  PHSideScrollingImagePicker.m
//
//  Created by Patrick B. Gibson on 9/16/13.
//

#import "PHSideScrollingImagePicker.h"
#import "PHSideScrollingImagePickerCell.h"

#define kImageSpacing 6.0
#define kHorizontalCheckmarkInset -4.0

@interface PHSideScrollingLayout : UICollectionViewFlowLayout
@end

@implementation PHSideScrollingLayout
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context
{
    NSLog(@"invalidatin");
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        [cell setNeedsLayout];
        [self.collectionView.superview setNeedsLayout];
    }
    [super invalidateLayoutWithContext:context];
}
@end

@interface PHSideScrollingImagePicker () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *superviewConstraints;
@end

@implementation PHSideScrollingImagePicker

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}


- (void)setup
{
    // Configure the flow layout
    PHSideScrollingLayout *flow = [[PHSideScrollingLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = kImageSpacing;
    
    // Configure the collection view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.collectionViewLayout = flow;
    [collectionView registerClass:[PHSideScrollingImagePickerCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.superviewConstraints = [NSMutableArray array];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    
}

- (void)setImages:(NSArray *)images;
{
    self.selectedIndexes = [NSMutableArray array];
    self.imagesArray = [images copy];
    
    [self.collectionView reloadData];
}

- (NSArray *)selectedImageIndexes;
{
    return [_selectedIndexes copy];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.imagesArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PHSideScrollingImagePickerCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
//    [cell setNeedsUpdateConstraints];
//    [cell layoutIfNeeded];
//    [cell updateConstraintsIfNeeded];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSUInteger index = indexPath.row;
    NSNumber *path = @(index);
    
    PHSideScrollingImagePickerCell *cell = (PHSideScrollingImagePickerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedIndexes containsObject:path]) {
        [self.selectedIndexes removeObject:path];
        [cell setSelected:NO];
    } else {
        [self.selectedIndexes addObject:path];
        [cell setSelected:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidUpdateForPicker:)]) {
        [self.delegate selectionDidUpdateForPicker:self];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UIImage *imageAtPath = [self.imagesArray objectAtIndex:indexPath.row];
    
    CGFloat imageHeight = imageAtPath.size.height;
    CGFloat viewHeight = collectionView.bounds.size.height;
    CGFloat scaleFactor = viewHeight/imageHeight;
    
    CGSize scaledSize = CGSizeApplyAffineTransform(imageAtPath.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    return scaledSize;
}

- (void)updateConstraints
{
    [super updateConstraints];

    NSLog(@"updating");
    
    for (PHSideScrollingImagePickerCell *cell in self.collectionView.visibleCells) {
        
        // The checkmark should move left as the image moves offscreen to the right.
//        NSLayoutConstraint *floatingConstraintSlideToLeft =
//        [NSLayoutConstraint constraintWithItem:cell.checkmarkView
//                                     attribute:NSLayoutAttributeRight
//                                     relatedBy:NSLayoutRelationLessThanOrEqual
//                                        toItem:self.collectionView
//                                     attribute:NSLayoutAttributeRight
//                                    multiplier:1.0
//                                      constant:kHorizontalCheckmarkInset];
//        floatingConstraintSlideToLeft.priority = 1000;
//        [self.collectionView addConstraint:floatingConstraintSlideToLeft];
//        [self.superviewConstraints addObject:floatingConstraintSlideToLeft];
        
        // But, the checkmark should try to stick to the right edge of the superview.
        NSLayoutConstraint *floatingConstraintStickToRightEdge =
        [NSLayoutConstraint constraintWithItem:cell.checkmarkView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:kHorizontalCheckmarkInset];
        floatingConstraintStickToRightEdge.priority = 1000;
        [self addConstraint:floatingConstraintStickToRightEdge];
////        [self.superviewConstraints addObject:floatingConstraintStickToRightEdge];

        
    }
    


}

@end

//
//  PHSideScrollingImagePicker.m
//
//  Created by Patrick B. Gibson on 9/16/13.
//

#import "PHSideScrollingImagePicker.h"
#import "PHSideScrollingLayout.h"
#import "PHSideScrollingImagePickerCell.h"
#import "PHSideScrollingCheckCell.h"

#define kImageSpacing 6.0

@interface PHSideScrollingImagePicker () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMapTable *indexPathToCheckViewTable;
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
    [collectionView registerClass:[PHSideScrollingCheckCell class] forSupplementaryViewOfKind:@"check" withReuseIdentifier:@"CheckCell"];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.indexPathToCheckViewTable = [NSMapTable strongToWeakObjectsMapTable];
    
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PHSideScrollingImagePickerCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    PHSideScrollingCheckCell *checkView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CheckCell" forIndexPath:indexPath];
    [self.indexPathToCheckViewTable setObject:checkView forKey:indexPath];
    
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        [checkView setChecked:YES];
    }
    
    return checkView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [self toggleSelectionAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [self toggleSelectionAtIndexPath:indexPath];
}

- (void)toggleSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    NSNumber *path = @(index);
    
    PHSideScrollingImagePickerCell *cell = (PHSideScrollingImagePickerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    PHSideScrollingCheckCell *checkmarkView = [self.indexPathToCheckViewTable objectForKey:indexPath];
    
    // Manage internal selection state
    if ([self.selectedIndexes containsObject:path]) {
        [self.selectedIndexes removeObject:path];
        [cell setSelected:NO];
        [checkmarkView setChecked:NO];
    } else {
        [self.selectedIndexes addObject:path];
        [cell setSelected:YES];
        [checkmarkView setChecked:YES];
    }
    
    // Notify delegate
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


@end

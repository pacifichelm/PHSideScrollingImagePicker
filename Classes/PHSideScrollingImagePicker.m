//
//  PHSideScrollingImagePicker.m
//
//  Created by Patrick B. Gibson on 9/16/13.
//

#import "PHSideScrollingImagePicker.h"

#define kVerticalCheckmarkInset -2.0
#define kHorizontalCheckmarkInset -4.0
#define kImageSpacing 5.0

@interface PHSideScrollingImagePicker () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *checkmarkImageViews;
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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.showsHorizontalScrollIndicator = NO;
//    self.backgroundColor = [UIColor whiteColor];
    
    self.superviewConstraints = [NSMutableArray array];
}

- (void)setImages:(NSArray *)images;
{
    for (UIImageView *imageView in self.imageViews) {
        [imageView removeFromSuperview];
    }
    for (UIImageView *imageView in self.checkmarkImageViews) {
        [imageView removeFromSuperview];
    }
    
    self.selectedIndexes = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.checkmarkImageViews = [NSMutableArray array];
    
    for (UIImage *image in images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor =[UIColor magentaColor];
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        UIImage *emptyCheckmark = [UIImage imageNamed:@"unchecked.png"];
        UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:emptyCheckmark];
        checkmarkView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:checkmarkView];
        [self.checkmarkImageViews addObject:checkmarkView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:tap];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)imageViewTapped:(UITapGestureRecognizer *)sender;
{
    NSUInteger index = [self.imageViews indexOfObject:[sender view]];
    NSNumber *path = @(index);
    
    if ([self.selectedIndexes containsObject:path]) {
        [self.selectedIndexes removeObject:path];
        
        UIImage *emptyCheckmark = [UIImage imageNamed:@"unchecked.png"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:index];
        [checkmarkView setImage:emptyCheckmark];
        [self bringSubviewToFront:checkmarkView];
    } else {
        [self.selectedIndexes addObject:path];
        
        UIImage *fullCheckmark = [UIImage imageNamed:@"checked.png"];
        UIImageView *checkmarkView = [self.checkmarkImageViews objectAtIndex:index];
        [checkmarkView setImage:fullCheckmark];
        [self bringSubviewToFront:checkmarkView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidUpdateForPicker:)]) {
        [self.delegate selectionDidUpdateForPicker:self];
    }
}

- (NSArray *)selectedImageIndexes;
{
    return [_selectedIndexes copy];
}

- (void)updateConstraints
{
    [super updateConstraints];

    // Reset
    [self removeConstraints:self.constraints];
    [self.superview removeConstraints:self.superviewConstraints];
    [self.superviewConstraints removeAllObjects];

    
    // Bail early if there's no views
    if (self.imageViews.count <= 0) {
        return;
    }
    
    // For the first subview, set the leading on the left to 5
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViews[0]
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:kImageSpacing]];
    
    
    UIImageView *previousView = nil;
    for (UIImageView *subview in self.imageViews) {
        
        
        // Force the imageview to retain it's aspect ratio when resized.
        CGFloat aspectRatio = subview.intrinsicContentSize.height/subview.intrinsicContentSize.width;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subview
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:aspectRatio
                                                          constant:0]];
        
        
        // Center vertically in the scroll view, leave some space for padding.
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:0.98
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        

        // As long as we're not the first view, set the leading to the offset 5 points
        // from the previous view's right side.
        if (previousView) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previousView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:kImageSpacing]];
        }
        
        previousView = subview;
    }
    
    // On the last image view, set the trailing space to be -5 points to leave a bit of space.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViews[self.imageViews.count - 1]
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:-kImageSpacing]];
    
    // Set all the checkmark views to be in the bottom left of the image views.
    NSUInteger i = 0;
    for (UIImageView *checkmarkView in self.checkmarkImageViews) {
        
        UIImageView *matchingImageView = [self.imageViews objectAtIndex:i];
        
        // Position the checkmark view in the bottom of the image view
        [self addConstraint:[NSLayoutConstraint constraintWithItem:checkmarkView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:matchingImageView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:kVerticalCheckmarkInset]];

        // The checkmark should move left as the image moves offscreen to the right.
        NSLayoutConstraint *floatingConstraintSlideToLeft =
        [NSLayoutConstraint constraintWithItem:checkmarkView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:self.superview
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:kHorizontalCheckmarkInset];
        floatingConstraintSlideToLeft.priority = 450;
        [self.superview addConstraint:floatingConstraintSlideToLeft];
        [self.superviewConstraints addObject:floatingConstraintSlideToLeft];
 
        // But, the checkmark should try to stick to the right edge of the superview.
        NSLayoutConstraint *floatingConstraintStickToRightEdge =
        [NSLayoutConstraint constraintWithItem:checkmarkView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                        toItem:self.superview
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:kHorizontalCheckmarkInset];
        floatingConstraintStickToRightEdge.priority = 350;
        [self.superview addConstraint:floatingConstraintStickToRightEdge];
        [self.superviewConstraints addObject:floatingConstraintStickToRightEdge];

        
        // These two constraints ensure the checkbox never leaves the bounds (left and right) of the matching image view.
        NSLayoutConstraint *floatingBoundsConstraintLeft =
        [NSLayoutConstraint constraintWithItem:checkmarkView
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                        toItem:matchingImageView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:-kHorizontalCheckmarkInset];
        floatingBoundsConstraintLeft.priority = 1000;
        [self addConstraint:floatingBoundsConstraintLeft];

        NSLayoutConstraint *floatingBoundsConstraintRight =
        [NSLayoutConstraint constraintWithItem:checkmarkView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:matchingImageView
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:kHorizontalCheckmarkInset];
        floatingBoundsConstraintRight.priority = 1000;
        [self addConstraint:floatingBoundsConstraintRight];
        
        i++;
    }
}

@end

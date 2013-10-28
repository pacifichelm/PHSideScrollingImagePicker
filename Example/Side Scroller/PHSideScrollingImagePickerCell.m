//
//  PHSideScrollingImagePickerCell.m
//  Side Scroller
//
//  Created by Patrick Gibson on 10/27/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import "PHSideScrollingImagePickerCell.h"

#define kVerticalCheckmarkInset -2.0
#define kHorizontalCheckmarkInset -4.0

@interface PHSideScrollingImagePickerCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIImageView *checkmarkView;

@property (nonatomic, strong) NSMutableArray *superviewConstraints;
@end

@implementation PHSideScrollingImagePickerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    self.superviewConstraints = [NSMutableArray array];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
    checkmarkView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:checkmarkView];
    self.checkmarkView = checkmarkView;

    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, checkmarkView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    
    // Position the checkmark view in the bottom of the image view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:checkmarkView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:kVerticalCheckmarkInset]];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        UIImage *emptyCheckmark = [UIImage imageNamed:@"checked.png"];
        self.checkmarkView.image = emptyCheckmark;

    } else {
        UIImage *fullCheckmark = [UIImage imageNamed:@"unchecked.png"];
        self.checkmarkView.image = fullCheckmark;
    }
}

- (void)prepareForReuse
{
    [self setSelected:NO];
//    [self.superview removeConstraints:self.superviewConstraints];
}

- (void)layoutSubviews
{
    NSLog(@"layin out");
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    
    
//    // These two constraints ensure the checkbox never leaves the bounds (left and right) of the matching image view.
//    NSLayoutConstraint *floatingBoundsConstraintLeft =
//    [NSLayoutConstraint constraintWithItem:checkmarkView
//                                 attribute:NSLayoutAttributeLeft
//                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                    toItem:self
//                                 attribute:NSLayoutAttributeLeading
//                                multiplier:1.0
//                                  constant:-kHorizontalCheckmarkInset];
//    floatingBoundsConstraintLeft.priority = 1000;
//    [self addConstraint:floatingBoundsConstraintLeft];
//    
//    NSLayoutConstraint *floatingBoundsConstraintRight =
//    [NSLayoutConstraint constraintWithItem:checkmarkView
//                                 attribute:NSLayoutAttributeRight
//                                 relatedBy:NSLayoutRelationLessThanOrEqual
//                                    toItem:self
//                                 attribute:NSLayoutAttributeRight
//                                multiplier:1.0
//                                  constant:kHorizontalCheckmarkInset];
//    floatingBoundsConstraintRight.priority = 1000;
//    [self addConstraint:floatingBoundsConstraintRight];
}

@end

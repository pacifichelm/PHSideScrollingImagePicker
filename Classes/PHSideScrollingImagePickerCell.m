//
//  PHSideScrollingImagePickerCell.m
//  Side Scroller
//
//  Created by Patrick Gibson on 10/27/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import "PHSideScrollingImagePickerCell.h"

@interface PHSideScrollingImagePickerCell ()
@property (nonatomic, weak) UIImageView *imageView;
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;

    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
}

- (void)prepareForReuse
{
    [self setSelected:NO];
}

@end

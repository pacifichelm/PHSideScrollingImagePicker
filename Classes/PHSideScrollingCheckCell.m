//
//  PHCheckCell.m
//  Side Scroller
//
//  Created by Patrick B. Gibson on 11/3/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import "PHSideScrollingCheckCell.h"

@interface PHSideScrollingCheckCell ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation PHSideScrollingCheckCell

+ (CGSize)defaultSize;
{
    return [UIImage imageNamed:@"unchecked.png"].size;
}

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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)setChecked:(BOOL)checked;
{
    if (checked) {
        UIImage *emptyCheckmark = [UIImage imageNamed:@"checked.png"];
        self.imageView.image = emptyCheckmark;
        
    } else {
        UIImage *fullCheckmark = [UIImage imageNamed:@"unchecked.png"];
        self.imageView.image = fullCheckmark;
    }
}

- (void)prepareForReuse
{
    [self setChecked:NO];
}

@end

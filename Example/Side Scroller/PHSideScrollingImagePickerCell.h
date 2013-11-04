//
//  PHSideScrollingImagePickerCell.h
//  Side Scroller
//
//  Created by Patrick Gibson on 10/27/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHSideScrollingCheckCell.h"

@interface PHSideScrollingImagePickerCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, weak) PHSideScrollingCheckCell *check;

@end

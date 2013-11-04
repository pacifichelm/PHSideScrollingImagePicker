//
//  PHCheckCell.h
//  Side Scroller
//
//  Created by Patrick B. Gibson on 11/3/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHSideScrollingCheckCell : UICollectionReusableView

+ (CGSize)defaultSize;
- (void)setChecked:(BOOL)checked;

@end

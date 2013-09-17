//
//  PHSideScrollingImagePicker.h
//
//  Created by Patrick B. Gibson on 9/16/13.
//

#import <UIKit/UIKit.h>

@interface PHSideScrollingImagePicker : UIScrollView

@property (nonatomic, strong, readonly) NSArray *selectedImageIndexes;

- (void)setImages:(NSArray *)images;

@end

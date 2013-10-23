//
//  PHSideScrollingImagePicker.h
//
//  Created by Patrick B. Gibson on 9/16/13.
//

#import <UIKit/UIKit.h>

@class PHSideScrollingImagePicker;

@protocol PHSideScrollingImagePickerDelegate <UIScrollViewDelegate>
@optional
- (void)selectionDidUpdateForPicker:(PHSideScrollingImagePicker *)picker;
@end

@interface PHSideScrollingImagePicker : UIView

@property (nonatomic, weak) id<PHSideScrollingImagePickerDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *selectedImageIndexes;

- (void)setImages:(NSArray *)images;

@end

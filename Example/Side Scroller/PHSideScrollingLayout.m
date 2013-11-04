//
//  PHSideScrollingLayout.m
//  Side Scroller
//
//  Created by Patrick B. Gibson on 11/4/13.
//  Copyright (c) 2013 Pacific Helm. All rights reserved.
//

#import "PHSideScrollingLayout.h"

#import "PHSideScrollingCheckCell.h"

#define kHorizontalCheckmarkInset 4.0
#define kVericalCheckmarkInset 2.0


@implementation PHSideScrollingLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
{
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // Add our supplementary views, thet checkmark views
    for (UICollectionViewLayoutAttributes *attrs in [attributes copy]) {
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:@"check" atIndexPath:attrs.indexPath]];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // Capture some commonly used variables...
	CGRect collectionViewBounds = self.collectionView.bounds;
    CGFloat collectionViewXOffset = self.collectionView.contentOffset.x;
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *checkAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
	checkAttributes.size = [PHSideScrollingCheckCell defaultSize];
    checkAttributes.zIndex = 100;
    
    CGFloat checkVerticalCenter = CGRectGetMaxY(cellAttributes.frame) - kVericalCheckmarkInset - checkAttributes.size.height/2;
    
	checkAttributes.center = (CGPoint){
        CGRectGetMaxX(cellAttributes.frame) - kHorizontalCheckmarkInset - checkAttributes.size.width/2,
        checkVerticalCenter
    };
    
    // If the left side of the check view isn't visible, but the relative cell view is, move the check to the left so it is also visible.
    CGFloat leftSideOfCell = CGRectGetMinX(cellAttributes.frame);
    CGFloat rightSideOfVisibleArea = collectionViewXOffset + CGRectGetWidth(collectionViewBounds);
    if (leftSideOfCell < rightSideOfVisibleArea && CGRectGetMaxX(checkAttributes.frame) >= rightSideOfVisibleArea) {
        checkAttributes.center = (CGPoint){
            rightSideOfVisibleArea - checkAttributes.size.width/2,
            checkVerticalCenter
        };
    }
    
    // Never let the left side of the check view be less than the left side of the cell plus padding.
    if (CGRectGetMinX(checkAttributes.frame) < leftSideOfCell + kHorizontalCheckmarkInset) {
        checkAttributes.center = (CGPoint) {
            leftSideOfCell + kHorizontalCheckmarkInset + checkAttributes.size.width/2,
            checkVerticalCenter
        };
    }
    return checkAttributes;
}

@end

//
//  AppDelegate.m
//  CustomCalendar
//
//  Created by Susmita Horrow on 31/01/16.
//  Copyright © 2016 Ashutosh. All rights reserved.
//

#import "FullyHorizontalFlowLayout.h"

#define NumberOfColumn	7

@interface FullyHorizontalFlowLayout()

@property (nonatomic, strong) NSMutableDictionary *frameForIndexPath;

@end

@implementation FullyHorizontalFlowLayout

- (void)prepareLayout {
	[super prepareLayout];
	self.frameForIndexPath = [NSMutableDictionary dictionary];
	for(NSUInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
		for(NSUInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
			CGFloat startingX = 0.0;
			CGFloat startingY = 0.0;
			if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
				startingX = section * CGRectGetWidth(self.collectionView.frame);
				startingY = 0.0;

			}else {
				startingX = 0.0;
				startingY = section * CGRectGetHeight(self.collectionView.frame);

			}
			CGFloat width = self.collectionView.frame.size.width / 7.0;
			NSInteger rowNumber = item / 7;
			CGFloat originX = startingX + width * (item % 7);
			CGFloat originY = startingY + rowNumber * self.collectionView.frame.size.width / 8.0;
			CGFloat height = self.itemSize.height;
			CGRect cellFrame = CGRectMake(originX, originY, width, height);
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
			[self.frameForIndexPath setObject:NSStringFromCGRect(cellFrame) forKey:indexPath];
		}
	}
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath: indexPath];
	CGRect cellFrame = CGRectFromString([self.frameForIndexPath objectForKey: indexPath]);
	attributes.frame = cellFrame;
	return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
	NSMutableArray* elementsInRect = [NSMutableArray array];
	for(NSUInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
		for(NSUInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:item inSection:section];
			CGRect cellFrame = CGRectFromString([self.frameForIndexPath objectForKey: indexPath]);
			if(CGRectIntersectsRect(cellFrame, rect)) {
				//create the attributes object
				UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
				attr.frame = cellFrame;
				[elementsInRect addObject:attr];
			}
		}
	}

	return elementsInRect;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
	return YES;
}

- (CGSize)collectionViewContentSize{
	[super collectionViewContentSize];
	CGSize newSize;
	if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
		newSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.collectionView.numberOfSections * CGRectGetHeight(self.collectionView.frame));
	}else {
		newSize = CGSizeMake(self.collectionView.numberOfSections * CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
	}

	return newSize;
}

@end

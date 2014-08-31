//
//  HYPlazaViewLayout.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-19.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYPlazaViewLayout.h"

@interface HYPlazaViewLayout ()

@property (nonatomic, assign) NSInteger sectionCount;

@end

@implementation HYPlazaViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    _sectionCount = [self.collectionView numberOfSections];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSInteger i = 0; i < self.sectionCount; i++) {
        for (NSInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [allAttributes addObject:attributes];
        }
    }
    return allAttributes;
}

@end

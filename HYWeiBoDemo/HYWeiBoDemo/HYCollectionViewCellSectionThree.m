//
//  HYCollectionViewCellSectionThree.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-19.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYCollectionViewCellSectionThree.h"

@implementation HYCollectionViewCellSectionThree

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _labelTrend = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelTrend.textAlignment = NSTextAlignmentCenter;
        _labelTrend.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_labelTrend];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = CGRectMake(0, 0, 140, 40);
    self.labelTrend.frame = frame;
    self.labelTrend.text = [NSString stringWithFormat:@"#%@#", self.mDicTrends[@"name"]];
}

@end

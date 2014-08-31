//
//  NSString+FrameHight.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-26.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "NSString+FrameHight.h"

@implementation NSString (FrameHight)

- (CGFloat)frameHeightWithFountSize:(CGFloat)fontSize forViewWidth:(CGFloat)width
{
    //取出设置的系统字体的宽和高（size）
    NSDictionary *attributs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [self sizeWithAttributes:attributs];
    //用控件的宽度计算每一行显示的字的个数并向下取整
    NSUInteger wordsPerLine = floor(width / fontSize);
    CGFloat widthPerLine = fontSize * wordsPerLine;
    //显示的行数
    NSUInteger nLines = ceil(size.width / widthPerLine);
    CGFloat height = (nLines * size.height);
    return height;
}

@end

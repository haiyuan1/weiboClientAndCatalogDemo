//
//  HYViewControllerManager.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HYViewControllerType)
{
    HYViewControllerTypeUserGuideView,
    HYViewControllerTypeLoginView,
    HYViewControllerTypeMainView
};

@interface HYViewControllerManager : NSObject

+ (void)presentViewControllerWithType:(HYViewControllerType)type;

@end

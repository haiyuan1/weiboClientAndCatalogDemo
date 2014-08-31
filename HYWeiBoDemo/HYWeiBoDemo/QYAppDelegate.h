//
//  QYAppDelegate.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAppDelegate : UIResponder <UIApplicationDelegate, SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) SinaWeibo *sinaWeibo;

@end

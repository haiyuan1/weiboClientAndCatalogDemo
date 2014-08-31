//
//  QYAppDelegate.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "QYAppDelegate.h"
#import "QYSinaWeiboDelegate.h"

@implementation QYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLaunchStatus];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    QYSinaWeiboDelegate *sinaWeiboDelegate = [[QYSinaWeiboDelegate alloc] init];
    _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:sinaWeiboDelegate];
    
    NSDictionary *sinaWeiboInfo = [NSUD objectForKey:kAuthDataKey];
    if ([sinaWeiboInfo objectForKey:kAuthAccessTokenKey] &&
        [sinaWeiboInfo objectForKey:kAuthUserIDKey] &&
        [sinaWeiboInfo objectForKey:kAuthExpirationDateKey]) {
        _sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:kAuthAccessTokenKey];
        _sinaWeibo.userID = [sinaWeiboInfo objectForKey:kAuthUserIDKey];
        _sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:kAuthExpirationDateKey];
    }
    
    if ([NSUD boolForKey:kFirstLaunched]) {
        [HYViewControllerManager presentViewControllerWithType:HYViewControllerTypeUserGuideView];
    } else {
        if ([self.sinaWeibo isLoggedIn]) {
            [HYViewControllerManager presentViewControllerWithType:HYViewControllerTypeMainView];
        } else {
            [HYViewControllerManager presentViewControllerWithType:HYViewControllerTypeLoginView];
        }
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - init launched status
- (void)initLaunchStatus
{
    if (![NSUD boolForKey:kEverLaunched]) {
        [NSUD setBool:YES forKey:kEverLaunched];
        [NSUD setBool:YES forKey:kFirstLaunched];
    } else {
        [NSUD setBool:NO forKey:kFirstLaunched];
    }
    [NSUD synchronize];
}

- (void)dealloc
{
    HYSafeRelease(_sinaWeibo);
    HYSafeRelease(_window);
    [super dealloc];
}

@end

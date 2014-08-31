//
//  QYSinaWeiboDelegate.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-25.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "QYSinaWeiboDelegate.h"

@implementation QYSinaWeiboDelegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData:sinaweibo];
    [HYNSDC postNotificationName:kHYNotificationNameLogin object:nil];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [HYNSDC postNotificationName:kHYNotificationNameLogoff object:nil];
    [self removeAuthData:sinaweibo];
}

- (void)storeAuthData:(SinaWeibo *)sinaweibo
{
    NSDictionary *authData = @{kAuthAccessTokenKey: sinaweibo.accessToken,
                               kAuthUserIDKey: sinaweibo.userID,
                               kAuthExpirationDateKey: sinaweibo.expirationDate};
    [NSUD setObject:authData forKey:kAuthDataKey];
    [NSUD synchronize];
}

- (void)removeAuthData:(SinaWeibo *)sinaweibo
{
    [NSUD removeObjectForKey:kAuthDataKey];
    [NSUD synchronize];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"Login error: %@", error);
}

@end

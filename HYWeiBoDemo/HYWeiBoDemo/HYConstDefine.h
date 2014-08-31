//
//  HYConstDefine.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#ifndef HYWeiBoDemo_HYConstDefine_h
#define HYWeiBoDemo_HYConstDefine_h

#define kAppKey                 @"4246590151"
#define kAppSecret              @"592f1a3b81551c341a713bf8b696b9f1"
#define kAppRedirectURI         @"https://api.weibo.com/oauth2/default.html"


#define kEverLaunched           @"everLaunched"
#define kFirstLaunched          @"firstLaunched"



#define kAuthDataKey            @"SinaWeiboAuthData"
#define kAuthAccessTokenKey     @"AccessTokenKey"
#define kAuthUserIDKey          @"UserIDKey"
#define kAuthExpirationDateKey  @"ExpirationDateKey"
#define kAuthRefreshTokenKey    @"refreshToken"

#define kHYNotificationNameLogin    @"notificationLogin"
#define kHYNotificationNameLogoff   @"notificationLogoff"

#define NSUD    [NSUserDefaults standardUserDefaults]

#define HYNSDC  [NSNotificationCenter defaultCenter]

#define AppDelegate ((QYAppDelegate *)[UIApplication sharedApplication].delegate)

#define HYSafeRelease(_pointer) {[_pointer release], _pointer = nil;}

static NSString * const kStatuesCreateTime = @"created_at";
static NSString * const kStatuesID = @"id";
static NSString * const kStatuesMID = @"mid";
static NSString * const kStatuesText = @"text";
static NSString * const kStatuesSource = @"source";
static NSString * const kStatuesThumbnailPic = @"thumbnail_pic";
static NSString * const kStatuesOriginalPic = @"original_pic";
static NSString * const kStatuesPicUrls = @"pic_urls";
static NSString * const kStatuesRetweetStatues = @"retweeted_status";
static NSString * const kStatuesUserInfo = @"user";
static NSString * const kStatuesRetweetStatuesID = @"retweeted_status_id";
static NSString * const kStatuesRepostsCount = @"reposts_count";
static NSString * const kStatuesCommentCount = @"comments_count";
static NSString * const kStatuesAttitudesCount = @"attitudes_count";

static NSString * const kUserInfoScreenName = @"screen_name";
static NSString * const kUserInfoName = @"name";
static NSString * const kUserAvatarLarge = @"avatar_large";
static NSString * const kUserAvatarHd = @"avatar_hd";
static NSString * const kUserID = @"id";
static NSString * const kUserFriendsCount = @"friends_count";
static NSString * const kUserFollowersCount = @"followers_count";
static NSString * const kUserStatusesCount = @"statuses_count";
static NSString * const kUserFavouritesCount = @"favourites_count";
static NSString * const kUserVerifiedReason = @"verified_reason";
static NSString * const kUserDescription = @"description";
static NSString * const kUserStatusInfo = @"status";
static NSString * const kUserStatuses = @"statuses";
static NSString * const kUserStatuesID = @"id";

static NSString * const kFriendUser = @"users";
static NSString * const kFriendUserProfileImageUrl = @"profile_image_url";

static NSString * const kHYWeiBoDataBaseName = @"HY_weibo_client";

#endif

//
//  HYWeiBoDataBaseEngine.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-8.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYWeiBoDataBaseEngine.h"
#import "FMDatabase.h"

@interface HYWeiBoDataBaseEngine ()

@property (nonatomic, retain) FMDatabase *mDb;

@end

@implementation HYWeiBoDataBaseEngine

+ (instancetype)shareInstance
{
    static HYWeiBoDataBaseEngine *dbEngine = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        dbEngine = [[self alloc] init];
    });
    return dbEngine;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *dbName = [NSString stringWithFormat:@"%@.sqlite", kHYWeiBoDataBaseName];
        NSString *dbPath = [self copyFile2Documents:dbName];
        self.mDb = [FMDatabase databaseWithPath:dbPath];
        if (![_mDb open]) {
            NSLog(@"Open %@ Error! error msg is %@", dbPath, [_mDb lastErrorMessage]);
        }
    }
    return self;
}

- (NSString *)copyFile2Documents:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:kHYWeiBoDataBaseName ofType:@"sqlite"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        if (error != nil) {
            NSLog(@"%@",error);
            return @"";
        }
    }
    return destPath;
}

- (void)saveTimeLinesToDataBase:(NSArray *)timeLines
{
    for (NSDictionary *dicStatus in timeLines) {
        [self saveStatusToDataBase:dicStatus];
    }
}

- (void)saveTempStatusToDrafts:(NSDictionary *)tempStatus
{
    
}

- (void)saveUserInfoToDataBase:(NSDictionary *)dicUserInfo withStatusID:(NSString *)statusID
{
    if (dicUserInfo != nil) {
        NSString *sql = @"insert into t_user \
        (id,user_id,screen_name,name,status_id,avatar_large) \
        values (null,?,?,?,?,?)";
        BOOL isOK = [self.mDb executeUpdate:sql, [dicUserInfo objectForKey:kUserID], [dicUserInfo objectForKey:kUserInfoScreenName], [dicUserInfo objectForKey:kUserInfoName], statusID, [dicUserInfo objectForKey:kUserAvatarLarge]];
        if (!isOK) {
            NSLog(@"Save user info to db failed. Error:%@", [self.mDb lastErrorMessage]);
            return;
        }
        
    }
}

- (void)saveStatusToDataBase:(NSDictionary *)dicStatus
{
    NSString *sql = @"insert into t_status (id,status_id,created_at,text,source,thumbnail_pic, \
                    original_pic,user_id,retweeted_status_id,reposts_count, \
                    comments_count,attitudes_count) values \
                    (null,?,?,?,?,?,?,?,?,?,?,?)";
    BOOL isOK = [self.mDb executeUpdate:sql,
                 [dicStatus objectForKey:kStatuesID],
                 [dicStatus objectForKey:kStatuesCreateTime],
                 [dicStatus objectForKey:kStatuesText],
                 [dicStatus objectForKey:kStatuesSource],
                 [dicStatus objectForKey:kStatuesThumbnailPic],
                 [dicStatus objectForKey:kStatuesOriginalPic],
                 [[dicStatus objectForKey:kStatuesUserInfo] objectForKey:kUserID],
                 [[dicStatus objectForKey:kStatuesRetweetStatues] objectForKey:kStatuesID],
                 [dicStatus objectForKey:kStatuesRepostsCount],
                 [dicStatus objectForKey:kStatuesCommentCount],
                 [dicStatus objectForKey:kStatuesAttitudesCount]];
    if (!isOK) {
        NSLog(@"Save status to db failed. Error:%@", [self.mDb lastErrorMessage]);
        return;
    }
    [self saveUserInfoToDataBase:[dicStatus objectForKey:kStatuesUserInfo] withStatusID:[dicStatus objectForKey:kStatuesID]];
    NSDictionary *dicRetweetStatus = [dicStatus objectForKey:kStatuesRetweetStatues];
    if (dicRetweetStatus != nil) {
        [self saveStatusToDataBase:dicRetweetStatus];
    } else {
        NSLog(@"Warrning: save data parame is emporty");
    }
}

- (NSArray *)queryTimeLinesFromDataBase
{
    NSString *sql = @"SELECT status_id,created_at,text,source,thumbnail_pic, \
                    original_pic,user_id,retweeted_status_id,reposts_count,comments_count, \
                    attitudes_count FROM t_status \
                    where created_at < ? limit 20";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    FMResultSet *resultSet = [self.mDb executeQuery:sql, currentDate];
    NSMutableArray *arrayRet = [[NSMutableArray alloc] initWithCapacity:20];
    while ([resultSet next]) {
        NSDictionary *userInfo = [self queryUserInfoFromDataBase:[resultSet objectForColumnIndex:6]];
        if (nil == userInfo) {
            return nil;
        }
        NSDictionary *statusInfo = [self queryStatusFromDataBase:[resultSet objectForColumnIndex:7]];
        if (statusInfo != nil) {
            [arrayRet addObject:@{kStatuesID: [resultSet objectForColumnIndex:0],
                                  kStatuesCreateTime: [resultSet objectForColumnIndex:1],
                                  kStatuesText: [resultSet objectForColumnIndex:2],
                                  kStatuesSource: [resultSet objectForColumnIndex:3],
                                  kStatuesThumbnailPic: [resultSet objectForColumnIndex:4],
                                  kStatuesOriginalPic: [resultSet objectForColumnIndex:5],
                                  kStatuesUserInfo: userInfo,
                                  kStatuesRetweetStatues: statusInfo,
                                  }];
        } else {
            [arrayRet addObject:@{kStatuesID: [resultSet objectForColumnIndex:0],
                                 kStatuesCreateTime: [resultSet objectForColumnIndex:1],
                                 kStatuesText: [resultSet objectForColumnIndex:2],
                                 kStatuesSource: [resultSet objectForColumnIndex:3],
                                 kStatuesThumbnailPic: [resultSet objectForColumnIndex:4],
                                 kStatuesOriginalPic: [resultSet objectForColumnIndex:5],
                                 kStatuesUserInfo: userInfo,
                                  }];
        }
    }
    return arrayRet;
}

- (NSDictionary *)queryTempStatusFromDataBase
{
    return nil;
}

- (NSDictionary *)queryUserInfoFromDataBase:(NSString *)userId
{
    NSString *sql = @"SELECT user_id,screen_name,name,avatar_large FROM t_user where user_id = ?";
    FMResultSet *userInfo = [self.mDb executeQuery:sql, userId];
    NSDictionary *dicRet = nil;
    while ([userInfo next]) {
        dicRet = @{kUserID: [userInfo objectForColumnIndex:0],
                   kUserInfoScreenName: [userInfo objectForColumnIndex:1],
                   kUserInfoName: [userInfo objectForColumnIndex:2],
                   kUserAvatarLarge: [userInfo objectForColumnIndex:3]};
    }
    return dicRet;
}

- (NSDictionary *)queryStatusFromDataBase:(NSString *)statusId
{
    NSString *sql = @"SELECT created_at,text,source,thumbnail_pic,original_pic \
                    reposts_count,comments_count,attitudes_count FROM t_status where status_id = ?";
    FMResultSet *statusInfo = [self.mDb executeQuery:sql, statusId];
    NSDictionary *dicStatus = nil;
    while ([statusInfo next]) {
        dicStatus = @{kStatuesID: statusId,
                      kStatuesCreateTime: [statusInfo objectForColumnIndex:0],
                      kStatuesText: [statusInfo objectForColumnIndex:1],
                      kStatuesSource: [statusInfo objectForColumnIndex:2],
                      kStatuesThumbnailPic: [statusInfo objectForColumnIndex:3],
                      kStatuesOriginalPic: [statusInfo objectForColumnIndex:4]};
    }
    return dicStatus;
}

@end

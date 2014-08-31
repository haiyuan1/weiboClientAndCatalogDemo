//
//  HYWeiBoDataBaseEngine.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-8.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYWeiBoDataBaseEngine : NSObject

+ (instancetype)shareInstance;

- (void)saveStatusToDataBase:(NSDictionary *)dicStatus;

- (void)saveTimeLinesToDataBase:(NSArray *)timeLines;

- (void)saveUserInfoToDataBase:(NSDictionary *)dicUserInfo withStatusID:(NSString *)statusID;

- (void)saveTempStatusToDrafts:(NSDictionary *)tempStatus;

- (NSArray *)queryTimeLinesFromDataBase;

- (NSArray *)queryTempStatusFromDataBase;

- (NSDictionary *)queryUserInfoFromDataBase:(NSString *)userId;

- (NSDictionary *)queryStatusFromDataBase:(NSString *)statusId;

@end

//
//  HYStatuesTableViewCell.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-28.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYStatuesTableViewCell;
@protocol HYStatuesTableViewCellDelegate <NSObject>

@required
- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell StatuesImageViewDidSelected:(UIGestureRecognizer *)gesture;
- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell AvatarImageViewDidSelected:(UIGestureRecognizer *)gesture;
- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell RetweetImageViewDidSelected:(UIGestureRecognizer *)gesture;

@end

@interface HYStatuesTableViewCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *cellData;

@property (nonatomic, retain) UIImageView *avatarImageView;
@property (nonatomic, retain) UILabel *labelName;
@property (nonatomic, retain) UILabel *labelCreateTime;
@property (nonatomic, retain) UILabel *labelSource;

@property (nonatomic, retain) UILabel *labelStatues;
@property (nonatomic, retain) UIView *statuesImageViewBg;

@property (nonatomic, retain) UILabel *labelRetweetStatues;
@property (nonatomic, retain) UIView *retweetImageViewBg;

@property (nonatomic, assign) id<HYStatuesTableViewCellDelegate>delegate;
@end

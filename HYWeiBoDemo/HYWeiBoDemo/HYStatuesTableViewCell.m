//
//  HYStatuesTableViewCell.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-28.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYStatuesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XMLDictionary.h"
#import "NSString+FrameHight.h"

@implementation HYStatuesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        const CGFloat fontSize = 14.0f;
        const CGFloat minFontSize = 12.0f;
        UIFont *customFont = [UIFont systemFontOfSize:fontSize];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        _avatarImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarImageViewTapped:)];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
        [self.contentView addSubview:_avatarImageView];
        HYSafeRelease(tapGestureRecognizer);
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelName.font = customFont;
        [self.contentView addSubview:_labelName];
        
        _labelCreateTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelCreateTime.font = [UIFont systemFontOfSize:minFontSize];
        _labelCreateTime.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_labelCreateTime];
        
        _labelSource = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelSource.font = [UIFont systemFontOfSize:minFontSize];
        _labelSource.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_labelSource];
        
        _labelStatues = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelStatues.numberOfLines = 0;
        _labelStatues.font = customFont;
        [self.contentView addSubview:_labelStatues];
        
        _statuesImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_statuesImageViewBg];
        
        _labelRetweetStatues = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelRetweetStatues.numberOfLines = 0;
        _labelRetweetStatues.font = customFont;
        [self.contentView addSubview:_labelRetweetStatues];
        
        _retweetImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_retweetImageViewBg];
    }
    return self;
}

//解决cell重用队列重用带来的重复
- (void)restoreCellSubviewFrame
{
    self.labelStatues.frame = CGRectZero;
    self.labelRetweetStatues.frame = CGRectZero;
    self.statuesImageViewBg.frame = CGRectZero;
    self.retweetImageViewBg.frame = CGRectZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self restoreCellSubviewFrame];
    
    NSDictionary *statuesUserInfo = [self.cellData objectForKey:kStatuesUserInfo];
    NSDictionary *statuesInfo = self.cellData;
    NSUInteger widthSpace = 5;
    
    NSString *strUrl = [statuesUserInfo objectForKey:kUserAvatarLarge];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:strUrl]];
    
    self.labelName.text = [statuesUserInfo objectForKey:kUserInfoScreenName];
    self.labelName.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + widthSpace, 2, 100, 20);
    
    NSString *strDate = [statuesInfo objectForKey:kStatuesCreateTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    
    NSTimeInterval interval = [dateFromString timeIntervalSinceNow];
    if ((int)interval / 3600 >= 1) {
        self.labelCreateTime.text = [NSString stringWithFormat:@"%d小时之前", abs((int)interval / 3600)];
    }
    self.labelCreateTime.text = [NSString stringWithFormat:@"%d分钟之前", abs((int)interval / 60)];
    self.labelCreateTime.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + widthSpace, CGRectGetMaxY(self.labelName.frame) + 2, 100, 20);
    
    self.labelSource.frame =  CGRectMake(CGRectGetMaxX(self.labelCreateTime.frame) + widthSpace, self.labelCreateTime.frame.origin.y, 200, 20);
    NSDictionary *dicSourceInfo = [NSDictionary dictionaryWithXMLString:[statuesInfo objectForKey:kStatuesSource]];
    self.labelSource.text = [dicSourceInfo objectForKey:XMLDictionaryTextKey];
    
    self.labelStatues.text = [statuesInfo objectForKey:kStatuesText];
    CGRect newFrame = CGRectMake(5, CGRectGetMaxY(self.labelSource.frame) + widthSpace, 310, [self.labelStatues.text frameHeightWithFountSize:14.0f forViewWidth:310.0f]);
    self.labelStatues.frame = newFrame;
    
    for (UIView *stView in self.statuesImageViewBg.subviews) {
        [stView removeFromSuperview];
    }
    for (UIView * retView in self.retweetImageViewBg.subviews) {
        [retView removeFromSuperview];
    }
    
    NSUInteger statuesImageWidth = 80;
    NSUInteger statuesImageHeight = 80;
    
    NSDictionary *retweetStatuesInfo = [statuesInfo objectForKey:kStatuesRetweetStatues];
    if (nil == retweetStatuesInfo) {
        NSArray *statusPicUrls = [statuesInfo objectForKey:kStatuesPicUrls];
        if (statusPicUrls.count == 1) {
            NSString *strPicUrls = [statusPicUrls[0] objectForKey:kStatuesThumbnailPic];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
            UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, image.size.width, image.size.height)];
            
            statusImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStatuesImageViewTapped:)];
            [statusImageView addGestureRecognizer:tapGesture];
            HYSafeRelease(tapGesture);
            
            statusImageView.image = image;
            [self.statuesImageViewBg addSubview:statusImageView];
            self.statuesImageViewBg.frame = CGRectMake(widthSpace, CGRectGetMaxY(self.labelStatues.frame), image.size.width, image.size.height);
            HYSafeRelease(statusImageView);
        } else {
            self.statuesImageViewBg.frame = CGRectMake(widthSpace, CGRectGetMaxY(self.labelStatues.frame), 310, 80 * ceilf(statusPicUrls.count / 3));
            for (int i = 0; i < statusPicUrls.count; i++) {
                UIImageView *statuesImageView = nil;
                if (statusPicUrls.count == 4) {
                    statuesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statuesImageWidth * (i % 2), statuesImageHeight * ceil(i / 2), statuesImageWidth, statuesImageHeight)];
                } else {
                    statuesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statuesImageWidth * (i % 3), statuesImageHeight * ceil(i / 3), statuesImageWidth, statuesImageHeight)];
                }
                
                statuesImageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStatuesImageViewTapped:)];
                [statuesImageView addGestureRecognizer:tapGesture];
                
                NSString *strPicUrls = [statusPicUrls[i] objectForKey:kStatuesThumbnailPic];
                [statuesImageView setImageWithURL:[NSURL URLWithString:strPicUrls]];
                [self.statuesImageViewBg addSubview:statuesImageView];
                HYSafeRelease(statuesImageView);
            }
        }
    } else {
        NSString *retweetStatuesText = [retweetStatuesInfo objectForKey:kStatuesText];
        self.labelRetweetStatues.text = retweetStatuesText;
        self.labelRetweetStatues.backgroundColor = [UIColor lightGrayColor];
        CGRect newFrame = CGRectMake(5, CGRectGetMaxY(self.labelStatues.frame), 310.0f, [retweetStatuesText frameHeightWithFountSize:14.0f forViewWidth:310.0f]);
        self.labelRetweetStatues.frame = newFrame;
        
        NSArray *retweetStatuesPicUrls = [retweetStatuesInfo objectForKey:kStatuesPicUrls];
        if (retweetStatuesPicUrls.count == 1) {
            NSString *strPicUrls = [retweetStatuesPicUrls[0] objectForKey:kStatuesThumbnailPic];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
            UIImageView *retweetStatuesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, statuesImageWidth, statuesImageHeight)];
            [retweetStatuesImageView setImage:image];
            
            retweetStatuesImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetweetStatuesImageViewTapped:)];
            [retweetStatuesImageView addGestureRecognizer:tapGesture];
            HYSafeRelease(tapGesture);
            
            [self.retweetImageViewBg addSubview:retweetStatuesImageView];
            self.retweetImageViewBg.frame = CGRectMake(5, CGRectGetMaxY(self.labelRetweetStatues.frame), image.size.width, image.size.height);
            HYSafeRelease(retweetStatuesImageView);
        } else {
            self.retweetImageViewBg.frame = CGRectMake(2, CGRectGetMaxY(self.labelRetweetStatues.frame), 310, 80 * ceilf(retweetStatuesPicUrls.count / 3));
            for (int i = 0; i < retweetStatuesPicUrls.count; i++) {
                UIImageView *retweetImageView = nil;
                if (retweetStatuesPicUrls.count == 4) {
                    retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statuesImageWidth *(i % 2), statuesImageHeight * ceil(i / 2), statuesImageWidth, statuesImageHeight)];
                } else {
                    retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statuesImageWidth * (i % 3), statuesImageHeight * (i / 3), statuesImageWidth, statuesImageHeight)];
                }
                NSString *strPicUrls = [retweetStatuesPicUrls[i] objectForKey:kStatuesThumbnailPic];
                [retweetImageView setImageWithURL:[NSURL URLWithString:strPicUrls]];
                [self.retweetImageViewBg addSubview:retweetImageView];
                HYSafeRelease(retweetImageView);
            }
        }
    }
    
}

#pragma mark - delegate
- (void)onAvatarImageViewTapped:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(statuesTableViewCell:AvatarImageViewDidSelected:)]) {
        [self.delegate statuesTableViewCell:self AvatarImageViewDidSelected:gesture];
    }
}

- (void)onStatuesImageViewTapped:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(statuesTableViewCell:StatuesImageViewDidSelected:)]) {
        [self.delegate statuesTableViewCell:self StatuesImageViewDidSelected:gesture];
    }
}

- (void)onRetweetStatuesImageViewTapped:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(statuesTableViewCell:RetweetImageViewDidSelected:)]) {
        [self.delegate statuesTableViewCell:self RetweetImageViewDidSelected:gesture];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    HYSafeRelease(_avatarImageView);
    HYSafeRelease(_labelSource);
    HYSafeRelease(_labelName);
    HYSafeRelease(_labelCreateTime);
    [super dealloc];
}

@end

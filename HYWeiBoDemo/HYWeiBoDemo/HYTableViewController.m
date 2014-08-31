//
//  HYTableViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-31.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYTableViewController.h"
#import "NSString+FrameHight.h"

@implementation HYTableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

static const CGFloat fontSize = 14.0f;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dicStatuesInfo = nil;
    if (self.userTimeLine == nil) {
        dicStatuesInfo = self.statuesList[section];
    } else {
        dicStatuesInfo = self.userTimeLine;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    //转发微博按钮
    UIButton *retweetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 2.5, 90, 30)];
    [retweetBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet_os7"] forState:UIControlStateNormal];
    NSString *retweetButtonTitles = [NSString stringWithFormat:@"%@", [dicStatuesInfo objectForKey:kStatuesRepostsCount]];
    [retweetBtn setTitle:retweetButtonTitles forState:UIControlStateNormal];
    [retweetBtn setTitle:retweetButtonTitles forState:UIControlStateHighlighted];
    [retweetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [retweetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    [retweetBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [retweetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [retweetBtn addTarget:self action:@selector(onRetweetButton:) forControlEvents:UIControlEventTouchUpInside];
    retweetBtn.tag = section;
    [footerView addSubview:retweetBtn];
    
    UIButton *discussBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 2.5, 90, 30)];
    [discussBtn setImage:[UIImage imageNamed:@"timeline_icon_comment_os7"] forState:UIControlStateNormal];
    NSString *discussBtnTitles = [NSString stringWithFormat:@"%@", [dicStatuesInfo objectForKey:kStatuesCommentCount]];
    [discussBtn setTitle:discussBtnTitles forState:UIControlStateNormal];
    [discussBtn setTitle:discussBtnTitles forState:UIControlStateHighlighted];
    [discussBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [discussBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    [discussBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [discussBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [discussBtn addTarget:self action:@selector(onDiscussButton:) forControlEvents:UIControlEventTouchUpInside];
    //    discussBtn.tag = section;
    [footerView addSubview:discussBtn];
    
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 2.5, 90, 30)];
    [praiseBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike_os7"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateSelected];
    [praiseBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateHighlighted];
    NSString *praiseBtnTitles = [NSString stringWithFormat:@"%@", [dicStatuesInfo objectForKey:kStatuesAttitudesCount]];
    [praiseBtn setTitle:praiseBtnTitles forState:UIControlStateNormal];
    [praiseBtn setTitle:praiseBtnTitles forState:UIControlStateHighlighted];
    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [praiseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [praiseBtn addTarget:self action:@selector(onPraiseButton:) forControlEvents:UIControlEventTouchUpInside];
    //    praiseBtn.tag = section;
    [footerView addSubview:praiseBtn];
    
    HYSafeRelease(retweetBtn);
    HYSafeRelease(discussBtn);
    HYSafeRelease(praiseBtn);
    
    return footerView;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height4Header = 40.0f;
    CGFloat statusTextHeight = 0.0f;
    CGFloat statusImageViewHeight = 0.0f;
    CGFloat retweetStatusTextHeight = 0.0f;
    
    NSDictionary *dicStatusInfo = nil;
    if (self.userTimeLine == nil) {
        dicStatusInfo = self.statuesList[indexPath.section];
    } else {
        dicStatusInfo = self.userTimeLine;
    }
    
    NSString *content = [dicStatusInfo objectForKey:kStatuesText];
    statusTextHeight = [content frameHeightWithFountSize:fontSize forViewWidth:310.0f];
    
    NSDictionary *retweetStatus = [dicStatusInfo objectForKey:kStatuesRetweetStatues];
    
    if (nil == retweetStatus) {
        NSArray *picUrls = [dicStatusInfo objectForKey:kStatuesPicUrls];
        if (picUrls.count == 1) {
            NSDictionary *pic = picUrls[0];
            NSString *strUrl = [pic objectForKey:kStatuesThumbnailPic];
            /*
             NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
             UIImage *image = [UIImage imageWithData:imageData];
             statusImageViewHeight += image.size.height;
             */
            statusImageViewHeight += [self downloadJpgImage:strUrl].height;
        } else {
            int picLineCount = ceil(picUrls.count / 3.0f);
            statusImageViewHeight += (80 * picLineCount);
        }
    } else {
        NSString *retContent = [retweetStatus objectForKey:kStatuesText];
        retweetStatusTextHeight = [retContent frameHeightWithFountSize:fontSize forViewWidth:310.0f];
        NSArray *picUrls = [retweetStatus objectForKey:kStatuesPicUrls];
        if (picUrls.count == 1) {
            NSDictionary *pic = picUrls[0];
            NSString *strUrl = [pic objectForKey:kStatuesThumbnailPic];
            /*
             NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
             UIImage *image = [UIImage imageWithData:imageData];
             statusImageViewHeight += image.size.height;
             */
            statusImageViewHeight += [self downloadJpgImage:strUrl].height;
        } else {
            int picLineCount = ceil(picUrls.count / 3.0f);
            statusImageViewHeight += (80 * picLineCount);
        }
    }
    return (height4Header + statusTextHeight +statusImageViewHeight + retweetStatusTextHeight + 20);
}

#pragma mark - JPG格式图片的处理
- (CGSize)downloadJpgImage:(NSString *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [self jpgImageSizeWithHeaderData:data];
}

- (CGSize)jpgImageSizeWithHeaderData:(NSData *)data
{
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


@end

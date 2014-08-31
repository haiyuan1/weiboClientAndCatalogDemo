//
//  HYAboutMeTableViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYAboutMeTableViewController.h"
#import "UIImageView+WebCache.h"
#import "HYStatuesTableViewCell.h"
#import "NSString+FrameHight.h"

@interface HYAboutMeTableViewController () <SinaWeiboRequestDelegate>

@property (nonatomic, retain) NSDictionary *currentUserInfo;
@property (nonatomic, retain) NSArray *fullTimeLines;

@end

@implementation HYAboutMeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tabBarItem initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
        self.isHiddenNavigationBar = YES;
        self.title = @"个人中心";
        _userID = nil;
        [self requestUserTimeLineFromSinaServer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect headFrame = CGRectMake(0, 0, 320, 255);
    UIView *headView = [[UIView alloc] initWithFrame:headFrame];
    headView.backgroundColor = [UIColor whiteColor];
    
    CGRect imageViewFrame = CGRectMake(0, -100, 320, 250);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = [UIImage imageNamed:@"profile_cover_background@2x.jpg"];
    [headView addSubview:imageView];
    
    self.tableView.tableHeaderView = headView;
    
    if (!self.isHiddenNavigationBar) {
        UINavigationController *nav = self.tabBarController.viewControllers[0];
        UIViewController *viewController = nav.topViewController;
        self.currentUserInfo = [viewController valueForKey:@"currentUserInfo"];
    }
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, 60, 60)];
    [avatarImageView setImageWithURL:[NSURL URLWithString:[self.currentUserInfo objectForKey:kUserAvatarHd]]];
    [headView addSubview:avatarImageView];
    
    CGFloat interWidth = 15.0f;
    CGFloat interHeight = 5.0f;
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + interWidth, avatarImageView.frame.origin.y, 100, 30)];
    labelName.textColor = [UIColor whiteColor];
    [labelName setFont:[UIFont boldSystemFontOfSize:14.0f]];
    labelName.text = [self.currentUserInfo objectForKey:kUserInfoScreenName];
    [headView addSubview:labelName];
    
    UIButton *btnWriteStatus = [self creatButton:[UIImage imageNamed:@"userinfo_relationship_indicator_compose_os7"] Title:@"写微博" Frame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + interWidth, CGRectGetMaxY(labelName.frame) + interHeight, 100, 25)];
    [headView addSubview:btnWriteStatus];
    
    UIButton *btnFriends = [self creatButton:[UIImage imageNamed:@"userinfo_relationship_indicator_friends_os7"] Title:@"好友列表" Frame:CGRectMake(CGRectGetMaxX(btnWriteStatus.frame) + interWidth, btnWriteStatus.frame.origin.y, 100, 25)];
    [headView addSubview:btnFriends];
    
    UIButton *btnPersonDesp = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(avatarImageView.frame) + 5.0f, 300, 20)];
    btnPersonDesp.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btnPersonDesp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnPersonDesp setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    NSString *personDespTitle = [self.currentUserInfo objectForKey:kUserVerifiedReason];
    if (nil == personDespTitle || personDespTitle.length == 0) {
        personDespTitle = [self.currentUserInfo objectForKey:kUserDescription];
    }
    [btnPersonDesp setTitle:personDespTitle forState:UIControlStateNormal];
    [btnPersonDesp setTitle:personDespTitle forState:UIControlStateHighlighted];
    [btnPersonDesp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headView addSubview:btnPersonDesp];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnPersonDesp.frame) + 5, 320, 1)];
    lineImageView.image = [UIImage imageNamed:@"settings_statistic_form_background_line"];
    [headView addSubview:lineImageView];
    
    UIView *detailUserInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineImageView.frame), 320, 40)];
    detailUserInfoBgView.tag = 3111;
    NSString *statusCountTitle = [NSString stringWithFormat:@"%@\n微博", [self.currentUserInfo objectForKey:kUserStatusesCount]];
    NSString *friendCountTitle = [NSString stringWithFormat:@"%@\n关注", [self.currentUserInfo objectForKey:kUserFriendsCount]];
    NSString *followCountTitle = [NSString stringWithFormat:@"%@\n粉丝", [self.currentUserInfo objectForKey:kUserFollowersCount]];
    [headView addSubview:detailUserInfoBgView];
    
    NSArray *detailUserInfoTitles = @[@"详细\n资料", statusCountTitle, friendCountTitle, followCountTitle, @"更多"];
    for (int i = 0; i < detailUserInfoTitles.count; i++) {
        NSString *title = detailUserInfoTitles[i];
        [self creatDetailUserInfoItems:title Frame:CGRectMake(i * 64, 0, 64, 40)];
    }
    
    HYSafeRelease(imageView);
    HYSafeRelease(avatarImageView);
    HYSafeRelease(labelName);
    HYSafeRelease(btnPersonDesp);
    HYSafeRelease(lineImageView);
    HYSafeRelease(headView);
}

- (void)creatDetailUserInfoItems:(NSString *)title Frame:(CGRect)frame
{
    UIView *bgView = [self.tableView.tableHeaderView viewWithTag:3111];
    UIButton *btnUserDetail = [[UIButton alloc] initWithFrame:frame];
    btnUserDetail.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    btnUserDetail.titleLabel.numberOfLines = 2;
    btnUserDetail.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [btnUserDetail setTitle:title forState:UIControlStateNormal];
    [btnUserDetail setTitle:title forState:UIControlStateHighlighted];
    [btnUserDetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnUserDetail setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [bgView addSubview:btnUserDetail];
    HYSafeRelease(btnUserDetail);
}

- (UIButton *)creatButton:(UIImage *)bgImage Title:(NSString *)title Frame:(CGRect)frame
{
    UIButton *retButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retButton.frame = frame;
    retButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    retButton.layer.cornerRadius = 3.0f;
    retButton.layer.borderWidth = 0.5f;
    
    [retButton setTitle:title forState:UIControlStateNormal];
    [retButton setTitle:title forState:UIControlStateHighlighted];
    [retButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [retButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [retButton setImage:bgImage forState:UIControlStateNormal];
    
    [retButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 60)];
    [retButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    retButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    retButton.backgroundColor = [UIColor clearColor];
    return retButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = self.isHiddenNavigationBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestUserTimeLineFromSinaServer
{
    NSString *strUserID = nil;
    if (self.userID == nil) {
        strUserID = AppDelegate.sinaWeibo.userID;
    } else {
        strUserID = self.userID;
    }
    [AppDelegate.sinaWeibo requestWithURL:@"statuses/user_timeline.json" params:[NSMutableDictionary dictionaryWithObject:strUserID forKey:@"uid"] httpMethod:@"GET" delegate:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#if 0
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height4Header = 40.0f;
    CGFloat statusTextHeight = 0.0f;
    CGFloat statusImageViewHeight = 0.0f;
    CGFloat retweetStatusTextHeight = 0.0f;
    
    NSDictionary *dicStatusInfo = self.userTimeLine;
    
    NSString *content = [dicStatusInfo objectForKey:kStatuesText];
    statusTextHeight = [content frameHeightWithFountSize:14.0f forViewWidth:310.0f];
    
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
        retweetStatusTextHeight = [retContent frameHeightWithFountSize:14.0 forViewWidth:310.0f];
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
#endif

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"aboutMeTableViewCell";
    HYStatuesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (nil == cell) {
        cell = [[HYStatuesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.cellData = self.userTimeLine;
    return cell;
}
#if 0
static const CGFloat fontSize = 14.0f;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dicStatuesInfo = self.userTimeLine;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

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
#endif
#pragma mark - sinaWeibo request delegate
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    self.fullTimeLines = [result objectForKey:kUserStatuses];
    if (self.userTimeLine == nil) {
        self.userTimeLine = self.fullTimeLines[0];
        [self.tableView reloadData];
    }
}

@end

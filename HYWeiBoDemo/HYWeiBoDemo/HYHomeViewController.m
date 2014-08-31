//
//  HYHomeViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYHomeViewController.h"
#import "QYPlaySound.h"
#import "NSString+FrameHight.h"
#import "UIImageView+WebCache.h"
#import "TSActionSheet.h"
#import "HYAboutMeTableViewController.h"
#import "HYEditStatusViewController.h"
#import <sqlite3.h>

@interface HYHomeViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) NSDictionary *currentUserInfo;

@end

CGFloat fontSize = 14.0f;

@implementation HYHomeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        
        self.statuesList = [[HYWeiBoDataBaseEngine shareInstance] queryTimeLinesFromDataBase];
        if (self.statuesList == nil) {
            [SVProgressHUD showWithStatus:@"正在获取数据"];
            [self requestHomeLineFromSinaServer];
            [self requestUserInfoFromSinaServer];
        }
}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    refreshControl.backgroundColor = [UIColor clearColor];
    [refreshControl addTarget:self action:@selector(onRefreshControl:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    HYSafeRelease(refreshControl);
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_compose_os7"] style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBarButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    HYSafeRelease(leftBarButtonItem);
    
    UIButton *btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    [btnTitle setTitle:@"碧水瀚海" forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnTitle.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btnTitle addTarget:self action:@selector(onTitleButtonTapped:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btnTitle;
    HYSafeRelease(btnTitle);
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_pop_os7"] style:UIBarButtonItemStylePlain target:self action:@selector(onRightButtonItem:forEvent:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    HYSafeRelease(rightBarButtonItem);
}

- (void)requestHomeLineFromSinaServer
{
    [AppDelegate.sinaWeibo requestWithURL:@"statuses/home_timeline.json" params:[NSMutableDictionary dictionaryWithObject:AppDelegate.sinaWeibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
}

- (void)requestUserInfoFromSinaServer
{
    [AppDelegate.sinaWeibo requestWithURL:@"users/show.json" params:[NSMutableDictionary dictionaryWithObject:AppDelegate.sinaWeibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefreshControl:(UIRefreshControl *)refreshControl
{
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    QYPlaySound *playSound = [[QYPlaySound alloc] initForPlayingSoundEffectWith:@"msgcome.wav"];
    [playSound play];
    [self requestHomeLineFromSinaServer];
}

- (void)onLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    HYEditStatusViewController *editStatusViewController = [[HYEditStatusViewController alloc] init];
    [self presentViewController:editStatusViewController animated:YES completion:NULL];
    HYSafeRelease(editStatusViewController);
}

- (void)onTitleButtonTapped:(UIButton *)sender forEvent:(UIEvent *)event
{
    TSActionSheet *tsActionSheet = [[TSActionSheet alloc] initWithTitle:@"Hello"];
    CGRect oldFrame = tsActionSheet.frame;
    CGRect newFrame = (CGRect){oldFrame.origin, 130, oldFrame.size.height};
    tsActionSheet.frame = newFrame;
    tsActionSheet.popoverBaseColor = [UIColor darkGrayColor];
    tsActionSheet.titleFont = [UIFont boldSystemFontOfSize:14.0f];
    [tsActionSheet addButtonWithTitle:@"时间排序" block:^{
        
    }];
    [tsActionSheet addButtonWithTitle:@"智能排序" block:^{
        
    }];
    [tsActionSheet addButtonWithTitle:@"我的微博" block:^{
        
    }];
    [tsActionSheet addButtonWithTitle:@"密友圈" block:^{
        
    }];
    [tsActionSheet addButtonWithTitle:@"互相关注" block:^{
        
    }];
    tsActionSheet.cornerRadius = 1.0f;
    tsActionSheet.layer.opaque = YES;
    [tsActionSheet showWithTouch:event];
}

- (void)onRightButtonItem:(UIBarButtonItem *)barButtonItem forEvent:(UIEvent *)event
{
    TSActionSheet *tsActionSheet = [[TSActionSheet alloc] initWithTitle:@"qingyun"];
    CGRect oldFrame = tsActionSheet.frame;
    CGRect newFrame = {oldFrame.origin, 90, oldFrame.size.height};
    tsActionSheet.frame = newFrame;
    tsActionSheet.popoverBaseColor = [UIColor darkGrayColor];
    tsActionSheet.titleFont = [UIFont boldSystemFontOfSize:14.0f];
    [tsActionSheet addButtonWithTitle:@"刷新" block:^{
        [self onRefreshControl:nil];
    }];
    [tsActionSheet addButtonWithTitle:@"扫一扫" block:^{
        
    }];
    tsActionSheet.cornerRadius = 1.0f;
    [tsActionSheet showWithTouch:event];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.statuesList.count;
}

/*
const int widthSpace = 10;
NSUInteger statusImageWidth = 70.0f;
NSUInteger statusImageHeight = 70.0f;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"StatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        avatarImageView.tag = 1000;
        [cell.contentView addSubview:avatarImageView];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + widthSpace, 5, 100, 20)];
        labelName.tag = 1001;
        labelName.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:labelName];
        
        UILabel *labelCreatTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + widthSpace, CGRectGetMaxY(labelName.frame) + 2, 100, 20)];
        labelCreatTime.tag = 1002;
        labelCreatTime.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:labelCreatTime];
        
        UILabel *labelStatuesSource = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelCreatTime.frame) + widthSpace, labelCreatTime.frame.origin.y, 200, 20)];
        labelStatuesSource.tag = 1003;
        labelStatuesSource.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:labelStatuesSource];
        
        UILabel *labelStatusText = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(labelStatuesSource.frame)+5, 310, 100)];
        labelStatusText.tag = 1004;
        labelStatusText.font = [UIFont systemFontOfSize:fontSize];
        [cell.contentView addSubview:labelStatusText];
        
        UIView *statusImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        statusImageViewBg.tag = 1005;
        [cell.contentView addSubview:statusImageViewBg];
        HYSafeRelease(statusImageViewBg);
        
        UILabel *labelRetweetStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        labelRetweetStatus.tag = 1006;
        labelRetweetStatus.numberOfLines = 0;
        labelRetweetStatus.font = [UIFont systemFontOfSize:fontSize];
        labelRetweetStatus.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:labelRetweetStatus];
        HYSafeRelease(labelRetweetStatus);
        
        UIView *retStatusImageViewBg = [[UIView alloc] initWithFrame:CGRectZero];
        retStatusImageViewBg.tag = 1007;
        [cell.contentView addSubview:retStatusImageViewBg];
        HYSafeRelease(retStatusImageViewBg);
        
        HYSafeRelease(labelName);
        HYSafeRelease(labelCreatTime);
        HYSafeRelease(labelStatuesSource);
        HYSafeRelease(labelStatusText);
        HYSafeRelease(avatarImageView);
    }
    NSDictionary *statusInfo = self.statuesList[indexPath.section];
    NSDictionary *userInfo = [statusInfo objectForKey:@"user"];
    
    UIImageView *avatarView = (UIImageView *)[cell.contentView viewWithTag:1000];
    NSString *strUrl = [userInfo objectForKey:@"profile_image_url"];
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
    avatarView.image = [UIImage imageWithData:imgData];
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:1001];
    name.text = [userInfo objectForKey:@"screen_name"];
    
    UILabel *creatTime = (UILabel *)[cell.contentView viewWithTag:1002];
    NSString *strDate = [statusInfo objectForKey:@"created_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    NSTimeInterval interval = [dateFromString timeIntervalSinceNow];
    creatTime.text = [NSString stringWithFormat:@"%d分钟之前", abs((int)interval / 60)];
    
    UILabel *statuesSource = (UILabel *)[cell.contentView viewWithTag:1003];
    NSDictionary *dicSourceInfo = [NSDictionary dictionaryWithXMLString:[statusInfo objectForKey:@"source"]];
    statuesSource.text = [dicSourceInfo objectForKey:XMLDictionaryTextKey];
    
    UILabel *statuesText = (UILabel *)[cell.contentView viewWithTag:1004];
    statuesText.numberOfLines = 0;
    statuesText.text = [statusInfo objectForKey:@"text"];
    CGRect newFrame = CGRectMake(5, CGRectGetMaxY(statuesSource.frame) + 5, 310, [statuesText.text frameHeightWithFountSize:fontSize forViewWidth:310.0f]);
    statuesText.frame = newFrame;
    
    UIView *statusBgView = [cell.contentView viewWithTag:1005];
    for (UIView *statusView in [statusBgView subviews]) {
        [statusView removeFromSuperview];
    }
    
    UIView *retBgView = [cell.contentView viewWithTag:1007];
    for (UIView *retView in [retBgView subviews]) {
        [retView removeFromSuperview];
    }
    
    NSDictionary *retweetedStatusInfo = [statusInfo objectForKey:@"retweeted_status"];
    UIView *statusImageViewBg = [cell.contentView viewWithTag:1005];
    statusImageViewBg.frame = CGRectZero;
    UILabel *retweetText = (UILabel *)[cell.contentView viewWithTag:1006];
    retweetText.frame = CGRectZero;
    UIView *retweetImageViewBg = [cell.contentView viewWithTag:1007];
    retweetImageViewBg.frame = CGRectZero;
    if (nil == retweetedStatusInfo) {
        NSArray *statusPicUrls = [statusInfo objectForKey:@"pic_urls"];
        if (statusPicUrls.count == 1) {
            NSString *strPicUrls = [statusPicUrls[0] objectForKey:@"thumbnail_pic"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strPicUrls]]];
            UIImageView *statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, image.size.width, image.size.height)];
            statusImgView.image = image;
            [statusImageViewBg addSubview:statusImgView];
            statusImageViewBg.frame = CGRectMake(widthSpace, CGRectGetMaxY(statuesText.frame), image.size.width, image.size.height);
            HYSafeRelease(statusImgView);
        } else {
            statusImageViewBg.frame = CGRectMake(0, CGRectGetMaxY(statuesText.frame), 310, 80 * ceilf(statusPicUrls.count / 3.0f));
            for (int i = 0; i < statusPicUrls.count; i++) {
                UIImageView *stausImgView = nil;
                if (statusPicUrls.count == 4) {
                    stausImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statusImageWidth * (i % 2), statusImageHeight * ceil(i / 2), statusImageWidth, statusImageHeight)];
                } else {
                    stausImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statusImageWidth * (i % 3), statusImageHeight * ceil(i / 3), statusImageWidth, statusImageHeight)];
                }
                NSString *strPicUrls = [statusPicUrls[i] objectForKey:@"thumbnail_pic"];
                [stausImgView setImageWithURL:[NSURL URLWithString:strPicUrls]];
                [statusImageViewBg addSubview:stausImgView];
                HYSafeRelease(stausImgView);
            }
        }
    } else {
        retweetText.text = [retweetedStatusInfo objectForKey:@"text"];
        CGRect newFrame = CGRectMake(5, CGRectGetMaxY(statuesText.frame), 310, [retweetText.text frameHeightWithFountSize:fontSize forViewWidth:310.0f]);
        retweetText.frame = newFrame;
        
        NSArray *retweetPicUrls = [retweetedStatusInfo objectForKey:@"pic_urls"];
        if (retweetPicUrls.count == 1) {
            NSString *retPicUrls = [retweetPicUrls[0] objectForKey:@"thumbnail_pic"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:retPicUrls]]];
            UIImageView *retImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, image.size.width, image.size.height)];
            retImageView.image = image;
            [retweetImageViewBg addSubview:retImageView];
            retweetImageViewBg.frame = CGRectMake(widthSpace, CGRectGetMaxY(retweetText.frame) + 5, image.size.width, image.size.height);
            HYSafeRelease(retImageView);
        } else {
            retweetImageViewBg.frame = CGRectMake(2, CGRectGetMaxY(retweetText.frame) + 5, 310, 80 *ceilf(retweetPicUrls.count / 3.0f));
            for (int i = 0; i < retweetPicUrls.count; i++) {
                UIImageView *retImageView = nil;
                if (retweetPicUrls.count == 4) {
                    retImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statusImageWidth * (i % 2), statusImageHeight * ceil(i / 2), statusImageWidth, statusImageHeight)];
                } else {
                    retImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + statusImageWidth * (i % 3), 5 + statusImageHeight * ceil(i / 3), statusImageWidth, statusImageHeight)];
                }
                NSString *strRetPicUrls = [retweetPicUrls[i] objectForKey:@"thumbnail_pic"];
                [retImageView setImageWithURL:[NSURL URLWithString:strRetPicUrls]];
                [retweetImageViewBg addSubview:retImageView];
                HYSafeRelease(retImageView);
            }
        }
    }
    
    return cell;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"statuesCell";
    HYStatuesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (nil == cell) {
        cell = [[HYStatuesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.cellData = self.statuesList[indexPath.section];
    cell.delegate = self;
    
    return cell;
}

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
//    sqlite3 *db = NULL;
//    NSString *dbFileName = [[NSBundle mainBundle] pathForResource:@"HY_weibo_client" ofType:@"sqlite"];
//    int retResult = sqlite3_open([dbFileName UTF8String], &db);
//    if (retResult != SQLITE_OK) {
//        NSLog(@"Open db failure %@", dbFileName);
//        return;
//    }
    
    NSURL *url = [NSURL URLWithString:request.url];
    NSString *indentifierUrl = [[url pathComponents] lastObject];
    if ([indentifierUrl isEqualToString:@"show.json"]) {
        self.currentUserInfo = (NSDictionary *)result;
        [[HYWeiBoDataBaseEngine shareInstance] saveUserInfoToDataBase:self.currentUserInfo withStatusID:[self.currentUserInfo objectForKey:kUserStatusInfo][kUserStatuesID]];
        
//        sqlite3_stmt *stmt = NULL;
//        NSString *insertUserInfoSql = @"insert into t_user(id,user_id,screen_name) values(null,?,?)";
//        sqlite3_prepare_v2(db, [insertUserInfoSql UTF8String], -1, &stmt, NULL);
//        sqlite3_bind_int(stmt, 1, [self.currentUserInfo[kUserID] integerValue]);
//        sqlite3_bind_text(stmt, 2, [self.currentUserInfo[kUserInfoScreenName] UTF8String], -1, NULL);
//        retResult = sqlite3_step(stmt);
        
        UIButton *btnTitle = (UIButton *)self.navigationItem.titleView;
        NSString *title = [self.currentUserInfo objectForKey:kUserInfoScreenName];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitle:title forState:UIControlStateHighlighted];
    } else if ([indentifierUrl isEqualToString:@"home_timeline.json"]) {
        self.statuesList = [result objectForKey:@"statuses"];
        [[HYWeiBoDataBaseEngine shareInstance] saveTimeLinesToDataBase:self.statuesList];
        [self.tableView reloadData];
    }
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
//    sqlite3_close(db);
}

#pragma mark - Button CallBack On FooterView
- (void)onRetweetButton:(UIButton *)button
{
    HYEditStatusViewController *editStatusVC = [[HYEditStatusViewController alloc] init];
    editStatusVC.hidesBottomBarWhenPushed = YES;
    editStatusVC.dicStatus = self.statuesList[button.tag];
    [self.navigationController pushViewController:editStatusVC animated:YES];
    HYSafeRelease(editStatusVC);
}

- (void)onDiscussButton:(UIButton *)button
{
    
}

- (void)onPraiseButton:(UIButton *)button
{
    NSUInteger nAttitudeCount;
    if (button.selected) {
        button.selected = NO;
        nAttitudeCount = [[button titleForState:UIControlStateSelected] integerValue];
        nAttitudeCount--;
        [button setTitle:[NSString stringWithFormat:@"%d", nAttitudeCount] forState:UIControlStateNormal];
    } else {
        nAttitudeCount = [[button titleForState:UIControlStateNormal] integerValue];
        nAttitudeCount++;
        button.selected = YES;
        [button setTitle:[NSString stringWithFormat:@"%d", nAttitudeCount] forState:UIControlStateSelected];
    }
}

#pragma mark - HYStatuesTableViewCell delegate
- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell AvatarImageViewDidSelected:(UIGestureRecognizer *)gesture
{
//    CGPoint currentPoint = [gesture locationInView:self.tableView];
    
    HYAboutMeTableViewController *aboutMeViewController = [[HYAboutMeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    aboutMeViewController.userID = [[[cell.cellData objectForKey:kStatuesUserInfo] objectForKey:kUserID] stringValue];
    aboutMeViewController.isHiddenNavigationBar = NO;
    [aboutMeViewController setValue:[cell.cellData objectForKey:kStatuesUserInfo] forKey:@"currentUserInfo"];
    [aboutMeViewController setValue:cell.cellData forKeyPath:@"userTimeLine"];
    [self.navigationController pushViewController:aboutMeViewController animated:YES];
    HYSafeRelease(aboutMeViewController);
}

- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell StatuesImageViewDidSelected:(UIGestureRecognizer *)gesture
{
    NSString *urls = [cell.cellData objectForKey:kStatuesOriginalPic];
    [self showFullImageViewWithUrls:urls];
}
- (void)statuesTableViewCell:(HYStatuesTableViewCell *)cell RetweetImageViewDidSelected:(UIGestureRecognizer *)gesture
{
    NSDictionary *retweetStatuesInfo = [cell.cellData objectForKey:kStatuesRetweetStatues];
    NSString *originPicUrl = [retweetStatuesInfo objectForKey:kStatuesOriginalPic];
    if (originPicUrl != nil) {
        [self showFullImageViewWithUrls:originPicUrl];
    }
}
#pragma mark - scrollViewDelegate
static const NSInteger tagImageView = 1111;
- (void)showFullImageViewWithUrls:(NSString *)urls
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urls]]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFullImageViewTapped:)];
    [imageView addGestureRecognizer:tapGesture];
    HYSafeRelease(tapGesture);
    imageView.tag = tagImageView;
    imageView.userInteractionEnabled = YES;
    imageView.multipleTouchEnabled = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.contentSize = CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height);
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5f;
    scrollView.maximumZoomScale = 3.0f;
    [scrollView addSubview:imageView];
    HYSafeRelease(imageView);
    scrollView.backgroundColor = [UIColor darkTextColor];
    [AppDelegate.window addSubview:scrollView];
    HYSafeRelease(scrollView);
}

- (void)onFullImageViewTapped:(UITapGestureRecognizer *)gesture
{
    [gesture.view.superview removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:tagImageView];
}


@end

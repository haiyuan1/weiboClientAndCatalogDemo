//
//  HYPlazaViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYPlazaViewController.h"
#import "HYCollectionViewCellSectionOne.h"
#import "HYCollectionViewCellSectionTwo.h"
#import "HYCollectionViewCellSectionThree.h"
#import "HYCollectionViewCellSectionFour.h"

#define ONE_CELL_IDENTIFIER   @"CollectionViewCellSectionOne"
#define TWO_CELL_IDENTIFIER   @"CollectionViewCellSectionTwo"
#define THREE_CELL_IDENTIFIER @"CollectionViewCellSectionThree"
#define FOUR_CELL_IDENTIFIER  @"CollectionViewCellSectionFour"

typedef enum {
    kPNCollectionViewCellSectionOne,
    kPNCollectionViewCellSectionTwo,
    kPNCollectionViewCellSectionThree,
    kPNCollectionViewCellSectionFour,
    kPNCollectionViewCellSectionNumbers
} collectionSectionStyle;

@interface HYPlazaViewController () <SinaWeiboRequestDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionViewFlowLayout *layout;
@property (nonatomic, retain) NSArray *sectionOneImages;
@property (nonatomic, retain) NSArray *sectionLabelNames;
@property (nonatomic, retain) NSArray *sectionTrends;

@end

@implementation HYPlazaViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.tabBarItem initWithTitle:@"广场" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
        self.title = @"广场";
        self.sectionOneImages = @[@"contacts_findfriends_icon",@"messagescenter_comments_os7",@"contacts_findfriends_icon",@"messagescenter_comments_os7"];
        self.sectionLabelNames = @[@"扫一扫",@"找朋友",@"会员",@"周边"];
        [self reqeuestTrendsFromSinaServer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.placeholder = @"搜索";
    self.navigationItem.titleView = searchBar;
    [self registerPNCustomCollectionViewCell];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)reqeuestTrendsFromSinaServer
{
    SinaWeibo *sinaWeibo = AppDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:@"trends/hourly.json" params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
}

- (void)registerPNCustomCollectionViewCell
{
    [self.collectionView registerClass:[HYCollectionViewCellSectionOne class] forCellWithReuseIdentifier:ONE_CELL_IDENTIFIER];
    [self.collectionView registerClass:[HYCollectionViewCellSectionTwo class] forCellWithReuseIdentifier:TWO_CELL_IDENTIFIER];
    [self.collectionView registerClass:[HYCollectionViewCellSectionThree class] forCellWithReuseIdentifier:THREE_CELL_IDENTIFIER];
    [self.collectionView registerClass:[HYCollectionViewCellSectionFour class] forCellWithReuseIdentifier:FOUR_CELL_IDENTIFIER];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kPNCollectionViewCellSectionNumbers;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int ret = 0;
    switch (section) {
        case kPNCollectionViewCellSectionOne:
            ret = 4;
            break;
        case kPNCollectionViewCellSectionTwo:
            ret = 1;
            break;
        case kPNCollectionViewCellSectionThree:
            ret = 4;
            break;
        case kPNCollectionViewCellSectionFour:
            ret = 16;
            break;
        default:
            break;
    }
    return ret;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    switch (indexPath.section) {
        case kPNCollectionViewCellSectionOne:
        {
            HYCollectionViewCellSectionOne *tmpCell = (HYCollectionViewCellSectionOne *)[collectionView dequeueReusableCellWithReuseIdentifier:ONE_CELL_IDENTIFIER forIndexPath:indexPath];
            tmpCell.imageView.image = [UIImage imageNamed:self.sectionLabelNames[indexPath.row]];
            tmpCell.label.text = self.sectionLabelNames[indexPath.item];
            cell = tmpCell;
        }
            break;
        case kPNCollectionViewCellSectionTwo:
        {
            HYCollectionViewCellSectionTwo *twoCell = (HYCollectionViewCellSectionTwo *)[collectionView dequeueReusableCellWithReuseIdentifier:TWO_CELL_IDENTIFIER forIndexPath:indexPath];
            twoCell.imageView.image = [UIImage imageNamed:@"messagescenter_comments_os7"];
            twoCell.titleLabel.text = @"Title";
            twoCell.subTitleLabel.text = @"Subtitle";
            cell = twoCell;
        }
            break;
        case kPNCollectionViewCellSectionThree:
        {
            HYCollectionViewCellSectionThree *threeCell = (HYCollectionViewCellSectionThree *)[collectionView dequeueReusableCellWithReuseIdentifier:THREE_CELL_IDENTIFIER forIndexPath:indexPath];
            threeCell.mDicTrends = self.sectionTrends[0][indexPath.item];
            cell = threeCell;
        }
            break;
        case kPNCollectionViewCellSectionFour:
        {
            HYCollectionViewCellSectionFour *fourCell = (HYCollectionViewCellSectionFour *)[collectionView dequeueReusableCellWithReuseIdentifier:FOUR_CELL_IDENTIFIER forIndexPath:indexPath];
            cell = fourCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section) {
        case kPNCollectionViewCellSectionOne:
            size = CGSizeMake(140, 44);
            break;
        case kPNCollectionViewCellSectionTwo:
            size = CGSizeMake(300, 80);
            break;
        case kPNCollectionViewCellSectionThree:
            size = CGSizeMake(140, 40);
            break;
        case kPNCollectionViewCellSectionFour:
            size = CGSizeMake(57, 70);
            break;
        default:
            break;
    }
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s:%@",__func__,response);
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    NSLog(@"%s",__func__);
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s:%@",__func__,error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%s,%@",__func__,result);
    self.sectionTrends = [[result objectForKey:@"trends"] allValues];
    [self.collectionView reloadData];
}


@end

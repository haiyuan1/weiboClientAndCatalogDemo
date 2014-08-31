//
//  HYMainViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-25.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYMainViewController.h"

#import "HYHomeViewController.h"
#import "HYMessageViewController.h"
#import "HYPlazaViewController.h"
#import "HYAboutMeTableViewController.h"
#import "HYMoreViewController.h"
#import "HYPlazaViewLayout.h"

@interface HYMainViewController ()

@end

@implementation HYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
        self.tabBar.tintColor = [UIColor orangeColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HYHomeViewController *homeViewVCtrl = [[HYHomeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    HYMessageViewController *messageViewVCtrl = [[HYMessageViewController alloc] initWithStyle:UITableViewStylePlain];
    HYPlazaViewController *plazaVCtrl = [[HYPlazaViewController alloc] initWithCollectionViewLayout:[[HYPlazaViewLayout alloc] init]];
    HYAboutMeTableViewController *aboutMeVCtrl = [[HYAboutMeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    HYMoreViewController *moreViewVCtrl = [[HYMoreViewController alloc] initWithStyle:UITableViewStylePlain];
    
    NSArray *viewCtrollers = @[homeViewVCtrl, messageViewVCtrl, plazaVCtrl, aboutMeVCtrl, moreViewVCtrl];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *vc in viewCtrollers) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
        HYSafeRelease(vc);
        HYSafeRelease(nav);
    }
    self.viewControllers = vcs;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

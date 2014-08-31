//
//  HYLoginViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYLoginViewController.h"

@interface HYLoginViewController ()

@end

@implementation HYLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)doLogin:(UIButton *)sender {
    [AppDelegate.sinaWeibo logIn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HYNSDC addObserver:self selector:@selector(onLogin:) name:kHYNotificationNameLogin object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [HYNSDC removeObserver:self name:kHYNotificationNameLogin object:nil];
}

- (void)onLogin:(NSNotification *)notification
{
    [HYViewControllerManager presentViewControllerWithType:HYViewControllerTypeMainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

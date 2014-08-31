//
//  QYTransitionsViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-29.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYTransitionsViewController.h"

@interface QYTransitionsViewController ()

@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) UIImageView *firstView;
@property (nonatomic, retain) UIImageView *secondView;

@end

@implementation QYTransitionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Transitions";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //创建容器视图
    _container = [[UIView alloc] initWithFrame:CGRectMake(30, 70, 260, 200)];
    [self.view addSubview:_container];
    
    //创建两个视图
    _firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 200)];
    _firstView.image = [UIImage imageNamed:@"scene1.jpg"];
    [_container addSubview:_firstView];
    
    _secondView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 200)];
    _secondView.image = [UIImage imageNamed:@"scene2.jpg"];
//    [_container addSubview:_secondView];
    
    
    //创建toolBar并添加barbuttonItem
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44, 320, 44)];
    
    UIBarButtonItem *flipItem = [[UIBarButtonItem alloc] initWithTitle:@"Flip Image" style:UIBarButtonItemStyleDone target:self action:@selector(flipAction:)];
    UIBarButtonItem *curlItem = [[UIBarButtonItem alloc] initWithTitle:@"Curl Image" style:UIBarButtonItemStyleDone target:self action:@selector(curlAction:)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *items = @[flexibleItem, flipItem, curlItem, flexibleItem];
    toolBar.items = items;
    toolBar.tintColor = [UIColor blackColor];
    [flipItem release];
    flipItem = nil;
    [curlItem release];
    curlItem = nil;
    [flexibleItem release];
    flexibleItem = nil;
    [self.view addSubview:toolBar];
    [toolBar release];
    toolBar = nil;
}

- (void)flipAction:(UIBarButtonItem *)sender
{
    if (_firstView.superview) {
        [UIView transitionWithView:_container duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_firstView removeFromSuperview];
            [_container addSubview:_secondView];
            
        } completion:nil];
    } else {
        [UIView transitionWithView:_container duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_secondView removeFromSuperview];
            [_container addSubview:_firstView];
        } completion:nil];
    }
}

- (void)curlAction:(UIBarButtonItem *)sender
{
    if (_firstView.superview) {
        [UIView transitionWithView:_container duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            [_firstView removeFromSuperview];
            [_container addSubview:_secondView];
        } completion:nil];
    } else {
        [UIView transitionWithView:_container duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            [_secondView removeFromSuperview];
            [_container addSubview:_firstView];
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_firstView release];
    _firstView = nil;
    [_secondView release];
    _secondView = nil;
    [_container release];
    _container = nil;
    [super dealloc];
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

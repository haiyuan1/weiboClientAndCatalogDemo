//
//  QYImageViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-29.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYImageViewController.h"

@interface QYImageViewController ()

@property (nonatomic, retain) UIImageView *imageView;

@end

@implementation QYImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Images";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, 260, 200)];
    _imageView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"scene%d.jpg", i+1]]];
    }
    _imageView.animationImages = images;
    [_imageView setAnimationDuration:2];
    
    [self.view addSubview:_imageView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 420, 300, 30)];
    slider.minimumValue = 0.5;
    slider.maximumValue = 5.5;
    slider.value = 3;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:slider];
    [slider release];
    slider = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 450, 80, 30)];
    label.text = @"Duration";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    
    
    [self.view addSubview:label];
    
    [label release];
    label = nil;
    
    [_imageView startAnimating];
}

- (void)sliderAction:(UISlider *)slider
{
    [_imageView setAnimationDuration:slider.value];
    [_imageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_imageView release];
    _imageView = nil;
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

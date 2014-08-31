//
//  HYUserGuideViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-7-24.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYUserGuideViewController.h"

@interface HYUserGuideViewController ()

@end

@implementation HYUserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollVIew.pagingEnabled = YES;
    self.scrollVIew.showsHorizontalScrollIndicator = NO;
    self.scrollVIew.showsVerticalScrollIndicator = NO;
    self.scrollVIew.delegate = self;
    
    const NSUInteger pageCount = 5;
    self.scrollVIew.contentSize = CGSizeMake(self.view.bounds.size.width*pageCount, self.view.bounds.size.height);
    for (int i = 0; i < pageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_features_%d.jpg", i+1]];
        [self.scrollVIew addSubview:imageView];
        HYSafeRelease(imageView);
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger contentOffset = self.view.bounds.size.width*4 + 100;
    if ((self.scrollVIew.contentOffset.x - contentOffset) >0) {
        [HYViewControllerManager presentViewControllerWithType:HYViewControllerTypeLoginView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollVIew release];
    [super dealloc];
}
@end

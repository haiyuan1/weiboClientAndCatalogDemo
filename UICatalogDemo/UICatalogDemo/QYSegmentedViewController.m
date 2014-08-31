//
//  QYSegmentedViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-29.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSegmentedViewController.h"

@interface QYSegmentedViewController ()

@property (nonatomic, retain) NSArray *array;

@end

@implementation QYSegmentedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Segments";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //创建label
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 20)];
    firstLabel.text = @"UISegmentedControl:";
    firstLabel.font = [UIFont systemFontOfSize:18];
    firstLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:firstLabel];
    [firstLabel release];
    firstLabel = nil;
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 20)];
    secondLabel.text = @"UISegmentControlStyleBordered:";
    secondLabel.textColor = [UIColor darkGrayColor];
    secondLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:secondLabel];
    [secondLabel release];
    secondLabel = nil;
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 280, 20)];
    thirdLabel.text = @"UISegmentControlStyleBar:";
    thirdLabel.textColor = [UIColor darkGrayColor];
    thirdLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:thirdLabel];
    [thirdLabel release];
    thirdLabel = nil;
    
    UILabel *forthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 20)];
    forthLabel.text = @"UISegmentControlStyleBar:tint";
    forthLabel.textColor = [UIColor darkGrayColor];
    forthLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:forthLabel];
    [forthLabel release];
    forthLabel = nil;
    
    UILabel *fiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 20)];
    fiveLabel.text = @"UISegmentControlStyleBar:image";
    fiveLabel.textColor = [UIColor darkGrayColor];
    fiveLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:fiveLabel];
    [fiveLabel release];
    fiveLabel = nil;



    
    //创建segmentedControl
    UIImage *liftImage = [UIImage imageNamed:@"segment_check"];
    UIImage *middleImage = [UIImage imageNamed:@"segment_search"];
    UIImage *rightImage = [UIImage imageNamed:@"segment_tools"];
    
    NSArray *arrayWhithCusSegment = @[liftImage, middleImage, rightImage];
    
    UISegmentedControl *segmentedWithImage = [[UISegmentedControl alloc] initWithItems:arrayWhithCusSegment];
    segmentedWithImage.frame = CGRectMake(20, 110, 280, 40);
    [self.view addSubview:segmentedWithImage];
    [segmentedWithImage release];
    segmentedWithImage = nil;
    
    self.array = @[@"Check", @"Search", @"Tools"];
    
    UISegmentedControl *segmentedStyleBordered = [[UISegmentedControl alloc] initWithItems:_array];
    segmentedStyleBordered.frame = CGRectMake(20, 190, 280, 40);
    [self.view addSubview:segmentedStyleBordered];
    [segmentedStyleBordered release];
    segmentedStyleBordered = nil;
    
    
    UISegmentedControl *segmentedStyleBar = [[UISegmentedControl alloc] initWithItems:_array];
    segmentedStyleBar.frame = CGRectMake(20, 270, 280, 40);
    [self.view addSubview:segmentedStyleBar];
    [segmentedStyleBar release];
    segmentedStyleBar = nil;
    
    
    UISegmentedControl *segmentedStyleBarTint = [[UISegmentedControl alloc] initWithItems:_array];
    segmentedStyleBarTint.frame = CGRectMake(20, 350, 280, 40);
    segmentedStyleBarTint.tintColor = [UIColor redColor];
    [self.view addSubview:segmentedStyleBarTint];
    [segmentedStyleBarTint release];
    segmentedStyleBarTint = nil;
    
    
    UISegmentedControl *segmentedWithBgimage = [[UISegmentedControl alloc] initWithItems:_array];
    segmentedWithBgimage.frame = CGRectMake(20, 430, 280, 40);
    [segmentedWithBgimage setBackgroundImage:[UIImage imageNamed:@"segmentedBackground"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.view addSubview:segmentedWithBgimage];
    [segmentedWithBgimage release];
    segmentedWithBgimage = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_array release];
    _array =nil;
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

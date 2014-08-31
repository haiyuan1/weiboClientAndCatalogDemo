//
//  QYControlsViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-27.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYControlsViewController.h"

#define kViewTag           101

#pragma mark - constant values
static NSString *kSectionTitleKey = @"sectionTitle";
static NSString *kLabelKey = @"label";
static NSString *kViewKey = @"button";
static NSString *kSourceKey = @"source";

static NSString *kViewCellID = @"ViewCellID";
static NSString *kSourceCellID = @"sourceCellID";

@interface QYControlsViewController ()
@property (nonatomic, retain) NSArray *dataArray;

@property (nonatomic, retain) UISwitch *switchControl;
@property (nonatomic, retain) UISlider *sliderControl;
@property (nonatomic, retain) UISlider *customSlider;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIActivityIndicatorView *progressInd;
@property (nonatomic, retain) UIProgressView *progressBar;
@property (nonatomic, retain) UIStepper *stepper;

@end

@implementation QYControlsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Controls";
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tinted" style:UIBarButtonItemStyleDone target:self action:@selector(tintedAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    rightBarButtonItem = nil;
    
    //初始化数据
    
    self.dataArray = @[
                       @{ kSectionTitleKey:@"UISwitch",
                          kLabelKey:@"Standard Switch",
                          kViewKey:self.switchControl,
                          kSourceKey:@"QYControlsViewController.m\n-(UISwitch *)switchControl"
                           },
                       @{ kSectionTitleKey:@"UISlider",
                          kLabelKey:@"Standard Slider",
                          kViewKey:self.sliderControl,
                          kSourceKey:@"QYControlsViewController.m\n-(UISlider *)sliderControl"
                          },
                       @{ kSectionTitleKey:@"UISlider",
                          kLabelKey:@"Customized Slider",
                          kViewKey:self.customSlider,
                          kSourceKey:@"QYControlsViewController.m\n-(UISlider *)customSlider"
                          },
                       @{ kSectionTitleKey:@"UIPageControl",
                          kLabelKey:@"Ten Pages",
                          kViewKey:self.pageControl,
                          kSourceKey:@"QYControlsViewController.m\n-(UIPageControl *)pageControl"
                          },
                       @{ kSectionTitleKey:@"UIActivityindicatorview",
                          kLabelKey:@"Style Gray",
                          kViewKey:self.progressInd,
                          kSourceKey:@"QYControlsViewController.m\n-(UIActivityIndicatorView *)progressInd"
                          },
                       @{ kSectionTitleKey:@"UIProgressview",
                          kLabelKey:@"Style Default",
                          kViewKey:self.progressBar,
                          kSourceKey:@"QYControlsViewController.m\n-(UIProgressView *)progressBar"
                          },
                       @{ kSectionTitleKey:@"UIStepper",
                          kLabelKey:@"Stepper 1 to 10",
                          kViewKey:self.stepper,
                          kSourceKey:@"QYControlsViewController.m\n-(UIStepper *)stepper"
                          },


                       ];
    //注册cell标示符
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kViewCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSourceCellID];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dataArray[section] objectForKey:kSectionTitleKey];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *dict = self.dataArray[indexPath.section];
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kViewCellID];
        
        // Configure the cell...
        cell.textLabel.text = [dict objectForKey:kLabelKey];
        
        //移除之前单元格嵌入的view
        UIView *view2remove = [cell.contentView viewWithTag:kViewTag];
        if (view2remove) {
            [view2remove removeFromSuperview];
        }
        
        //往cell里添加view
        UIView *view = [dict objectForKey:kViewKey];
        CGRect newFrame = view.frame;
        newFrame.origin.x = CGRectGetWidth(cell.contentView.frame) - 10 - CGRectGetWidth(newFrame);
        view.frame = newFrame;
        [cell.contentView addSubview:view];
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *progressInd = (UIActivityIndicatorView *)view;
            [progressInd startAnimating];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID forIndexPath:indexPath];
    
    // Configure the cell...
        cell.textLabel.text = [dict objectForKey:kSourceKey];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 50 : 38;
}

#pragma mark - events process
- (void)tintedAction:(UIBarButtonItem *)sender
{
    if (_switchControl.thumbTintColor == nil) {
        _switchControl.thumbTintColor = [UIColor redColor];
        _switchControl.onTintColor = [UIColor blueColor];
        _sliderControl.tintColor = [UIColor yellowColor];
        _progressInd.Color = [UIColor blueColor];
        _progressBar.progress = 1;
        _stepper.tintColor = [UIColor blueColor];
    } else {
        _switchControl.thumbTintColor = nil;
        _switchControl.onTintColor = nil;
        _sliderControl.tintColor = nil;
        _progressInd.Color = nil;
        _progressBar.progress = 0.5;
        _stepper.tintColor = nil;
    }
}
- (void)switchAction:(UISwitch *)sender
{
    NSLog(@"%s:%d", __func__, sender.on);
}

- (void)sliderControlAction:(UISlider *)sender
{
    
}

- (void)customSliderAction:(UISlider *)sender
{
    
}

- (void)pageControlAction:(UIPageControl *)sender
{
    
}

- (void)stepperAction:(UIStepper *)sender
{
    NSLog(@"%s,%.2f", __func__, sender.value);
}

#pragma mark - lasy creation of controls
- (UISwitch *)switchControl
{
    if (_switchControl == nil) {
        _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
        [_switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        _switchControl.tag = kViewTag;
        
    }
    return _switchControl;
}

- (UISlider *)sliderControl
{
    if (_sliderControl == nil) {
        _sliderControl = [[UISlider alloc] initWithFrame:CGRectMake(0, 10, 120, 30)];
        
        _sliderControl.minimumValue = 0;
        _sliderControl.maximumValue = 100;
        _sliderControl.value = 50;
        _sliderControl.tag = kViewTag;
        [_sliderControl addTarget:self action:@selector(sliderControlAction:) forControlEvents:UIControlEventValueChanged];
        _sliderControl.tag = kViewTag;
    }
    return _sliderControl;
}

- (UISlider *)customSlider
{
    if (_customSlider == nil) {
        _customSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 10, 120, 30)];
        _customSlider.minimumValue = 0;
        _customSlider.maximumValue = 100;
        _customSlider.value = 50;
        [_customSlider addTarget:self action:@selector(customSliderAction:) forControlEvents:UIControlEventValueChanged];
        _customSlider.tag = kViewTag;
        
        
        //自定义左右图片
        UIImage *liftImage = [[UIImage imageNamed:@"orangeslide"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8) resizingMode:UIImageResizingModeStretch];
        UIImage *rightImage = [[UIImage imageNamed:@"yellowslide"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8) resizingMode:UIImageResizingModeStretch];
        [_customSlider setMinimumTrackImage:liftImage forState:UIControlStateNormal];
        [_customSlider setMaximumTrackImage:rightImage forState:UIControlStateNormal];
        [_customSlider setThumbImage:[UIImage imageNamed:@"slider_ball"] forState:UIControlStateNormal];
    }
    return _customSlider;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 15, 160, 20)];
        _pageControl.backgroundColor = [UIColor darkGrayColor];
        _pageControl.numberOfPages = 10;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
        _pageControl.tag = kViewTag;
        
    }
    return _pageControl;
}

- (UIActivityIndicatorView *)progressInd
{
    if (_progressInd == nil) {
        _progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _progressInd.frame = CGRectMake(0, 20, 30, 30);
        _progressInd.tag = kViewTag;
        [_progressInd startAnimating];
        
    }
    return _progressInd;
}

- (UIProgressView *)progressBar
{
    if (_progressBar == nil) {
        _progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressBar.frame = CGRectMake(0, 20, 160, 20);
        
        _progressBar.progress = 0.5;
        _progressBar.tag = kViewTag;
    }
    return _progressBar;
}

- (UIStepper *)stepper
{
    if (_stepper == nil) {
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
        _stepper.value = 1;
        _stepper.stepValue = 1;
        _stepper.minimumValue = 1;
        _stepper.maximumValue = 10;
        
        [_stepper addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
        _stepper.tag = kViewTag;
        
    }
    return _stepper;
}

- (void)dealloc
{
    [_dataArray release];
    [_switchControl release];
    [_sliderControl release];
    [_customSlider release];
    [_pageControl release];
    [_progressInd release];
    [_progressBar release];
    [_stepper release];
    [super dealloc];
}


@end

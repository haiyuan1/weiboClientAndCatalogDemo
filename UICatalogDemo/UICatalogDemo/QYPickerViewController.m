//
//  QYPickerViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-29.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYPickerViewController.h"
#import "QYCustomDataSource.h"

@interface QYPickerViewController ()

#pragma mark - pickerView
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *pickerViewData;
@property (nonatomic, retain) UILabel *label;

@property (nonatomic, retain) UISegmentedControl *mainSegmentedCtrl;

#pragma mark - datePicker
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UILabel *datePickerLabel;
@property (nonatomic, retain) UISegmentedControl *dateSegmentedCtrl;

#pragma mark - customPicker
@property (nonatomic, retain) QYCustomDataSource *dataSource;
@property (nonatomic, retain) UIPickerView *customPicker;

@end

@implementation QYPickerViewController

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
    self.title = @"Pickers";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //创建pickerView
    [self createPickerView];
    
    //创建并设置Toolbar
    [self createToolbar];
    
    //创建DatePicker
    [self createDatePicker];
    
    //创建customPicker
    [self creatCustomPicker];
}

#pragma mark - create main views
- (void)createPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 70, 0, 0)];
    NSLog(@"_pickerView.frame:%@", NSStringFromCGRect(_pickerView.frame));
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    _pickerView.showsSelectionIndicator = YES;
    
    [self.view addSubview:_pickerView];
    
    self.pickerViewData = @[@"Hai Yuan", @"Wang Delong", @"Zhu Xingzhi", @"Sun Biao", @"Wang shaofeng", @"Tian Chao", @"Song Zhanfa", @"Shen Guanghui"];
    
    //创建PickerView下面的随着选择不同的值改变的lable
    _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 300, 200, 30)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = [NSString stringWithFormat:@"Hai Yuan - 0"];
    
    [self.view addSubview:_label];
}

- (void)createToolbar
{
    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44, 320, 44)];
    
    NSArray *items = @[@"UIPicker", @"UIDatePicker", @"Custom"];
    _mainSegmentedCtrl = [[UISegmentedControl alloc] initWithItems:items];
    _mainSegmentedCtrl.frame = CGRectMake(10, 5, 300, 34);
    _mainSegmentedCtrl.tintColor = [UIColor darkGrayColor];
//    _mainSegmentedCtrl.backgroundColor = [UIColor lightGrayColor];
    [_mainSegmentedCtrl addTarget:self action:@selector(changePickers:) forControlEvents:UIControlEventValueChanged];
    
    [toobar addSubview:_mainSegmentedCtrl];
    
    [self.view addSubview:toobar];
    [toobar release];
    toobar = nil;
}

- (void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 70, 0, 0)];
    
    _datePicker.datePickerMode = UIDatePickerModeTime;
    _datePicker.hidden = YES;
    
    [self.view addSubview:_datePicker];
    
    _datePickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, 220, 30)];
    _datePickerLabel.text = @"UIDatePickerModeTime";
    _datePickerLabel.textColor = [UIColor blackColor];
    _datePickerLabel.textAlignment = NSTextAlignmentCenter;
    _datePickerLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_datePickerLabel];
    _datePickerLabel.hidden = YES;
    
    
    //datePickerLabel 下面的segmentControl
    NSArray *items = @[@"1", @"2", @"3", @"4"];
    _dateSegmentedCtrl = [[UISegmentedControl alloc] initWithItems:items];
    _dateSegmentedCtrl.frame = CGRectMake(60, 335, 200, 30);
    [_dateSegmentedCtrl addTarget:self action:@selector(changePickersStyle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_dateSegmentedCtrl];
    _dateSegmentedCtrl.hidden = YES;
    
}

- (UIPickerView *)creatCustomPicker
{
    CGRect frame = {0, 70, 320, 216};
    _dataSource = [[QYCustomDataSource alloc] init];
    _customPicker = [[UIPickerView alloc] initWithFrame:frame];
    
    _customPicker.dataSource = self.dataSource;
    _customPicker.delegate = self.dataSource;
    
    _customPicker.showsSelectionIndicator = YES;
    
    _customPicker.hidden = YES;
     [self.view addSubview:_customPicker];
    return _customPicker;
    
}

#pragma mark - pickerView data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerViewData.count;
}

#pragma mark - pickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat retVlaue;
    if (component == 0) {
        retVlaue = 240;
    } else {
        retVlaue = 80;
    }
    return retVlaue;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *retStr = nil;
    if (pickerView == _pickerView) {
        if (component == 0) {
            retStr = [_pickerViewData[row] retain];
        } else {
            retStr = [[[NSNumber numberWithInt:row] stringValue] retain];
        }
    }
    return [retStr autorelease];
}

//指定component的指定row的属性标题
//属性标题的优先级比较高，如果设置了属性标题，属性标题会覆盖正常标题的
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *attStr = nil;
    NSString *title = nil;
    if (row == 0) {
        if (component == 0) {
            title = [_pickerViewData[row] retain];
        } else {
            title = [[[NSNumber numberWithInt:row] stringValue] retain];
        }
        attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [title release];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attStr.length)];
    }
    return [attStr autorelease];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _label.text = [NSString stringWithFormat:@"%@ - %d", [_pickerViewData objectAtIndex:[_pickerView selectedRowInComponent:0]], [_pickerView selectedRowInComponent:1]];
}


#pragma mark - evens handle

- (void)hidenPickers
{
     _pickerView.hidden = YES;
    _label.hidden = YES;
    
    
    _datePicker.hidden = YES;
    _datePickerLabel.hidden = YES;
    _dateSegmentedCtrl.hidden = YES;
    
    //自定义picker显示
    _customPicker.hidden = YES;
    
    
}

- (void)showPicker
{
    _pickerView.hidden = NO;
    _label.hidden = NO;
}

- (void)showDatePicker
{
    _datePicker.hidden = NO;
    _datePickerLabel.hidden = NO;
    _dateSegmentedCtrl.hidden = NO;
}

- (void)showCustomPicker
{
    _customPicker.hidden = NO;
}

- (void)changePickers:(UISegmentedControl *)sender
{
    [self hidenPickers];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showPicker];
            break;
        case 1:
            [self showDatePicker];
            break;
        case 2:
            [self showCustomPicker];
            break;
        default:
            break;
    }
    
}

- (void)changePickersStyle:(UISegmentedControl *)sender
{
    if (sender == _dateSegmentedCtrl) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                _datePickerLabel.text = @"UIDatePickerModeTime";
                _datePicker.datePickerMode = UIDatePickerModeTime;
                break;
            case 1:
                _datePickerLabel.text = @"UIDatePickerModeDate";
                _datePicker.datePickerMode = UIDatePickerModeDate;
                break;
            case 2:
                _datePickerLabel.text = @"UIDatePickerModeDateAndTime";
                _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                break;
            case 3:
                _datePickerLabel.text = @"UIDatePickerModeCountDownTimer";
                _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_pickerView release];
    _pickerView = nil;
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

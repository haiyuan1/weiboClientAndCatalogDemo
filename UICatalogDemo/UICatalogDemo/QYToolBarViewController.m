//
//  QYToolBarViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-30.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYToolBarViewController.h"

@interface QYToolBarViewController ()

@property (nonatomic, retain) UISegmentedControl *segmented;
@property (nonatomic, retain) UISwitch *imageSwitch;
@property (nonatomic, retain) UISwitch *tintedSwitch;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSArray *pickerViewArray;
@property (nonatomic, assign) UIBarButtonSystemItem systemItem;
@property (nonatomic, retain) NSArray *array;


@end

@implementation QYToolBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"ToolBar";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    UILabel *barStyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 20)];
    
    barStyLabel.text = @"UIBarStyle:";
    barStyLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:barStyLabel];
    [barStyLabel release];
    barStyLabel = nil;
    
    [self segmented];
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, 50, 20)];
    imageLabel.text = @"Image:";
    imageLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:imageLabel];
    [imageLabel release];
    imageLabel = nil;
    
    
    UILabel *tintedLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 125, 50, 20)];
    
    tintedLabel.text = @"Tinted:";
    tintedLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tintedLabel];
    [tintedLabel release];
    tintedLabel = nil;
    
    
    [self switch];
    
    UILabel *barButtonStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 200, 20)];
    barButtonStyleLabel.text = @"UIBarButtonItemStyle:";
    barButtonStyleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:barButtonStyleLabel];
    [barButtonStyleLabel release];
    barButtonStyleLabel = nil;
    
    UILabel *sysItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 200, 20)];
    sysItemLabel.text = @"UIBarButtonSystemItem:";
    sysItemLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:sysItemLabel];
    [sysItemLabel release];
    sysItemLabel = nil;
    
    
    //创建PickerView
    
    self.pickerViewArray = @[@"Done", @"Cancel", @"Edit", @"Save", @"Add", @"FlexibelSpace", @"FixedSpace", @"Compose", @"Reply", @"Action", @"Organize", @"BookMarks", @"Search", @"Refresh", @"Stop", @"Camera", @"Trash", @"Play", @"Pause", @"Rewind", @"FastForward", @"Undo", @"Redo", @"PageCurl"];

    [self creatPickerView];
    [self.view addSubview:_pickerView];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    //创建ToolBar
    [self toolBar];
    
}

#pragma mark - creation segmented
- (UISegmentedControl *)segmented
{
    NSArray *array = @[@"Default", @"Black", @"Translucent"];
    _segmented = [[UISegmentedControl alloc] initWithItems:array];
    _segmented.frame = CGRectMake(10, 90, 280, 30);
    _segmented.tintColor = [UIColor darkGrayColor];
    _segmented.alpha = 0.3;
    
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmented];
    return _segmented;
}

#pragma mark - creation switch
- (UISwitch *)switch
{
    _imageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(70, 125, 50, 30)];
    [_imageSwitch addTarget:self action:@selector(imageSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    _tintedSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 125, 50, 30)];
    
    [_tintedSwitch addTarget:self action:@selector(tintedSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_imageSwitch];
    [self.view addSubview:_tintedSwitch];
    return _imageSwitch;
    return _tintedSwitch;
}

#pragma mark - creation toolBar
- (UIToolbar *)toolBar
{
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44, 320, 44)];
//    _toolBar.backgroundColor = [UIColor whiteColor];
    [_toolBar setTranslucent:YES];
    [self.view addSubview:_toolBar];
    
    
#if 1
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Item1" style:UIBarButtonItemStyleDone target:self action:nil];
    UIImage *image = [UIImage imageNamed:@"whiteButton"];
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8) resizingMode:UIImageResizingModeStretch];
    [item1 setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
#endif
#if 0
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8) resizingMode:UIImageResizingModeStretch ] style:UIBarButtonItemStyleDone target:self action:nil];
#endif
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Item2" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *itemTool = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"segment_tools"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *changeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.systemItem target:self action:nil];
    
    self.array = @[changeItem, flexible, item1, flexible, item2, itemTool];
    
    _toolBar.items = _array;
    [item1 release];
    item1 = nil;
    [item2 release];
    item2 = nil;
    [itemTool release];
    itemTool = nil;
    return _toolBar;
}

#pragma mark - creation picker view
- (UIPickerView *)creatPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(70, 260, 216, 160)];
        return _pickerView;
}

#pragma mark - picker view datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerViewArray.count;
}


#pragma mark - picker view delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (component == 0) {
        title = [_pickerViewArray[row] retain];
    }
    return [title autorelease];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _systemItem = row;
    [self toolBar];
}

#pragma mark - evens handle
- (void)imageSwitchAction:(UISwitch *)sender
{
    if (sender.on) {
        _tintedSwitch.enabled = NO;
        _segmented.enabled = NO;
        [_toolBar setBackgroundImage:[UIImage imageNamed:@"searchBarBackground"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        _tintedSwitch.enabled = YES;
        _segmented.enabled = YES;
        [_toolBar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    }
}

- (void)tintedSwitchAction:(UISwitch *)sender
{
    if (sender.on) {
        _imageSwitch.enabled = NO;
        _segmented.enabled = NO;
        _toolBar.tintColor = [UIColor yellowColor];
    } else {
        _imageSwitch.enabled = YES;
        _segmented.enabled = YES;
        _segmented.tintColor = [UIColor darkGrayColor];
        _toolBar.tintColor = nil;
    }
}

- (void)segmentedAction:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0: {
            _toolBar.barTintColor = [UIColor whiteColor];
        }
            break;
        case 1: {
            _toolBar.barTintColor = [UIColor blackColor];
        }
            break;
        case 2: {
            _toolBar.translucent = YES;
        }
            break;
    
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_segmented release];
    _segmented = nil;
    [_imageSwitch release];
    _imageSwitch = nil;
    [_tintedSwitch release];
    _tintedSwitch = nil;
    [_pickerView release];
    _pickerView = nil;
    [_toolBar release];
    _toolBar = nil;
    [_pickerViewArray release];
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

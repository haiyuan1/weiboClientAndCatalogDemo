//
//  QYMainTableViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-25.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYMainTableViewController.h"

#pragma mark - constant values
static NSString *kCellIdentify = @"QYMainViewController";
static NSString *kTitleKey = @"title";
static NSString *kSubTitleKey = @"subTitle";
static NSString *kViewControllerKey = @"viewController";


//QYTableViewCell的接口
@interface QYTableViewCell : UITableViewCell

@end

 //QYTableViewCell的实现
@implementation QYTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentify];
}

@end

#pragma mark -

@interface QYMainTableViewController ()

@property (nonatomic, retain) NSMutableArray *menulist;

@end

@implementation QYMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"UICatalog";
	
	self.clearsSelectionOnViewWillAppear = YES;
	
	//初始化数据
	self.menulist = [NSMutableArray array];
	//Buttons
	[self.menulist addObject:@{ kTitleKey:@"Buttons",
								kSubTitleKey:@"Various uses of UIButton",
								kViewControllerKey:@"QYButtonsViewController"
							   }];
	[self.menulist addObject:@{ kTitleKey:@"Controls",
								kSubTitleKey:@"Various uses of UIControl",
								kViewControllerKey:@"QYControlsViewController"
							   
							   }];
    [self.menulist addObject:@{ kTitleKey:@"TextFields",
								kSubTitleKey:@"Uses of UITextField",
								kViewControllerKey:@"QYTextFieldViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"SearchBar",
								kSubTitleKey:@"Uses of UISearchBar",
								kViewControllerKey:@"QYSearchBarViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"TextView",
								kSubTitleKey:@"Uses of UITextField",
								kViewControllerKey:@"QYTextViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"Pickers",
								kSubTitleKey:@"Uses of UIDatapicker, UIPickerView",
								kViewControllerKey:@"QYPickerViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"Images",
								kSubTitleKey:@"Uses of UIImageView",
								kViewControllerKey:@"QYImageViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"Web",
								kSubTitleKey:@"Uses of UIWebView",
								kViewControllerKey:@"QYWebViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"Segments",
								kSubTitleKey:@"Various uses of UISegmentedControl",
								kViewControllerKey:@"QYSegmentedViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"ToolBar",
								kSubTitleKey:@"uses of UIToolBar",
                                kViewControllerKey:@"QYToolBarViewController"
                                
                                }];
    [self.menulist addObject:@{ kTitleKey:@"Alerts",
								kSubTitleKey:@"Various uses of UIAlertView, UIActionSheet",
                                kViewControllerKey:@"QYAlertViewController"
                                
                                }];

    [self.menulist addObject:@{ kTitleKey:@"Transitions",
								kSubTitleKey:@"Uses of UIViewAnimationTransitions",
                                kViewControllerKey:@"QYTransitionsViewController"
                                
                                }];

	//创建返回按钮，并设置导航栏的tintcolor
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
	backBarButtonItem.title = @"Back";
	self.navigationItem.backBarButtonItem = backBarButtonItem;
	[backBarButtonItem release];
    backBarButtonItem = nil;
	
	[self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
	
	//注册Cell标示符
	[self.tableView registerClass:[QYTableViewCell class] forCellReuseIdentifier:kCellIdentify];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menulist.count;
}

static NSInteger counters = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict = self.menulist[indexPath.row];
	cell.textLabel.text = [dict objectForKey:kTitleKey];
	cell.detailTextLabel.text = [dict objectForKey:kSubTitleKey];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController *viewController;
	NSString *vcName = [self.menulist[indexPath.row] objectForKey:kViewControllerKey];
	if (vcName) {
		viewController = [[NSClassFromString(vcName) alloc] init];
	}
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
    viewController = nil;
}

- (void)dealloc
{
	[_menulist release];
    _menulist = nil;
	[super dealloc];
}

@end

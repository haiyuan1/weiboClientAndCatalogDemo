//
//  QYButtonsViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-25.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYButtonsViewController.h"

#define kStdButtonWidth    106
#define kStdButtonHeight   40
#define kViewTag           101

#pragma mark - constant values
static NSString *kSectionTitleKey = @"sectionTitle";
static NSString *kLabelKey = @"label";
static NSString *kViewKey = @"button";
static NSString *kSourceKey = @"source";

static NSString *kViewCellID = @"viewCellID";
static NSString *kSourceCellID = @"sourceCellID";

@interface QYButtonsViewController ()
@property (nonatomic, retain) NSArray *dataArray;


//buttons
@property (nonatomic, retain) UIButton *grayButton;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIButton *roundedButtonType;
@property (nonatomic, retain) UIButton *attrTextButton;
@property (nonatomic, retain) UIButton *detailDisclosureButton;
@property (nonatomic, retain) UIButton *infoLightButtonType;
@property (nonatomic, retain) UIButton *infoDarkButtonType;
@property (nonatomic, retain) UIButton *contactAddType;
@end

@implementation QYButtonsViewController

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
	
	//title
	self.title = @"Buttons";
	
	//数据
	self.dataArray = @[
					   @{ kSectionTitleKey: @"UIButton",
						  kLabelKey:@"Background Image",
						  kViewKey:self.grayButton,
						 
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)grayButton"
						 },
					   @{ kSectionTitleKey:@"UIButton",
						  kLabelKey:@"Button with Image",
						  kViewKey:self.imageButon,
						  
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)imageButton"
						   },
					   @{ kSectionTitleKey:@"UIButtonsTypeRoundedRect",
						  kLabelKey:@"Rounded Button",
						  kViewKey:self.roundedButtonType,
						  
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)roundedButtonType"
						   },
					   @{ kSectionTitleKey:@"UIButtonsTypeRoundedRect",
						  kLabelKey:@"Attributed Text",
						  kViewKey:self.attrTextButton,
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)attrTextButton"
						   },
					   @{ kSectionTitleKey:@"UIButtonsTypeDetailDisclosure",
						  kLabelKey:@"Detail Disclosure",
						  kViewKey:self.detailDisclosureButton,
						  
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)detailDisclosureButton"
						   },
					   @{ kSectionTitleKey:@"UIButtonTypeInfoLight",
						  kLabelKey:@"Info Light",
						  kViewKey:self.infoLightButtonType,
						  kSourceKey:@"QYButtonsViewController.m:\n(UIButton *)infoLightButtonType"
						   },
					   @{ kSectionTitleKey: @"UIButtonsTypeInfoDark",
						  kLabelKey:@"Info Dark",
						  kViewKey:self.infoDarkButtonType,
						  kSourceKey:@"QYButtonsTypeViewController.m:\n(UIButton *)infoDarkButtonType"
						 },
					   @{ kSectionTitleKey: @"UIButtonTypeContactAdd",
						  kLabelKey:@"Contact Add",
						  kViewKey:self.contactAddType,
						  kSourceKey:@"ButtonsViewController.m:(UIButton *)contactAddButtonType"
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
		cell = [tableView dequeueReusableCellWithIdentifier:kViewCellID forIndexPath:indexPath];
		// Configure the cell...
		//移除之前的cell上嵌入的view
		UIView *view2remove = [cell.contentView viewWithTag:kViewTag];
		if (view2remove) {
			[view2remove removeFromSuperview];
		}
		cell.textLabel.text = [dict objectForKey:kLabelKey];
		
		UIButton *btn = [dict objectForKey:kViewKey];
		CGRect newFrame = btn.frame;
		newFrame.origin.x = CGRectGetWidth(cell.contentView.frame) - CGRectGetWidth(newFrame) - 10;
		btn.frame = newFrame;
		[cell.contentView addSubview:btn];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID forIndexPath:indexPath];
		// Configure the cell...
		cell.textLabel.text = [dict objectForKey:kSourceKey];
		cell.textLabel.textColor = [UIColor grayColor];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.numberOfLines = 2;
		cell.textLabel.font = [UIFont systemFontOfSize:12];
	}
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - lazy create buttons
- (UIButton *)grayButton
{
	if (_grayButton == nil) {
		//创建_grayButton
		_grayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, kStdButtonWidth, kStdButtonHeight)];
		[_grayButton setTitle:@"Gray" forState:UIControlStateNormal];
		[_grayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		UIImage *bgImg = [[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
		UIImage *hlBgImg = [[UIImage imageNamed:@"blueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
		
		[_grayButton setBackgroundImage:bgImg forState:UIControlStateNormal];
		[_grayButton setBackgroundImage:hlBgImg forState:UIControlStateHighlighted];
		
		_grayButton.tag = kViewTag;
	}
	return _grayButton;
}

- (UIButton *)imageButon
{
	if (_imageButton == nil) {
		//创建_imageButton
		_imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, kStdButtonWidth, kStdButtonHeight)];
		
		UIImage *bgImg = [[UIImage imageNamed:@"whiteButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
		UIImage *hlBgImg = [[UIImage imageNamed:@"blueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
		[_imageButton setBackgroundImage:bgImg forState:UIControlStateNormal];
		[_imageButton setBackgroundImage:hlBgImg forState:UIControlStateHighlighted];
		[_imageButton setImage:[UIImage imageNamed:@"UIButton_custom"] forState:UIControlStateNormal];
		_imageButton.tag = kViewTag;
	}
	
	return _imageButton;
}

- (UIButton *)roundedButtonType
{
	if (_roundedButtonType == nil) {
		_roundedButtonType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_roundedButtonType.frame = CGRectMake(0, 5, kStdButtonWidth, kStdButtonHeight);
		[_roundedButtonType setTitle:@"Rounded" forState:UIControlStateNormal];
		_roundedButtonType.tag = kViewTag;
	}
	return _roundedButtonType;
}

- (UIButton *)attrTextButton
{
	if (_attrTextButton == nil) {
		_attrTextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_attrTextButton.frame = CGRectMake(0, 5, kStdButtonWidth, kStdButtonHeight);
		NSMutableAttributedString *normalAttrString = [[NSMutableAttributedString alloc] initWithString:@"Rounded"];
		
		[normalAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, normalAttrString.length)];
		
		NSMutableAttributedString *hlAttrString = [[NSMutableAttributedString alloc] initWithString:@"Roounded"];
		
		[hlAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, hlAttrString.length)];
		
		[_attrTextButton setAttributedTitle:normalAttrString forState:UIControlStateNormal];
		[normalAttrString release];
        normalAttrString = nil;
		[_attrTextButton setAttributedTitle:hlAttrString forState:UIControlStateHighlighted];
		[hlAttrString release];
        hlAttrString = nil;
		_attrTextButton.tag = kViewTag;
	}
	
	return _attrTextButton;
}

- (UIButton *)detailDisclosureButton
{
	if (_detailDisclosureButton == nil) {
		_detailDisclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		_detailDisclosureButton.frame = CGRectMake(0, 10, 30, 30);
		_detailDisclosureButton.tag = kViewTag;
	}
	return _detailDisclosureButton;
}

- (UIButton *)infoLightButtonType
{
	if (_infoLightButtonType == nil) {
		_infoLightButtonType = [UIButton buttonWithType:UIButtonTypeInfoLight];
		_infoLightButtonType.frame = CGRectMake(0, 10, 30, 30);
		_infoLightButtonType.backgroundColor = [UIColor lightGrayColor];
		_infoLightButtonType.tag = kViewTag;
	}
	return _infoLightButtonType;
}

- (UIButton *)infoDarkButtonType
{
	if (_infoDarkButtonType == nil) {
		_infoDarkButtonType = [UIButton buttonWithType:UIButtonTypeInfoDark];
		_infoDarkButtonType.frame = CGRectMake(0, 10, 30, 30);
		_infoDarkButtonType.tag = kViewTag;
	}
	return _infoDarkButtonType;
}

- (UIButton *)contactAddType
{
	if (_contactAddType == nil) {
		_contactAddType = [UIButton buttonWithType:UIButtonTypeContactAdd];
		_contactAddType.frame = CGRectMake(0, 10, 30, 30);
		_contactAddType.tag = kViewTag;
	}
	return _contactAddType;
}

- (void)dealloc
{
	[_dataArray release];
    _dataArray = nil;
	[_grayButton release];
    _grayButton = nil;
	[_imageButton release];
    _imageButton = nil;
		[super dealloc];
}


@end

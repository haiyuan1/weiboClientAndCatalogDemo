//
//  QYAlertViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-30.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYAlertViewController.h"

#define kViewTag           101


static NSString *kSectionTitleKey = @"sectiontTitle";
static NSString *kViewTitleKey = @"viewTitle";
static NSString *kSourceOfSubViewKey = @"sourceOfSubView";



static NSString *kViewCellID = @"viewCellID";
static NSString *kSourceViewCellID = @"sourceViewCellID";

@interface QYAlertViewController ()

@property (nonatomic, retain) NSArray *dataArray;

@end

@implementation QYAlertViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
       self.title = @"Alerts";
        
        self.dataArray = @[
                       @{ kSectionTitleKey: @"UIActionsheet",
                          kViewTitleKey:@"Show Simple",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - dialogSimpleAction"
                         },
                       @{ kSectionTitleKey: @"UIActionsheet",
                          kViewTitleKey:@"Show OK-Cancel",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - dialogOKCancelAction"
                          },
                       @{ kSectionTitleKey: @"UIActionsheet",
                          kViewTitleKey:@"Show Customized",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - dialogOtherAction"
                          },
                       @{ kSectionTitleKey: @"UIAlertView",
                          kViewTitleKey:@"Show Simple",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - alertSimpleAction"
                          },
                       @{ kSectionTitleKey: @"UIAlertView",
                          kViewTitleKey:@"Show OK-Cancel",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - alertOKCancelAction"
                          },

                       @{ kSectionTitleKey: @"UIAlertview",
                          kViewTitleKey:@"Show Custom",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - alertOtherAction"
                          },
                       
                       @{ kSectionTitleKey: @"UIAlertview",
                          kViewTitleKey:@"Show Text Input",
                          kSourceOfSubViewKey:@"QYAlertViewController.m - alertSecureAction"
                          }

                       ];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kViewCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSourceViewCellID];
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 50 : 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    switch (indexPath.section) {
        case 0: {
            UIActionSheet *simpleAction = [[UIActionSheet alloc] initWithTitle:@"UIActionSheet<title>" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [simpleAction showInView:self.view];
            [simpleAction release];
            simpleAction = nil;
        
        }
            break;
        case 1: {
            UIActionSheet *showOKCancel = [[UIActionSheet alloc] initWithTitle:@"UIActionSheet<title>" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [showOKCancel showInView:self.view];
            [showOKCancel release];
            showOKCancel = nil;

        }
            break;
        case 2: {
            UIActionSheet *customSheet = [[UIActionSheet alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
            [customSheet setTitle:@"UIActionSheet<title>"];
            [customSheet addButtonWithTitle:@"Button1"];
            [customSheet addButtonWithTitle:@"Button2"];
            [customSheet setDestructiveButtonIndex:1];
            [customSheet showInView:self.view];
            [customSheet release];
            customSheet = nil;

        }
            break;
        case 3: {
            UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [simpleAlert show];
            [simpleAlert release];
            simpleAlert = nil;
        }
            break;
        case 4: {
            UIAlertView *showOKCancelAlert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [showOKCancelAlert show];
            [showOKCancelAlert release];
            showOKCancelAlert = nil;

        }
            break;
        case 5: {
            UIAlertView *customAlert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"<Alert message>" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Button1",@"Button2", nil];
            [customAlert show];
            [customAlert release];
            customAlert = nil;
            
        }
            break;
        case 6: {
            UIAlertView *secureAlert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:@"Enter a password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            secureAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [secureAlert show];
            [secureAlert release];
            secureAlert = nil;
        }
            break;
   
        default:
            break;
    }
}

#pragma mark - Table View Cells setting
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *dict = _dataArray[indexPath.section];
   
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kViewCellID forIndexPath:indexPath];
        cell.textLabel.text = nil;
        cell.textLabel.text = [dict objectForKey:kViewTitleKey];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setSelected:YES animated:YES];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kSourceViewCellID forIndexPath:indexPath];
        cell.textLabel.text = nil;
        cell.textLabel.text = [dict objectForKey:kSourceOfSubViewKey];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   
     return cell;
}

- (void)dealloc {
    
    [_dataArray release];_dataArray = nil;
    [super dealloc];
}

@end

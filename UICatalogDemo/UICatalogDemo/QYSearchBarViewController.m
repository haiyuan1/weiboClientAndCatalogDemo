//
//  QYSearchBarViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-28.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSearchBarViewController.h"

@interface QYSearchBarViewController ()

@property (nonatomic, retain) UISearchBar *searchBar;

@end

@implementation QYSearchBarViewController

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
    
    self.title = @"SearchBar";
    
    //创建searchBar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    _searchBar.backgroundColor = [UIColor blueColor];
    
    //属性设置
    _searchBar.showsBookmarkButton = YES;
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    
    [self.view addSubview:_searchBar];
    //创建segmented
    NSArray *items = @[@"Normal", @"Tinted", @"Background"];
    UISegmentedControl *changeBgView = [[UISegmentedControl alloc] initWithItems:items];
    changeBgView.frame = CGRectMake(30, 130, 260, 30);
    changeBgView.tintColor = [UIColor grayColor];
    
    [changeBgView addTarget:self action:@selector(changeViewStyle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:changeBgView];
    [changeBgView release];

}

#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CGRect searchBarFrame = searchBar.frame;
    searchBarFrame.origin.y -= 44;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    searchBar.frame = searchBarFrame;
    [UIView commitAnimations];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    CGRect searchBarFrame = searchBar.frame;
    searchBarFrame.origin.y += 44;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    searchBar.frame = searchBarFrame;
    [UIView commitAnimations];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    CGRect searchBarFrame = searchBar.frame;
    searchBarFrame.origin.y += 44;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    searchBar.frame = searchBarFrame;
    [UIView commitAnimations];
    [searchBar resignFirstResponder];

}

- (void)changeViewStyle:(UISegmentedControl *)sender
{
//    NSLog(@"%s:%d", __func__, sender.selectedSegmentIndex);
    _searchBar.barTintColor = nil;
    [_searchBar setBackgroundImage:nil];
    [_searchBar setImage:nil forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    switch (sender.selectedSegmentIndex) {
        case 1:
            _searchBar.barTintColor = [UIColor redColor];
            break;
        case 2:
            [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchBarBackground"]];
            [_searchBar setImage:[UIImage imageNamed:@"bookmarkImage"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
            [_searchBar setImage:[UIImage imageNamed:@"bookmarkImageHighlighted"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
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
    [_searchBar release];
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

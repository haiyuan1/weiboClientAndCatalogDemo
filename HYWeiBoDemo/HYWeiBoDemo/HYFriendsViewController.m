//
//  HYFriendsViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-2.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYFriendsViewController.h"
#import "UIImageView+WebCache.h"
#import "ChineseToPinyin.h"

@interface HYFriendsViewController () <SinaWeiboRequestDelegate, UISearchBarDelegate>

@property (nonatomic, retain) NSArray *indexKeys;
@property (nonatomic, retain) NSArray *friendList;
@property (nonatomic, retain) NSMutableDictionary *showContact;
@property (nonatomic,  retain) NSArray *sectionsTitles;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation HYFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人";
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -20);
    
    _indexKeys = [[NSArray alloc] initWithObjects:UITableViewIndexSearch, @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    
    self.searchBar.placeholder = @"搜索";
//    self.searchBar.showsCancelButton = YES;
    self.searchBar.showsBookmarkButton = YES;
    
    _showContact = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    self.searchBar.delegate = self;
    
    [self requestFriendListFromServer];
}

- (void)requestFriendListFromServer
{
    [AppDelegate.sinaWeibo requestWithURL:@"friendships/friends.json" params:[NSMutableDictionary dictionaryWithObject:AppDelegate.sinaWeibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) {
        [self.tableView scrollRectToVisible:self.searchBar.frame animated:YES];
        return -1;
    }
    return [self.sectionsTitles indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.sectionsTitles[section];
    NSArray *contacts = self.showContact[key];
    return contacts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionsTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"FriendListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    NSString *key = self.sectionsTitles[indexPath.section];
    cell.textLabel.text = [self.showContact[key][indexPath.row] objectForKey:kUserInfoScreenName];
    NSString *strAvatarImageViewUrl = [self.showContact[key][indexPath.row] objectForKey:kFriendUserProfileImageUrl];
    [cell.imageView setImageWithURL:[NSURL URLWithString:strAvatarImageViewUrl]];
    
    return cell;
}

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}

- (NSString *)getPinyinNameFirstLetter:(NSString *)userName
{
    NSString *strRet = nil;
    if ([userName canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        strRet = [[NSString stringWithFormat:@"%c", [userName characterAtIndex:0]] uppercaseString];
    } else {
        unichar firstLetter = pinyinFirstLetter([userName characterAtIndex:0]);
        strRet = [[NSString stringWithFormat:@"%c", firstLetter] uppercaseString];
    }
    return strRet;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    self.friendList = [result objectForKey:kFriendUser];
    [self reloadData:self.friendList];
}

- (void)doSearchWithText:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"screen_name CONTAINS[c]%@", searchText];
    NSArray *searchContacts = [self.friendList filteredArrayUsingPredicate:predicate];
    if ([searchText isEqualToString:@""]) {
        searchContacts = [self.friendList copy];
    }
    [self.showContact removeAllObjects];
    [self reloadData:searchContacts];
}


#pragma mark - searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        [self.showContact removeAllObjects];
        [self reloadData:self.friendList];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self doSearchWithText:searchBar.text];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)reloadData:(NSArray *)array
{
    for (NSDictionary *contact in array) {
        NSString *friendName = [contact objectForKey:kUserInfoScreenName];
        NSString *nameFirstLetter = [self getPinyinNameFirstLetter:friendName];
        if (!isalpha([nameFirstLetter characterAtIndex:0])) {
            nameFirstLetter = @"#";
        }
        NSMutableArray *tempcontactArray = self.showContact[nameFirstLetter];
        if (nil == tempcontactArray) {
            tempcontactArray = [[NSMutableArray alloc] initWithCapacity:10];
            [tempcontactArray addObject:contact];
            [self.showContact setObject:tempcontactArray forKey:nameFirstLetter];
            HYSafeRelease(tempcontactArray);
        } else {
            [tempcontactArray addObject:contact];
        }
    }
    NSMutableArray *titlesArray = [[[self.showContact allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    NSInteger indexOfJing = [titlesArray indexOfObject:@"#"];
    if (indexOfJing != NSNotFound) {
        [titlesArray removeObjectAtIndex:indexOfJing];
        [titlesArray addObject:@"#"];
    }
    self.sectionsTitles = titlesArray;
    HYSafeRelease(titlesArray);
    [self.tableView reloadData];
}

- (void)dealloc
{
    HYSafeRelease(_indexKeys);
    HYSafeRelease(_showContact);
    [_searchBar release];
    [super dealloc];
}
@end

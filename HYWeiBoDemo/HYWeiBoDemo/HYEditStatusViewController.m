//
//  HYEditStatusViewController.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-1.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYEditStatusViewController.h"
#import "HYEmojiPageView.h"
#import "HYFriendsViewController.h"
#import "NSString+FrameHight.h"
#import "UIImageView+WebCache.h"

@interface HYEditStatusViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, HYEmojPageViewDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, retain) UIToolbar *kbTopBarView;
@property (nonatomic, retain) UIScrollView *emojiScrollView;
@property (nonatomic, retain) NSMutableString *cacheTextViewText;
@property (nonatomic, retain) UIView *retweetBackgroundView;

@property (nonatomic, retain) NSMutableArray *postImages;

@end

@implementation HYEditStatusViewController

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
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    self.senderBtn.enabled = NO;
    self.senderBtn.alpha = 0.5;
    
    self.kbTopBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 568, 320, 44)];
    self.kbTopBarView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.kbTopBarView];
    [self createKeyboardTopBarItems];
    
    if (self.dicStatus != nil) {
        self.textView.text = [self.dicStatus objectForKey:kStatuesText];
        CGFloat statusTextHeight = [self.textView.text frameHeightWithFountSize:14.0f forViewWidth:300.0f];
        _retweetBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, statusTextHeight + 10, 300, 80)];
        _retweetBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _retweetBackgroundView.layer.borderWidth = 0.5f;
        
        UIImageView *thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_retweetBackgroundView addSubview:thumbImageView];
        
        UILabel *retweetUserName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thumbImageView.frame) + 10, 10, 200, 20)];
        retweetUserName.textColor = [UIColor blackColor];
        [_retweetBackgroundView addSubview:retweetUserName];
        
        UILabel *labelRetweetStatusText = [[UILabel alloc] initWithFrame:CGRectMake(retweetUserName.frame.origin.x, CGRectGetMaxY(retweetUserName.frame) + 5, 200, 40)];
        labelRetweetStatusText.numberOfLines = 2;
        labelRetweetStatusText.textColor = [UIColor lightGrayColor];
        labelRetweetStatusText.font = [UIFont systemFontOfSize:13.0f];
        [_retweetBackgroundView addSubview:labelRetweetStatusText];
        
        NSDictionary *dicRetweetStatus = [self.dicStatus objectForKey:kStatuesRetweetStatues];
        if (dicRetweetStatus != nil) {
            NSArray *picUrls = dicRetweetStatus[kStatuesPicUrls];
            if (picUrls.count > 0 && picUrls != nil) {
                [thumbImageView setImageWithURL:[NSURL URLWithString:picUrls[0][kStatuesThumbnailPic]]];
            } else {
                [thumbImageView setImageWithURL:[NSURL URLWithString:dicRetweetStatus[kStatuesUserInfo][kUserAvatarLarge]]];
            }
            retweetUserName.text = dicRetweetStatus[kStatuesUserInfo][kUserInfoScreenName];
            labelRetweetStatusText.text = dicRetweetStatus[kStatuesText];
        } else {
            NSArray *picUrls = [self.dicStatus objectForKey:kStatuesPicUrls];
            if (picUrls.count > 0 && picUrls != nil) {
                [thumbImageView setImageWithURL:[NSURL URLWithString:[picUrls[0] objectForKey:kStatuesThumbnailPic]]];
            } else {
                [thumbImageView setImageWithURL:[NSURL URLWithString:self.dicStatus[kStatuesUserInfo][kUserAvatarLarge]]];
            }
            retweetUserName.text = self.dicStatus[kStatuesUserInfo][kUserInfoScreenName];
            labelRetweetStatusText.text = self.dicStatus[kStatuesText];
        }
        HYSafeRelease(thumbImageView);
        HYSafeRelease(retweetUserName);
        HYSafeRelease(labelRetweetStatusText);
        [self.textView addSubview:_retweetBackgroundView];
    }
}

- (void)createKeyboardTopBarItems
{
    UIBarButtonItem *flexSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(onCameraBarItemTapped:)];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(onPhotoBarItemTapped:)];
    UIBarButtonItem *atContactItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onAtContactBarItemTapped:)];
    UIBarButtonItem *emotionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onEmotionBarItemTapped:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddBarItemTapped:)];
    
    [self.kbTopBarView setItems:@[cameraItem, flexSpaceItem, photoItem, flexSpaceItem, atContactItem, flexSpaceItem, emotionItem, flexSpaceItem, addItem]];
    
}

#pragma mark - BarButtonItem event

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Open Media Error" message:@"Device doesn't support that media source" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)onCameraBarItemTapped:(UIBarButtonItem *)sender
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void)onPhotoBarItemTapped:(UIBarButtonItem *)sender
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)onAtContactBarItemTapped:(UIBarButtonItem *)sender
{
    HYFriendsViewController *friendsViewCtrl = [[HYFriendsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self presentViewController:friendsViewCtrl animated:YES completion:NULL];
    HYSafeRelease(friendsViewCtrl);
}

- (void)onEmotionBarItemTapped:(UIBarButtonItem *)sender
{
    if (self.emojiScrollView != nil) {
        [self.emojiScrollView removeFromSuperview];
        self.emojiScrollView = nil;
        [self.textView becomeFirstResponder];
    } else {
        _emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 216, 320, 216)];
        self.emojiScrollView.backgroundColor = [UIColor whiteColor];
        self.emojiScrollView.pagingEnabled = YES;
        self.emojiScrollView.showsHorizontalScrollIndicator = NO;
        self.emojiScrollView.showsVerticalScrollIndicator = NO;
        NSUInteger nPageCount = [HYEmojiPageView pageForAllEmoji:35];
        self.emojiScrollView.contentSize = CGSizeMake(320*nPageCount, 216);
        
        for (int i = 0; i < nPageCount; i++) {
            HYEmojiPageView *fView = [[HYEmojiPageView alloc] initWithFrame:CGRectMake(10 + 320 * i, 15, 320, 170)];
            fView.delegate = self;
            fView.backgroundColor = [UIColor clearColor];
            [fView loadEmojiItem:i size:CGSizeMake(33, 43)];
            [self.emojiScrollView addSubview:fView];
            HYSafeRelease(fView);
        }
        self.textView.inputView = self.emojiScrollView;
        [self.textView resignFirstResponder];
    }
}

#pragma mark - EmojiPageViewDelegate
- (void)emojiViewDidSelected:(HYEmojiPageView *)emojiView Item:(UIButton *)btnItem
{
//    NSMutableString *textViewString = [NSMutableString string];
//    [textViewString appendString:self.textView.text];
//    [textViewString appendString:[btnItem titleForState:UIControlStateNormal]];
//    self.textView.text = textViewString;
    [self textView:self.textView shouldChangeTextInRange:NSRangeFromString(nil) replacementText:[btnItem titleForState:UIControlStateNormal]];
}

- (void)onAddBarItemTapped:(UIBarButtonItem *)sender
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HYNSDC addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [HYNSDC addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [HYNSDC removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [HYNSDC removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.textView addGestureRecognizer:self.swipeGesture];
    HYSafeRelease(self.swipeGesture);
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect kbTopBarViewShowFrame = CGRectMake(keyboardFrame.origin.x, keyboardFrame.origin.y - 44, 320, 44);
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:timerInterval delay:0.0f options:animationOptions animations:^{
        self.kbTopBarView.frame = kbTopBarViewShowFrame;
    } completion:nil];
    
    CGRect oldTextViewFrame = self.textView.frame;
    oldTextViewFrame.size.height -= (CGRectGetHeight(keyboardFrame)+44);
    self.textView.frame = oldTextViewFrame;
}

- (void)keyboardWillHiden:(NSNotification *)notification
{
    [self.textView removeGestureRecognizer:self.swipeGesture];
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect kbTopBarViewFrame = CGRectMake(keyBoardFrame.origin.x, CGRectGetMinY(keyBoardFrame) - 44, 320, 44);
    CGFloat timerInterval = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:timerInterval delay:0.0f options:animationOptions animations:^{
        self.kbTopBarView.frame = kbTopBarViewFrame;
    } completion:nil];
    
    CGRect oldTextViewFrame = self.textView.frame;
    oldTextViewFrame.size.height += (CGRectGetHeight(keyBoardFrame) + 44);
    self.textView.frame = oldTextViewFrame;
}
#pragma mark - swipeGesture
- (void)onSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    [self.textView resignFirstResponder];
}

#pragma mark - navView Button event
- (IBAction)onCancelButton:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"存入草件箱", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)onSenderButton:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在发送..."];
    NSString *statusText = self.textView.text;
    if (self.postImages != nil && self.postImages.count > 0) {
        [AppDelegate.sinaWeibo requestWithURL:@"statuses/upload.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:statusText,@"status",[self.postImages lastObject], @"pic", nil] httpMethod:@"POST" delegate:self];
    } else {
        [AppDelegate.sinaWeibo requestWithURL:@"statuses/update.json" params:[NSMutableDictionary dictionaryWithObject:statusText forKey:@"status"] httpMethod:@"POST" delegate:self];
    }
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (self.navigationController != nil) {
                [self.textView resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            break;
        case 1:
            if (self.navigationController != nil) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            break;
        case 2:
            break;
        default:
            break;
    }
}

#pragma mark - textView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSRange range;
    range.location = 0;
    range.length = 0;
    textView.selectedRange = range;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"分享新鲜事..."]) {
        textView.text = nil;
    } else if (textView.text.length == 0) {
        textView.text = @"分享新鲜事...";
        textView.selectedRange = range;
    } else  if (textView.text.length > 0) {
        NSRange delRange;
        if ([text isEqualToString:@""] || text == nil) {
            if (range.location >= 1) {
                delRange.location = range.location - 1;
                delRange.length = 1;
            } else if (range.location == 0) {
                delRange.location = 0;
                delRange.length = 1;
            }
            [self.cacheTextViewText deleteCharactersInRange:delRange];
        } else {
            [self.cacheTextViewText appendString:text];
        }
        self.textView.text = self.cacheTextViewText;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0 && ![textView.text isEqualToString:@"分享新鲜事..."]) {
        self.senderBtn.enabled = YES;
        self.senderBtn.alpha = 1.0f;
    } else {
        self.senderBtn.enabled = NO;
        self.senderBtn.alpha = 0.5f;
    }
}

#pragma mark - UIPickerImageControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.postImages == nil) {
        _postImages = [[NSMutableArray alloc] initWithCapacity:9];
    }
    [self.postImages addObject:image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 200, 100)];
    imageView.image = image;
    [self.textView addSubview:imageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableString *)cacheTextViewText
{
    if (_cacheTextViewText == nil) {
        _cacheTextViewText = [[NSMutableString alloc] initWithCapacity:20];
    }
    return _cacheTextViewText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sinaWeibo request delegate
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *respond = (NSHTTPURLResponse *)response;
    if (respond.statusCode == 200) {
        [SVProgressHUD dismissWithSuccess:@"成功"];
        if (self.navigationController != nil) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD dismissWithError:@"发送失败"];
}

- (void)dealloc
{
    HYSafeRelease(_textView);
    HYSafeRelease(_senderBtn);
    HYSafeRelease(_emojiScrollView);
    HYSafeRelease(_cacheTextViewText);
    HYSafeRelease(_swipeGesture);
    HYSafeRelease(_kbTopBarView);
    HYSafeRelease(_postImages);
    [super dealloc];
}
@end

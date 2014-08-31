//
//  QYTextViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-28.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYTextViewController.h"

@interface QYTextViewController ()

@property (nonatomic, retain) UITextView *textView;

@end

@implementation QYTextViewController

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
    
    self.title = @"TextView";
    [self setupTextView];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillApear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - setup TextView
- (void)setupTextView
{
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    NSString *text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country\n\nThis text view can also use attributed strings.";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(text.length - 23, 3)];
    [attributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:NSMakeRange(text.length - 23, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length - 19, 19)];
    
    _textView.attributedText = attributedString;
    _textView.delegate = self;
    [attributedString release];
    
    [self.view addSubview:_textView];
    
}

#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [saveItem release];
}

- (void)saveAction:(UIBarButtonItem *)sender
{
    [_textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Notifications
- (void)keyboardWillApear:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGRect keyboradFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double animationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"resize4keyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect textViewFrame = _textView.frame;
    textViewFrame.size.height -= keyboradFrame.size.height;
    _textView.frame = textViewFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGRect keyboradFrame = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double animationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"resize4keyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect textViewFrame = _textView.frame;
    textViewFrame.size.height += keyboradFrame.size.height;
    _textView.frame = textViewFrame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_textView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

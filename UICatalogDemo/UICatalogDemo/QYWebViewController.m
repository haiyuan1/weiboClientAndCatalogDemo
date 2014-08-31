//
//  QYWebViewController.m
//  UICatalogDemo
//
//  Created by qingyun on 14-6-29.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYWebViewController.h"

@interface QYWebViewController ()

@property (nonatomic, retain) UITextField *urlTextField;
@property (nonatomic, retain) UIWebView *webView;

@end

@implementation QYWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Web";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //URL搜索栏TextField
    _urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, 300, 30)];
    _urlTextField.borderStyle = UITextBorderStyleRoundedRect;
    _urlTextField.text = @"http://www.apple.com";
    _urlTextField.textColor = [UIColor blackColor];
    _urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _urlTextField.delegate = self;
    
    _urlTextField.keyboardType = UIKeyboardTypeURL;
    _urlTextField.returnKeyType = UIReturnKeyGo;
    
    [self.view addSubview:_urlTextField];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 94, 320, 480)];
    _webView.delegate = self;
    
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    //请求URL，打开URL地址相对应的Web页面
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlTextField.text]]];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlTextField.text]]];
    
    return YES;
}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_webView release];
    _webView = nil;
    [_urlTextField release];
    _urlTextField = nil;
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

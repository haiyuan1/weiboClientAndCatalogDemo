//
//  HYEditStatusViewController.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-1.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYEditStatusViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIButton *senderBtn;
@property (retain, nonatomic) NSDictionary *dicStatus;
@end

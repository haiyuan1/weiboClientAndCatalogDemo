//
//  HYEmojiPageView.h
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-2.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYEmojPageViewDelegate;

@interface HYEmojiPageView : UIView

@property (nonatomic, assign) id <HYEmojPageViewDelegate>delegate;


- (void)loadEmojiItem:(int)page size:(CGSize)size;

+ (NSInteger)pageForAllEmoji:(int)countPage;

@end

@protocol HYEmojPageViewDelegate <NSObject>

- (void)emojiViewDidSelected:(HYEmojiPageView *)emojiView Item:(UIButton *)btnItem;

@end

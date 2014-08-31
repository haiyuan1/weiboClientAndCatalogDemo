//
//  HYEmojiPageView.m
//  HYWeiBoDemo
//
//  Created by qingyun on 14-8-2.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "HYEmojiPageView.h"
#import "Emoji.h"

@interface HYEmojiPageView ()

@property (nonatomic, retain) NSArray *allEmojis;

@end

@implementation HYEmojiPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allEmojis = [Emoji allEmoji];
    }
    return self;
}

- (void)loadEmojiItem:(int)page size:(CGSize)size
{
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 9; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(j*size.width, i*size.height, size.width, size.height);
            UIFont *emojiFont = [UIFont fontWithName:@"AppleColorEmoji" size:29.0];
            btn.titleLabel.font = emojiFont;
            if (i == 3 && j == 8) {
                [btn setImage:[UIImage imageNamed:@"emojiDelete"] forState:UIControlStateNormal];
            } else {
                NSString *emoji = self.allEmojis[i*9 + j + page*35];
                [btn setTitle:emoji forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
}

- (void)onButtonTapped:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(emojiViewDidSelected:Item:)]) {
        [self.delegate emojiViewDidSelected:self Item:button];
    }
}

+ (NSInteger)pageForAllEmoji:(int)countPage
{
    NSArray *emojis = [Emoji allEmoji];
    return emojis.count / countPage;
}

@end

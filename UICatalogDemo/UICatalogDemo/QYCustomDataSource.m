//
//  QYCustomDataSource.m
//  UICatalogDemo
//
//  Created by qingyun on 14-7-1.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYCustomDataSource.h"

@implementation QYCustomDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

#if 1
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 120, 30)];
    lable.font = [UIFont systemFontOfSize:18];
    switch (row) {
        case 0: {
            UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12-6AM"]];
            imageView1.frame = CGRectMake(70, 0, 30, 30);
            lable.text = @"Early Morning";
            [rowView addSubview:imageView1];
            [rowView addSubview:lable];
            [imageView1 release];
            imageView1 = nil;
        }
            break;
        case 1: {
            UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6-12AM"]];
            imageView2.frame = CGRectMake(70, 0, 30, 30);
            lable.text = @"Late Morning";
            [rowView addSubview:imageView2];
            [rowView addSubview:lable];
            [imageView2 release];
            imageView2 = nil;
        }
            break;
        case 2: {
            UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12-6PM"]];
            imageView3.frame = CGRectMake(70, 0, 30, 30);
            lable.text = @"Afternoon";
            [rowView addSubview:imageView3];
            [rowView addSubview:lable];
            [imageView3 release];
            imageView3 = nil;
        }
            break;
        case 3: {
            UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6-12PM"]];
            imageView4.frame = CGRectMake(70, 0, 30, 30);
            lable.text = @"Evening";
            [rowView addSubview:imageView4];
            [rowView addSubview:lable];
            [imageView4 release];
            imageView4 = nil;
        }
            break;

        default:
            break;
    }
    return rowView;
}
#endif
@end

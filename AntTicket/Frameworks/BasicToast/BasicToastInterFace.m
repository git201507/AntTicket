//
//  BasicToastInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicToastInterFace.h"
#import "BasicToastManger.h"

@implementation BasicToastInterFace

+ (void)showToast:(NSString *)text
{
    [[BasicToastManger Instance] showToast:text];
}

+ (void)showToast:(NSString *)text showTime:(BasicToastTime)time
{
    [[BasicToastManger Instance] showToast:text showTime:time];
}

+ (void)showToast:(NSString *)text font:(BasicToastFont)font
{
    [[BasicToastManger Instance] showToast:text font:font];
}

+ (void)showToast:(NSString *)text showTime:(BasicToastTime)time font:(BasicToastFont)font
{
    [[BasicToastManger Instance] showToast:text showTime:time font:font];
}

@end

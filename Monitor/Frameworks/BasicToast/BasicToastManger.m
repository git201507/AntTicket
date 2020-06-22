//
//  BasicToastManger.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicToastManger.h"
#import "BasicToastView.h"

@interface BasicToastManger ()
{
@private
    __weak BasicToastView *_toastView;
}

@end

@implementation BasicToastManger

+ (BasicToastManger*)Instance
{
    static BasicToastManger *obj = nil;
    @synchronized([BasicToastManger class])
    {
        if (obj == nil)
        {
            obj = [[BasicToastManger alloc] init];
        }
        
    }
    return obj;
}

- (BasicToastView *)getToastView
{
    if (!_toastView)
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicToastView" owner:self options:nil]; //通过这个方法,取得我们的视图
        _toastView = [nibViews objectAtIndex:0];
    }
    return _toastView;
}

- (void)showToast:(NSString *)text
{
    BasicToastView *view = [self getToastView];
    [view setText:text];
    [view show];
}

- (void)showToast:(NSString *)text showTime:(BasicToastTime)time
{
    BasicToastView *view = [self getToastView];
    [view setShowDuringTime:time];
    [view setText:text];
    [view show];
}

- (void)showToast:(NSString *)text font:(BasicToastFont)font
{
    BasicToastView *view = [self getToastView];
    [view setTextFount:font];
    [view setText:text];
    [view show];
}

- (void)showToast:(NSString *)text showTime:(BasicToastTime)time font:(BasicToastFont)font
{
    BasicToastView *view = [self getToastView];
    [view setShowDuringTime:time];
    [view setTextFount:font];
    [view setText:text];
    [view show];
}


@end

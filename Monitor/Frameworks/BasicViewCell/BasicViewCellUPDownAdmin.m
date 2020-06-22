//
//  BasicViewCellUPDownAdmin.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCellUPDownAdmin.h"

@implementation BasicViewCellUPDownAdmin

- (void)animationPushWillStart:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell
{
    CGRect rect = pushViewCell.frame;
    rect.origin.y = ViewCellManger.frame.size.height;
    pushViewCell.frame = rect;
    
    [UIView beginAnimations:@"BasicViewCellAdminPush" context:nil];
    
    [UIView setAnimationDuration:BASICVIEWCELLADMINTIME];//动画执行时间
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画的执行速度
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    pushViewCell.frame = ViewCellManger.bounds;
    [UIView commitAnimations];
    
    
}

- (void)animationPopWillStart:(BasicViewCellManger *)ViewCellManger popViewCell:(BasicViewCell *)popViewCell
{
    [UIView beginAnimations:@"BasicViewCellAdminPOP" context:nil];
    
    [UIView setAnimationDuration:BASICVIEWCELLADMINTIME];//动画执行时间
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画的执行速度
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    CGRect rect = popViewCell.frame;
    rect.origin.y = ViewCellManger.frame.size.height;
    popViewCell.frame = rect;
    [UIView commitAnimations];
}

@end

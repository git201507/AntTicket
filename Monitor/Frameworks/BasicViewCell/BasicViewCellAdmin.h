//
//  BasicViewCellAdmin.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicViewCellManger.h"

#define BASICVIEWCELLADMINTIME  (0.2)

@interface BasicViewCellAdmin : NSObject
{
    __weak BasicViewCell *_viewCell;
    __weak BasicViewCellManger *_viewCellManger;
    SEL _pushSEL;
    SEL _popSEL;
}


- (void)pushAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL;
- (void)popAdmin:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell doneAdmin:(SEL)adminSEL;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

// 动画, 需要不同动画重写这些函数
- (void)animationPushWillStart:(BasicViewCellManger *)ViewCellManger pushViewCell:(BasicViewCell *)pushViewCell;
- (void)animationPopWillStart:(BasicViewCellManger *)ViewCellManger popViewCell:(BasicViewCell *)popViewCell;


@end

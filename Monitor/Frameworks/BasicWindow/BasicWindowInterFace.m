//
//  BasicWindowInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicWindowInterFace.h"

@implementation BasicWindowInterFace

+ (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level
{
    return [[BasicWindowManger Instance] addViewToWindow:view level:level];
}

//获取当前显示的viewcon
+ (UIViewController *)getCurTopController
{
    return [[BasicWindowManger Instance] getCurTopController];
}
//获取当前主win
+ (UIWindow *)getMainWindow
{
    return [[BasicWindowManger Instance] getMainWindow];
}

@end

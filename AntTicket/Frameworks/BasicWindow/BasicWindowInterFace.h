//
//  BasicWindowInterFace.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicWindowManger.h"

@interface BasicWindowInterFace : NSObject

//添加view到Window上，根据级别，级别越高显示在最上面
+ (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level;

//获取当前显示的viewcon
+ (UIViewController *)getCurTopController;
//获取当前主win
+ (UIWindow *)getMainWindow;

@end

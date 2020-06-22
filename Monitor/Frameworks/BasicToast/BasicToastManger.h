//
//  BasicToastManger.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicToastDef.h"
@interface BasicToastManger : NSObject
{
    
}


+ (BasicToastManger*)Instance;

- (void)showToast:(NSString *)text;
- (void)showToast:(NSString *)text showTime:(BasicToastTime)time;
- (void)showToast:(NSString *)text font:(BasicToastFont)font;
- (void)showToast:(NSString *)text showTime:(BasicToastTime)time font:(BasicToastFont)font;

@end

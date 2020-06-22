//
//  BasicMessageCenter.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicMessageCenter.h"

@implementation BasicMessageCenter

+ (void)fireMessage:(NSString *)messageId anexObj:(id)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:messageId object:obj];
}

+ (void)subMessage:(id)observer selector:(SEL)aSelector name:(NSString *)aName
{
    [[NSNotificationCenter defaultCenter]  addObserver:observer selector:aSelector name:aName object:nil];
}

+ (void)unSubMessage:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end

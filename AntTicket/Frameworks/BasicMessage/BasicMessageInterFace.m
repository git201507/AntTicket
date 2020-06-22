//
//  BasicMessageInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicMessageInterFace.h"
#import "BasicMessageCenter.h"

@implementation BasicMessageInterFace

+ (void)fireMessageOnMainThread:(NSString *)messageId anexObj:(id)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BasicMessageCenter fireMessage:messageId anexObj:obj];
    });
}

+ (void)fireMessageOnCurrentThread:(NSString *)messageId anexObj:(id)obj
{
    [BasicMessageCenter fireMessage:messageId anexObj:obj];
}

+ (void)subMessage:(id)observer selector:(SEL)aSelector MessageID:(NSString *)messageId
{
    [BasicMessageCenter subMessage:observer selector:aSelector name:messageId];
}

+ (void)unSubMessage:(id)observer
{
    [BasicMessageCenter unSubMessage:observer];
}

@end

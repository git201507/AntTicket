//
//  BasicMessageInterFace.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMessageInterFace : NSObject

//在主线程发送消息，异步接收也在主线程(常用)
+ (void)fireMessageOnMainThread:(NSString *)messageId anexObj:(id)obj;

//在当前线程发送，同步接收也在当前线程
+ (void)fireMessageOnCurrentThread:(NSString *)messageId anexObj:(id)obj;

//绑定消息
+ (void)subMessage:(id)observer selector:(SEL)aSelector MessageID:(NSString *)messageId;

//解除绑定
+ (void)unSubMessage:(id)observer;

@end

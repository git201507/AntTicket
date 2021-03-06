//
//  BasicMessageCenter.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BasicMessageCenter : NSObject

+ (void)fireMessage:(NSString *)messageId anexObj:(id)obj;

+ (void)subMessage:(id)observer selector:(SEL)aSelector name:(NSString *)aName;

+ (void)unSubMessage:(id)observer;

@end

//
//  NSString+JSON.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
//将NSString ，NSArray， NSDic 转成json字符串
+(NSString *) jsonStringWithObject:(id) object;
@end

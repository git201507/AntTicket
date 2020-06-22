//
//  BasicFileMD5Check.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BasicFileMD5Check : NSObject

+ (NSString *)getFileMD5WithPath:(NSString*)path;

//获取md5字符串
+ (NSString *)md5With16:(NSString *)str;

+ (NSString *)md5With64:(NSString *)str;

@end

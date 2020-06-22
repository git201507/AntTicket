//
//  BasicConfigPath.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicConfigPath : NSObject

+ (NSString *)getConfigPathWithKey:(NSString *)key;

+ (NSArray *)getConfigPathKeyArray;

//改变config文件路径
+ (BOOL)changConfigPathWithKey:(NSString *)key val:(NSString *)val;

//从包中复制到doc目录下
+ (BOOL)copyOrReplaceConfigFile;

@end

//
//  HttpUtil.h
//  XQQ
//
//  Created by leehom on 14-11-26.
//  Copyright (c) 2014年 leehom. All rights reserved.
//

#import <Foundation/Foundation.h>

//函数别名,在C++相当于是定义一个函数.有类型及参数个数.要用的时候直接传你实现好的函数地址即可.
//在JAVA中相当于是接口interface,用于回调用的.但是没有Java接口这么强大,Java接口支持N个函数还能被继承
//这里面仅仅是一个函数体,在某时刻被调用而已
typedef void (^FinishBlock)(NSString *dataString);

//http代理
@interface HttpUtil : NSObject<NSURLConnectionDataDelegate>

//定义需要的成员变量
@property (strong, nonatomic) NSMutableData *resultData;//保存HTTP结果对象
@property (strong, nonatomic) FinishBlock finishBlock;//回调方法

//该函数相当于是静态方法 不需要实例即可访问
+(NSString*)httpAsynchronousRequestUrl:(NSString*) spec postStr:(NSString*)sData;

//该函数相当于是静态方法 不需要实例即可访问
+(void)httpNsynchronousRequestUrl:(NSString*) spec postStr:(NSString*)sData finshedBlock:(FinishBlock)block;

@end
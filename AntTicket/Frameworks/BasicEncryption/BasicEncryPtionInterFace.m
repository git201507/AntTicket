//
//  BasicEncryPtionInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicEncryPtionInterFace.h"
#import "BasicEncryPtionAES.h"
#import "BasicFileMD5Check.h"

@implementation BasicEncryPtionInterFace

//加密,key16位，24位或者32位
+ (NSData *)AESEncryptWithKey:(NSString *)key sourceData:(NSData *)data
{
    return [BasicEncryPtionAES AESEncryptWithKey:key sourceData:data];
}
//解密,key16位，24位或者32位
+ (NSData *)AESDecryptWithKey:(NSString *)key sourceData:(NSData *)data;
{
    return [BasicEncryPtionAES AESDecryptWithKey:key sourceData:data];
}
+ (NSString *)getFileMD5WithPath:(NSString*)path
{
    return [BasicFileMD5Check getFileMD5WithPath:path];
}

+ (NSString *)md5With16:(NSString *)str
{
    return [BasicFileMD5Check md5With16:str];
}

+ (NSString *)md5With64:(NSString *)str
{
    return [BasicFileMD5Check md5With64:str];
}

@end

//
//  BasicConfigPath.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicConfigPath.h"
#import "BasicAccountLib.h"

#define CONFIGPATH (@"ConfigPath.plist")

@implementation BasicConfigPath

+ (NSString *)getConfigPathWithKey:(NSString *)key
{
    NSString *path = nil;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    
    if (!dic)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    
    NSString *str = [dic valueForKey:key];
    if (!str)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        str = [dic valueForKey:key];
    }
    path = str;
    
    return path;
}

+ (BOOL)changConfigPathWithKey:(NSString *)key val:(NSString *)val
{
    BOOL rlt = NO;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    [dic setValue:val forKey:key];
    
    rlt = [dic writeToFile:docFilePath atomically:YES];
    
    return rlt;
}

+ (NSArray *)getConfigPathKeyArray
{
    NSArray *array = nil;
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    NSDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:docFilePath];
    
    if (dic)
    {
        array = [dic allKeys];
    }
    
    return array;
}

+ (BOOL)copyOrReplaceConfigFile
{
    BOOL rlt = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ConfigPath" ofType:@"plist"];
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *docFilePath = [NSString stringWithFormat:@"%@/%@", docPath, CONFIGPATH];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    rlt = [dic writeToFile:docFilePath atomically:YES];
    
    return rlt;
}
@end

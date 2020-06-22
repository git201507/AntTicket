//
//  BasicUserManger+Account.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserAccountManger.h"
#import "BasicAccountLib.h"
#import "NSString+JSON.h"
#import "BasicAccountLib.h"

#define ACCOUNTFROM   (@"AccountFrom")

@implementation BasicUserAccountManger

+ (BasicUserAccountManger*) Instance
{
    static BasicUserAccountManger *obj = nil;
    @synchronized([BasicUserAccountManger class])
    {
        if (obj == nil)
        {
            obj = [[BasicUserAccountManger alloc] init];
        }
        
    }
    return obj;
}

- (instancetype)init
{
    id obj = [super init];
    if (obj && !_curAccount)
    {
        _curAccount = [[BasicAccount alloc] init];
        [_curAccount awakenAccountWithName:PUBLICACCOUNT];
    }
    
    return obj;
}

- (BOOL)chooseAccount:(NSString *)accountName
{
    if (_curAccount)
    {
        [_curAccount closeAccount];
    }
    
    _curAccount = [[BasicAccount alloc] init];
    [_curAccount awakenAccountWithName:accountName];
    
    if (![accountName isEqualToString:PUBLICACCOUNT])
    {
        NSArray *array = [self getAccountForm];
        
        if (array)
        {
            NSMutableArray *saveArray = [NSMutableArray arrayWithArray:array];
            for (int i = 0; i < [saveArray count]; i ++)
            {
                NSDictionary *dic = [saveArray objectAtIndex:i];
                NSString *str = [[dic allValues] objectAtIndex:0];
                if ([str isEqualToString:accountName])
                {
                    [saveArray removeObject:dic];
                    break;
                }
            }
            
            NSString *userName = [_curAccount getUserName];
            if (userName)
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:accountName forKey:userName];
                [saveArray insertObject:dic atIndex:0];
                [self setAccountFormToFile:saveArray];
            }
        }
        else
        {
            NSString *userName = [_curAccount getUserName];
            if (userName)
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObject:accountName forKey:userName];
                array = [NSArray arrayWithObjects:dic, nil];
                [self setAccountFormToFile:array];
            }
            
        }
    }
    
    
    
    return YES;
}

- (BOOL)savePassWordInfo:(NSString *)accountName passWord:(NSString *)passWord
{
    BOOL rlt = NO;
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount savePassWordWithName:accountName passWord:passWord];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account savePassWordWithName:accountName passWord:passWord];
    }
    
    return rlt;
}

- (BOOL)saveUserName:(NSString *)accountName userName:(NSString *)userName
{
    BOOL rlt = NO;
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount saveUserNameWithAccountName:accountName userName:userName];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account saveUserNameWithAccountName:accountName userName:userName];
    }
    
    return rlt;
}

- (BOOL)saveToken:(NSString *)accountName token:(NSString *)token
{
    BOOL rlt = NO;
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount saveTokenWithAccountName:accountName token:token];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account saveTokenWithAccountName:accountName token:token];
    }
    
    return rlt;
}

//储存附加信息
- (BOOL)saveAdditionalInfoWithAccountName:(NSString *)accountName dic:(NSDictionary *)addInfo
{
    BOOL rlt = NO;
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount saveAdditionalInfoWithAccountName:accountName additionalDic:addInfo];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account saveAdditionalInfoWithAccountName:accountName additionalDic:addInfo];
    }
    
    return rlt;
}

- (BOOL)setAccountSettingInfo:(NSString *)accountName key:(NSString *)key val:(id)val
{
    BOOL rlt = NO;
    
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount setSettingInfoWithKey:key val:val];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account setSettingInfoWithKey:key val:val];
    }
    
    return rlt;
}

- (instancetype)getAccountSettingInfo:(NSString *)accountName key:(NSString *)key
{
    id rlt = nil;
    
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount getSettingInfoWithKey:key];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account getSettingInfoWithKey:key];
    }
    
    return rlt;
}

//存储用户隐秘信息，自动加密
- (BOOL)setSecretUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val
{
    BOOL rlt = NO;
    NSDictionary *dataDic = [val getObjectData];
    
    NSString *key = [NSString stringWithUTF8String:object_getClassName(val)];
    
    NSString *str = [NSString jsonStringWithObject:dataDic];
    
    if (str && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount saveUserSecretInfoName:str key:key];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account saveUserSecretInfoName:str key:key];
    }
    
    return YES;
}
//获取用户隐秘信息，自动解密 将info alloc后在set
- (BOOL)getSecretUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info
{
    id rlt = nil;
    BOOL rltVal = NO;
    
    if (!info)
    {
        return NO;
    }
    
    NSString *key = [NSString stringWithUTF8String:object_getClassName(info)];
    
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount getUserSecretInfoName:key];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account getUserSecretInfoName:key];
    }
    
    if (rlt)
    {
        NSData *data = [rlt dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        rltVal = [info setJsonDataWithDic:dic];
    }
    
    return rltVal;
}

//存储用户非隐秘信息，不加密
- (BOOL)setPublicUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val
{
    BOOL rlt = NO;
    NSDictionary *dataDic = [val getObjectData];
    
    NSString *key = [NSString stringWithUTF8String:object_getClassName(val)];
    
    NSString *str = [NSString jsonStringWithObject:dataDic];
    
    if (str && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount setPublicUserInfo:str key:key];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account setPublicUserInfo:str key:key];
    }
    
    return YES;
}
//获取用户非隐秘信息
- (BOOL)getPublicUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info
{
    id rlt = nil;
    BOOL rltVal = NO;
    
    if (!info)
    {
        return NO;
    }
    
    NSString *key = [NSString stringWithUTF8String:object_getClassName(info)];
    
    if (_curAccount && [_curAccount.accountName isEqualToString:accountName])
    {
        rlt = [_curAccount getPublicUserInfo:key];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        rlt = [account getPublicUserInfo:key];
    }
    
    if (rlt)
    {
        NSData *data = [rlt dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        rltVal = [info setJsonDataWithDic:dic];
    }
    
    return rltVal;
}

- (NSString *)getPassWordWithAccountName:(NSString *)accountName
{
    NSString *passWord = nil;
    if ([_curAccount.accountName isEqualToString:accountName])
    {
        passWord = [_curAccount getPassWord];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        passWord = [account getPassWord];
    }
    
    return passWord;
}

- (NSString *)getUserNameWithAccountName:(NSString *)accountName
{
    NSString *userName = nil;
    if ([_curAccount.accountName isEqualToString:accountName])
    {
        userName = [_curAccount getUserName];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        userName = [account getUserName];
    }
    
    return userName;
}

- (NSString *)getTokenWithAccountName:(NSString *)accountName
{
    NSString *token = nil;
    if ([_curAccount.accountName isEqualToString:accountName])
    {
        token = [_curAccount getTokenStr];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        token = [account getTokenStr];
    }
    
    return token;
}

//获取附加信息
- (NSDictionary *)getAdditionalInfoWithAccountName:(NSString *)accountName
{
    NSDictionary *infoDic = nil;
    if ([_curAccount.accountName isEqualToString:accountName])
    {
        infoDic = [_curAccount getAdditionalInfo];
    }
    else
    {
        BasicAccount *account = [[BasicAccount alloc] init];
        [account awakenAccountWithName:accountName];
        infoDic = [account getAdditionalInfo];
    }
    
    return infoDic;
}

- (BOOL)setAccountFormToFile:(NSArray *)array
{
    BOOL rlt = NO;
    
    NSString *accountPAth = [BasicAccountLib getAccountPath];
    if (array && accountPAth)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@%@", accountPAth, ACCOUNTFROM];
        rlt = [array writeToFile:filePath atomically:YES];
    }
    return rlt;
}

- (NSArray *)getAccountForm
{
    NSArray *array = nil;
    
    NSString *accountPAth = [BasicAccountLib getAccountPath];
    
    if (accountPAth)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@%@", accountPAth, ACCOUNTFROM];
        
        array = [[NSArray alloc] initWithContentsOfFile:filePath];
    }
    
    return array;
}

- (BOOL)getIsLogingState
{
    BOOL rlt = NO;
    if (_curAccount)
    {
        if (![[_curAccount accountName] isEqualToString:PUBLICACCOUNT])
        {
            rlt = YES;
        }
    }
    
    return rlt;
}

- (NSString *)getCurAccountName
{
    return [_curAccount accountName];
}

- (BasicAccount *)getCurAccountClass
{
    return _curAccount;
}

//清除登录过的列表
- (BOOL)removeAccountList
{
    BOOL rlt = NO;
    NSMutableArray *accountArray = (NSMutableArray *)[self getAccountForm];
    if ([accountArray count] > 0)
    {
        NSString *accountPAth = [BasicAccountLib getAccountPath];
        
        if (accountPAth)
        {
            NSString *filePath = [NSString stringWithFormat:@"%@%@", accountPAth, ACCOUNTFROM];
            rlt = [BasicAccountLib removeFolder:filePath];
        }
        //        [accountArray removeAllObjects];
        //        rlt = [self setAccountFormToFile:accountArray];
    }
    
    return rlt;
}
@end

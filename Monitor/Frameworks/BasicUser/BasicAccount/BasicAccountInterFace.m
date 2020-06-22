//
//  BasicAccountInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicAccountInterFace.h"
#import "BasicUserAccountManger.h"

@implementation BasicAccountInterFace

+ (BOOL)getIsLogingState
{
    return [[BasicUserAccountManger Instance] getIsLogingState];
}


//获取登录过的列表
+ (NSArray *)getAccountForm
{
    return [[BasicUserAccountManger Instance] getAccountForm];
}

//储存账户密码
+ (BOOL)savePassWordInfo:(NSString *)accountName passWord:(NSString *)passWord
{
    return [[BasicUserAccountManger Instance] savePassWordInfo:accountName passWord:passWord];
}


//储存账户名
+  (BOOL)saveUserName:(NSString *)accountName userName:(NSString *)userName
{
    return [[BasicUserAccountManger Instance] saveUserName:accountName userName:userName];
}


//获取token
+ (BOOL)saveToken:(NSString *)accountName token:(NSString *)token
{
    return [[BasicUserAccountManger Instance] saveToken:accountName token:token];
}

//储存附加信息
+ (BOOL)saveAdditionalInfo:(NSString *)accountName dic:(NSDictionary *)addInfo
{
    return [[BasicUserAccountManger Instance] saveAdditionalInfoWithAccountName:accountName  dic:addInfo];
}

//通过账户获取密码
+ (NSString *)getPassWordWithAccountName:(NSString *)accountName
{
    return [[BasicUserAccountManger Instance] getPassWordWithAccountName:accountName ];
}

+ (NSString *)getUserNameWithAccountName:(NSString *)accountName
{
    return [[BasicUserAccountManger Instance] getUserNameWithAccountName:accountName ];
}


//获取token
+ (NSString *)getTokenWithAccountName:(NSString *)accountName
{
    return [[BasicUserAccountManger Instance] getTokenWithAccountName:accountName];
}

//储存附加信息
+ (NSDictionary *)getAdditionalInfoWithAccountName:(NSString *)accountName
{
    return [[BasicUserAccountManger Instance] getAdditionalInfoWithAccountName:accountName];
}


//选择账户
+ (BOOL)chooseAccount:(NSString *)accountName
{
    return [[BasicUserAccountManger Instance] chooseAccount:accountName ];
}


//获取当前账户ID
+ (NSString *)getCurAccountName
{
    return [[BasicUserAccountManger Instance] getCurAccountName];
}


//设置账户setting内信息
+ (BOOL)setAccountSettingInfo:(NSString *)accountName key:(NSString *)key val:(id)val
{
    return [[BasicUserAccountManger Instance] setAccountSettingInfo:accountName key:key val:val];
}


//获取账户setting内信息
+ (instancetype)getAccountSettingInfo:(NSString *)accountName key:(NSString *)key
{
    id obj = [[BasicUserAccountManger Instance] getAccountSettingInfo:accountName key:key];
    return obj;
}


//存储用户隐秘信息，自动加密
+ (BOOL)setSecretUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val
{
    return [[BasicUserAccountManger Instance] setSecretUserInfo:accountName val:val];
}

//获取用户隐秘信息，自动解密 将info alloc后在set
+ (BOOL)getSecretUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info
{
    return [[BasicUserAccountManger Instance] getSecretUserInfo:accountName SetVal:info];
}


//存储用户非隐秘信息，不加密
+ (BOOL)setPublicUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val
{
    return [[BasicUserAccountManger Instance] setPublicUserInfo:accountName val:val];
}

//获取用户非隐秘信息 将info alloc后在set
+ (BOOL)getPublicUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info
{
    return [[BasicUserAccountManger Instance] getPublicUserInfo:accountName SetVal:info];
}


//获取当前账户类
+ (BasicAccount *)getCurAccountClass
{
    return [[BasicUserAccountManger Instance] getCurAccountClass];
}

//清除登录过的列表
+ (BOOL)removeAccountList
{
    return [[BasicUserAccountManger Instance] removeAccountList];
}
@end

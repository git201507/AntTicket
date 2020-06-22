//
//  BasicAccountInterFace.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicAccount.h"
#import "BasicJsonKvcClass.h"

@interface BasicAccountInterFace : NSObject

//是否在登录状态
+ (BOOL)getIsLogingState;

//获取登录过的列表
+ (NSArray *)getAccountForm;

//储存账户密码
+ (BOOL)savePassWordInfo:(NSString *)accountName passWord:(NSString *)passWord;

//储存账户名
+ (BOOL)saveUserName:(NSString *)accountName userName:(NSString *)userName;

//储存token
+ (BOOL)saveToken:(NSString *)accountName token:(NSString *)token;

//储存附加信息
+ (BOOL)saveAdditionalInfo:(NSString *)accountName dic:(NSDictionary *)addInfo;

//通过账户获取密码
+ (NSString *)getPassWordWithAccountName:(NSString *)accountName;

//获取当前账户名称
+ (NSString *)getUserNameWithAccountName:(NSString *)accountName;

//获取token
+ (NSString *)getTokenWithAccountName:(NSString *)accountName;

//获取附加信息
+ (NSDictionary *)getAdditionalInfoWithAccountName:(NSString *)accountName;

//切换账户
+ (BOOL)chooseAccount:(NSString *)accountName;

//获取当前账户类
+ (BasicAccount *)getCurAccountClass;

//获取当前账户ID
+ (NSString *)getCurAccountName;

//设置账户setting内信息
+ (BOOL)setAccountSettingInfo:(NSString *)accountName key:(NSString *)key val:(id)val;

//获取账户setting内信息
+ (instancetype)getAccountSettingInfo:(NSString *)accountName key:(NSString *)key;

//存储用户隐秘信息，自动加密
+ (BOOL)setSecretUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val;

//获取用户隐秘信息，自动解密 将info alloc后在set
+ (BOOL)getSecretUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info;


//存储用户非隐秘信息，不加密
+ (BOOL)setPublicUserInfo:(NSString *)accountName val:(BasicJsonKvcClass *)val;

//获取用户非隐秘信息 将info alloc后在set
+ (BOOL)getPublicUserInfo:(NSString *)accountName SetVal:(BasicJsonKvcClass *)info;

//清除登录过的列表
+ (BOOL)removeAccountList;

@end

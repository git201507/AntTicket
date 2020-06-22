//
//  BasicUserNet.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSSNETRltState)
{
    NSSNETRltState_NETERROR = 0,  //网络连不上或请求超时
    NSSNETRltState_NotReachable = 1,
    NSSNETRltState_SUCESS = 200,  //成功
    NSSNETRltState_OVERDUE = 403,//过期
    NSSNETRltState_NotFound = 404,//没找到
    NSSNETRltState_OTHERERROR = 1404, //其他的问题
    NSSNETRltState_URLERROR = 1405, //url拼写错误
};

typedef NS_ENUM(NSUInteger, NSSNETTimeOut)
{
    NSSNETTimeOut_MinLevel1 = 5,
    NSSNETTimeOut_MinLevel2 = 10,
    NSSNETTimeOut_MaxLevel1 = 25,
    NSSNETTimeOut_MaxLevel2 = 50,
};

#define NETERROR_DISCONNECTION @"无法连接服务器，请稍后再试!  "

@interface BasicUserNet : NSObject
{
    
}

#pragma mark - 登陆
// 登录
+ (NSSNETRltState) PostToLogIn:(NSString *) user password:(NSString *) password receiveData:(NSData **) receiveData;

// 获取user
+ (NSSNETRltState) PostToFetchUserDetailWithAccessToken:(NSString *) token receiveData:(NSData **)receiveData;
// 刷新token
+ (NSSNETRltState) PostToUpdateToken:(NSString *)token receiveData:(NSData **)receiveData;
+ (NSSNETRltState) PostToUpdateAccessToken:(NSString *)token receiveData:(NSData **)receiveData;
// 城市
+ (NSSNETRltState) PostToCity:(NSString *)city  bodyDic:(NSDictionary *)dic receiveData:(NSData **) receiveData;
+ (NSSNETRltState) PostToSetCity:(NSString *)city receiveData:(NSData **) receiveData;

#pragma mark - 注册
// 注册获取验证码
+ (NSSNETRltState) PostToRegisterVerify:(NSString *) phonenum receiveData:(NSData **) receiveData;
// 注册校验验证码
+ (NSSNETRltState) PostToRegisterCheckVerify:(NSString *) phonenum withSN:(NSString *) sn withCode:(NSString *) code receiveData:(NSData **) receiveData;

+ (NSSNETRltState) PostToRegisterCheckVerify:(NSString *) phonenum withCode:(NSString *) code receiveData:(NSData **) receiveData;
// 注册提交
+ (NSSNETRltState) PostToRegisterCommit:(NSString *) phonenum withSession:(NSString *) session withPassword:(NSString *) password receiveData:(NSData **) receiveData;

+ (NSSNETRltState) PostToRegisterCommit:(NSString *) phonenum withPassword:(NSString *) password receiveData:(NSData **) receiveData;

#pragma mark - 找回密码
// 找回密码获取验证码
+ (NSSNETRltState) PostToRetrievePswdVerify:(NSString *) phonenum receiveData:(NSData **) receiveData;
// 找回密码校验验证码
+ (NSSNETRltState) PostToRetrievePswdCheckVerify:(NSString *)phonenum code:(NSString *) code sn:(NSString *) sn receiveData:(NSData **) receiveData;
+ (NSSNETRltState) PostToRetrievePswdCheckVerify:(NSString *) phonenum withCode:(NSString *) code receiveData:(NSData **) receiveData;

// 找回密码提交
+ (NSSNETRltState) PostToRetrievePswdCommit:(NSString *) phonenum session:(NSString *) session newpassword:(NSString *) newpassword receiveData:(NSData **) receiveData;
+ (NSSNETRltState) PostToRetrievePswdCommit:(NSString *) phonenum newpassword:(NSString *) newpassword receiveData:(NSData **) receiveData;


#pragma mark - 修改密码
+ (NSSNETRltState) PostToChangePswdCommit:(NSString *)oldpassword password: (NSString *)password receiveData:(NSData **) receiveData;
+ (NSSNETRltState) PostToChangePswdCommit:(NSString *)oldpassword password: (NSString *)password accountName:(NSString *)accountName receiveData:(NSData **) receiveData;
// 提交密码
+ (NSString *)getChangePassWordCommitURL;
// 校验原密码
+ (NSString *)getChangePassWordVolidateURL;


// 带.do请求的Https,application/json.(parameters值为NSSJsonKvcClass类或可以转成json的类如字典）
+ (NSSNETRltState)UserHTTPPOST:(NSString *)url parameters:(id)parameters receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout;
+ (NSSNETRltState)UserHTTPGET:(NSString *)url receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout;
// 带.do请求的上传图片请求
//+ (NSSNETRltState)UserHTTPPOSTImage:(NSString *)url parameters:(NSDictionary *)parameters fileName:(NSString *)fileName imageData:(NSData *)imageData receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout netStateInfo:(NetStateInfo **)stateInfo;

@end

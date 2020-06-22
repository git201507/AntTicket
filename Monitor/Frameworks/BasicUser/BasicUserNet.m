//
//  BasicUserNet.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserNet.h"
#import "BasicUserDef.h"
#import "BasicDriver.h"
#import "BasicAccountInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "BasicConfigPath.h"

#define LogInURL                        @"auth.action"        //登陆
#define CityChooseSetURL                @"switch/city/set.do"
#define CityChooseURL                   @"switch/city/style.do"

// 注册
//#define RegisterVerifyURL               @"reg/Mobile/GoPaySY/getVerify.action"      //获取验证码

#define RegisterVerifyURL               @"api/push/v1/sms/send"      //获取验证码



//#define RegisterCheckVerifyURL          @"reg/Mobile/volidateCode.action"   //校验验证码

#define RegisterCheckVerifyURL          @"api/push/v1/sms/verify"   //校验验证码
//#define RegisterCommitURL               @"reg/Mobile/submit.action"         //提交注册

#define RegisterCommitURL               @"api/v1/users"         //提交注册

// 找回密码
//#define RetrievePasswordVerifyURL       @"passwd/find/Mobile/GoPaySY/getVerify.action"      //获取验证码
#define RetrievePasswordVerifyURL       @"api/push/v1/sms/send"      //获取验证码
//#define RetrievePasswordCheckVerifyURL  @"passwd/find/Mobile/volidateCode.action"   //校验验证码
#define RetrievePasswordCheckVerifyURL  @"api/push/v1/sms/verify"   //校验验证码
#define RetrievePasswordCommitURL       @"passwd/find/Mobile/submit.action"         //提交

//修改密码
#define ChangePassWordCommitURL         @"passwd/change/submit.do"       //提交密码
#define ChangePassWordCommitWithParasURL(publicid, oldpassword, password) ([NSString stringWithFormat:@"api/v1/users/%@/password?original_password=%@&password=%@", publicid, oldpassword, password])
#define ChangePassWordRetrieveURL(publicid, password) ([NSString stringWithFormat:@"api/v1/users/%@/password?password=%@", publicid, password])

#define ChangePassWordVolidateURL       @"passwd/change/volidate.do"     //校验原密码


@implementation BasicUserNet


//+ (NSSNETRltState) PostToLogIn:(NSString *) user password:(NSString *) password receiveData:(NSData **)receiveData
//{
//    NSString *url = [NSString stringWithFormat: @"%@auth.action?username=%@&password=%@&grant_type=password&scope=mobile", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], user, password];
//    NSSNETRltState state = [NSSNETInterFace HttpGetReq:url receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
//}
+ (NSSNETRltState) PostToLogIn:(NSString *) user password:(NSString *) password receiveData:(NSData **)receiveData
{
//    NSString *url = [NSString stringWithFormat: @"%@oauth/token?grant_type=password&username=%@&password=%@&scope=read", [BasicConfigPath getConfigPathWithKey:@"ACOUNTPATH"], user, password];
//    
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    
//    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    [headerDic setObject:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
//    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:nil header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToFetchUserDetailWithAccessToken:(NSString *) token receiveData:(NSData **)receiveData
{
//    NSString *url = [NSString stringWithFormat: @"%@oauth/check_token?token=%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], token];
//    
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    
//    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    [headerDic setObjectByNSS:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
//    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:nil header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToUpdateToken:(NSString *)token receiveData:(NSData **)receiveData
{
//    NSString *url = [NSString stringWithFormat: @"%@refresh.action?refresh_token=%@&grant_type=password&scope=mobile", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], token];
//    NSSNETRltState state = [NSSNETInterFace HttpGetReq:url receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToUpdateAccessToken:(NSString *)token receiveData:(NSData **)receiveData
{
//    NSString *url = [NSString stringWithFormat: @"%@oauth/token?client_id=%@&grant_type=refresh_token&client_secret=%@&refresh_token=%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"],USERREGISTER_APPID_STRING,USERREGISTER_SECRET_STRING, token];
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    
//    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    [headerDic setObjectByNSS:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
//    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:nil header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}
+ (NSSNETRltState) PostToCity:(NSString *)city bodyDic:(NSDictionary *)dic receiveData:(NSData **) receiveData
{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:city,@"city", dic, @"styles",nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], CityChooseURL];
//    NSSNETRltState state = [self UserHTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToSetCity:(NSString *)city receiveData:(NSData **) receiveData
{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:city,@"city", nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], CityChooseSetURL];
//    NSSNETRltState state = [self UserHTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2];
//    return state;
    NSSNETRltState state;
    
    return state;
}

//+ (NSSNETRltState) PostToRegisterVerify:(NSString *) phonenum receiveData:(NSData **) receiveData
//{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum,@"phone",nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RegisterVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
//}

+ (NSSNETRltState) PostToRegisterVerify:(NSString *) phonenum receiveData:(NSData **) receiveData
{
//    FetchMsgCodeReqInfo *reqInfo = [[FetchMsgCodeReqInfo alloc] init];
//    reqInfo.appId = USERREGISTER_APPID_STRING;
//    reqInfo.mobile = phonenum;
//    reqInfo.templateId = [NSNumber numberWithInt:SMS_TEMP_REG_INT];
//    reqInfo.message = nil;
//    reqInfo.params = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    NSDictionary *parasItem = [[NSDictionary alloc] initWithObjectsAndKeys:@"company", @"key", SMS_TEMP_PARACOMPANY_STRING, @"value", nil];
//    [reqInfo.params addObjectByNSS:parasItem];
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"MSGVERIFYPATH"], RegisterVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqInfo receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRegisterCheckVerify:(NSString *) phonenum withSN:(NSString *) sn withCode:(NSString *) code receiveData:(NSData **) receiveData
{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum, @"phone", sn, @"sn", code, @"code", nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RegisterCheckVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRegisterCheckVerify:(NSString *) phonenum withCode:(NSString *) code receiveData:(NSData **) receiveData
{
//    VerifyMsgCodeReqInfo *reqInfo = [[VerifyMsgCodeReqInfo alloc] init];
//    reqInfo.appId = USERREGISTER_APPID_STRING;
//    reqInfo.mobile = phonenum;
//    reqInfo.verfCode = code;
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"MSGVERIFYPATH"], RegisterCheckVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqInfo receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRegisterCommit:(NSString *) phonenum withSession:(NSString *) session withPassword:(NSString *) password receiveData:(NSData **) receiveData
{    
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum, @"phone", session, @"session", password, @"password", nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RegisterCommitURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRegisterCommit:(NSString *) phonenum withPassword:(NSString *) password receiveData:(NSData **) receiveData
{
//    CommitRegistReqInfo *reqParas = [[CommitRegistReqInfo alloc] init];
//    reqParas.username = phonenum;
//    reqParas.password = password;
//    reqParas.email = nil;
//    reqParas.phone = phonenum;
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RegisterCommitURL];
//    
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    
//    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    [headerDic setObjectByNSS:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
//    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqParas header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}

//+ (NSSNETRltState) PostToRetrievePswdVerify:(NSString *) phonenum receiveData:(NSData **) receiveData
//{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum,@"account",nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RetrievePasswordVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
//}

+ (NSSNETRltState) PostToRetrievePswdVerify:(NSString *) phonenum receiveData:(NSData **) receiveData
{  
//    FetchMsgCodeReqInfo *reqInfo = [[FetchMsgCodeReqInfo alloc] init];
//    reqInfo.appId = USERREGISTER_APPID_STRING;
//    reqInfo.mobile = phonenum;
//    reqInfo.templateId = [NSNumber numberWithInt:SMS_TEMP_LOST_INT];
//    reqInfo.message = nil;
//    reqInfo.params = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    NSDictionary *parasItem = [[NSDictionary alloc] initWithObjectsAndKeys:@"company", @"key", SMS_TEMP_PARACOMPANY_STRING, @"value", nil];
//    [reqInfo.params addObjectByNSS:parasItem];
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"MSGVERIFYPATH"], RetrievePasswordVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqInfo receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRetrievePswdCheckVerify:(NSString *)phonenum code:(NSString *) code sn:(NSString *) sn receiveData:(NSData **) receiveData
{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum, @"account", code, @"code", sn, @"sn", nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RetrievePasswordCheckVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRetrievePswdCheckVerify:(NSString *) phonenum withCode:(NSString *) code receiveData:(NSData **) receiveData;
{
//    VerifyMsgCodeReqInfo *reqInfo = [[VerifyMsgCodeReqInfo alloc] init];
//    reqInfo.appId = USERREGISTER_APPID_STRING;
//    reqInfo.mobile = phonenum;
//    reqInfo.verfCode = code;
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"MSGVERIFYPATH"], RegisterCheckVerifyURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqInfo receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRetrievePswdCommit:(NSString *) phonenum session:(NSString *) session newpassword:(NSString *) newpassword receiveData:(NSData **) receiveData
{
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:phonenum, @"account", session, @"session", newpassword, @"newpasswd", nil];
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RetrievePasswordCommitURL];
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSSNETRltState) PostToRetrievePswdCommit:(NSString *) phonenum newpassword:(NSString *) newpassword receiveData:(NSData **) receiveData
{
//    CommitRegistReqInfo *reqParas = [[CommitRegistReqInfo alloc] init];
//    reqParas.username = phonenum;
//    reqParas.password = newpassword;
//    reqParas.email = nil;
//    reqParas.phone = phonenum;
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", [NSSConfigPath getConfigPathWithKey:@"ACOUNTPATH"], RegisterCommitURL];
//    
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    
//    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    [headerDic setObjectByNSS:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
//    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:reqParas header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}

+ (NSString *)getChangePassWordCommitURL
{
    return [[BasicConfigPath getConfigPathWithKey:@"ACOUNTPATH"] stringByAppendingString:ChangePassWordCommitURL];
}

+ (NSString *)getChangePassWordCommitURL:(NSString *)oldpassword password: (NSString *)password accountName:(NSString *)accountName;
{
    return [[BasicConfigPath getConfigPathWithKey:@"ACOUNTPATH"] stringByAppendingString:ChangePassWordCommitWithParasURL(accountName, oldpassword, password)];
}

+ (NSString *)getChangePasswordRetrieveURL: (NSString *)password accountName:(NSString *)accountName;
{
    return [[BasicConfigPath getConfigPathWithKey:@"ACOUNTPATH"] stringByAppendingString:ChangePassWordRetrieveURL(accountName, password)];
}

+ (NSSNETRltState) PostToChangePswdCommit:(NSString *)oldpassword password: (NSString *)password receiveData:(NSData **) receiveData
{
    NSString *url = [BasicUserNet getChangePassWordCommitURL:oldpassword password:password accountName:[BasicAccountInterFace getCurAccountName]];
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    
    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    [headerDic setObject:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:nil header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
        return state;
}

+ (NSSNETRltState) PostToChangePswdCommit:(NSString *)oldpassword password: (NSString *)password accountName:(NSString *)accountName receiveData:(NSData **) receiveData
{
    NSString *url = [BasicUserNet getChangePasswordRetrieveURL:password accountName:accountName];
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    
    NSData *data = [[NSString stringWithFormat:@"%@:%@",USERREGISTER_APPID_STRING, USERREGISTER_SECRET_STRING]  dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    [headerDic setObject:[NSString stringWithFormat:@"Basic %@", base64Encoded] forKey:@"Authorization"];
    
//    NSSNETRltState state = [NSSNETInterFace HTTPPOST:url parameters:nil header:headerDic receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
//    
//    return state;
    NSSNETRltState state;
    
    return state;
}


+ (NSString *)getChangePassWordVolidateURL
{
    return [[BasicConfigPath getConfigPathWithKey:@"ACOUNTPATH"] stringByAppendingString:ChangePassWordVolidateURL];
}

+ (NSSNETRltState)UserHTTPPOST:(NSString *)url parameters:(id)parameters receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout
{
    NSURL *totalUrl =  [[NSURL alloc] initWithString:url];
    if (!totalUrl)
    {
        totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString *domain = [totalUrl host];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
    NSString *curAccountName = [BasicAccountInterFace getCurAccountName];
    NSString *token = [BasicAccountInterFace getTokenWithAccountName:curAccountName];
    if (!token)
    {
        return NSSNETRltState_NETERROR;
    }
    [cookieProperties setObject:token forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSSNETRltState state /*= [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:timeout netStateInfo:nil]*/;
    if (state == NSSNETRltState_OVERDUE)
    {
        ReciveShellInfo *info = [[ReciveShellInfo alloc] init];
        
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:(*receiveData) options:NSJSONReadingMutableLeaves error:nil];
        
        if ([info setJsonDataWithDic:infoDic])
        {
            if (info.infocode && [info.infocode integerValue] == 2)
            {
                NSArray *array = [BasicAccountInterFace getAccountForm];
                
                if (array && ([array count] > 0))
                {
                    //BOOL isSucess = NO;
                    NSString *isSucess = nil;
                    NSDictionary *accountDic = [array objectAtIndex:0];
                    NSArray *valArray = [accountDic allValues];
                    NSString *accountName = [valArray objectAtIndex:0];
                    //isSucess = [[NSSUserMangerLogIn Instance] doLogInAuto:YES accountName:accountName];
                    isSucess = [[BasicUserMangerLogIn Instance] doLogInAutoRetNewToken:YES accountName:accountName];
                    
                    if (isSucess)
                    {
                        NSURL *totalUrl =  [NSURL URLWithString:url];
                        if (!totalUrl)
                        {
                            totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        }
                        NSString *domain = [totalUrl host];
                        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                        [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
                        //                        NSString *curAccountName = [NSSAccountInterFace getCurAccountName];
                        //                        NSString *token = [NSSAccountInterFace getTokenWithAccountName:curAccountName];
                        //                        if (!token)
                        //                        {
                        //                            return NSSNETRltState_NETERROR;
                        //                        }
                        //                        [cookieProperties setObjectByNSS:token forKey:NSHTTPCookieValue];
                        [cookieProperties setObject:isSucess forKey:NSHTTPCookieValue];
                        [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
                        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                        
                        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                        
                        //state = [NSSNETInterFace HTTPPOST:url parameters:parameters receiveData:receiveData timeOut:NSSNETTimeOut_MaxLevel2 netStateInfo:nil];
                    }
                }
            }
        }
    }
    return state;
}

/*
+ (NSSNETRltState)UserHTTPGET:(NSString *)url receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout
{
    NSURL *totalUrl =  [NSURL URLWithString:url];
    if (!totalUrl)
    {
        totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString *domain = [totalUrl host];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObjectByNSS:@"token" forKey:NSHTTPCookieName];
    NSString *curAccountName = [NSSAccountInterFace getCurAccountName];
    NSString *token = [NSSAccountInterFace getTokenWithAccountName:curAccountName];
    if (!token)
    {
        return NSSNETRltState_NETERROR;
    }
    [cookieProperties setObjectByNSS:token forKey:NSHTTPCookieValue];
    [cookieProperties setObjectByNSS:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObjectByNSS:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObjectByNSS:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSSNETRltState state = [NSSNETInterFace HttpGetReq:url receiveData:receiveData timeOut:timeout netStateInfo:nil];
    
    if (state == NSSNETRltState_OVERDUE)
    {
        ReciveShellInfo *info = [[ReciveShellInfo alloc] init];
        
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:(*receiveData) options:NSJSONReadingMutableLeaves error:nil];
        
        if ([info setJsonDataWithDic:infoDic])
        {
            if (info.infocode && [info.infocode integerValue] == 2)
            {
                NSArray *array = [NSSAccountInterFace getAccountForm];
                
                if (array)
                {
                    BOOL isSucess = NO;
                    NSDictionary *accountDic = [array objectAtIndexByNSS:0];
                    NSArray *valArray = [accountDic allValues];
                    NSString *accountName = [valArray objectAtIndexByNSS:0];
                    isSucess = [[NSSUserMangerLogIn Instance] doLogInAuto:YES accountName:accountName];
                    
                    if (isSucess)
                    {
                        NSURL *totalUrl =  [NSURL URLWithString:url];
                        if (!totalUrl)
                        {
                            totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        }
                        NSString *domain = [totalUrl host];
                        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                        [cookieProperties setObjectByNSS:@"token" forKey:NSHTTPCookieName];
                        NSString *curAccountName = [NSSAccountInterFace getCurAccountName];
                        NSString *token = [NSSAccountInterFace getTokenWithAccountName:curAccountName];
                        if (!token)
                        {
                            return NSSNETRltState_NETERROR;
                        }
                        [cookieProperties setObjectByNSS:token forKey:NSHTTPCookieValue];
                        [cookieProperties setObjectByNSS:domain forKey:NSHTTPCookieDomain];
                        [cookieProperties setObjectByNSS:@"/" forKey:NSHTTPCookiePath];
                        [cookieProperties setObjectByNSS:@"0" forKey:NSHTTPCookieVersion];
                        
                        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                        state = [NSSNETInterFace HttpGetReq:url receiveData:receiveData timeOut:timeout netStateInfo:nil];
                        
                    }
                }
            }
        }
    }
    return state;
}*/

/*
+ (NSSNETRltState)UserHTTPPOSTImage:(NSString *)url parameters:(NSDictionary *)parameters fileName:(NSString *)fileName imageData:(NSData *)imageData receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout netStateInfo:(NetStateInfo **)stateInfo
{
    NSURL *totalUrl =  [NSURL URLWithString:url];
    if (!totalUrl)
    {
        totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString *domain = [totalUrl host];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObjectByNSS:@"token" forKey:NSHTTPCookieName];
    NSString *curAccountName = [NSSAccountInterFace getCurAccountName];
    NSString *token = [NSSAccountInterFace getTokenWithAccountName:curAccountName];
    if (!token)
    {
        return NSSNETRltState_NETERROR;
    }
    [cookieProperties setObjectByNSS:token forKey:NSHTTPCookieValue];
    [cookieProperties setObjectByNSS:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObjectByNSS:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObjectByNSS:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSSNETRltState state = [NSSNETInterFace HTTPPOSTImage:url parameters:parameters fileName:fileName imageData:imageData receiveData:receiveData timeOut:timeout netStateInfo:stateInfo];
    
    if (state == NSSNETRltState_OVERDUE)
    {
        ReciveShellInfo *info = [[ReciveShellInfo alloc] init];
        
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:(*receiveData) options:NSJSONReadingMutableLeaves error:nil];
        
        if ([info setJsonDataWithDic:infoDic])
        {
            if (info.infocode && [info.infocode integerValue] == 2)
            {
                NSArray *array = [NSSAccountInterFace getAccountForm];
                
                if (array)
                {
                    BOOL isSucess = NO;
                    NSDictionary *accountDic = [array objectAtIndexByNSS:0];
                    NSArray *valArray = [accountDic allValues];
                    NSString *accountName = [valArray objectAtIndexByNSS:0];
                    isSucess = [[NSSUserMangerLogIn Instance] doLogInAuto:YES accountName:accountName];
                    
                    if (isSucess)
                    {
                        NSURL *totalUrl =  [NSURL URLWithString:url];
                        if (!totalUrl)
                        {
                            totalUrl=[[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        }
                        NSString *domain = [totalUrl host];
                        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                        [cookieProperties setObjectByNSS:@"token" forKey:NSHTTPCookieName];
                        NSString *curAccountName = [NSSAccountInterFace getCurAccountName];
                        NSString *token = [NSSAccountInterFace getTokenWithAccountName:curAccountName];
                        if (!token)
                        {
                            return NSSNETRltState_NETERROR;
                        }
                        [cookieProperties setObjectByNSS:token forKey:NSHTTPCookieValue];
                        [cookieProperties setObjectByNSS:domain forKey:NSHTTPCookieDomain];
                        [cookieProperties setObjectByNSS:@"/" forKey:NSHTTPCookiePath];
                        [cookieProperties setObjectByNSS:@"0" forKey:NSHTTPCookieVersion];
                        
                        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                        state = [NSSNETInterFace HTTPPOSTImage:url parameters:parameters fileName:fileName imageData:imageData receiveData:receiveData timeOut:timeout netStateInfo:stateInfo];
                        
                    }
                }
            }
        }
    }
    return state;
}*/
@end

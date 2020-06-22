//
//  BasicUserDef.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserDef.h"
#import "BasicLogIn/BasicUserMangerLogIn.h"

#pragma mark - 登录返回结果
@implementation AccountProfileInfo
@synthesize emailcheck = _emailcheck;
@synthesize phonetag = _phonetag;

@end

@implementation LoginUser

- (NSString *)changePropertyType:(NSString*)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"description"])
    {
        str = @"userDescription";
    }
    else if ([proname isEqualToString:@"userDescription"])
    {
        str = @"description";
    }
    
    return str;
}

@end

@implementation AccountInfo

@end

@implementation AccountMoreInfo

@end

@implementation AccountReciveInfo

@end

@implementation AccountCheckReciveInfo

@end

@implementation AccountRetreivePasswordInfo

@end

@implementation ReciveShellInfo
@synthesize infocode = _infocode;
@synthesize infomessage = _infomessage;

@end

#pragma mark - 个人附加信息
@implementation AccountPersonAnnexInfo
@synthesize email = _email;
@synthesize zipCode = _zipCode;
@synthesize address = _address;
@synthesize nation = _nation;

@end

@implementation AccountPersonReciveInfo
@synthesize infocode = _infocode;
@synthesize infomessage = _infomessage;
@synthesize data = _data;

@end

#pragma --用户注册:获取验证码
@implementation FetchMsgCodeReqInfo

@end


@implementation VerifyMsgCodeReqInfo

@end

@implementation CommitRegistReqInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"userDescription"])
    {
        str = @"description";
    }
    else if ([proname isEqualToString:@"description"])
    {
        str = @"userDescription";
    }
    
    return str;
}
@end









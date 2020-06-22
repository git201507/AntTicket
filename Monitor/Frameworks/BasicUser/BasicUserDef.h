//
//  BasicUserDef.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicJsonKvcClass.h"

typedef NS_ENUM(NSInteger, BasicUSERINFOCODESTATE)
{
    BASICUSERINFOCODESTATE_FAULTSTATE = -1,//失败
    BASICUSERINFOCODESTATE_UNINITIALIZED = 0,
    BASICUSERINFOCODESTATE_SUCCESSSTATE = 1,//成功
    BASICUSERINFOCODESTATE_SESSIONOUT = 2,//过期，超时
};

typedef NS_ENUM(NSUInteger, BASICUSERGUARANTEEFUNLISTTYPE)
{
    BASICUSERGUARANTEEFUNLISTTYPE_SRC = 0,//查询功能列表
    BASICUSERGUARANTEEFUNLISTTYPE_CARD = 1,//社保卡功能列表
};

typedef NS_ENUM(NSUInteger, BASICUSERLONGSTATE)
{
    BASICUSERLONGSTATE_NONE = 0,//没有登录
    BASICUSERLONGSTATE_LONGIN_MANUAL = 1,//手动登录成功
    BASICUSERLONGSTATE_AUTO = 2, //自动登录成功,现在一般用于过期
    BASICUSERLONGSTATE_AUTONONET = 3,//直接切换账户，不登录
    BASICUSERLONGSTATE_OVERDUE = 4, //自动登录未成功，过期
};

typedef NS_ENUM(NSUInteger, BASICUserRegistType)
{
    Mobile = 0,     //手机注册
    USERNAME = 1,   //用户名注册
    EMAIL = 2,      //邮箱注册
};

#define PUBLICACCOUNT (@"PublicAccount")

#define AUTONYMLEVEL_1000 (1000)
#define AUTONYMLEVEL_10   (10)

#define NSSUSERACCOUNTCHANGEDMESSAGE_MainThread (@"NSSUserAccountChangedMessage")  //账户改变是发送的消息
#define NSSUSERMYSTATUSCHANGEDMESSAGE_MainThread (@"NSSUserMyStatusChangedMessage")  //我的消息数量变化的消息
#define NSSUSERMONEYACCOUNTCHANGEDMESSAGE_MainThread (@"NSSUserCartStatusChangedMessage")  //我的蚂蚁账户变化的消息
#define NSSUSERCHRONICSTATUSCHANGEDMESSAGE_MainThread (@"NSSUserChronicStatusChangedMessage")  //慢性病发布推送的消息通知
#define NSSUSERCITYCHANGEDMESSAGE_MainThread (@"NSSUserCityChangedMessage")  //选择城市变化的消息

#pragma mark - 账户内设置settingInfo储存的key
//注意：key宏定义的规范
//宏名字以 “ACCOUNTSETTING_”开头，然后是“名字_”，然后是返回值类型，如果要是返回值为NSNumber后面在加上NSNumber里面值的类型
//字符串的定义，以 “ACCOUNTSETTING_”开头，然后是“名字_KEY",加上中文注释表示其使用的地方
//使用方法存入的val只能是基本类型，不能是自定义的类。int，BOOL等需要用NSNumber存储
#define ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL   (@"ACCOUNTSETTING_ISREMMBERPASSWORD_KEY")//是否记住密码
#define ACCOUNTSETTING_SELECTEDADDRESS_DIC              (@"ACCOUNTSETTING_SELECTEDADDRESS_KEY")//选中地址,key为address类
#define ACCOUNTSETTING_SELECTEDAREA_DIC              (@"ACCOUNTSETTING_SELECTEDAREA_KEY")//选中地区,key为areaName和areaId
#define ACCOUNTSETTING_SELECTEDFAMILYMEMBER_DIC              (@"ACCOUNTSETTING_SELECTEDFAMILYMEMBER_KEY")//选中家庭成员,key为Person类
#define ACCOUNTSETTING_ISCHOOSECURRENTLOCATION_NSNUMBER_BOOL   (@"ACCOUNTSETTING_ISCHOOSECURRENTLOCATION_KEY")//是否选择当前位置

#pragma --用户注册、找回密码需要的常量
#define USERREGISTER_APPID_STRING       (@"99995")
#define USERREGISTER_SECRET_STRING      (@"VpFOVBYa1pYZ0VWdEdkQ3J1")
#define SMS_TEMP_PARACOMPANY_STRING     (@"东软在线购药")
#define SMS_TEMP_REG_INT                (3)
#define SMS_TEMP_REG_STRING             (@"【#company#】验证码为#code#,尊敬的用户您好, 您正在使用本手机进行用户注册.请不要将验证码泄漏给他人.")
#define SMS_TEMP_LOST_INT               (1)
#define SMS_TEMP_LOST_STRING            (@"【#company#】验证码为#code#,尊敬的用户您好, 您正在使用手机找回密码.请不要将验证码泄漏给他人.")


//#define OPENID (@"ocQHfszMZuxLvhepHrmHprUJmDaY")

#define OPENID (@"o2ljbwrbfW2E6BVSATKRqjxnVjGI")
//o2ljbwrbfW2E6BVSATKRqjxnVjGI

#pragma mark - 登录返回结果
@interface AccountProfileInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSNumber *emailcheck;//是否邮箱已验证
@property (nonatomic, strong) NSNumber *phonetag;//是否手机验证
@end

@interface LoginUser : BasicJsonKvcClass

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordAlgorithm;
@property (nonatomic, copy) NSString *uid;//与原来的publicid对应
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *userDescription;
@property (nonatomic, strong) NSDictionary *additionalInfos;
@property (nonatomic, strong) NSArray *authorities;
@property (nonatomic, assign) BOOL accountNonExpired;
@property (nonatomic, assign) BOOL accountNonLocked;
@property (nonatomic, assign) BOOL credentialsNonExpired;
@property (nonatomic, assign) BOOL enabled;

@end

@interface AccountInfo : BasicJsonKvcClass

//@property (nonatomic, copy) NSString *refresh_token;
//@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, copy) NSString *accountType;//@financing"
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, assign) int deposit;//0,
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *followme;//@"http://192.168.172.189:8080/shunhecore/mc/register?followme=15120001111"
@property (nonatomic, copy) NSString *gender;//保密"
@property (nonatomic, copy) NSString *idCard;//410411198503255608
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, assign) int integral;//0
@property (nonatomic, copy) NSString *lastLogTime;//2016-08-04 11:59:38
@property (nonatomic, copy) NSString *intmemberLevel;//3级 黑钻
@property (nonatomic, copy) NSString *mobile;//15120001111
@property (nonatomic, copy) NSString *name;//华超
@property (nonatomic, copy) NSString *nickName;//15120001111
@property (nonatomic, copy) NSString *realNameVerify;//已认证
@property (nonatomic, copy) NSString *recommendCode;//15120001111
@property (nonatomic, copy) NSString *token;//40282c3d56539859015653b5901f0005
@property (nonatomic, copy) NSString *userId;//40288108550549610155054bdde70001
@property (nonatomic, copy) NSString *userType;//index

@end

@interface AccountMoreInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *expires_at;
@property (nonatomic, strong) NSArray *scope;
@property (nonatomic, copy) NSString *grant_type;
@property (nonatomic, copy) NSString *client_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, assign) long exp;
@property (nonatomic, strong) NSArray *authorities;
@property (nonatomic, strong) LoginUser *user;

@end

@interface AccountReciveInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) AccountInfo *data;
@property (nonatomic, strong) NSString *msg;
@end

@interface AccountCheckReciveInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *msg;
@end

@interface AccountRetreivePasswordInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *msg;
@end

#pragma mark - 个人附加信息
@interface AccountPersonAnnexInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *zipCode;//邮编
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *nation;//民族

@end

@interface AccountPersonReciveInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSNumber *infocode;
@property (nonatomic, strong) NSString *infomessage;
@property (nonatomic, strong) AccountPersonAnnexInfo *data;
@end

@interface ReciveShellInfo : BasicJsonKvcClass
@property (nonatomic, strong) NSNumber *infocode;
@property (nonatomic, strong) NSString *infomessage;
@end

#pragma --用户注册
@interface FetchMsgCodeReqInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSNumber *templateId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray *params;

@end

@interface VerifyMsgCodeReqInfo: BasicJsonKvcClass

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *verfCode;

@end

@interface CommitRegistReqInfo: BasicJsonKvcClass
@property (nonatomic, copy) NSString *username; /*用户名称*/
@property (nonatomic, copy) NSString *password; /*用户密码*/
@property (nonatomic, copy) NSString *passwordAlgorithm;/*密码算法*/
@property (nonatomic, copy) NSString *uid; /* 用户ID */
@property (nonatomic, copy) NSString *phone; /*用户手机号*/
@property (nonatomic, copy) NSString *email; /*用户email*/
@property (nonatomic, copy) NSString *domain; /* 用户所在的业务域; 每个业务域下用户是唯一的*/
@property (nonatomic, copy) NSString *userDescription; /* 用户描述 */
@property (nonatomic, copy) NSDictionary *additionalInfos; /*其它用户信息, 每个业务域*/

@end







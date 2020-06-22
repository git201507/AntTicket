//
//  BasicDriver.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PhoneScreen)
{
    PHONESCREEN_4 = 0,
    PHONESCREEN_5 = 1,
    PHONESCREEN_6 = 2,
    PHONESCREEN_6Pluse = 3,
};

typedef NS_ENUM(NSUInteger, PhoneSysVersion)
{
    PHONESYSVERSIONBELOW_IOS7 = 0,//IOS7版本以前
    PHONESYSVERSIONOVER_IOS7 = 1,//IOS7版本以上
    PHONESYSVERSIONOVER_IOS8 = 2,//IOS8以上
};

#define PhoneRectSize_4     CGRectMake(0, 0, 320, 480)
#define PhoneRectSize_5     CGRectMake(0, 0, 320, 568)
#define PhoneRectSize_6     CGRectMake(0, 0, 375, 667)
#define PhoneRectSize_6s    CGRectMake(0, 0, 414, 736)

//键盘变化
#define NSSFOUNDATIONKEYBORADCHANGE_MAINTREAD (@"NSSFoundationKeyboradChange")

@interface BasicDriver : NSObject
{
@private
    CGRect _curKeyBoradRect;
}

//获取键盘高度
+ (CGRect)getCurKeyBoradRect;

+ (PhoneScreen)getPhoneScreenType;

+ (PhoneSysVersion)getPhoneSysVersion;

//获取系统版本号
+ (NSString *)getOSInfo;
//获取手机型号
+ (NSString *)getDriveMachine;

//获取运营商名称
+ (NSString *)getProprietorName;
//获取运营商网络编号
+ (NSString *)getPrioruetirCode;

//拨打电话
+ (void)telCall:(NSString *)phoneNum;

@end

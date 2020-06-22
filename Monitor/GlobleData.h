//
//  GlobleData.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/4.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicJsonKvcClass.h"

#define CountSizeInPageList @"20"

typedef NS_ENUM(NSUInteger, CouponStatus)
{
    COUPONSTATUS_UNUSED = 1,//未使用
    COUPONSTATUS_USED = 8,//已使用
    COUPONSTATUS_EXPIRED = 9,//已过期
};

typedef NS_ENUM(NSUInteger, FinanceHistoryStatus)
{
    FinanceHistoryStatus_Collecting = 1,//募集中
    FinanceHistoryStatus_Financing = 2,//理财中
    FinanceHistoryStatus_finished = 3,//已还款
};

typedef NS_ENUM(NSUInteger, MoneyRecordStatus)
{
    MoneyRecordStatus_Fillin = 1,//充值
    MoneyRecordStatus_Cash = 4,//提现
    MoneyRecordStatus_Invest = 2,//投资
};

typedef NS_ENUM(NSUInteger, SalaryRecordStatus)
{
    SalaryRecordStatus_MySalary = 0,//累计获得工资
    SalaryRecordStatus_Withdraw = 1,//已提现
    SalaryRecordStatus_CouponUse = 2,//兑换优惠劵
};

@interface FillinMessageBody : BasicJsonKvcClass
@property (nonatomic, copy) NSString *message;// = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxSZXF1ZXN0IHZlcnNpb249IjIuMSI+CjxIZWFkPgo8VHhDb2RlPjQyNTQ8L1R4Q29kZT4KPEluc3RpdHV0aW9uSUQ+MDAxODAzPC9JbnN0aXR1dGlvbklEPgo8L0hlYWQ+CjxCb2R5Pgo8UGF5bWVudEFjY291bnROdW1iZXI+ODAwMDAwMDEzNTE5PC9QYXltZW50QWNjb3VudE51bWJlcj4KPFBheW1lbnRObz4zZ3FHa041TDFmR3BzdGg0WkF2ZWxjPC9QYXltZW50Tm8+CjxBbW91bnQ+MTAwMDwvQW1vdW50Pgo8UGFnZVVSTD5odHRwOi8vMTE1LjI4Ljg1Ljk3L3d4L2Zyb250L3JldHVybi9jaG9uZ3pTdWNjZXNzPC9QYWdlVVJMPgo8L0JvZHk+CjwvUmVxdWVzdD4=";

@property (nonatomic, copy) NSString *plainText;// = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<Request version=\"2.1\">\n<Head>\n<TxCode>4254</TxCode>\n<InstitutionID>001803</InstitutionID>\n</Head>\n<Body>\n<PaymentAccountNumber>800000013519</PaymentAccountNumber>\n<PaymentNo>3gqGkN5L1fGpsth4ZAvelc</PaymentNo>\n<Amount>1000</Amount>\n<PageURL>http://115.28.85.97/wx/front/return/chongzSuccess</PageURL>\n</Body>\n</Request>";

@property (nonatomic, copy) NSString *signature;// = 1907C69289892210E54FF8A5CAFD75B41F09B1A56E043F58D5D6338EE75F4000A7A3223EFB5A9CC84B1DFAE5A89A18E20507BA82D1F1F87067963618FBEFC7B0CBC13A54EA21B23F81CF11D0B7573888920BC1CA1128C78E07ECA669AFC8B54C18C0D019866B375EBD1BC794413D767982EBD341D778B7CD9BF6D7DC8CA59B24;

@end

@interface FillinMessageReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) FillinMessageBody *data;

@end

@interface CouponDateEntity : BasicJsonKvcClass

@property (nonatomic, assign) int date; //10
@property (nonatomic, assign) int day; //3
@property (nonatomic, assign) int hours; //18
@property (nonatomic, assign) int minutes; //12
@property (nonatomic, assign) int month; //7
@property (nonatomic, assign) int nanos; //0
@property (nonatomic, assign) int seconds; //48
@property (nonatomic, assign) long long time; //1470823968000
@property (nonatomic, copy) NSString *timezoneOffset; //"-480"
@property (nonatomic, assign) int year; //116

@end

@interface CouponEntity : BasicJsonKvcClass
@property (nonatomic, assign) float amount; //5
@property (nonatomic, copy) NSString *couponId; //8ab3ce1e530ead700153124512230204
@property (nonatomic, copy) NSString *couponName; //"\U6ee1100\U51cf5"
@property (nonatomic, copy) NSString *couponNo; //"";
@property (nonatomic, assign) int couponType; //2
@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, copy) NSString *deadline; //"2016-09-08"
@property (nonatomic, copy) NSString *draftId; //"";
@property (nonatomic, copy) NSString *uid; //4028810a5673e9fa015673f0af8e000c;
@property (nonatomic, copy) NSString *ipsAccount; //800000013519;
@property (nonatomic, copy) NSString *memberId; //402881e551cda3fc0151cdae1cf40002;
@property (nonatomic, strong) CouponDateEntity *modifyDate;
@property (nonatomic, copy) NSString *realName; //"\U8d75\U767e\U987a"
@property (nonatomic, copy) NSString *remark; //"\U65b0\U7528\U6237\U5b9e\U540d\U6ce8\U518c\U5956\U52b1\Uff1b\U94c2\U91d1/\U666e\U901a\U7528\U6237\U63a8\U8350\U6210\U529f\U5956\U52b1\Uff1b\U5e73\U53f0\U81ea\U52a8\U53d1\U653e"
@property (nonatomic, copy) NSString *showCreateDate; //"2016-08-10";
@property (nonatomic, assign) int status; //1
@property (nonatomic, assign) int sync;//1
@property (nonatomic, copy) NSString *useInfoId; //4028810a5673e9fa015673f0af8e000b;
@property (nonatomic, copy) NSString *userMobile; //13811050099;
@property (nonatomic, assign) int usingLimitAmount; //100;

@end

@interface CouponRecordList : BasicJsonKvcClass

@property (nonatomic, assign) int autoCount;
@property (nonatomic, assign) int first;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPages;

@end

@interface CouponRecordReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) CouponRecordList *data;

@end

@interface CouponHeader : BasicJsonKvcClass

@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, assign) float hasBeenUsed; //5
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, copy) NSString *memberId; //402881e551cda3fc0151cdae1cf40002;
@property (nonatomic, strong) CouponDateEntity *modifyDate;

@property (nonatomic, assign) float outOfDate;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) float unused;

@end


@interface CouponHeaderReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) CouponHeader *data;

@end

@interface CouponCenterEntity : BasicJsonKvcClass

@property (nonatomic, assign) int amount;// = 5;
@property (nonatomic, copy) NSString *couponName;// = "\U6ee125\U5143\U53ef\U7528";
@property (nonatomic, assign) int couponType;// = 1;
@property (nonatomic, strong) CouponDateEntity *createDate;// =                 {
@property (nonatomic, copy) NSString *uid;// = 8ab3ce1e52a76d400152f2fed1fc18c2;
@property (nonatomic, copy) NSString *image;// = "";
@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) CouponDateEntity *modifyDate;// = "<null>";
@property (nonatomic, copy) NSString *remark;// = "";
@property (nonatomic, assign) int status;// = 2;
@property (nonatomic, assign) int totalAmount;// = 0;
@property (nonatomic, assign) int totalCount;// = 0;
//@property (nonatomic, strong) NSArray *useInfoList;
@property (nonatomic, assign) int usingLimitAmount;// = 25;
@property (nonatomic, assign) int validityDays;// = 30;

@end

@interface CouponCenterList : BasicJsonKvcClass

@property (nonatomic, assign) int autoCount;
@property (nonatomic, assign) int first;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPages;

@end

@interface CouponCenterListReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) CouponCenterList *data;

@end

@interface SalaryHeader : BasicJsonKvcClass

@property (nonatomic, assign) float cashFrozen;
@property (nonatomic, assign) float cashed;
@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, copy) NSString *sid;// = "9e377362-f4cd-11e5-99eb-00163e00";
@property (nonatomic, copy) NSString *memberId;// = 402881e551cda3fc0151cdae1cf40002;
@property (nonatomic, strong) CouponDateEntity *modifyDate;
@property (nonatomic, assign) float surplus;// = "444.45";
@property (nonatomic, assign) float total;// = "1444.45";
@property (nonatomic, assign) float withdraw;// = 0;

@end


@interface SalaryHeaderReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) SalaryHeader *data;

@end

//@interface SalaryDetail : BasicJsonKvcClass
//
//@property (nonatomic, strong) CouponDateEntity *createDate;
//@property (nonatomic, copy) NSString *createDateStr; //5
//@property (nonatomic, copy) NSString *sid;
//@property (nonatomic, strong) CouponDateEntity *modifyDate;
//
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *operate;
//@property (nonatomic, copy) NSString *profit;
//@property (nonatomic, copy) NSString *realName;
//
//amount = 100;
//applicantID = 402881e551cda3fc0151cdae1cf40002;
//bankCode = 1234567;
//bankName = "\U00e4\U00b8\U00ad\U00e5\U009b\U00bd\U00e5\U0086\U009c\U00e4\U00b8\U009a\U00e9\U0093\U00b6\U00e8\U00a1\U008c";
//createDate =                 {
//    date = 1;
//    day = 1;
//    hours = 13;
//    minutes = 52;
//    month = 1;
//    nanos = 0;
//    seconds = 2;
//    time = 1454305922000;
//    timezoneOffset = "-480";
//    year = 116;
//};
//id = 4028b881529b45e501529b634f88000e;
//mobile = 13811050099;
//modifyDate = "<null>";
//realName = "\U8d75\U767e\U987a";
//status = 0;
//withDrawDate = "";
//
//@end
//
//@interface SalaryDetailList : BasicJsonKvcClass
//
//@property (nonatomic, assign) int autoCount;
//@property (nonatomic, assign) int first;
//@property (nonatomic, assign) int pageNo;
//@property (nonatomic, assign) int pageSize;
//@property (nonatomic, strong) NSArray *result;
//@property (nonatomic, assign) int totalCount;
//@property (nonatomic, assign) int totalPages;
//
//@end
//
//
//@interface SalaryDetailReceiveInfo : BasicJsonKvcClass
//
//@property (nonatomic, copy) NSString *msg;
//@property (nonatomic, copy) NSString *state;
//@property (nonatomic, strong) SalaryDetailList *data;
//
//@end

@interface SalaryWithdraw : BasicJsonKvcClass

@property (nonatomic, assign) float amount;
@property (nonatomic, copy) NSString *applicantID;// = 402881e551cda3fc0151cdae1cf40002;
@property (nonatomic, copy) NSString *bankCode;// = 1234567;
@property (nonatomic, copy) NSString *bankName;// = "\U00e4\U00b8\U00ad\U00e5\U009b\U00bd\U00e5\U0086\U009c\U00e4\U00b8\U009a\U00e9\U0093\U00b6\U00e8\U00a1\U008c";
@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) CouponDateEntity *modifyDate;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, assign) int status;// = 0;
@property (nonatomic, copy) NSString *withDrawDate;// = "";

@end

@interface SalaryWithdrawList : BasicJsonKvcClass

@property (nonatomic, assign) int autoCount;
@property (nonatomic, assign) int first;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPages;

@end


@interface SalaryWithdrawReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) SalaryWithdrawList *data;

@end

@interface SalaryTotalDetail : BasicJsonKvcClass

@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, copy) NSString *createDateStr; //5
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, strong) CouponDateEntity *modifyDate;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *operate;
@property (nonatomic, copy) NSString *profit;
@property (nonatomic, copy) NSString *realName;

@end

@interface SalaryTotalDetailList : BasicJsonKvcClass

@property (nonatomic, assign) int autoCount;
@property (nonatomic, assign) int first;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPages;

@end


@interface SalaryTotalDetailReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) SalaryTotalDetailList *data;

@end

@interface FinanceProductEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *uid;//4028810e5499abac015499d89cd3002e
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *ceaseDate;
@property (nonatomic, copy) NSString *draftId;
@property (nonatomic, copy) NSString *draftState;//"release"，"finsh", "financing"
@property (nonatomic, copy) NSString *draftStateStr;
@property (nonatomic, strong) NSDecimalNumber *expectIncome;//263.01
@property (nonatomic, assign) int financeDays;//6
@property (nonatomic, strong) NSDecimalNumber *financing;//100000
@property (nonatomic, copy) NSString *flag;//"1"
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *ipsAccount;//"800000014882"
@property (nonatomic, copy) NSString *latestRepaymentDate;//"2016-05-18"
@property (nonatomic, copy) NSString *limitTime;//"6"
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, strong) NSDecimalNumber *maxAmount; //1000;
@property (nonatomic, strong) NSDecimalNumber *minAmount;//1
@property (nonatomic, copy) NSString *name;//"新手标"
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *phoneID;
@property (nonatomic, copy) NSString *phoneType;
@property (nonatomic, strong) NSDecimalNumber *profit;//15
@property (nonatomic, strong) NSDecimalNumber *progress;//10
@property (nonatomic, copy) NSString *releaseDate;
@property (nonatomic, copy) NSString *riskLevel;
@property (nonatomic, copy) NSString *systemType;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, assign) int tempDays;//0
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *valueDate;//"2016-05-11"
@property (nonatomic, copy) NSString *versionCode;
@property (nonatomic, copy) NSString *zsy;//0
@property (nonatomic, copy) NSString *rzCoupon;

@end

@interface FinanceProductReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface FinanceProductDetail : BasicJsonKvcClass

@property (nonatomic, copy) NSString *acceptance;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *ceaseDate;
@property (nonatomic, copy) NSString *couponFive;
@property (nonatomic, copy) NSString *couponFour;
@property (nonatomic, copy) NSString *couponOne;
@property (nonatomic, copy) NSString *couponThree;
@property (nonatomic, copy) NSString *couponTwo;
@property (nonatomic, copy) NSString *draftId;
@property (nonatomic, copy) NSString *draftType;
@property (nonatomic, copy) NSString *faceValue;
@property (nonatomic, strong) NSNumber *financeDays;
@property (nonatomic, strong) NSNumber *financing;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *isNew;
@property (nonatomic, copy) NSString *latestRepaymentDate;
@property (nonatomic, strong) NSNumber *maxAmount;
@property (nonatomic, strong) NSNumber *minAmount;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *phoneID;
@property (nonatomic, copy) NSString *phoneType;
@property (nonatomic, strong) NSNumber *profit;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, strong) NSNumber *surplus;
@property (nonatomic, copy) NSString *systemType;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, assign) int tempDays;//0
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *valueDate;
@property (nonatomic, copy) NSString *versionCode;
@property (nonatomic, assign) int bidCount;//0表示没有申请，1表示已申请

@end

@interface FinanceProductDetailReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) FinanceProductDetail *data;

@end


@interface FinancePersonEntity : BasicJsonKvcClass

@property (nonatomic, assign) int amount;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *phoneID;
@property (nonatomic, copy) NSString *phoneType;
@property (nonatomic, copy) NSString *systemType;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *versionCode;

@end

@interface FinancePersonReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface VerifyVipCodeReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;

@end

@interface FinanceHistoryHeader : BasicJsonKvcClass

@property (nonatomic, strong) NSNumber *financing;
@property (nonatomic, strong) NSNumber *finsh;
@property (nonatomic, strong) NSNumber *investment;

@end


@interface FinanceHistoryHeaderReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) FinanceHistoryHeader *data;

@end

@interface MoneyRecordHeader : BasicJsonKvcClass

@property (nonatomic, strong) CouponDateEntity *abnormalDate;
@property (nonatomic, copy) NSString *accountId;// = 402881e551cda3fc0151cdae1cf40002;
@property (nonatomic, assign) float availableAmount;// = "912355080.6900001";
@property (nonatomic, assign) float cAvaliable;// = "912355080.6900001";
@property (nonatomic, assign) float cFinancing;// = 0;
@property (nonatomic, assign) float cFreeze;// = "2298446.88";
@property (nonatomic, assign) float cTotal;// = "914653527.5700001";
@property (nonatomic, strong) CouponDateEntity *createDate;
@property (nonatomic, assign) float eAvaliable;// = "912355080.6900001";
@property (nonatomic, assign) float eFinancing;// = 0;
@property (nonatomic, assign) float eFreeze;// = "2298446.88";
@property (nonatomic, assign) float eTotal;// = "914653527.5700001";
@property (nonatomic, assign) float financingAmount;// = 0;
@property (nonatomic, assign) float freezeAmount;// = "2298546.82";
@property (nonatomic, copy) NSString *id;// = 402881e551cda3fc0151cdae1cf40003;
@property (nonatomic, copy) NSString *ipsAccount;// = 800000013519;
@property (nonatomic, strong) CouponDateEntity *modifyDate;
@property (nonatomic, copy) NSString *name;// = "";
@property (nonatomic, assign) int reason;// = 0;
@property (nonatomic, assign) float totalAmount;// = "914653627.51";
@property (nonatomic, strong) NSString *totalDraw;// = 0;
@property (nonatomic, assign) float totalExpensesAmount;// = "20048.43";
@property (nonatomic, strong) NSString *totalIncomeAmount;// = "65.75";
@property (nonatomic, assign) float totalRecharge;// = 300;
@property (nonatomic, strong) NSString *totalTradeAmount;// = "102283792.61";

@end


@interface MoneyRecordHeaderReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) MoneyRecordHeader *data;

@end

@interface MoneyRecordEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *billNo;// = 22rCDDYiJeV8zzUVvm9LxD;
@property (nonatomic, copy) NSString *createDate;// = "<null>";
@property (nonatomic, copy) NSString *createDateStr;// = "2016-03-18 13:58";
@property (nonatomic, copy) NSString *uid;// = 402881e953884c5b0153884e06020004;
@property (nonatomic, copy) NSString *modifyDate;// = "<null>";
@property (nonatomic, copy) NSString *name;// = "";
@property (nonatomic, copy) NSString *referID;// = 800000013519;
@property (nonatomic, strong) NSNumber *tradeAmount;// = 100;

@end

@interface MoneyRecordReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSMutableArray *data;

@end

@interface ExchangeCouponReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;

@end

@interface SalaryCashReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;

@end

@interface MessageEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *readState;

@end

@interface MessageList : BasicJsonKvcClass

@property (nonatomic, assign) int autoCount;
@property (nonatomic, assign) int first;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, assign) int totalPages;

@end


@interface MessageListReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) MessageList *data;

@end

@interface InvitorEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *salary;
@property (nonatomic, copy) NSString *date;

@end

@interface InvitorListReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSArray *data;

@end

@interface FinancePlannerEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *adviserImg;
@property (nonatomic, copy) NSString *adviserIntroduction;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *realName;

@end

@interface FinancePlannerReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) FinancePlannerEntity *data;

@end

@interface PlannerCustomer : BasicJsonKvcClass

@property (nonatomic, copy) NSString *pid;// = 40288108550549610155054bdde70001;
@property (nonatomic, copy) NSString *realName;// = "\U534e**";
@property (nonatomic, copy) NSString *totalIncome;// = "231.12";
@property (nonatomic, copy) NSString *totalInvest;// = "70000.0";
@property (nonatomic, copy) NSString *totalSalary;// = "0.0";

@end

@interface PlannerCustomerReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSNumber *sumIncome;
@property (nonatomic, strong) NSNumber *sumInvest;
@property (nonatomic, strong) NSNumber *sumSalary;
@property (nonatomic, strong) NSArray *data;

@end

@interface MyPlannerProfit : BasicJsonKvcClass

@property (nonatomic, copy) NSString *bidId;// = 8a232d725875d76e0158761c5a7d0018;
@property (nonatomic, copy) NSString *createDate;// = "2016-11-18";
@property (nonatomic, copy) NSString *draftId;// = 8a232d725875d76e015876108088000a;
@property (nonatomic, copy) NSString *draftName;// = "\U6d4b\U8bd5VIP1118";
@property (nonatomic, copy) NSString *memberId;// = 8a232d7258163c550158189c88280020;
@property (nonatomic, copy) NSString *memberName;// = "\U9b4f\U5353";
@property (nonatomic, strong) NSNumber *salary;// = "493.15";

@end

@interface MyPlannerProfitReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSArray *data;

@end

@interface RankEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int rank;
@property (nonatomic, copy) NSString *totalInvest;
@property (nonatomic, assign) int totalSalary;
@property (nonatomic, assign) int type;

@end

@interface RankListReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSArray *data;

@end

@interface ShareEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *title;//: "在蚂蚁宜票，提我好使,跟我来蚂蚁宜票理财~",
@property (nonatomic, copy) NSString *desc;//: "投资优选标，额外获得一个点的收益;投资VIP标，有我为你提供一对一的服务~",
@property (nonatomic, copy) NSString *link;//: "http://www.ypbill.com/views/weixin/wxlogin/shareFinancial.jsp?realname=${member.realName}&adviserIntroduction=${member.adviserIntroduction}&adviserImg=${member.adviserImg}&code=${member.loginName}",
@property (nonatomic, copy) NSString *imgUrl;//:"http://www.ypbill.com/logo.png",

@end

@interface ShareReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) ShareEntity *data;

@end

@interface PlannerEntity : BasicJsonKvcClass

@property (nonatomic, copy) NSString *adviserImg;// = "/att/head/iO5vDh5bfIPOEESLdc2af8tE8FePEREiwq-699mf1143ILAuIIon0b40OOswwwc0.jpg";
@property (nonatomic, copy) NSString *adviserIntroduction;// = "\U8ddf\U54e5\U8d70210";
@property (nonatomic, copy) NSString *pid;// = 40288108550549610155054bdde70001;
@property (nonatomic, copy) NSString *loginName;// = "151****111";
@property (nonatomic, copy) NSString *realName;// = "\U534e\U8d85";

@end

@interface PlannerListReceiveInfo : BasicJsonKvcClass

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong) NSArray *data;

@end

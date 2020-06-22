//
//  GlobleData.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/4.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "GlobleData.h"

@implementation FillinMessageBody

@end

@implementation FillinMessageReceiveInfo

//- (NSString *)changePropertyType:(NSString *)proname
//{
//    NSString *str = nil;
//    
//    if ([proname isEqualToString:@"userDescription"])
//    {
//        str = @"description";
//    }
//    else if ([proname isEqualToString:@"description"])
//    {
//        str = @"userDescription";
//    }
//    
//    return str;
//}
@end

@implementation CouponEntity

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return str;
}
@end

@implementation CouponRecordList

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"result"])
    {
        str = @"CouponEntity";
    }
    
    return str;
}
@end

@implementation CouponRecordReceiveInfo

@end

@implementation CouponHeader
- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return str;
}
@end

@implementation CouponHeaderReceiveInfo

@end

@implementation CouponCenterEntity

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return str;
}
@end

@implementation CouponCenterList

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"result"])
    {
        str = @"CouponCenterEntity";
    }
    
    return str;
}
@end

@implementation CouponCenterListReceiveInfo

@end

@implementation SalaryHeader

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"sid";
    }
    
    return str;
}

@end

@implementation SalaryHeaderReceiveInfo

@end

@implementation SalaryTotalDetail

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"sid";
    }
    
    return str;
}

@end

@implementation SalaryTotalDetailList

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"result"])
    {
        str = @"SalaryTotalDetail";
    }
    
    return str;
}

@end

@implementation SalaryTotalDetailReceiveInfo

@end

@implementation SalaryWithdraw

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"sid";
    }
    
    return str;
}

@end

@implementation SalaryWithdrawList

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"result"])
    {
        str = @"SalaryWithdraw";
    }
    
    return str;
}

@end

@implementation SalaryWithdrawReceiveInfo

@end

@implementation FinanceProductEntity

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return str;
}

@end



@implementation FinanceProductReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"FinanceProductEntity";
    }
    
    return str;
}

@end

@implementation FinanceProductDetail
- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    if ([proname isEqualToString:@"count"])
    {
        str = @"bidCount";
    }
    return str;
}

@end

@implementation FinanceProductDetailReceiveInfo

@end


@implementation FinancePersonEntity

@end

@implementation FinancePersonReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"FinancePersonEntity";
    }
    
    return str;
}

@end

@implementation VerifyVipCodeReceiveInfo

@end

@implementation FinanceHistoryHeader

@end

@implementation FinanceHistoryHeaderReceiveInfo

@end

@implementation MoneyRecordHeader

@end

@implementation MoneyRecordHeaderReceiveInfo

@end


@implementation MoneyRecordEntity

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"uid";
    }
    
    return str;
}

@end

@implementation MoneyRecordReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"MoneyRecordEntity";
    }
    
    return str;
}

@end

@implementation ExchangeCouponReceiveInfo

@end

@implementation SalaryCashReceiveInfo

@end

@implementation MessageEntity

@end

@implementation MessageList

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"result"])
    {
        str = @"MessageEntity";
    }
    
    return str;
}

@end

@implementation MessageListReceiveInfo

@end

@implementation InvitorEntity

@end

@implementation InvitorListReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"InvitorEntity";
    }
    
    return str;
}

@end

@implementation FinancePlannerEntity

@end

@implementation FinancePlannerReceiveInfo

@end

@implementation PlannerCustomer

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"pid";
    }
    
    return str;
}

@end

@implementation PlannerCustomerReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"PlannerCustomer";
    }
    
    return str;
}

@end

@implementation MyPlannerProfit

@end

@implementation MyPlannerProfitReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"MyPlannerProfit";
    }
    
    return str;
}

@end

@implementation RankEntity

@end

@implementation RankListReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"RankEntity";
    }
    
    return str;
}

@end

@implementation ShareEntity

@end

@implementation ShareReceiveInfo

@end

@implementation PlannerEntity

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"id"])
    {
        str = @"pid";
    }
    
    return str;
}

@end

@implementation PlannerListReceiveInfo

- (NSString *)changePropertyType:(NSString *)proname
{
    NSString *str = nil;
    
    if ([proname isEqualToString:@"data"])
    {
        str = @"PlannerEntity";
    }
    
    return str;
}

@end




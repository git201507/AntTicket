//
//  BasicMoneyAccountDef.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicJsonKvcClass.h"

@interface MyAccountDetail : BasicJsonKvcClass

@property (nonatomic, assign) double availableAmount;//可用余额
@property (nonatomic, assign) int couponAmount;//优惠券
@property (nonatomic, assign) double financingAmount;//理财中
@property (nonatomic, assign) double freezeAmount;//募集中
@property (nonatomic, copy) NSString *ipsAccount;
@property (nonatomic, copy) NSString *memberLevel;//"level_3";
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int salaryAmount;//工资
@property (nonatomic, assign) double totalAmount;//总淄川
@property (nonatomic, assign) double totalIncomeAmount;//总收益
@property (nonatomic, assign) int vip;//0
@property (nonatomic, copy) NSString *isRealNameVerify;
@property (nonatomic, assign) int news;//0
@property (nonatomic, assign) int couponNumber;//优惠券个数
@property (nonatomic, copy) NSString *invitorLevel;//"level_3";
@property (nonatomic, assign) int financial;

@end

@interface MyAccountDetailReceiveInfo : BasicJsonKvcClass

@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) MyAccountDetail *data;
@property (nonatomic, strong) NSString *msg;

@end

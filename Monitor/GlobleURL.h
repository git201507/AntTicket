//
//  GlobleURL.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/4.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#ifndef GlobleURL_h
#define GlobleURL_h

#pragma mark - app相关信息
#define System_GetAppVersionURL @"api/m/getAppVersion"

#pragma mark - 登录与注册

//登录
#define Account_UserLoginFirstStepURL @"api/wechat/user/login"
//#define Account_UserLoginSecondStepURL @"wx/front/login/userLogin.jhtml"

//验证手机号是否已经被注册
#define Account_UserRegistCheckPhoneNumberExistURL @"api/wechat/user/validatePhoneNumber"

//获取图片验证码
#define Account_UserAppYzCodeURL @"common/img/appYzCode.jpeg?d=%f&memberId=%@"

//获取手机验证码
#define Account_FetchShortMessageVerifyChineseCodeURL @"sms/sender/getMobileVerifyCode"
#define Account_FetchShortMessageVerifyCodeURL(tel, code, userid) ([NSString stringWithFormat:@"sms/sender/getAppMobileVerifyCode?mobileNumber=%@&yz=%@&memberId=%@", tel, code, userid])

//判断邀请码是否存在
#define Account_UserRegistCheckInviteCodeExistURL @"api/wechat/useropr/checkgetInviteCode"

//判断验证码是否正确
#define Account_UserRegistValidateUserPhoneVerifyCodeURL @"api/wechat/user/validateUserPhoneVerifyCode"

//注册
#define Account_UserRegistFirstStepURL @"api/wechat/user/register"
//#define Account_UserRegistSecondStepURL @"wx/front/login/userZhuce.jhtml"

//忘记密码时找回
#define Account_UserRegistRetrievePasswordURL @"api/wechat/useropr/forgetPassword"

//修改密码
#define Account_UserRegistModifyPasswordURL @"api/wechat/useropr/modifyPassword"

//退出当前账户
#define Account_UserLogoutURL @"api/wechat/user/logout"

#pragma mark - 我的账户

//我的分享
#define Mine_MySharedListURL(memberId)  ([NSString stringWithFormat:@"wx/front/wdzh/appwdfx.jhtml?memberId=%@", memberId])

//加载账户信息
#define Mine_FindAccountInfoURL @"api/wechat/account/findAccountInfo"

//账户充值

////异步交易 4234、4235、4242、4246、4254、4258、4272、3212
////测试地址：
//#define ZhongJin_SynchronousTestAPIURL @"https://test.cpcn.com.cn/Gateway4PaymentUser/InterfaceI"
//#define ZhongJin_SynchronousProductAPIURL @"https://user.cpcn.com.cn/Gateway4PaymentUser/InterfaceI"
//
////同步交易 4232、4237、4238、4244、4252、4256、4276、3216、3231、3236、3237、3238、3241、3246、3251、3256、3261、3262、3310、3312、3315、9999
////测试地址：
//#define ZhongJin_ASynchronousTestAPIURL @"https://test.cpcn.com.cn/Gateway4PaymentUser/InterfaceII"
////生产地址：
//#define ZhongJin_ASynchronousProductAPIURL @"https://user.cpcn.com.cn/Gateway4PaymentUser/InterfaceII"

#define Mine_FillinMoneyURL @"cp/member/appChongZhi"
#define Mine_CashMoneyURL @"cp/member/appTiXian"
#define Mine_BuyBidURL @"cp/member/appZhiFu"
#define Mine_CertificationURL @"cp/member/appRenZheng"
#define Mine_SignContractURL @"cp/member/appQianYue"

#define Mine_CouponHeaderInfoURL @"api/wechat/coupon/mycouponHeaderInfo"
#define Mine_CouponUseRecordListURL @"api/wechat/coupon/couponUseRecordList"

#pragma mark - 我要理财
#define Finance_GetNewBidNumberURL @"api/wechat/draft/getDraftNumber"
//新手标列表
#define Finance_FetchNewFishProductListURL @"api/wechat/finance/fianceNewProductList"
//普通标列表
#define Finance_FetchGeneralProductListURL @"api/wechat/finance/fianceProductList"
//VIP标列表
#define Finance_FetchVIPProductListURL @"api/wechat/finance/fianceVipProductList"

//标的详情
#define Finance_ProductDetailURL(draftId, memberId) ([NSString stringWithFormat:@"api/wechat/finance/appFinanceDetail?draftId=%@&memberId=%@", draftId, memberId])

//购买记录
#define Finance_FetchBidderListURL @"api/wechat/finance/findBidderList"

//申请记录
#define Finance_FetchVipBidderListURL @"api/wechat/draft/findApplyList"

//VIP标申请
#define Finance_VerifyVipCodeURL @"api/wechat/draft/appVerifyVipCode"

#pragma mark - 理财记录

#define History_GetPersonalFianceMoneyURL @"api/wechat/finance/statPersonalFianceMoney"
#define History_GetPersonalFianceListURL @"api/wechat/finance/fianceList"


#define Record_GetPersonalMoneyURL @"api/wechat/finance/statPersonalMoney"
#define Record_GetPersonalMoneyTradeListURL @"api/wechat/finance/findPersonalMoneyTradeList"

#pragma mark - 蚂蚁工资
//Parameters:
//token
#define Salary_GetHeaderInfoURL @"api/wechat/salary/mysalaryHeaderInfo"
//Parameters:
//token
//pageNo
//pageSize
#define Salary_GetListInfoURL @"api/wechat/salary/mysalaryList"//我的工资列表
//Parameters:
//token
//pageNo
//pageSize
#define Salary_GetCashListInfoURL @"api/wechat/salary/withdrawList"//已提现列表
//Parameters:
//token
//userid
//status:8
//pageNo
//pageSize
#define Salary_FetchCouponListInfoURL @"api/wechat/coupon/couponUseRecordList"//兑换优惠券列表
//Parameters:
//token
#define Salary_GetSalaryAmountURL @"api/wechat/salary/salaryAmount"//兑换优惠券页面加载工资余额
//Parameters:
//status
//userid
//couponType
//pageNo
//pageSize
#define Salary_GetCouponListURL @"api/wechat/coupon/couponList"//兑换优惠券页面列表
//Parameters:
//token
//couponID
#define Salary_ExchangeCouponURL @"api/wechat/salary/salaryExchangeCoupon"//执行兑换优惠券
//Parameters:
//token
//amount
//realName
//bankName
//bankCode
#define Salary_WithdrawSalaryURL @"api/wechat/salary/salaryWithdraw"//工资提现

#pragma mark - 消息中心
#define MessageCenter_GetMsgNumberURL @"api/wechat/user/getMessageNumber"//消息数量
//Parameters:
//readStateType
//pageNo
//pageSize
//ownerId
#define MessageCenter_FetchMsgListURL @"api/wechat/msg/mymsgList"//消息列表
//Parameters:
//msgId
#define MessageCenter_ShowMsgDetailURL(msgId) ([NSString stringWithFormat:@"api/wechat/msg/mymsgDetail?msgId=%@", msgId])//消息详情

#pragma mark - 邀请人员列表
#define Settings_MyInvitorListURL @"api/wechat/salary/findMyInvitorList"

#pragma mark - 设置
//获取二维码图片
#define Settings_App2DCodeURL @"api/wechat/user/getInviteCode"

//生成二维码图片
#define Settings_Get2DCodeURL(address) ([NSString stringWithFormat:@"common/img/inviteCode.png?v=%@", address])

#pragma mark - 抽奖与分享

#define Prize_ValidateCommonPrizeShare    @"api/member/appValidateCommon"

#define Prize_GetPrizeId    @"api/member/appGetPrizeId"

#define Prize_ShareCoupon    @"api/wechat/coupon/shareCoupon"
#define Prize_GetSharedCoupon    @"api/wechat/coupon/getSharedCoupon"

//#define Prize_GetCommonURL(prizeId,memberId) ([NSString stringWithFormat:@"wx/front/login/appCommonPrize.jhtml?prizeId=%@&memberId=%@", prizeId, memberId])

#define Prize_GetCommonURL(prizeId) ([NSString stringWithFormat:@"wx/front/login/appCommonPrize.jhtml?prizeId=%@", prizeId])

#define Prize_GetVIPURL(memberId) ([NSString stringWithFormat:@"wx/front/login/appPrize.jhtml?memberId=%@", memberId])

#pragma mark - 理财师
//是否可选理财师
#define FinancePlanner_GetMyAdviserURL @"api/wechat/finance/getMyAdviser"

//理财师列表
#define FinancePlanner_FinancialPlannerListURL @"api/member/pageAdvanserList"

#define FinancePlanner_SetMyFinancialURL @"api/wechat/finance/setMyFinancial"

//个人介绍
#define FinancePlanner_FinancialIntroductionURL @"api/m/getAdviserById"

//修改个人介绍
#define FinancePlanner_UpdateIntroductionURL @"api/wechat/user/updateFinancialIntroduction"

//我的客户
#define FinancePlanner_AllMyCustomerURL(memberId)  ([NSString stringWithFormat:@"api/wechat/user/getAllMyCustomer?memberId=%@", memberId])

//我的收益
#define FinancePlanner_PageVipSalaryURL @"api/wechat/finance/pageVipSalary"

//业绩排名
#define FinancePlanner_MyFinancialRankURL(memberId)  ([NSString stringWithFormat:@"api/wechat/user/getMyFinancialRank?memberId=%@", memberId])

//理财师了解更多的画面地址
#define FinancePlanner_FinancialMoreDetailURL(memberId)  ([NSString stringWithFormat:@"wx/front/wdzh/appFinancial.jhtml?memberId=%@", memberId])

//会员等级
#define FinancePlanner_TickerLevelURL(memberId)  ([NSString stringWithFormat:@"wx/front/wdzh/levels.jhtml?memberId=%@", memberId])

#endif /* GlobleURL_h */

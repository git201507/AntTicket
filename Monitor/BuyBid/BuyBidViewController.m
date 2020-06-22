//
//  BuyBidViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BuyBidViewController.h"
#import "GlobleData.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"
#import "BasicToastInterFace.h"
#import "BasicDriver.h"
#import "BasicUserInterFace.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "GlobleURL.h"

@interface BuyBidViewController ()
{
    
}
@property (nonatomic, weak) IBOutlet UITextField *amountBuyText;

@end

@implementation BuyBidViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.title = @"标的购买";
    
    _bidNameLabel.text = _financeDetail.name;
    
    NSString *tempProfitStr = [NSString stringWithFormat:@"%0.2f",[_financeDetail.profit floatValue]];
    unichar n1 = [tempProfitStr characterAtIndex:tempProfitStr.length-2];
    unichar n2 = [tempProfitStr characterAtIndex:tempProfitStr.length-1];
    
    if (n1 == 48 && n2 == 48)
    {
        tempProfitStr = [tempProfitStr substringWithRange:NSMakeRange(0, tempProfitStr.length-3)];
    }
    
    _profitLabel.text = [NSString stringWithFormat:@"%@%%", tempProfitStr];
    _financeDayLabel.text = [NSString stringWithFormat:@"%d天",[_financeDetail.financeDays intValue]];
    _financeDescriptionLabel.text = [NSString stringWithFormat:@"起投金额：%d元",[_financeDetail.minAmount intValue]];
    UILabel *surplusLabel = [_targetView viewWithTag:10];
    surplusLabel.text = [NSString stringWithFormat:@"剩余金额%0.2f元", [_financeDetail.surplus floatValue]];
    UILabel *financingLabel = [_targetView viewWithTag:20];
    financingLabel.text = [NSString stringWithFormat:@"计划金额%0.2f元", [_financeDetail.financing floatValue]];
    
    UIProgressView *progress = [_targetView viewWithTag:30];
    progress.progress = [_financeDetail.progress floatValue]/100.f;
    
    UILabel *progressLabel = [_targetView viewWithTag:40];
    progressLabel.text = ([_financeDetail.progress intValue] >= 100) ? @"100%" : [NSString stringWithFormat:@"%0.2f%%",[_financeDetail.progress floatValue]];
    
    _amountBuyText.text = @"";
    _amountBuyText.placeholder = [NSString stringWithFormat:@"%0.2f元",[_financeDetail.minAmount floatValue]];
    _amountBuyText.returnKeyType = UIReturnKeyDone;
    _amountBuyText.delegate = self;
    _amountBuyText.tintColor = [UIColor redColor];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    MyAccountDetail *myAccountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    _availableAmountLabel.text = [NSString stringWithFormat:@"*您的账户余额还剩%0.2f元", myAccountDetail.availableAmount];
    
    _memberId = accountInfo.userId;
    _draftId=_financeProduct.uid;
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainZhongJin"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_memberId forKey:@"gmUserID"];
        [seg setValue:_draftId forKey:@"draftID"];
        [seg setValue:_amountBuyText.text forKey:@"amount"];
    }
}

#pragma mark -- 自己的方法
- (void)getUserMoneyAccountByToken:(NSString *)token
{
    //请求参数
    NSMutableDictionary *params = [@{@"token":token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_FindAccountInfoURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         MyAccountDetailReceiveInfo *info = [[MyAccountDetailReceiveInfo alloc] init];
         
         //登录状态异常，进入登录界面
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"] || !info.data)
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         //自动登录成功，设置账户信息页
         //1、发通知
         MyAccountDetail *myAccountDetail = (MyAccountDetail *)info.data;
         NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:info.data forKey:@"MoneyAccountDetail"];
         [[NSNotificationCenter defaultCenter] postNotificationName:NSSUSERMONEYACCOUNTCHANGEDMESSAGE_MainThread object:nil userInfo:myDictionary];
         
         if(myAccountDetail.news == 0 && [_isNewsBid boolValue])
         {
             [BasicToastInterFace showToast:@"只有第一次购买标的用户才能购买!  "];
             return;
         }
         
         if([_amountBuyText.text length] == 0)
         {
             [BasicToastInterFace showToast:@"购买金额不能为空!  "];
             return;
         }
         if([_amountBuyText.text floatValue] <= 0.0f)
         {
             [BasicToastInterFace showToast:@"购买金额必须大于0元!  "];
             return;
         }
         if([_amountBuyText.text floatValue] < [_financeDetail.minAmount floatValue])
         {
             [BasicToastInterFace showToast:@"购买金额必须大于起投金额!  "];
             return;
         }
         
         float afterBuyAmount = [_financeDetail.surplus floatValue] - [_amountBuyText.text floatValue];
         if(afterBuyAmount < 0.f)
         {
             [BasicToastInterFace showToast:@"购买金额不能大于剩余金额!  "];
             return;
         }
         
         if(afterBuyAmount > 0.f && afterBuyAmount < [_financeDetail.minAmount floatValue])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"标的即将满标，您需要一次性投资%@元!  ", [_financeDetail.surplus stringValue]]];
             return;
         }
         
         if([_isNewsBid boolValue] && [_amountBuyText.text floatValue] > 2000.f)
         {
             [BasicToastInterFace showToast:@"本新手标最大购买金额不能超过2000!  "];
             return;
         }
         
         [self performSegueWithIdentifier:@"MainZhongJin" sender:nil];
     }
                          failure:^(NSError *error)
     {
         //登录过期
         if (error.code == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             return;
         }
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

#pragma mark -- 与xib绑定的方法

- (IBAction)confirmBuyBid:(id)sender
{
    NSString *curAccount = [BasicAccountInterFace getCurAccountName];
    if (!curAccount)
    {
        [BasicToastInterFace showToast:@"获取account失败!  "];
        return;
    }
    
    NSString *curAccountToken = [BasicAccountInterFace getTokenWithAccountName:curAccount];
    if (!curAccountToken)
    {
        [BasicToastInterFace showToast:@"获取token失败!  "];
        return;
    }
    
    [self getUserMoneyAccountByToken:curAccountToken];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        //假如多个输入，比如注册和登录，就可以根据不同的输入框来上移不同的位置，从而更加人性化
        
        //键盘高度216
        
        //滑动效果（动画）
        
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        
        self.view.frame = CGRectMake(0.0f, -100.0f/*屏幕上移的高度，可以自己定*/, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        //滑动效果
        
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        
        //恢复屏幕
        
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text length] == 0 && ([string isEqualToString:@"0"] || [string isEqualToString:@"."]))
    {
        return NO;
    }
    
    if([textField.text length] > 14 && string.length > 0)
    {
        [BasicToastInterFace showToast:@"购买金额不能超过14位数!  "];
        return NO;
    }
    
    BOOL flag = [self validateNumber:string textField:textField];
    if (flag)
    {
        [self performSelector:@selector(changeValueAfterInput) withObject:nil afterDelay:0.3f];
    }
    return flag;
}
- (void)changeValueAfterInput
{
    //double forFloat = [_amountBuyText.text floatValue] * [_financeDetail.profit floatValue] * [_financeDetail.financeDays floatValue] / 365.f / 100.f;
    double forDouble = [_amountBuyText.text doubleValue] * (double)_financeDetail.tempDays / (double)365.000000;
    _forValue.text = [NSString stringWithFormat:@"%0.2lf元", forDouble * [_financeDetail.profit doubleValue] / (double)100.000000];
    
    double fPersent=0.000000;
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    
    NSString *judgeLevel = accountDetail.memberLevel;
    if([accountDetail.memberLevel characterAtIndex:accountDetail.memberLevel.length-1] > [accountDetail.invitorLevel characterAtIndex:accountDetail.invitorLevel.length-1])
    {
        judgeLevel = accountDetail.invitorLevel;
    }
    
    if([judgeLevel isEqualToString:@"level_4"])
    {
        fPersent=(double)0.000000;
    }
    if([judgeLevel isEqualToString:@"level_3"])
    {
        fPersent=(double)0.005000;
    }
    if([judgeLevel isEqualToString:@"level_2"])
    {
        fPersent=(double)0.010000;
    }
    if([judgeLevel isEqualToString:@"level_1"])
    {
        fPersent=(double)0.010000;
    }
    
    _forOutValue.text = [NSString stringWithFormat:@"%0.2lf元", forDouble*fPersent];
}

- (BOOL)validateNumber:(NSString*)number textField:(UITextField *)textField
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        i++;
    }
//    if (res && textField.text.length > 5)
//    {
//        [BasicToastInterFace showToast:@"验证码位数不能超过6位。"];
//        res = NO;
//    }
    return res;
}

@end

//
//  SalaryCashViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "SalaryCashViewController.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserDef.h"
#import "LoadingView.h"
#import "BasicAccountInterFace.h"
#import "BasicUserNet.h"
#import "BasicUserMangerLogIn.h"
#import "BasicUserInterFace.h"
#import "UIColor+Hex.h"

@interface SalaryCashViewController ()
{
    
}
@property (nonatomic, copy) NSString *balanceVal;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UITextField *cashTextField;
@property (nonatomic, weak) IBOutlet UITextField *realNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *cardNoTextField;
@property (nonatomic, weak) IBOutlet UITextField *bankNameTextField;

@end

@implementation SalaryCashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    NSMutableAttributedString *noticeStr1 = [[NSMutableAttributedString alloc] initWithString:@"温馨提示："];
    [noticeStr1 addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(0, noticeStr1.length)];
    NSMutableAttributedString *noticeStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您的账户余额还剩%@元，根据国家相关规定，我们需要在您提现时代扣20%%个人所得税\r\n如您希望全额获得工资，建议您将工资提现为优惠券优惠券理财将全额返还到您的账户中", _balanceVal]];
    [noticeStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#686868" alpha:1] range:NSMakeRange(0, noticeStr2.length)];
    [noticeStr1 appendAttributedString:noticeStr2];
    
    _descriptionLabel.attributedText = noticeStr1;
    
    _cashTextField.returnKeyType = UIReturnKeyNext;
    _realNameTextField.returnKeyType = UIReturnKeyNext;
    _cardNoTextField.returnKeyType = UIReturnKeyNext;
    _bankNameTextField.returnKeyType = UIReturnKeyDone;
    
    _cashTextField.tintColor = [UIColor redColor];
    _realNameTextField.tintColor = [UIColor redColor];
    _cardNoTextField.tintColor = [UIColor redColor];
    _bankNameTextField.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cashSalary
{
    if ([_balanceVal floatValue] < 100.f)
    {
        [BasicToastInterFace showToast:@"工资余额不足!  "];
        return;
    }
    
    if ([_cashTextField.text floatValue] < 100.f)
    {
        [BasicToastInterFace showToast:@"提现金额不能少于100元!  "];
        return;
    }
    
    if ([_balanceVal floatValue] < [_cashTextField.text floatValue])
    {
        [BasicToastInterFace showToast:@"工资余额不足!  "];
        return;
    }
    
    if([_realNameTextField.text length] == 0)
    {
        [BasicToastInterFace showToast:@"真实姓名不能为空!  "];
        return;
    }
    
    if([_cardNoTextField.text length] == 0)
    {
        [BasicToastInterFace showToast:@"银行卡号不能为空!  "];
        return;
    }
    if([_bankNameTextField.text length] == 0)
    {
        [BasicToastInterFace showToast:@"开户行不能为空!  "];
        return;
    }

    [self doSalaryCash];
}

- (void)doSalaryCash
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    NSMutableDictionary *params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]], @"amount":_cashTextField.text, @"realName":_realNameTextField.text, @"bankName":_bankNameTextField.text, @"bankCode":_cardNoTextField.text} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Salary_WithdrawSalaryURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         SalaryCashReceiveInfo *info = [[SalaryCashReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             if([info.msg isEqualToString:@"当前用户登录状态异常"])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"工资提现成功" delegate:self cancelButtonTitle:@"继续提现" otherButtonTitles:@"完成", nil];
         [alert show];
     }
                          failure:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         //登录过期
         if (error.code == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
             [BasicUserInterFace doLogIn];
             return;
         }
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
#pragma mark -- UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if(self.cashTextField.editing)
    {
        [self.realNameTextField becomeFirstResponder];
    }
    else if(self.realNameTextField.editing)
    {
        [self.cardNoTextField becomeFirstResponder];
    }
    else if(self.cardNoTextField.editing)
    {
        [self.bankNameTextField becomeFirstResponder];
    }
    else if(self.bankNameTextField.editing)
    {
        [self.bankNameTextField resignFirstResponder];
    }
    return YES;
}

@end

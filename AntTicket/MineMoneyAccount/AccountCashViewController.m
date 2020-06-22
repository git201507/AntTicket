//
//  AccountCashViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "AccountCashViewController.h"
#import "BasicConfigPath.h"
#import "BasicUserMangerLogIn.h"
#import "BasicUserInterFace.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "HttpUtil.h"
#import "AFNRequestData.h"
#import "GlobleData.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"

@interface AccountCashViewController ()
{
    
}
@property (nonatomic, weak) IBOutlet UITextField *amountCashText;
@property (nonatomic, weak) IBOutlet UILabel *payAccountNoLabel;

@end

@implementation AccountCashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];

    self.title = @"提现";
    _amountCashText.text = @"";
    _amountCashText.placeholder = [NSString stringWithFormat:@"%0.2f", accountDetail.availableAmount];
    
    _amountCashText.tintColor = [UIColor redColor];
    _payAccountNoLabel.text = _ipsAccount;
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainZhongJin"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_amountCashText.text forKey:@"amount"];
        [seg setValue:_ipsAccount forKey:@"ipsAccount"];
    }
}

#pragma mark -- 自己的方法

#pragma mark -- 与xib绑定的方法

- (IBAction)confirmCashAccount:(id)sender
{
    if([_amountCashText.text length] == 0)
    {
        [BasicToastInterFace showToast:@"提现金额不能为空!  "];
        return;
    }
    if([_amountCashText.text floatValue] <= 0.0f)
    {
        [BasicToastInterFace showToast:@"提现金额必须大于0元!  "];
        return;
    }
    
    MyAccountDetail *_accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    if([_amountCashText.text floatValue] > _accountDetail.availableAmount)
    {
        [BasicToastInterFace showToast:@"提现金额不能超过账户可用余额!  "];
        return;
    }
    
    [self performSegueWithIdentifier:@"MainZhongJin" sender:nil];
}

#pragma mark -- UITextFieldDelegate
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
        [BasicToastInterFace showToast:@"提现金额不能超过14位整数!  "];
        return NO;
    }
    
    return [self validateNumber:string textField:textField];
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
    
    return res;
}
@end

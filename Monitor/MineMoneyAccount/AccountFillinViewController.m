//
//  AccountFillinViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "AccountFillinViewController.h"
#import "BasicConfigPath.h"
#import "BasicUserMangerLogIn.h"
#import "BasicUserInterFace.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "GlobleData.h"

@interface AccountFillinViewController ()
{
    
}

@property (nonatomic, weak) IBOutlet UITextField *amountFillinText;
@property (nonatomic, weak) IBOutlet UILabel *payAccountNoLabel;

@end

@implementation AccountFillinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.title = @"充值";
    _amountFillinText.text = @"";
    _amountFillinText.tintColor = [UIColor redColor];
    
    _payAccountNoLabel.text = _ipsAccount;
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainZhongJin"])
    {
        id seg = segue.destinationViewController;

        [seg setValue:_amountFillinText.text forKey:@"amount"];
        [seg setValue:_ipsAccount forKey:@"ipsAccount"];
    }
}

#pragma mark -- 自己的方法
- (IBAction)confirmFillinAccount:(id)sender
{
    if([_amountFillinText.text length] == 0)
    {
        [BasicToastInterFace showToast:@"充值金额不能为空!  "];
        return;
    }
    if([_amountFillinText.text floatValue] <= 0.0f)
    {
        [BasicToastInterFace showToast:@"充值金额必须大于0元!  "];
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
        [BasicToastInterFace showToast:@"充值金额不能超过14位整数!  "];
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

//
//  CertificationViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "CertificationViewController.h"
#import "BasicToastInterFace.h"

@interface CertificationViewController ()
{
    
}

@end

@implementation CertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.nameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.tintColor = [UIColor redColor];
    
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.returnKeyType = UIReturnKeyDone;
    self.numberTextField.tintColor = [UIColor redColor];
    
    self.title = @"实名认证";
    _nameTextField.text = @"";
    _numberTextField.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MainZhongJin"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_nameTextField.text forKey:@"realName"];
        [seg setValue:_numberTextField.text forKey:@"identNo"];
    }
}

#pragma mark - 与xib关联的方法
- (IBAction)popToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)doCertificate
{
    if ([_nameTextField.text length] == 0)
    {
        [BasicToastInterFace showToast:@"请输入正确的用户名!  "];
        return;
    }
    if ([_nameTextField.text length] == 0)
    {
        [BasicToastInterFace showToast:@"请输入正确的身份证号!  "];
        return;
    }
    
    [self performSegueWithIdentifier:@"MainZhongJin" sender:nil];
}

#pragma mark - 自己的方法

#pragma mark - 代理方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (self.nameTextField.editing)
    {
        [self.numberTextField becomeFirstResponder];
        return YES;
    }
    if (self.numberTextField.editing)
    {
        [self.numberTextField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end

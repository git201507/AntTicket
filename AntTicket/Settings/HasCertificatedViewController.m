//
//  HasCertificatedViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "HasCertificatedViewController.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"

@interface HasCertificatedViewController ()
{
    
}

@end

@implementation HasCertificatedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.title = @"实名认证信息";
    
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    _nameLabel.text = accountInfo.name;
    _telLabel.text = accountInfo.mobile;
    _cardNoLabel.text = accountInfo.idCard;
    _zhongjinNoLabel.text = accountDetail.ipsAccount;
    _stateLabel.text = @"认证成功";
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
#pragma mark - 与xib关联的方法

@end

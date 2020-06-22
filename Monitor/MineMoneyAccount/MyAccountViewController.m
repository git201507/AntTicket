//
//  MyAccountViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UIColor+Hex.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicMoneyAccountDef.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
#import "BasicMessageInterFace.h"
#import "UserMoneyAccountUpdater.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicViewCellUPDownAdmin.h"
#import "GlobleData.h"
#import "BasicViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyAccountViewController ()
{
    NSString *_couponNumber;
    NSString *_salaryAmount;
    
    NSString *_ipsAccount;
    BOOL _isCommonPrize;
}
@property(nonatomic, strong) BasicViewCell *levelImageBackView;

@end

@implementation MyAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];

    _fillInBtn.layer.masksToBounds = YES;
    _fillInBtn.layer.cornerRadius = 5.f;
    _fetchCashBtn.layer.masksToBounds = YES;
    _fetchCashBtn.layer.cornerRadius = 5.f;

    //绑定账号切换消息
    [BasicMessageInterFace subMessage:self selector:@selector(accountChange) MessageID:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread];
    
    //绑定资金账户变化消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyAccountChanged:) name:NSSUSERMONEYACCOUNTCHANGEDMESSAGE_MainThread object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *curAccount = [BasicAccountInterFace getCurAccountName];
    if (!curAccount)
    {
        return;
    }
    
    NSString *curAccountToken = [BasicAccountInterFace getTokenWithAccountName:curAccount];
    if (!curAccountToken)
    {
        return;
    }
    
    [UserMoneyAccountUpdater getUserMoneyAccountByToken:curAccountToken];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FillinAccount"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_ipsAccount forKey:@"ipsAccount"];
    }
    if ([segue.identifier isEqualToString:@"CashAccount"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_ipsAccount forKey:@"ipsAccount"];
    }
    if ([segue.identifier isEqualToString:@"toPrize"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:sender forKey:@"isCommon"];
    }
    
}

#pragma mark - 与xib关联的方法
- (IBAction)showTel:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要拨出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (IBAction)showLevel:(id)sender
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:self options:nil];
    BasicViewCell *protocolView = [nibViews objectAtIndex:5];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    
    NSString *judgeLevel = accountDetail.memberLevel;
    
    if([judgeLevel isEqualToString:@"level_4"])
    {
        [protocolView setValue:@"您的会员级别是普通，享受投资增益8%-12%不等待遇，无推荐投资返利" forKey:@"levelStr"];
    }
    if([judgeLevel isEqualToString:@"level_3"])
    {
        [protocolView setValue:@"您的会员级别是白金，享受投资增益0.5%，推荐人投资0.5%返利待遇" forKey:@"levelStr"];
    }
    if([judgeLevel isEqualToString:@"level_2"])
    {
        [protocolView setValue:@"您的会员级别是红钻，享受投资增益1%，推荐人投资1%返利待遇" forKey:@"levelStr"];
    }
    if([judgeLevel isEqualToString:@"level_1"])
    {
        [protocolView setValue:@"您的会员级别是黑钻，享受投资增益1%，推荐人投资2%返利待遇" forKey:@"levelStr"];
    }
    
    [keywindow addViewCellToManger:protocolView animated:nil];
    return;
    
//    if (!_levelImageBackView)
//    {
//        _levelImageBackView = [[BasicViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        [_levelImageBackView setBackgroundColor:[UIColor colorWithHexString:@"#686868" alpha:0.8f]];
//        
//        UIImageView *levelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_memberlevel"]];
//        levelImageView.frame = CGRectMake(24.35f/2.f, 40.f/2.f, self.view.bounds.size.width-24.35f, self.view.bounds.size.height-40.f);
//        [levelImageView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
//        [_levelImageBackView addSubview:levelImageView];
//        
//        UIButton *levelCloseImageView = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 37.5f, 37.5f)];
//        [levelCloseImageView setCenter:CGPointMake(levelImageView.center.x + levelImageView.bounds.size.width/2.f - levelImageView.bounds.size.width/6.f, levelImageView.center.y - levelImageView.bounds.size.height/2.f + levelImageView.bounds.size.height/12.f)];
//        [levelCloseImageView setBackgroundImage:[UIImage imageNamed:@"pic_memberlevel_close"] forState:UIControlStateNormal];
//        [levelCloseImageView addTarget:self action:@selector(closeLevel:) forControlEvents:UIControlEventTouchUpInside];
//        [_levelImageBackView addSubview:levelCloseImageView];
//    }
//    
//    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
//    [keywindow addViewCellToManger:(BasicViewCell *)_levelImageBackView animated:nil];
}
- (void)closeLevel:(id)sender
{
    [_levelImageBackView.viewCellManger popToLastViewCell:nil];
}

- (IBAction)showVIP:(id)sender
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:self options:nil];
    BasicViewCell *protocolView = [nibViews objectAtIndex:8];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addViewCellToManger:protocolView animated:nil];
    return;
}

- (IBAction)showFinancial:(id)sender
{
    if(_accountDetail.financial == 2)
    {
        [self performSegueWithIdentifier:@"PlannerHomePage" sender:nil];
        return;
    }
    else
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:self options:nil];
        BasicViewCell *protocolView = [nibViews objectAtIndex:0];

        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addViewCellToManger:protocolView animated:nil];
    }
}


- (IBAction)showSettings:(id)sender
{
    [self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (IBAction)showMessageList:(id)sender
{    
    [self performSegueWithIdentifier:@"toMessageList" sender:nil];
}

- (IBAction)fillinMoney:(id)sender
{
    if (!_ipsAccount || _ipsAccount.length == 0)
    {
        [self performSegueWithIdentifier:@"accountToCertificate" sender:nil];
        return;
    }
    
    [self performSegueWithIdentifier:@"FillinAccount" sender:nil];
}

- (IBAction)cashMoney:(id)sender
{
    if (!_ipsAccount || _ipsAccount.length == 0)
    {
        [self performSegueWithIdentifier:@"accountToCertificate" sender:nil];
        return;
    }
    
    [self performSegueWithIdentifier:@"CashAccount" sender:nil];
}

#pragma mark - 自己的方法
- (void)getMessageNumbers
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    NSMutableDictionary *params = [@{@"memberId":accountInfo.userId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:MessageCenter_GetMsgNumberURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         VerifyVipCodeReceiveInfo *info = [[VerifyVipCodeReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [_msgBtn setBackgroundImage:[UIImage imageNamed:@"icon_msg_none"] forState:UIControlStateNormal];
             return;
         }
         
         NSArray *numArray = [info.msg componentsSeparatedByString:@"-"];
         if([numArray count] < 3)
         {
             return;
         }
         
         NSString *unReadMsg = [numArray objectAtIndex:0];
         
         if ([unReadMsg intValue] <= 0)
         {
             [_msgBtn setBackgroundImage:[UIImage imageNamed:@"icon_msg_none"] forState:UIControlStateNormal];
         }
         else
         {
             [_msgBtn setBackgroundImage:[UIImage imageNamed:@"icon_msg"] forState:UIControlStateNormal];
         }
         
         NSString *prizeNum = [numArray objectAtIndex:1];
         NSString *commonPrizeNum = [numArray objectAtIndex:2];
         
         if ([commonPrizeNum intValue] != 0)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"http://mayi.shunher.com\r\n您有抽奖机会" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
             _isCommonPrize = YES;
             [alert show];
             return;
         }
         else if ([prizeNum intValue] != 0)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"http://mayi.shunher.com\r\n您有抽奖机会" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
             _isCommonPrize = NO;
             [alert show];
             return;
         }
     }
         failure:^(NSError *error)
     {
         [_msgBtn setBackgroundImage:[UIImage imageNamed:@"icon_msg_none"] forState:UIControlStateNormal];
     }];
}

//调用方法，接受信息。
- (void)moneyAccountChanged:(NSNotification *)notification
{
    _accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    [self resetAccountDisplay];
}

- (void)resetAccountDisplay
{
    [self getMessageNumbers];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    if(_accountDetail.vip == 1)
    {
        [_vipBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip"] forState:UIControlStateNormal];
    }
    else
    {
        [_vipBtn setBackgroundImage:[UIImage imageNamed:@"icon_novip"] forState:UIControlStateNormal];
    }
    
    [_levelBtn setHidden:YES];
    
    if ([_accountDetail.memberLevel isEqualToString:@"level_4"] || [_accountDetail.memberLevel isEqualToString:@"level_3"] || [_accountDetail.memberLevel isEqualToString:@"level_2"] || [_accountDetail.memberLevel isEqualToString:@"level_1"])
    {
        if([_accountDetail.memberLevel isEqualToString:@"level_4"])
        {
            [_levelBtn setBackgroundImage:[UIImage imageNamed:@"icon_putong"] forState:UIControlStateNormal];
        }
        else if([_accountDetail.memberLevel isEqualToString:@"level_3"])
        {
            [_levelBtn setBackgroundImage:[UIImage imageNamed:@"icon_baizuan"] forState:UIControlStateNormal];
        }
        else if([_accountDetail.memberLevel isEqualToString:@"level_2"])
        {
            [_levelBtn setBackgroundImage:[UIImage imageNamed:@"icon_hongzuan"] forState:UIControlStateNormal];
        }
        else if([_accountDetail.memberLevel isEqualToString:@"level_1"])
        {
            [_levelBtn setBackgroundImage:[UIImage imageNamed:@"icon_heizuan"] forState:UIControlStateNormal];
        }
        [_levelBtn setHidden:NO];
    }
    
    if(_accountDetail.financial == 2)
    {
        [_lcsBtn setBackgroundImage:[UIImage imageNamed:@"icon_lcsh"] forState:UIControlStateNormal];
    }
    else
    {
        [_lcsBtn setBackgroundImage:[UIImage imageNamed:@"icon_lcsn"] forState:UIControlStateNormal];
    }
    
    if (!accountInfo.name || [accountInfo.name length] == 0)
    {
        _nameLabel.text = accountInfo.mobile;
    }
    else
    {
        _nameLabel.text = accountInfo.name;
    }
    
    _incomeLabel.text = [NSString stringWithFormat:@"%0.2f", _accountDetail.totalIncomeAmount];
    _assetLabel.text = [NSString stringWithFormat:@"%0.2f",  _accountDetail.totalAmount];
    _collectLabel.text =[NSString stringWithFormat:@"%0.2f",  _accountDetail.freezeAmount];
    _financingLabel.text =[NSString stringWithFormat:@"%0.2f",  _accountDetail.financingAmount];
    _balanceLabel.text =[NSString stringWithFormat:@"%0.2f",  _accountDetail.availableAmount];
    _couponNumber = [NSString stringWithFormat:@"%d",  _accountDetail.couponNumber];
    _salaryAmount =  [NSString stringWithFormat:@"%d",  _accountDetail.salaryAmount];
    
    _ipsAccount = _accountDetail.ipsAccount;
    
    if ([_couponNumber intValue] >= 0 || [_salaryAmount intValue] >= 0)
    {
        [_tableView reloadData];
    }
}

- (void)accountChange
{
    if ([BasicUserInterFace getLogInState] != BASICUSERLONGSTATE_NONE)
    {
        NSString *curAccount = [BasicAccountInterFace getCurAccountName];
        NSString *token = [BasicAccountInterFace getTokenWithAccountName:curAccount];
        [UserMoneyAccountUpdater getUserMoneyAccountByToken:token];
    }
}

- (void)doLogout:(UIButton *)sender
{
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserLogoutURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:nil succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         MyAccountDetailReceiveInfo *info = [[MyAccountDetailReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
         }
         
         [BasicUserInterFace doLogOut];
         [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
         [BasicUserInterFace doLogIn];
     }
                          failure:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         
         [BasicUserInterFace doLogOut];
         [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
         [BasicUserInterFace doLogIn];
     }];
}

#pragma mark - 代理方法
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 60;
    }
    return 0;
}


//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, 20)];
    detailLabel.text = @"账户明细";
    detailLabel.font = [UIFont systemFontOfSize:14.f];
    detailLabel.textColor = [UIColor colorWithHexString:@"#686868" alpha:1];
    [view addSubview:detailLabel];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 40)];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [exitBtn setTitleColor:[UIColor colorWithHexString:@"#686868" alpha:1] forState:UIControlStateNormal];
    [exitBtn setBackgroundColor:[UIColor whiteColor]];
    [exitBtn addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitBtn];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.f];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"ico_coupon"];
            cell.textLabel.text = @"优惠劵";
            
            if([cell viewWithTag:100])
            {
                [[cell viewWithTag:100] removeFromSuperview];
            }
            if ([_couponNumber intValue] > 0)
            {
                UILabel *couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 12, 21, 21)];
                couponLabel.backgroundColor = [UIColor whiteColor];
                couponLabel.textAlignment = NSTextAlignmentCenter;
                couponLabel.font = [UIFont systemFontOfSize:9.f];
                couponLabel.textColor = [UIColor redColor];
                couponLabel.layer.masksToBounds = YES;
                couponLabel.layer.cornerRadius = couponLabel.bounds.size.width/2;
                couponLabel.layer.borderColor = [UIColor redColor].CGColor;
                couponLabel.layer.borderWidth = 1.f;
                couponLabel.text = _couponNumber;
                [cell addSubview:couponLabel];
                couponLabel.tag = 100;
            }
        }
        else if (indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"ico_salary"];
            cell.textLabel.text = @"蚂蚁工资";
            
//            if([cell viewWithTag:200])
//            {
//                [[cell viewWithTag:200] removeFromSuperview];
//            }
//            if ([_salaryAmount intValue] > 0)
//            {
//                UILabel *salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 12, 21, 21)];
//                salaryLabel.backgroundColor = [UIColor redColor];
//                salaryLabel.textAlignment = NSTextAlignmentCenter;
//                salaryLabel.font = [UIFont systemFontOfSize:9.f];
//                salaryLabel.textColor = [UIColor whiteColor];
//                salaryLabel.layer.masksToBounds = YES;
//                salaryLabel.layer.cornerRadius = salaryLabel.bounds.size.width/2;
//                salaryLabel.text = _salaryAmount;
//                [cell addSubview:salaryLabel];
//                salaryLabel.tag = 200;
//            }
        }
        else if (indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"icon_myshare"];
            cell.textLabel.text = @"我的分享";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头 
    }
    
    else if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0)
        {
            
            cell.imageView.image = [UIImage imageNamed:@"ico_financing_record"];
            cell.textLabel.text = @"理财记录";
        }
        else if (indexPath.row == 1)
        {
            
            cell.imageView.image = [UIImage imageNamed:@"ico_cash_record"];
            cell.textLabel.text = @"资金记录";
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"toCouponList" sender:nil];
            return;
        }
        if(indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"toSalaryList" sender:nil];
            return;
        }
        if(indexPath.row == 2)
        {
            [self performSegueWithIdentifier:@"myShare" sender:nil];
            return;
        }
        
    }
    if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"toFinanceHistory" sender:nil];
            return;
        }
        if(indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"toMoneyRecord" sender:nil];
            return;
        }
    }
}
#pragma mark -- alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"提示"])
    {
        if (buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"4006551295"]]];
        }
        return;
    }
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"toPrize" sender:[NSNumber numberWithBool:_isCommonPrize]];
    }
}

@end

//
//  SalaryViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "SalaryViewController.h"
#import "UIColor+Hex.h"
#import "BasicAccountInterFace.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicMoneyAccountDef.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
#import "BasicMessageInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "LoadingView.h"
#import "GlobleData.h"
#import "UITableView+Cell.h"
#import "MJRefresh.h"

@interface SalaryViewController ()
{
    NSString *_couponAmount;
    NSString *_salaryAmount;
    
    NSString *_ipsAccount;
    NSMutableArray *_salaryDetailList;
    
    SalaryRecordStatus _salaryType;
    int _pageNo;
}

@end

@implementation SalaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _fetchCouponBtn.layer.masksToBounds = YES;
    _fetchCouponBtn.layer.cornerRadius = 5.f;
    _cashBtn.layer.masksToBounds = YES;
    _cashBtn.layer.cornerRadius = 5.f;
    
    [self setupRefresh];
    
    _salaryDetailList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self getSalaryHeaderInfo];
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
    if ([segue.identifier isEqualToString:@"FetchCoupons"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_balanceLabel.text forKey:@"balanceVal"];
        [seg setValue:_ipsAccount forKey:@"ipsAccount"];
    }
    if ([segue.identifier isEqualToString:@"SalaryCash"])
    {
        id seg = segue.destinationViewController;
        
        [seg setValue:_balanceLabel.text forKey:@"balanceVal"];
    }
}

#pragma mark - 与xib关联的方法
- (IBAction)changeSalaryType:(UIButton *)sender
{
    if (sender == _mysalaryListBtn)
    {
        _salaryType = SalaryRecordStatus_MySalary;
    }
    if (sender == _withdrawListBtn)
    {
        _salaryType = SalaryRecordStatus_Withdraw;
    }
    if (sender == _couponUseRecordBtn)
    {
        _salaryType = SalaryRecordStatus_CouponUse;
    }
    _pageNo = 1;
    [self getSalaryDetailInfo];
}

- (IBAction)cashSalary:(id)sender
{
    [self performSegueWithIdentifier:@"SalaryCash" sender:nil];
}

- (IBAction)fetchCoupons:(id)sender
{
    [self performSegueWithIdentifier:@"FetchCoupons" sender:nil];
}

#pragma mark - 自己的方法

- (void)getSalaryHeaderInfo
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    //请求参数
    NSMutableDictionary *params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]]} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Salary_GetHeaderInfoURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         SalaryHeaderReceiveInfo *info = [[SalaryHeaderReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.data)
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             if([info.msg isEqualToString:@"当前用户登录状态异常"])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         
         _balanceLabel.text = [NSString stringWithFormat:@"%0.2f", info.data.surplus];
         _totalLabel.text = [NSString stringWithFormat:@"%0.2f", info.data.total];
         _cashLabel.text = [NSString stringWithFormat:@"%0.2f", info.data.cashed];
         _couponLabel.text = [NSString stringWithFormat:@"%0.2f", info.data.withdraw];
         
         _salaryType = SalaryRecordStatus_MySalary;
         _pageNo = 1;
         
         [self getSalaryDetailInfo];
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

- (void)getSalaryDetailInfo
{
    if (_pageNo == 1)
    {
        [_salaryDetailList removeAllObjects];
        [_tableView reloadData];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    NSMutableDictionary *params;
    NSString *lastURL;
    
    if (_salaryType == SalaryRecordStatus_MySalary)
    {
        params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]],@"pageNo":[NSString stringWithFormat:@"%d", _pageNo],@"pageSize":@"20"} mutableCopy];
        lastURL = Salary_GetListInfoURL;
    }
    if (_salaryType == SalaryRecordStatus_Withdraw)
    {
        params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]],@"pageNo":[NSString stringWithFormat:@"%d", _pageNo],@"pageSize":@"20"} mutableCopy];
        lastURL = Salary_GetCashListInfoURL;
    }
    if (_salaryType == SalaryRecordStatus_CouponUse)
    {
        params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]],@"userid":accountInfo.userId,@"status":@"1",@"pageNo":[NSString stringWithFormat:@"%d", _pageNo],@"pageSize":@"20"} mutableCopy];
        lastURL = Salary_FetchCouponListInfoURL;
    }
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:lastURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
        
         BasicJsonKvcClass *info = [[BasicJsonKvcClass alloc] init];
         if (_salaryType == SalaryRecordStatus_MySalary)
         {
             info  = [[SalaryTotalDetailReceiveInfo alloc] init];
         }
         if (_salaryType == SalaryRecordStatus_Withdraw)
         {
             info = [[SalaryWithdrawReceiveInfo alloc] init];
         }
         if (_salaryType == SalaryRecordStatus_CouponUse)
         {
             info  = [[CouponRecordReceiveInfo alloc] init];
         }

         if (![info setJsonDataWithDic:respData] || ![info valueForKey:@"state"] || ![[info valueForKey:@"state"] isEqualToString:@"1"])
         {
              [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", [info valueForKey:@"msg"]]];
             
             _pageNo = 1;
             if([[info valueForKey:@"msg"] isEqualToString:@"当前用户登录状态异常"])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         
         if (!_salaryDetailList)
         {
             _salaryDetailList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_salaryDetailList removeAllObjects];
         }
         
         [_salaryDetailList addObjectsFromArray:[[info valueForKey:@"data"] valueForKey:@"result"]];
         [_tableView reloadData];
         
         if ([[[info valueForKey:@"data"] valueForKey:@"result"] count]>0)
         {
             _pageNo++;
         }
         else
         {
             [BasicToastInterFace showToast:@"没有更多数据了!  "];
         }
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
         [_salaryDetailList removeAllObjects];
         [_tableView reloadData];
         _pageNo = 1;
     }];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addFooterWithTarget:self action:@selector(pullTable)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.footerPullToRefreshText = @"下拉即可刷新";
    self.tableView.footerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}
- (void)pullTable
{
    [self.tableView footerEndRefreshing];
    
    [self getSalaryDetailInfo];
}

#pragma mark - 代理方法
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_salaryDetailList count];
}


//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return nil;
//    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
//    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, 20)];
//    detailLabel.text = @"账户明细";
//    detailLabel.font = [UIFont systemFontOfSize:14.f];
//    detailLabel.textColor = [UIColor colorWithHexString:@"#686868" alpha:1];
//    [view addSubview:detailLabel];
//    return view;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return nil;
//    }
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
//    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 40)];
//    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [exitBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
//    [exitBtn setTitleColor:[UIColor colorWithHexString:@"#686868" alpha:1] forState:UIControlStateNormal];
//    [exitBtn setBackgroundColor:[UIColor whiteColor]];
//    [exitBtn addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [view addSubview:exitBtn];
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"SalaryListCell"];
    
    
    
    if (_salaryType == SalaryRecordStatus_MySalary)
    {
        SalaryTotalDetail *salary = [_salaryDetailList objectAtIndex:indexPath.row];
        
        UILabel *orderNoLabel = (UILabel *)[cell viewWithTag:100];
        orderNoLabel.layer.masksToBounds = YES;
        orderNoLabel.layer.cornerRadius = 8.f;
        orderNoLabel.layer.borderColor = [UIColor redColor].CGColor;
        orderNoLabel.layer.borderWidth = 1.f;
        orderNoLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
        nameLabel.text = salary.name;
        
        UILabel *profitLabel = (UILabel *)[cell viewWithTag:300];
        profitLabel.text = [NSString stringWithFormat:@"%0.2f元", [salary.profit floatValue]];
        
        UILabel *realNameLabel = (UILabel *)[cell viewWithTag:400];
        realNameLabel.text = [NSString stringWithFormat:@"工资来源：%@", salary.realName];
        
        UILabel *createDateLabel = (UILabel *)[cell viewWithTag:500];
        createDateLabel.text = salary.createDateStr;
        
        [[cell viewWithTag:500] setHidden:NO];
    }
    if (_salaryType == SalaryRecordStatus_Withdraw)
    {
        SalaryWithdraw *salary = [_salaryDetailList objectAtIndex:indexPath.row];
        
        UILabel *orderNoLabel = (UILabel *)[cell viewWithTag:100];
        orderNoLabel.layer.masksToBounds = YES;
        orderNoLabel.layer.cornerRadius = 8.f;
        orderNoLabel.layer.borderColor = [UIColor redColor].CGColor;
        orderNoLabel.layer.borderWidth = 1.f;
        orderNoLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
        nameLabel.text = salary.realName;
        
        UILabel *profitLabel = (UILabel *)[cell viewWithTag:300];
        profitLabel.text = [NSString stringWithFormat:@"%0.2f元 退回", salary.amount];
        
        UILabel *cardNoLabel = (UILabel *)[cell viewWithTag:400];
        cardNoLabel.text = [NSString stringWithFormat:@"卡号：%@", salary.bankCode];
        
        UILabel *withDrawDateLabel = (UILabel *)[cell viewWithTag:500];
        withDrawDateLabel.text = salary.withDrawDate;
        
        [[cell viewWithTag:500] setHidden:NO];
    }
    if (_salaryType == SalaryRecordStatus_CouponUse)
    {
        UILabel *orderNoLabel = (UILabel *)[cell viewWithTag:100];
        orderNoLabel.layer.masksToBounds = YES;
        orderNoLabel.layer.cornerRadius = 8.f;
        orderNoLabel.layer.borderColor = [UIColor redColor].CGColor;
        orderNoLabel.layer.borderWidth = 1.f;
        orderNoLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
        
        CouponEntity *coupon = [_salaryDetailList objectAtIndex:indexPath.row];
        
        UILabel *orderLabel = (UILabel *)[cell viewWithTag:100];
        orderLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row+1)];
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
        nameLabel.text = [NSString stringWithFormat:@"满%d元可用", coupon.usingLimitAmount];
        
        UILabel *amountLabel = (UILabel *)[cell viewWithTag:300];
        amountLabel.text = [NSString stringWithFormat:@"%d元", coupon.amount];
        
        UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:400];
        deadLineLabel.text = [NSString stringWithFormat:@"有效期至:%@", coupon.deadline];
        
        [[cell viewWithTag:500] setHidden:YES];
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end

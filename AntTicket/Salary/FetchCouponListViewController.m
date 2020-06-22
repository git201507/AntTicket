//
//  FetchCouponListViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "FetchCouponListViewController.h"
#import "UITableView+Cell.h"
#import "MJRefresh.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserNet.h"
#import "LoadingView.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "BasicUserInterFace.h"
#import "UIColor+Hex.h"

@interface FetchCouponListViewController ()
{
    NSMutableArray *_couponList;
    int _pageNo;
    NSInteger _selectedIndex;
}
@property (nonatomic, copy) NSString *balanceVal;
@property (nonatomic, copy) NSString *ipsAccount;

@end

@implementation FetchCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _selectedIndex = -1;
    [self setupRefresh];
    
    _couponList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _pageNo = 1;
    [self getCouponList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doFetchCoupon:(CouponCenterEntity *)coupon;
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    NSMutableDictionary *params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]], @"couponID":coupon.uid} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Salary_ExchangeCouponURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         //登录过期
         if (statusCode == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
             [BasicUserInterFace doLogIn];
             return;
         }
         
         ExchangeCouponReceiveInfo *info = [[ExchangeCouponReceiveInfo alloc] init];
         
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
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"优惠券兑换成功" delegate:self cancelButtonTitle:@"继续兑换" otherButtonTitles:@"完成", nil];
         [alert show];
     }
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)getCouponList
{
    if (_pageNo == 1)
    {
        [_couponList removeAllObjects];
        [_tableView reloadData];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    NSMutableDictionary *params = [@{@"status":@"2",@"pageNo":[NSString stringWithFormat:@"%d", _pageNo],@"pageSize":@"20",@"userid":accountInfo.userId,@"couponType":@"1"} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Salary_GetCouponListURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         //登录过期
         if (statusCode == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
             [BasicUserInterFace doLogIn];
             return;
         }
         CouponCenterListReceiveInfo *info = [[CouponCenterListReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", [info valueForKey:@"msg"]]];
             _pageNo = 1;
             [_tableView reloadData];
             return;
         }
         
         if (!_couponList)
         {
             _couponList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_couponList removeAllObjects];
         }
         
         [_couponList addObjectsFromArray:[[info valueForKey:@"data"] valueForKey:@"result"]];
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
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         [_couponList removeAllObjects];
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
    self.tableView.footerPullToRefreshText = @"上拉即可刷新";
    self.tableView.footerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}
- (void)pullTable
{
    [self.tableView footerEndRefreshing];
    
    [self getCouponList];
}

- (IBAction)fetchCoupon
{
    if (_selectedIndex == -1)
    {
        [BasicToastInterFace showToast:@"请选择优惠券!  "];
        return;
    }
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    if (!accountDetail.ipsAccount || [accountDetail.ipsAccount length] == 0)
    {
        [BasicToastInterFace showToast:@"请先到实名认证!  "];
        return;
    }
    
    if ([_balanceVal floatValue] <= 0.f)
    {
        [BasicToastInterFace showToast:@"工资余额不足!  "];
        return;
    }
    
    CouponCenterEntity *coupon = [_couponList objectAtIndex:_selectedIndex];
    
    if ([_balanceVal floatValue] < (float)coupon.amount)
    {
        [BasicToastInterFace showToast:@"工资余额少于优惠券面额!  "];
        return;
    }
    
    [self doFetchCoupon:coupon];
}
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}


#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0)
    {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != [_couponList count] - 1)
    {
        return 0;
    }
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != [_couponList count] - 1)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, tableView.frame.size.width, 30)];
    noticeLabel.text = @"上拉加载更多...";
    noticeLabel.textColor = [UIColor colorWithHexString:@"686868"];
    noticeLabel.textAlignment = NSTextAlignmentCenter;

    [view addSubview:noticeLabel];
    return view;
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_couponList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UILabel *salaryBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 12.5f, 80, 15)];
    salaryBalanceLabel.textColor = [UIColor blackColor];
    salaryBalanceLabel.font = [UIFont systemFontOfSize:14.f];
    salaryBalanceLabel.text = @"工资余额";
    [view addSubview:salaryBalanceLabel];
    
    UILabel *balanceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 12.5f, 150, 15)];
    balanceValueLabel.textColor = [UIColor redColor];
    balanceValueLabel.font = [UIFont systemFontOfSize:14.f];
    balanceValueLabel.text = [NSString stringWithFormat:@"%@元", _balanceVal];
    [view addSubview:balanceValueLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"CouponCenterCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CouponCenterEntity *coupon = [_couponList objectAtIndex:indexPath.section];
    
    UILabel *orderLabel = (UILabel *)[cell viewWithTag:100];
    [orderLabel setHidden:YES];
    
    if ([cell viewWithTag:500])
    {
        [[cell viewWithTag:500] removeFromSuperview];
    }
    
    NSDictionary *options = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f] };
    CGRect boundingRect = [[NSString stringWithFormat:@"%ld", (long)indexPath.section + 1] boundingRectWithSize:CGSizeMake(NSIntegerMax, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:options context:nil];
    
    if(boundingRect.size.width < 20.f)
    {
        boundingRect.size.width = 20.f;
    }
    
    UILabel *orderNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, boundingRect.size.width, boundingRect.size.width)];
    orderNameLabel.layer.cornerRadius = orderNameLabel.bounds.size.width/2;
    orderNameLabel.layer.masksToBounds = YES;
    orderNameLabel.layer.borderColor = [UIColor redColor].CGColor;
    orderNameLabel.layer.borderWidth = 1.f;
    orderNameLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.section + 1];
    orderNameLabel.textAlignment = NSTextAlignmentCenter;
    orderNameLabel.textColor = [UIColor redColor];
    orderNameLabel.font = [UIFont systemFontOfSize:14.f];
    orderNameLabel.tag = 500;
    [cell addSubview:orderNameLabel];
    //
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = [NSString stringWithFormat:@"满%d元可用", coupon.usingLimitAmount];
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:300];
    amountLabel.text = [NSString stringWithFormat:@"%d元", coupon.amount];
    
    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:400];
    deadLineLabel.text = [NSString stringWithFormat:@"有效期%d天", coupon.validityDays];
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.section;
}

@end

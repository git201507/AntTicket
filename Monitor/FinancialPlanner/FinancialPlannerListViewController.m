//
//  FinancialPlannerListViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "FinancialPlannerListViewController.h"
#import "UITableView+Cell.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicAccountInterFace.h"
#import "BasicUserDef.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserNet.h"
#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "LoadingView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface FinancialPlannerListViewController ()
{
    NSMutableArray *_plannerList;
    CouponHeader *_couponHeader;
    int _pageNo;
    int _selectedIndex;
}

@end

@implementation FinancialPlannerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _plannerList = [[NSMutableArray alloc] initWithCapacity:0];
    [self setupMJRefresh];
    
    _pageNo = 1;
    [self getFinancePlannerList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchPlanner
{
    [self.view endEditing:NO];
    _pageNo = 1;
    [self getFinancePlannerList];
}

- (void)getFinancePlannerList
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params;
    
    if (_nameTextField.text.length > 0)
    {
        params = [@{@"name": _nameTextField.text, @"start":[NSString stringWithFormat:@"%d", _pageNo], @"count":CountSizeInPageList, @"memberId":accountInfo.userId} mutableCopy];
    }
    else
    {
        params = [@{@"start":[NSString stringWithFormat:@"%d", _pageNo], @"count":CountSizeInPageList, @"memberId":accountInfo.userId} mutableCopy];
    }

    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_FinancialPlannerListURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         PlannerListReceiveInfo *info = [[PlannerListReceiveInfo alloc] init];
         
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
         
         if (!_plannerList)
         {
             _plannerList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_plannerList removeAllObjects];
         }
         
         [_plannerList addObjectsFromArray:info.data];
         [_tableView reloadData];
         
         if ([info.data count]>0)
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
         [_plannerList removeAllObjects];
         [_tableView reloadData];
         _pageNo = 1;
     }];
}

- (void)setupMJRefresh
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
    
    [self getFinancePlannerList];
}


- (void)selectPlanner:(UIButton *)sender
{
    _selectedIndex = [sender.restorationIdentifier intValue];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"理财师一旦选择不允许改变，选择后可以获得年化0.2%的额外增益，但将失去VIP抽奖机会，你确定要选择吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
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
    return [_plannerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"PlannerListCell"];

    PlannerEntity *planner = [_plannerList objectAtIndex:indexPath.row];

    UIButton *selectBtn = (UIButton *)[cell viewWithTag:10];
    selectBtn.restorationIdentifier = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [selectBtn addTarget:self action:@selector(selectPlanner:) forControlEvents:UIControlEventTouchUpInside];


    UILabel *realNameLabel = (UILabel *)[cell viewWithTag:20];
    realNameLabel.text = planner.realName;
    
    NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:planner.adviserImg];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:30];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         NSLog(@"这里可以在图片加载完成之后做些事情");
     }];
    
    UILabel *loginNameLabel = (UILabel *)[cell viewWithTag:50];
    loginNameLabel.text = [NSString stringWithFormat:@"推荐编码：%@", planner.loginName];
    
    UILabel *adviserIntroductionLabel = (UILabel *)[cell viewWithTag:60];
    adviserIntroductionLabel.text = [NSString stringWithFormat:@"个性签名：%@", planner.adviserIntroduction];
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        PlannerEntity *planner = [_plannerList objectAtIndex:_selectedIndex];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];

        LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];

        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];

        NSMutableDictionary *params = [@{@"financialId": planner.pid, @"memberId":accountInfo.userId} mutableCopy];
        NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_SetMyFinancialURL];
        [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
         {
             [loadingView removeView];
             NSLog(@"%@",respData);
             
             VerifyVipCodeReceiveInfo *info = [[VerifyVipCodeReceiveInfo alloc] init];
             if (![info setJsonDataWithDic:respData])
             {
                 [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
                 return;
             }
             
             if (info.state && [info.state isEqualToString:@"1"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您!" message:info.msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 return;
             }

             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"很遗憾！" message:info.msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }
                              failure:^(NSError *error)
         {
             [loadingView removeView];
             NSLog(@"%@",[error description]);
             
             [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         }];
    }
    if(buttonIndex == 0)
    {
        if ([alertView.title isEqualToString:@"恭喜您!"])
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

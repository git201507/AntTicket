//
//  FinanceHistoryViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "FinanceHistoryViewController.h"
#import "UITableView+Cell.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicAccountInterFace.h"
#import "BasicUserDef.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserNet.h"
#import "LoadingView.h"
#import "BasicUserMangerLogIn.h"
#import "BasicUserInterFace.h"
#import "MJRefresh.h"

@interface FinanceHistoryViewController ()
{
    NSMutableArray *_historyList;
    FinanceHistoryHeader *_historyHeader;
    int _pageNo;
    FinanceHistoryStatus _historyStatus;
}

@property (nonatomic, strong) UIButton *collecttingBtn;
@property (nonatomic, strong) UIButton *financingBtn;
@property (nonatomic, strong) UIButton *finishedBtn;
@property (nonatomic, strong) UILabel *hLineLabel1;
@property (nonatomic, strong) UILabel *hLineLabel2;
@property (nonatomic, strong) UILabel *hLineLabel3;

@end

@implementation FinanceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.
    UILabel *collectingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 45.f/2, 13, 90, 15)];
    [collectingLabel setCenter:CGPointMake(self.view.bounds.size.width/6, 20)];
    collectingLabel.textColor = [UIColor whiteColor];
    collectingLabel.font = [UIFont systemFontOfSize:14.f];
    collectingLabel.text = @"募集中(元)";
    collectingLabel.textAlignment = NSTextAlignmentCenter;
    collectingLabel.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:collectingLabel];
    
    
    UILabel *orderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 45.f/2, 28, 90, 15)];
    [orderLabel1 setCenter:CGPointMake(self.view.bounds.size.width/6, 50)];
    orderLabel1.textColor = [UIColor whiteColor];
    orderLabel1.font = [UIFont systemFontOfSize:14.f];
    orderLabel1.tag = 1000;
    orderLabel1.textAlignment = NSTextAlignmentCenter;
    orderLabel1.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel1];
    
    
    UILabel *financingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45.f/2, 13, 90, 15)];
    [financingLabel setCenter:CGPointMake(self.view.bounds.size.width/2, 20)];
    financingLabel.textColor = [UIColor whiteColor];
    financingLabel.font = [UIFont systemFontOfSize:14.f];
    financingLabel.textAlignment = NSTextAlignmentCenter;
    financingLabel.text = @"理财中(元)";
    financingLabel.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:financingLabel];
    
    UILabel *orderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45.f/2, 28, 90, 15)];
    [orderLabel2 setCenter:CGPointMake(self.view.bounds.size.width/2, 50)];
    orderLabel2.textColor = [UIColor whiteColor];
    orderLabel2.font = [UIFont systemFontOfSize:14.f];
    orderLabel2.textAlignment = NSTextAlignmentCenter;
    orderLabel2.tag = 2000;
    orderLabel2.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel2];
    
    UILabel *finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 13, 90, 15)];
    [finishedLabel setCenter:CGPointMake(self.view.bounds.size.width*5/6, 20)];
    finishedLabel.textColor = [UIColor whiteColor];
    finishedLabel.font = [UIFont systemFontOfSize:14.f];
    finishedLabel.textAlignment = NSTextAlignmentCenter;
    finishedLabel.text = @"已还款(元)";
    finishedLabel.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:finishedLabel];
    
    UILabel *orderLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 28, 90, 15)];
    [orderLabel3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 50)];
    orderLabel3.textColor = [UIColor whiteColor];
    orderLabel3.font = [UIFont systemFontOfSize:14.f];
    orderLabel3.textAlignment = NSTextAlignmentCenter;
    orderLabel3.tag = 3000;
    orderLabel3.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel3];
    
    [self setupMJRefresh];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    [self getHistoryHeaderInfo:loadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BidDetail"])
    {
        id seg = segue.destinationViewController;
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        FinanceProductEntity *item = [_historyList objectAtIndex:indexPath.row];
        item.uid = item.draftId;
        
        [seg setValue:item forKey:@"financeProduct"];
        [seg setValue:[NSNumber numberWithBool:NO] forKey:@"isVIPBid"];
    }
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
    
    [self getHistoryList:_historyStatus pageNo:_pageNo];
}

- (void)getHistoryHeaderInfo: (LoadingView *)loadingView
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:History_GetPersonalFianceMoneyURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinanceHistoryHeaderReceiveInfo *info = [[FinanceHistoryHeaderReceiveInfo alloc] init];
         
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
         
         _historyHeader = info.data;
         
         UILabel *investmentLabel = [_headerView viewWithTag:1000];
         investmentLabel.text = [NSString stringWithFormat:@"%0.2f",[_historyHeader.investment floatValue]];
         UILabel *financingLabel = [_headerView viewWithTag:2000];
         financingLabel.text = [NSString stringWithFormat:@"%0.2f",[_historyHeader.financing floatValue]];
         UILabel *finshLabel = [_headerView viewWithTag:3000];
         finshLabel.text = [NSString stringWithFormat:@"%0.2f",[_historyHeader.finsh floatValue]];
         
         _pageNo = 1;
         _historyStatus = FinanceHistoryStatus_Financing;
         [self getHistoryList:_historyStatus pageNo:_pageNo];
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

- (void)getHistoryList:(int)status pageNo:(int)pageNo
{
    if (_pageNo == 1)
    {
        [_historyList removeAllObjects];
        [_tableView reloadData];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"type": [NSString stringWithFormat:@"%lu", (unsigned long)_historyStatus], @"start":[NSString stringWithFormat:@"%d", pageNo], @"count":CountSizeInPageList, @"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:History_GetPersonalFianceListURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinanceProductReceiveInfo *info = [[FinanceProductReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             _pageNo = 1;
             if([info.msg isEqualToString:@"当前用户登录状态异常"])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         
         if (!_historyList)
         {
             _historyList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_historyList removeAllObjects];
         }
         
         [_historyList addObjectsFromArray:info.data];
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
         [_historyList removeAllObjects];
         [_tableView reloadData];
         _pageNo = 1;
     }];
}

- (void)selectHistoryType:(UIButton *)sender
{
    if (sender == _collecttingBtn)
    {
        if (_historyStatus == FinanceHistoryStatus_Collecting)
        {
            return;
        }
        
        _historyStatus = FinanceHistoryStatus_Collecting;
    }
    if (sender == _financingBtn)
    {
        if (_historyStatus == FinanceHistoryStatus_Financing)
        {
            return;
        }
        
        _historyStatus = FinanceHistoryStatus_Financing;
    }
    if (sender == _finishedBtn)
    {
        if (_historyStatus == FinanceHistoryStatus_finished)
        {
            return;
        }
        
        _historyStatus = FinanceHistoryStatus_finished;
    }
    _pageNo = 1;
    [self getHistoryList:_historyStatus pageNo:_pageNo];
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
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
    return [_historyList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label1 setCenter:CGPointMake(self.view.bounds.size.width/6, 19.5f)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14.f];
    label1.text = @"募集中";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor clearColor];
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label2 setCenter:CGPointMake(self.view.bounds.size.width/2, 19.5f)];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:14.f];
    label2.text = @"理财中";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor clearColor];
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 19.5f)];
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:14.f];
    label3.text = @"已还款";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.backgroundColor = [UIColor clearColor];
    [view addSubview:label3];
    
    
    _collecttingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 40)];
    [_collecttingBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_collecttingBtn];
    [_collecttingBtn addTarget:self action:@selector(selectHistoryType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel1.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel1];
    [_hLineLabel1 setHidden:YES];
    
    _financingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 40)];
    [_financingBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_financingBtn];
    [_financingBtn addTarget:self action:@selector(selectHistoryType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel2.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel2];
    [_hLineLabel2 setHidden:YES];
    
    _finishedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 39)];
    [_finishedBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_finishedBtn];
    [_finishedBtn addTarget:self action:@selector(selectHistoryType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel3.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel3];
    [_hLineLabel3 setHidden:YES];
    
    if (_historyStatus == FinanceHistoryStatus_Collecting) {
        [_hLineLabel1 setHidden:NO];
    }
    if (_historyStatus == FinanceHistoryStatus_Financing) {
        [_hLineLabel2 setHidden:NO];
    }
    if (_historyStatus == FinanceHistoryStatus_finished) {
        [_hLineLabel3 setHidden:NO];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"FinanceHistoryListCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    FinanceProductEntity *history = [_historyList objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = history.name;
    
    
    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:300];
    deadLineLabel.text = [NSString stringWithFormat:@"还款日期：%@ 理财期：%d天", history.latestRepaymentDate, history.financeDays];
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:400];

    amountLabel.text = [NSString stringWithFormat:@"%@(%@)元",history.amount,history.zsy];
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self performSegueWithIdentifier:@"BidDetail" sender:indexPath];
}

@end

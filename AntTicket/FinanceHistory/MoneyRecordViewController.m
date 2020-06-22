//
//  MoneyRecordViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/9/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "MoneyRecordViewController.h"
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

@interface MoneyRecordViewController ()
{
    NSMutableArray *_recordList;
    MoneyRecordHeader *_recordHeader;
    int _pageNo;
    MoneyRecordStatus _recordStatus;
}

@property (nonatomic, strong) UIButton *fillinBtn;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, strong) UIButton *investBtn;
@property (nonatomic, strong) UILabel *hLineLabel1;
@property (nonatomic, strong) UILabel *hLineLabel2;
@property (nonatomic, strong) UILabel *hLineLabel3;

@end

@implementation MoneyRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 15)];
    [label1 setCenter:CGPointMake(self.view.bounds.size.width/6, 20)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:14.f];
    label1.text = @"充值金额(元)";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:label1];
    
    
    UILabel *orderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 45.f/2, 28, self.view.bounds.size.width/3, 15)];
    [orderLabel1 setCenter:CGPointMake(self.view.bounds.size.width/6, 50)];
    orderLabel1.textColor = [UIColor whiteColor];
    orderLabel1.font = [UIFont systemFontOfSize:14.f];
    orderLabel1.tag = 1000;
    orderLabel1.textAlignment = NSTextAlignmentCenter;
    orderLabel1.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 15)];
    [label2 setCenter:CGPointMake(self.view.bounds.size.width/2, 20)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:14.f];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"提现金额(元)";
    label2.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:label2];
    
    UILabel *orderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45.f/2, 28, self.view.bounds.size.width/3, 15)];
    [orderLabel2 setCenter:CGPointMake(self.view.bounds.size.width/2, 50)];
    orderLabel2.textColor = [UIColor whiteColor];
    orderLabel2.font = [UIFont systemFontOfSize:14.f];
    orderLabel2.textAlignment = NSTextAlignmentCenter;
    orderLabel2.tag = 2000;
    orderLabel2.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 15)];
    [label3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 20)];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:14.f];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"理财收入(元)";
    label3.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:label3];
    
    UILabel *orderLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 28, self.view.bounds.size.width/3, 15)];
    [orderLabel3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 50)];
    orderLabel3.textColor = [UIColor whiteColor];
    orderLabel3.font = [UIFont systemFontOfSize:14.f];
    orderLabel3.textAlignment = NSTextAlignmentCenter;
    orderLabel3.tag = 3000;
    orderLabel3.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:orderLabel3];
    
    [self setupMJRefresh];
    
    [self getRecordHeaderInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMJRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(pullTable)];
    
    self.tableView.footerPullToRefreshText = @"下拉即可刷新";
    self.tableView.footerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}

- (void)pullTable
{
    [self.tableView footerEndRefreshing];
    
    [self getRecordList];
}

- (void)getRecordHeaderInfo
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Record_GetPersonalMoneyURL];
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
         
         MoneyRecordHeaderReceiveInfo *info = [[MoneyRecordHeaderReceiveInfo alloc] init];
         
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
         
         _recordHeader = info.data;
         
         UILabel *fillinLabel = [_headerView viewWithTag:1000];
         fillinLabel.text = [NSString stringWithFormat:@"%0.2f", _recordHeader.totalRecharge];
         UILabel *totalDrawLabel = [_headerView viewWithTag:2000];
         totalDrawLabel.text = [NSString stringWithFormat:@"%0.2f", [_recordHeader.totalDraw doubleValue]];
         UILabel *totalIncomeAmountLabel = [_headerView viewWithTag:3000];
         totalIncomeAmountLabel.text = [NSString stringWithFormat:@"%0.2f", [_recordHeader.totalIncomeAmount doubleValue]];
         
         _pageNo = 1;
         _recordStatus = MoneyRecordStatus_Fillin;
         [self getRecordList];
     }
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)getRecordList
{
    if (_pageNo == 1)
    {
        [_recordList removeAllObjects];
        [_tableView reloadData];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];

    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"type": [NSString stringWithFormat:@"%lu", (unsigned long)_recordStatus], @"start":[NSString stringWithFormat:@"%d", _pageNo], @"count":CountSizeInPageList, @"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Record_GetPersonalMoneyTradeListURL];
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
         
         MoneyRecordReceiveInfo *info = [[MoneyRecordReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
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
         
         if (!_recordList)
         {
             _recordList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_recordList removeAllObjects];
         }
         
         [_recordList addObjectsFromArray:info.data];
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
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         [_recordList removeAllObjects];
         [_tableView reloadData];
         _pageNo = 1;
     }];
}

- (void)selectRecordType:(UIButton *)sender
{
    if (sender == _fillinBtn)
    {
        if (_recordStatus == MoneyRecordStatus_Fillin)
        {
            return;
        }
        
        _recordStatus = MoneyRecordStatus_Fillin;
    }
    if (sender == _cashBtn)
    {
        if (_recordStatus == MoneyRecordStatus_Cash)
        {
            return;
        }
        
        _recordStatus = MoneyRecordStatus_Cash;
    }
    if (sender == _investBtn)
    {
        if (_recordStatus == MoneyRecordStatus_Invest)
        {
            return;
        }
        
        _recordStatus = MoneyRecordStatus_Invest;
    }
    _pageNo = 1;
    [self getRecordList];
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
    return [_recordList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label1 setCenter:CGPointMake(self.view.bounds.size.width/6, 15)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14.f];
    label1.text = @"充值";
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label2 setCenter:CGPointMake(self.view.bounds.size.width/2, 15)];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:14.f];
    label2.text = @"提现";
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 15)];
    [label3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 15)];
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:14.f];
    label3.text = @"投资";
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    
    _fillinBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 40)];
    [_fillinBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_fillinBtn];
    [_fillinBtn addTarget:self action:@selector(selectRecordType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel1.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel1];
    [_hLineLabel1 setHidden:YES];
    
    _cashBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 40)];
    [_cashBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_cashBtn];
    [_cashBtn addTarget:self action:@selector(selectRecordType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel2.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel2];
    [_hLineLabel2 setHidden:YES];
    
    _investBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 39)];
    [_investBtn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_investBtn];
    [_investBtn addTarget:self action:@selector(selectRecordType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel3.backgroundColor = [UIColor redColor];
    [view addSubview:_hLineLabel3];
    [_hLineLabel3 setHidden:YES];
    
    if (_recordStatus == MoneyRecordStatus_Fillin) {
        [_hLineLabel1 setHidden:NO];
    }
    if (_recordStatus == MoneyRecordStatus_Cash) {
        [_hLineLabel2 setHidden:NO];
    }
    if (_recordStatus == MoneyRecordStatus_Invest) {
        [_hLineLabel3 setHidden:NO];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"RecordMoneyListCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    MoneyRecordEntity *record = [_recordList objectAtIndex:indexPath.row];
    
    NSString *nameStr = @"";
    NSString *dateStr = @"";
    
    if (_recordStatus == MoneyRecordStatus_Fillin) {
        nameStr = @"平台充值";
        dateStr = @"充值";
    }
    else if (_recordStatus == MoneyRecordStatus_Cash) {
        nameStr = @"平台提现";
        dateStr = @"提现";
    }
    else if (_recordStatus == MoneyRecordStatus_Invest) {
        nameStr = @"平台投资";
        dateStr = @"投资";
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = nameStr;
    
    
    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:300];
    deadLineLabel.text = [NSString stringWithFormat:@"%@日期：%@", dateStr, record.createDateStr];
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:400];
    amountLabel.text = [NSString stringWithFormat:@"%0.2f元", [record.tradeAmount floatValue]];
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

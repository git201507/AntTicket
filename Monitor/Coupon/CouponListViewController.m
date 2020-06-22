//
//  CouponListViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "CouponListViewController.h"
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

@interface CouponListViewController ()
{
    NSMutableArray *_couponRecordList;
    CouponHeader *_couponHeader;
    int _pageNo;
    CouponStatus _couponStatus;
}

@property (nonatomic, strong) UIButton *unusedBtn;
@property (nonatomic, strong) UIButton *usedBtn;
@property (nonatomic, strong) UIButton *expiredBtn;

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _couponRecordList = [[NSMutableArray alloc] initWithCapacity:0];
    [self setupMJRefresh];
    
    [self getCouponHeaderInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCouponHeaderInfo
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_CouponHeaderInfoURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         CouponHeaderReceiveInfo *info = [[CouponHeaderReceiveInfo alloc] init];
         
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
         
         _couponHeader = info.data;
         _pageNo = 1;
         _couponStatus = COUPONSTATUS_UNUSED;
         [self getCouponUseRecordList:_couponStatus pageNo:_pageNo];
     }
                          failure:^(NSError *error)
     {
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

- (void)getCouponUseRecordList:(int)status pageNo:(int)pageNo
{
    if (_pageNo == 1)
    {
        [_couponRecordList removeAllObjects];
        [_tableView reloadData];
    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    //    status	String	优惠券状态 status 1:未使用 8:已使用 9:已过期
    //    pageNo	String	页码数
    //    pageSize	String	每页记录条数
    //    userId	String	用户memberId
    //    token	String
    
    NSMutableDictionary *params = [@{@"status": [NSString stringWithFormat:@"%d", status], @"pageNo":[NSString stringWithFormat:@"%d", pageNo], @"pageSize":CountSizeInPageList, @"userId":accountInfo.userId, @"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_CouponUseRecordListURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         CouponRecordReceiveInfo *info = [[CouponRecordReceiveInfo alloc] init];
         
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
         
         if (!_couponRecordList)
         {
             _couponRecordList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_couponRecordList removeAllObjects];
         }
         
         [_couponRecordList addObjectsFromArray:info.data.result];
         [_tableView reloadData];
         
         if ([info.data.result count]>0)
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
         [_couponRecordList removeAllObjects];
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
    
    [self getCouponUseRecordList:_couponStatus pageNo:_pageNo];
}

- (void)selectBidType:(UIButton *)sender
{
    if (sender == _unusedBtn)
    {
        _couponStatus = COUPONSTATUS_UNUSED;
    }
    if (sender == _usedBtn)
    {
        _couponStatus = COUPONSTATUS_USED;
    }
    if (sender == _expiredBtn)
    {
        _couponStatus = COUPONSTATUS_EXPIRED;
    }
    _pageNo = 1;
    [self getCouponUseRecordList:_couponStatus pageNo:_pageNo];
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 65;
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
    return [_couponRecordList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIView *selectTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
    [selectTypeView setBackgroundColor:[UIColor redColor]];
    
    UILabel *newFishBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 45.f/2, 13, 90, 15)];
    [newFishBidLabel setCenter:CGPointMake(self.view.bounds.size.width/6, 20)];
    newFishBidLabel.textColor = [UIColor whiteColor];
    newFishBidLabel.font = [UIFont systemFontOfSize:14.f];
    newFishBidLabel.text = @"未使用(元)";
    newFishBidLabel.textAlignment = NSTextAlignmentCenter;
    newFishBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:newFishBidLabel];
    
    UILabel *orderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 45.f/2, 28, 90, 15)];
    [orderLabel1 setCenter:CGPointMake(self.view.bounds.size.width/6, 50)];
    orderLabel1.textColor = [UIColor whiteColor];
    orderLabel1.font = [UIFont systemFontOfSize:14.f];
    orderLabel1.text = [NSString stringWithFormat:@"%0.2f", _couponHeader.unused];
    orderLabel1.textAlignment = NSTextAlignmentCenter;
    orderLabel1.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:orderLabel1];
    
    
    UILabel *optimalBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45.f/2, 13, 90, 15)];
    [optimalBidLabel setCenter:CGPointMake(self.view.bounds.size.width/2, 20)];
    optimalBidLabel.textColor = [UIColor whiteColor];
    optimalBidLabel.font = [UIFont systemFontOfSize:14.f];
    optimalBidLabel.textAlignment = NSTextAlignmentCenter;
    optimalBidLabel.text = @"已使用(元)";
    optimalBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:optimalBidLabel];
    
    UILabel *orderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45.f/2, 28, 90, 15)];
    [orderLabel2 setCenter:CGPointMake(self.view.bounds.size.width/2, 50)];
    orderLabel2.textColor = [UIColor whiteColor];
    orderLabel2.font = [UIFont systemFontOfSize:14.f];
    orderLabel2.textAlignment = NSTextAlignmentCenter;
    orderLabel2.text = [NSString stringWithFormat:@"%0.2f", _couponHeader.hasBeenUsed];
    orderLabel2.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:orderLabel2];
    
    UILabel *vipBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 13, 90, 15)];
    [vipBidLabel setCenter:CGPointMake(self.view.bounds.size.width*5/6, 20)];
    vipBidLabel.textColor = [UIColor whiteColor];
    vipBidLabel.font = [UIFont systemFontOfSize:14.f];
    vipBidLabel.textAlignment = NSTextAlignmentCenter;
    vipBidLabel.text = @"已过期(元)";
    vipBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:vipBidLabel];
    
    UILabel *orderLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 28, 90, 15)];
    [orderLabel3 setCenter:CGPointMake(self.view.bounds.size.width*5/6, 50)];
    orderLabel3.textColor = [UIColor whiteColor];
    orderLabel3.font = [UIFont systemFontOfSize:14.f];
    orderLabel3.textAlignment = NSTextAlignmentCenter;
    orderLabel3.text = [NSString stringWithFormat:@"%0.2f", _couponHeader.outOfDate];
    orderLabel3.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:orderLabel3];
    
    _unusedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 65)];
    [_unusedBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_unusedBtn];
    [_unusedBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _usedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 65)];
    [_usedBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_usedBtn];
    [_usedBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _expiredBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 65)];
    [_expiredBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_expiredBtn];
    [_expiredBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:selectTypeView];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"CouponListCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    CouponEntity *_coupon = [_couponRecordList objectAtIndex:indexPath.row];
    
    UILabel *couponNameLabel = (UILabel *)[cell viewWithTag:100];
    couponNameLabel.text = _coupon.couponName;
    
    UILabel *orderLabel = (UILabel *)[cell viewWithTag:200];
    [orderLabel setHidden:YES];
    
    if ([cell viewWithTag:500])
    {
        [[cell viewWithTag:500] removeFromSuperview];
    }
    
    NSDictionary *options = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f] };
    CGRect boundingRect = [[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1] boundingRectWithSize:CGSizeMake(NSIntegerMax, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:options context:nil];
    
    if(boundingRect.size.width < 20.f)
    {
        boundingRect.size.width = 20.f;
    }
    
    UILabel *orderNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 21, boundingRect.size.width, boundingRect.size.width)];
    orderNameLabel.layer.cornerRadius = orderNameLabel.bounds.size.width/2;
    orderNameLabel.layer.masksToBounds = YES;
    orderNameLabel.layer.borderColor = [UIColor redColor].CGColor;
    orderNameLabel.layer.borderWidth = 1.f;
    orderNameLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    orderNameLabel.textAlignment = NSTextAlignmentCenter;
    orderNameLabel.font = [UIFont systemFontOfSize:14.f];
    orderNameLabel.textColor = [UIColor redColor];
    orderNameLabel.tag = 500;
    [cell addSubview:orderNameLabel];
    
    
    UILabel *deadLineLabel = (UILabel *)[cell viewWithTag:300];
    deadLineLabel.text = [NSString stringWithFormat:@"有效期至:%@",_coupon.deadline];
    
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:400];
    amountLabel.text = [NSString stringWithFormat:@"%0.2f元", _coupon.amount];
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

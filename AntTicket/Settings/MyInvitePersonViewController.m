//
//  MyInvitePersonViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "MyInvitePersonViewController.h"
#import "UITableView+Cell.h"
#import "BasicToastInterFace.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicAccountInterFace.h"
#import "BasicUserDef.h"
#import "LoadingView.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserNet.h"
#import "MJRefresh.h"
#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"

@interface MyInvitePersonViewController ()
{
    NSMutableArray *_invitorList;
    int _pageNo;
}

@end

@implementation MyInvitePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self setupMJRefresh];
    _invitorList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _pageNo = 1;
    [self getInvitorList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destViewController = [segue destinationViewController];
    MessageEntity *msg = (MessageEntity *)sender;
    [destViewController setValue:msg.title forKey:@"titleStr"];
    [destViewController setValue:msg.content forKey:@"content"];
}

- (void)getInvitorList
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    //readStateType
    //pageNo
    //pageSize
    //ownerId
    
    NSMutableDictionary *params = [@{@"start":[NSString stringWithFormat:@"%d", _pageNo], @"count":CountSizeInPageList, @"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Settings_MyInvitorListURL];
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
         
         InvitorListReceiveInfo *info = [[InvitorListReceiveInfo alloc] init];
         
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
         
         if (!_invitorList)
         {
             _invitorList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_invitorList removeAllObjects];
         }
         
         [_invitorList addObjectsFromArray:info.data];
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
         [_invitorList removeAllObjects];
         [_tableView reloadData];
         _pageNo = 1;
     }];
}

- (void)setupMJRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(pullTable)];
    
    self.tableView.footerPullToRefreshText = @"上拉即可刷新";
    self.tableView.footerReleaseToRefreshText = @"松开即可刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}

- (void)pullTable
{
    [self.tableView footerEndRefreshing];
    
    [self getInvitorList];
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    UILabel *upHalfLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 20, 35)];
    
    [upHalfLabel setBackgroundColor:[UIColor colorWithRed:165.f/255.f green:134.f/255.f blue:58.f/255.f  alpha:0.8f]];
    upHalfLabel.textColor = [UIColor whiteColor];
    upHalfLabel.textAlignment = NSTextAlignmentCenter;
    
    float totalSalary = 0.f;
    for (InvitorEntity *invitor in _invitorList)
    {
        totalSalary += [invitor.salary floatValue];
    }
    
    upHalfLabel.text = [NSString stringWithFormat:@"邀请人数：%lu          工资总额：%0.2f", (unsigned long)[_invitorList count], totalSalary];
    
    [view addSubview:upHalfLabel];
    
    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, tableView.frame.size.width - 20, 35)];
    [headerTitleView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UILabel *titlePersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titlePersonLabel setCenter:CGPointMake(tableView.frame.size.width/6, 15)];
    titlePersonLabel.font = [UIFont systemFontOfSize:14];
    titlePersonLabel.text = @"姓名";
    titlePersonLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titlePersonLabel];
    
    UILabel *titleStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titleStatusLabel setCenter:CGPointMake(tableView.frame.size.width/2, 15)];
    titleStatusLabel.font = [UIFont systemFontOfSize:14];
    titleStatusLabel.text = @"产生工资";
    titleStatusLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleStatusLabel];
    
    UILabel *titleTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titleTimeLabel setCenter:CGPointMake(tableView.frame.size.width*5/6, 15)];
    titleTimeLabel.font = [UIFont systemFontOfSize:14];
    titleTimeLabel.text = @"注册时间";
    titleTimeLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleTimeLabel];
    
    [view addSubview:headerTitleView];
    
    return view;
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_invitorList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"InvitorListCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    InvitorEntity *invitor = [_invitorList objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10];
    nameLabel.text = invitor.name;
    
    UILabel *salaryLabel = (UILabel *)[cell viewWithTag:20];
    salaryLabel.text = [invitor.salary stringValue];
    
    UILabel *sendTimeLabel = (UILabel *)[cell viewWithTag:30];
    sendTimeLabel.text = invitor.date;
    
    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    InvitorEntity *invitor = [_invitorList objectAtIndex:indexPath.row];
    //    [self performSegueWithIdentifier:@"showMsgDetail" sender:msg];
}

@end

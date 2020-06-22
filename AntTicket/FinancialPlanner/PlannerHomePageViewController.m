//
//  PlannerHomePageViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "PlannerHomePageViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
#import "MJRefresh.h"
#import "GlobleData.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"

@interface PlannerHomePageViewController ()
{
    NSArray *_nibViews;
    int _pageNo;
    NSMutableArray *_customerList;
    NSMutableArray *_vipSalaryList;
    NSMutableArray *_rankList;
    
    FinancePlannerEntity *_financePlanner;
}

@property (nonatomic, assign) int infoType;

@property (nonatomic, copy) NSString *sumIncome;
@property (nonatomic, copy) NSString *sumInvest;
@property (nonatomic, copy) NSString *sumSalary;
@end

@implementation PlannerHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];    

    [self getFinancePlannerDetail];
    [self getCustomerList];
    [self setupMJRefresh];
    
    UIView *selectTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [selectTypeView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 66.f/2, 6, 66, 15)];
    customerLabel.textColor = [UIColor blackColor];
    customerLabel.font = [UIFont systemFontOfSize:14.f];
    customerLabel.text = @"我的客户";
    customerLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:customerLabel];
    
    UILabel *profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 66.f/2, 6, 66, 15)];
    profitLabel.textColor = [UIColor blackColor];
    profitLabel.font = [UIFont systemFontOfSize:14.f];
    profitLabel.text = @"我的收益";
    profitLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:profitLabel];
    
    UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 6, 66, 15)];
    rankLabel.textColor = [UIColor blackColor];
    rankLabel.font = [UIFont systemFontOfSize:14.f];
    rankLabel.text = @"业绩排名";
    rankLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:rankLabel];

    _customerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 29)];
    [_customerBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_customerBtn];
    [_customerBtn addTarget:self action:@selector(selectInfoType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, self.view.bounds.size.width/3, 1)];
    _hLineLabel1.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel1];
    [_hLineLabel1 setHidden:NO];
    
    _vipSalaryBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 29)];
    [_vipSalaryBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_vipSalaryBtn];
    [_vipSalaryBtn addTarget:self action:@selector(selectInfoType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 29, self.view.bounds.size.width/3, 1)];
    _hLineLabel2.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel2];
    [_hLineLabel2 setHidden:YES];
    
    _rankBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 29)];
    [_rankBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_rankBtn];
    [_rankBtn addTarget:self action:@selector(selectInfoType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 29, self.view.bounds.size.width/3, 1)];
    _hLineLabel3.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel3];
    [_hLineLabel3 setHidden:YES];
    
    [_tableHeaderView addSubview:selectTypeView];
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
    if ([segue.identifier isEqualToString:@"PlannerEdit"])
    {
        id seg = segue.destinationViewController;
        [seg setValue:_adviserIntroductionLabel.text forKey:@"contextStr"];
        return;
    }
    if ([segue.identifier isEqualToString:@"SharePlanner"])
    {
        id seg = segue.destinationViewController;
        NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:_financePlanner.adviserImg];
        NSString *link = [NSString stringWithFormat:@"realname=%@&adviserIntroduction=%@&adviserImg=%@&code=%@", _realNameLabel.text,  _adviserIntroductionLabel.text, urlPath, _loginNameLabel.text];
        [seg setValue:link forKey:@"paramStr"];
        return;
    }

//    if ([segue.identifier isEqualToString:@"Amplified"])
//    {
//        id seg = segue.destinationViewController;
//        
//
//        [seg setValue:sender forKey:@"imgUrlStr"];
//        return;
//    }
}

#pragma mark - 与xib关联的方法
- (IBAction)editPlanner:(id)sender
{
    [self performSegueWithIdentifier:@"PlannerEdit" sender:nil];
}

- (IBAction)sharePlanner:(id)sender
{
//    [self performSegueWithIdentifier:@"SharePlanner" sender:nil];

    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSString *textToShare = [NSString stringWithFormat:@"%@\r\n%@", @"在蚂蚁宜票，提我好使,跟我来蚂蚁宜票理财~", @"投资优选标，额外获得一个点的收益;投资VIP标，有我为你提供一对一的服务~"];
    NSString *linkUrl = [NSString stringWithFormat:@"http://mayi.shunher.com/views/weixin/wxlogin/appShareFinancial.jsp?memberId=%@", accountInfo.userId];
    
    NSArray *activityItems = @[textToShare, [UIImage imageNamed:@"ico_logo"], [NSURL URLWithString:linkUrl]];
    
    _activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        _activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks];
    }
    else
    {
        _activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo];
    }
    
    //给activityVC的属性completionHandler写一个block。
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
    _activityController.completionHandler = ^(NSString *activityType,BOOL completed)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            [BasicToastInterFace showToast:@"分享成功!  "];
        }
        else
        {
            NSLog(@"cancel");
        }
    };
    
    [self presentViewController:_activityController animated:TRUE completion:nil];
}

- (void)selectInfoType:(UIButton *)sender
{
    if (sender == _customerBtn)
    {
        [_hLineLabel1 setHidden:NO];
        [_hLineLabel2 setHidden:YES];
        [_hLineLabel3 setHidden:YES];
        _infoType = 0;
        
        [self getCustomerList];
        [_tableView reloadData];
        return;
    }
    if (sender == _vipSalaryBtn)
    {
        [_hLineLabel1 setHidden:YES];
        [_hLineLabel2 setHidden:NO];
        [_hLineLabel3 setHidden:YES];
        _infoType = 1;

        _pageNo = 1;
        [self getVipSalaryList];
        [_tableView reloadData];
        return;
    }
    if (sender == _rankBtn)
    {
        [_hLineLabel1 setHidden:YES];
        [_hLineLabel2 setHidden:YES];
        [_hLineLabel3 setHidden:NO];
        _infoType = 2;
        
        [self getRankList];
        [_tableView reloadData];
        return;
    }
}

#pragma mark - 自己的方法
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
    
    if(_infoType != 1)
    {
        return;
    }

    [self getVipSalaryList];
}

- (void)getFinancePlannerDetail
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"memberId":accountInfo.userId} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_FinancialIntroductionURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinancePlannerReceiveInfo *info = [[FinancePlannerReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         _financePlanner = info.data;
         
         NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:_financePlanner.adviserImg];
         
         [_adviserImg sd_setImageWithURL:[NSURL URLWithString:urlPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
          {
              NSLog(@"这里可以在图片加载完成之后做些事情");
              if(!_adviserImg.image)
              {
                  _adviserImg.image = [UIImage imageNamed:@"icon_touxiang_lcs"];
              }
          }];
         _adviserIntroductionLabel.text = _financePlanner.adviserIntroduction;
        _realNameLabel.text = _financePlanner.realName;
         _loginNameLabel.text = @"蚂蚁宜票高级理财顾问";
     }
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)getCustomerList
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];

    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_AllMyCustomerURL(accountInfo.userId)];
    [AFNRequestData requestURL:url
                    httpMethod:@"GET"
                        params:nil
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         PlannerCustomerReceiveInfo *info = [[PlannerCustomerReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             [_tableView reloadData];
             return;
         }
         
         _sumIncome = [info.sumIncome stringValue];
         _sumInvest = [info.sumInvest stringValue];
         _sumSalary = [info.sumSalary stringValue];
         _customerList = [[NSMutableArray alloc] initWithArray:info.data];

         [_tableView reloadData];
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         
         [_tableView reloadData];
         //         [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
     }];
}

- (void)getVipSalaryList
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    //    count	String
    //    start	String	页码数
    //    memberId	String
//    FinancePlanner_PageVipSalaryURL
//    FinancePlanner_MyFinancialRankURL
    NSMutableDictionary *params = [@{@"count": @"20", @"start":[NSString stringWithFormat:@"%d", _pageNo], @"memberId":accountInfo.userId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_PageVipSalaryURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         MyPlannerProfitReceiveInfo *info = [[MyPlannerProfitReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             _pageNo = 1;
             [_tableView reloadData];
             return;
         }
         
         if (!_vipSalaryList)
         {
             _vipSalaryList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_vipSalaryList removeAllObjects];
         }
         
         [_vipSalaryList addObjectsFromArray:info.data];
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
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         
         [_tableView reloadData];
         _pageNo = 1;
         //         [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
     }];
}

- (void)getRankList
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_MyFinancialRankURL(accountInfo.userId)];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:nil
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         RankListReceiveInfo *info = [[RankListReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             [_tableView reloadData];
             return;
         }
         
         if (!_rankList)
         {
             _rankList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         
         [_rankList removeAllObjects];
         
         [_rankList addObjectsFromArray:info.data];
         [_tableView reloadData];
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         
         [_tableView reloadData];
         //         [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
     }];
}

#pragma mark - 代理方法
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_infoType == 0)
    {
        return 44;
    }
    if (_infoType == 1)
    {
        return 73;
    }
    if (_infoType == 2)
    {
        RankEntity *rankItem = [_rankList objectAtIndex:indexPath.row];
        
        if (rankItem.type == 1)
        {
            return 88;
        }
        
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (_infoType != 1)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_infoType == 1)
    {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    
    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width - 20, 30)];
    [headerTitleView setBackgroundColor: [UIColor colorWithRed:165.f/255.f green:134.f/255.f blue:58.f/255.f alpha:0.8f]];
    
    UILabel *titlePersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/4, 30)];
    [titlePersonLabel setCenter:CGPointMake(tableView.frame.size.width/8, 15)];
    titlePersonLabel.font = [UIFont systemFontOfSize:14];
    titlePersonLabel.textColor = [UIColor whiteColor];
    titlePersonLabel.text = (_infoType == 0) ? @"姓名" : @"排名";
    titlePersonLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titlePersonLabel];
    
    UILabel *titleStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width/4, 30)];
    [titleStatusLabel setCenter:CGPointMake(tableView.frame.size.width*5/16, 15)];
    titleStatusLabel.font = [UIFont systemFontOfSize:14];
    titleStatusLabel.textColor = [UIColor whiteColor];
    titleStatusLabel.text = (_infoType == 0) ? @"累计投资" : @"姓名";
    titleStatusLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleStatusLabel];
    
    UILabel *titleTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/4, 30)];
    [titleTimeLabel setCenter:CGPointMake(tableView.frame.size.width*8.5/16, 15)];
    titleTimeLabel.font = [UIFont systemFontOfSize:14];
    titleTimeLabel.textColor = [UIColor whiteColor];
    titleTimeLabel.text = (_infoType == 0) ? @"创造工资" : @"近三月拉动";
    titleTimeLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleTimeLabel];
    
    UILabel *titleProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titleProfitLabel setCenter:CGPointMake(tableView.frame.size.width*13/16, 15)];
    titleProfitLabel.font = [UIFont systemFontOfSize:14];
    titleProfitLabel.textColor = [UIColor whiteColor];
    titleProfitLabel.text = (_infoType == 0) ? @"创造收益" : @"赚取工资";
    titleProfitLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleProfitLabel];
    
    [view addSubview:headerTitleView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_infoType == 1)
    {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_infoType == 1)
    {
        return [_vipSalaryList count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_infoType == 0)
    {
        if ([_customerList count] == 0)
        {
            return 1;
        }
        else
        {
            return [_customerList count] + 1;
        }
    }
    if (_infoType == 1)
    {
        return 1;
    }
    if (_infoType == 2)
    {
        return [_rankList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    UITableViewCell *cell = [tableView makeCellByIdentifier:@"BuyingBidCell"];
    _nibViews = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:self options:nil]; //通过这个方法,取得我们的视图
    UITableViewCell *cell;
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    if (_infoType == 2)
    {
        RankEntity *rankItem = [_rankList objectAtIndex:indexPath.row];
        if (rankItem.type == 1)
        {
            if (indexPath.row == 0)
            {
                cell = [_nibViews objectAtIndex:2/*_infoType*/];
            }
            else if (indexPath.row == [_rankList count] - 1)
            {
                cell = [_nibViews objectAtIndex:3/*_infoType*/];
            }
            else
            {
                cell = [_nibViews objectAtIndex:4/*_infoType*/];
            }
        }
        else
        {
            cell = [_nibViews objectAtIndex:1/*_infoType*/];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        UILabel *rankLabel = [cell viewWithTag:10];
        rankLabel.text = [NSString stringWithFormat:@"第%d名", rankItem.rank + 1];
        
        UILabel *nameLabel = [cell viewWithTag:20];
        if (rankItem.type == 1)
        {
            nameLabel.text = (accountInfo.name.length == 0 || !accountInfo.name) ? accountInfo.mobile : accountInfo.name;
            
            UILabel *desLabel = [cell viewWithTag:50];
            desLabel.text = rankItem.name;
        }
        else
        {
            nameLabel.text = rankItem.name;
        }
        
        UILabel *investLabel = [cell viewWithTag:30];
        investLabel.text = rankItem.totalInvest;
        
        UILabel *salaryLabel = [cell viewWithTag:40];
        salaryLabel.text = [NSString stringWithFormat:@"%d", rankItem.totalSalary];
    }
    
    if (_infoType == 0)
    {
        cell = [_nibViews objectAtIndex:1/*_infoType*/];
        
        if ((0 == [_customerList count]))
        {
            UILabel *nameLabel = [cell viewWithTag:10];
            nameLabel.text = @"合计";
            
            UILabel *investLabel = [cell viewWithTag:20];
            investLabel.text = _sumInvest;
            UILabel *salaryLabel = [cell viewWithTag:30];
            salaryLabel.text = _sumSalary;
            UILabel *profitLabel = [cell viewWithTag:40];
            profitLabel.text = _sumIncome;
        }
        else
        {
            if (indexPath.row == [_customerList count])
            {
                UILabel *nameLabel = [cell viewWithTag:10];
                nameLabel.text = @"合计";
                
                UILabel *investLabel = [cell viewWithTag:20];
                investLabel.text = _sumInvest;
                UILabel *salaryLabel = [cell viewWithTag:30];
                salaryLabel.text = _sumSalary;
                UILabel *profitLabel = [cell viewWithTag:40];
                profitLabel.text = _sumIncome;
            }
            else
            {
                PlannerCustomer *customer = [_customerList objectAtIndex:indexPath.row];
                
                UILabel *nameLabel = [cell viewWithTag:10];
                nameLabel.text = customer.realName;
                
                UILabel *investLabel = [cell viewWithTag:20];
                investLabel.text = customer.totalInvest;
                UILabel *salaryLabel = [cell viewWithTag:30];
                salaryLabel.text = customer.totalSalary;
                UILabel *profitLabel = [cell viewWithTag:40];
                profitLabel.text = customer.totalIncome;
            }
        }
    }
    
    if (_infoType == 1)
    {
        cell = [_nibViews objectAtIndex:7];
        
        if ([cell viewWithTag:100])
        {
            [[cell viewWithTag:100] removeFromSuperview];
        }
        
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 10, 25, 25)];
        indexLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.section + 1)];
        indexLabel.textColor = [UIColor redColor];
        indexLabel.font = [UIFont systemFontOfSize:14.f];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.layer.masksToBounds = YES;
        indexLabel.layer.cornerRadius = indexLabel.frame.size.width/2;
        indexLabel.layer.borderWidth = 1.f;
        indexLabel.layer.borderColor = [UIColor redColor].CGColor;
        indexLabel.tag = 100;
        [cell addSubview:indexLabel];
        
        MyPlannerProfit *plannerProfit = [_vipSalaryList objectAtIndex:indexPath.section];
        
        UILabel *nameLabel = [cell viewWithTag:10];
        nameLabel.text = plannerProfit.draftName;
        
        UILabel *salaryLabel = [cell viewWithTag:30];
        salaryLabel.text = [NSString stringWithFormat:@"%@元",[plannerProfit.salary stringValue]];
        UILabel *memberNameLabel = [cell viewWithTag:40];
        memberNameLabel.text = [NSString stringWithFormat:@"工资来源:%@",plannerProfit.memberName]; ;
        UILabel *createDateLabel = [cell viewWithTag:50];
        createDateLabel.text = plannerProfit.createDate;
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

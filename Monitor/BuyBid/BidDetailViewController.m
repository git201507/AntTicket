//
//  BidDetailViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BidDetailViewController.h"
#import "UIColor+Hex.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
#import "MJRefresh.h"
#import "GlobleData.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicViewCellUPDownAdmin.h"

@interface BidDetailViewController ()
{
    NSArray *_nibViews;
    int _pageNo;
    NSMutableArray *_personList;
    FinanceProductDetail *_financeProductDetail;
}

@property (nonatomic, assign) int infoType;
@property (nonatomic, strong) NSNumber *isVIPBid;
@property (nonatomic, strong) UIImageView *verifyImageView;
@property (nonatomic, strong) UITextField *checkTextField;
@property (nonatomic, strong) UIButton *hasTicketBtn;
@property (nonatomic, strong) UILabel *hasTicketLabel;
@property (nonatomic, strong) UILabel *clickChangeLabel;
@property (nonatomic, strong) UIButton *clickChangeBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@end

@implementation BidDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];    

    self.title = [_isVIPBid boolValue] ? @"VIP标的详情" : @"标的详情";
    [self getFinanceProductDetail];
    [self setupMJRefresh];
    
    UIView *selectTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [selectTypeView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *newFishBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6 - 66.f/2, 6, 66, 15)];
    newFishBidLabel.textColor = [UIColor blackColor];
    newFishBidLabel.font = [UIFont systemFontOfSize:14.f];
    newFishBidLabel.text = @"标的奖励";
    if ([_isVIPBid boolValue])
    {
        newFishBidLabel.text = @"投资信息";
    }
    else if ([_isNewsBid boolValue])
    {
        newFishBidLabel.text = @"标的详情";
    }
    newFishBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:newFishBidLabel];
    
    UILabel *optimalBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 66.f/2, 6, 66, 15)];
    optimalBidLabel.textColor = [UIColor blackColor];
    optimalBidLabel.font = [UIFont systemFontOfSize:14.f];
    optimalBidLabel.text = @"汇票信息";
    optimalBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:optimalBidLabel];
    
    
    UILabel *vipBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*5/6 - 66.f/2, 6, 66, 15)];
    vipBidLabel.textColor = [UIColor blackColor];
    vipBidLabel.font = [UIFont systemFontOfSize:14.f];
    vipBidLabel.text =  ![_isVIPBid boolValue] ? @"投标记录" : @"申请记录";
    vipBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:vipBidLabel];
    
    
    _aNewFishBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 29)];
    [_aNewFishBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_aNewFishBidBtn];
    [_aNewFishBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, self.view.bounds.size.width/3, 1)];
    _hLineLabel1.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel1];
    [_hLineLabel1 setHidden:NO];
    
    _optimalBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 29)];
    [_optimalBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_optimalBidBtn];
    [_optimalBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 29, self.view.bounds.size.width/3, 1)];
    _hLineLabel2.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel2];
    [_hLineLabel2 setHidden:YES];
    
    _vipBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 29)];
    [_vipBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_vipBidBtn];
    [_vipBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
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
    if ([segue.identifier isEqualToString:@"BuyBid"])
    {
        id seg = segue.destinationViewController;
        
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        [seg setValue:_financeProduct forKey:@"financeProduct"];
        [seg setValue:_financeProductDetail forKey:@"financeDetail"];
        [seg setValue:accountInfo.userId forKey:@"memberId"];
        [seg setValue:_financeProduct.uid forKey:@"draftId"];
        
        [seg setValue:_isNewsBid forKey:@"isNewsBid"];
        return;
    }
    if ([segue.identifier isEqualToString:@"Amplified"])
    {
        id seg = segue.destinationViewController;
        

        [seg setValue:sender forKey:@"imgUrlStr"];
        return;
    }
}

#pragma mark - 与xib关联的方法
- (void)checkHasTicket:(id)sender
{
    if([_hasTicketBtn.restorationIdentifier isEqualToString:@"icon_hasticketn"])
    {
        [_hasTicketBtn setBackgroundImage:[UIImage imageNamed:@"icon_hasticketh"] forState:UIControlStateNormal];
        _hasTicketBtn.restorationIdentifier = @"icon_hasticketh";
    }
    else
    {
        [_hasTicketBtn setBackgroundImage:[UIImage imageNamed:@"icon_hasticketn"] forState:UIControlStateNormal];
        _hasTicketBtn.restorationIdentifier = @"icon_hasticketn";
    }
}

- (void)buyBid:(id)sender
{
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    if (!accountDetail.ipsAccount || [accountDetail.ipsAccount length] == 0)
    {
        [self performSegueWithIdentifier:@"toCertificate" sender:nil];
        return;
    }
    
    if(![_isVIPBid boolValue])
    {
        
        [self performSegueWithIdentifier:@"BuyBid" sender:nil];
        return;
    }
    
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"memberId": accountInfo.userId} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_GetMyAdviserURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         if(![[respData objectForKey:@"msg"] isEqualToString:@"1"])
         {
             NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"Planner" owner:self options:nil];
             BasicViewCell *protocolView = [nibViews objectAtIndex:6];
             
             UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
             [keywindow addViewCellToManger:protocolView animated:nil];
         }
         else
         {
             [self applyVipBid];
         }
     }
                          failure:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [self applyVipBid];
     }];
}

- (void)applyVipBid
{
//    if ([_checkTextField.text length] == 0)
//    {
//        [BasicToastInterFace showToast:@"验证码不能为空! "];
//        return;
//    }
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"memberId": accountInfo.userId,/* @"verifyCode": _checkTextField.text,*/ @"draftId": _financeProduct.uid, @"adviserId": @"", @"adviserName": @"", @"choice": @"2", @"isTicket": [_hasTicketBtn.restorationIdentifier isEqualToString:@"icon_hasticketn"] ? @"0" : @"1"} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Finance_VerifyVipCodeURL];
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
         if([info.msg isEqualToString:@"重复"])
         {
             [BasicToastInterFace showToast:@"您已经提交过申请!  "];
             return;
         }
         if([info.msg isEqualToString:@"错误"])
         {
             [BasicToastInterFace showToast:@"验证码错误!  "];
             return;
         }
         if([info.msg isEqualToString:@"成功"])
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"http://www.ypbill.com" message:@"申请成功!稍后我们客服会和您联系，请保持电话畅通" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
             [alert show];
         }
     }
                          failure:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)selectBidType:(UIButton *)sender
{
    if (sender == _aNewFishBidBtn)
    {
        [_hLineLabel1 setHidden:NO];
        [_hLineLabel2 setHidden:YES];
        [_hLineLabel3 setHidden:YES];
        _infoType = 0;
        [_tableView reloadData];
        return;
    }
    if (sender == _optimalBidBtn)
    {
        [_hLineLabel1 setHidden:YES];
        [_hLineLabel2 setHidden:NO];
        [_hLineLabel3 setHidden:YES];
        _infoType = 1;
        [_tableView reloadData];
        return;
    }
    if (sender == _vipBidBtn)
    {
        [_hLineLabel1 setHidden:YES];
        [_hLineLabel2 setHidden:YES];
        [_hLineLabel3 setHidden:NO];
        _infoType = 2;
        if (!_personList || [_personList count] == 0)
        {
            [self getPersonList];
        }
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
    
    if(_infoType != 2)
    {
        return;
    }
    
    [self getPersonList];
}

- (void)getFinanceProductDetail
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    //    NSMutableDictionary *params = [@{@"draftId": _financeProduct.uid} mutableCopy];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Finance_ProductDetailURL(_financeProduct.uid, accountInfo.userId)];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:nil succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinanceProductDetailReceiveInfo *info = [[FinanceProductDetailReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         _financeProductDetail = info.data;
         
         _bidNameLabel.text = _financeProductDetail.name;
         
         NSString *tempProfitStr = [NSString stringWithFormat:@"%0.2f",[_financeProductDetail.profit floatValue]];
         unichar n1 = [tempProfitStr characterAtIndex:tempProfitStr.length-2];
         unichar n2 = [tempProfitStr characterAtIndex:tempProfitStr.length-1];
         
         if (n1 == 48 && n2 == 48)
         {
             tempProfitStr = [tempProfitStr substringWithRange:NSMakeRange(0, tempProfitStr.length-3)];
         }
         
         _profitLabel.text = [NSString stringWithFormat:@"%@%%", tempProfitStr];
         _financeDayLabel.text = [NSString stringWithFormat:@"%ld天", [_financeProductDetail.financeDays longValue]];
         
         if ([_isVIPBid boolValue])
         {
             _financeDescriptionLabel.text = [NSString stringWithFormat:@"计划金额：%0.2f元",[_financeProductDetail.minAmount floatValue]];
             NSArray *layoutArray = [_targetView constraints];
             for (int i = 0; i < [layoutArray count]; i++)
             {
                 NSLayoutConstraint *constraint = [layoutArray objectAtIndex:i];
                 if (constraint.firstAttribute == NSLayoutAttributeHeight)
                 {
                     constraint.constant = constraint.constant/2;
                 }
             }
             
             [[_targetView viewWithTag:10] setHidden:YES];
             [[_targetView viewWithTag:20] setHidden:YES];
             [[_targetView viewWithTag:30] setHidden:YES];
             [[_targetView viewWithTag:40] setHidden:YES];
             
             UILabel *targetProfitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 15)];
             targetProfitLabel.font = [UIFont systemFontOfSize:14];
             targetProfitLabel.text = @"预计收益";
             [_targetView addSubview:targetProfitLabel];
             
             UILabel *profitAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 150, 10, 130, 15)];
             profitAmountLabel.font = [UIFont systemFontOfSize:18];
             profitAmountLabel.text = [NSString stringWithFormat:@"%0.2f元", [_financeProduct.expectIncome floatValue]];
             profitAmountLabel.textColor = [UIColor redColor];
             profitAmountLabel.textAlignment = NSTextAlignmentRight;
             [_targetView addSubview:profitAmountLabel];
         }
         else
         {
             _financeDescriptionLabel.text = [NSString stringWithFormat:@"起投金额：%0.2f元",[_financeProductDetail.minAmount floatValue]];
             
             UILabel *surplusLabel = [_targetView viewWithTag:10];
             surplusLabel.text = [NSString stringWithFormat:@"剩余金额%0.2f元", [_financeProductDetail.surplus floatValue]];
             UILabel *financingLabel = [_targetView viewWithTag:20];
             financingLabel.text = [NSString stringWithFormat:@"计划金额%0.2f元", [_financeProductDetail.financing floatValue]];
             
             UIProgressView *progress = [_targetView viewWithTag:30];
             progress.progress = [_financeProductDetail.progress floatValue]/100.f;
             
             UILabel *progressLabel = [_targetView viewWithTag:40];
             progressLabel.text = ([_financeProductDetail.progress integerValue] >= 100) ? @"100%" : [NSString stringWithFormat:@"%0.2f%%",[_financeProductDetail.progress floatValue]];
         }
         [_tableView reloadData];
     }
                          failure:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)getPersonList
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    //    count	String
    //    start	String	页码数
    //    draftId	String
    
    NSMutableDictionary *params = [@{@"count": @"20", @"start":[NSString stringWithFormat:@"%d", _pageNo], @"draftId":_financeProduct.uid} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:![_isVIPBid boolValue] ? Finance_FetchBidderListURL : Finance_FetchVipBidderListURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         FinancePersonReceiveInfo *info = [[FinancePersonReceiveInfo alloc] init];

         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             _pageNo = 1;
             [_tableView reloadData];
             return;
         }
         
         if (!_personList)
         {
             _personList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_personList removeAllObjects];
         }
         
         [_personList addObjectsFromArray:info.data];
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
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         
         [_tableView reloadData];
         _pageNo = 1;
         //         [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
     }];
}

- (void)changeVerifyImage
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];

    NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:@"/common/img/vipCode.jpeg?d=%f&memberId=%@"];
    
    NSString *path = [NSString stringWithFormat:urlPath, [[NSDate date] timeIntervalSince1970], accountInfo.userId];
    
    
    [_verifyImageView sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         NSLog(@"这里可以在图片加载完成之后做些事情");
     }];
}

#pragma mark - 代理方法
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_infoType == 0)
    {
        return 108;
    }
    if (_infoType == 1)
    {
        return 302;
    }
    if (_infoType == 2)
    {
        return 28;
    }
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (_infoType == 2 )
    {
        return 60;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 20, 30)];
    
    [headerTitleLabel setBackgroundColor:[UIColor colorWithRed:165.f/255.f green:134.f/255.f blue:58.f/255.f  alpha:0.8f]];
    headerTitleLabel.textColor = [UIColor blueColor];
    headerTitleLabel.text = @"申购情况";
    headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:headerTitleLabel];
    
    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, tableView.frame.size.width - 20, 30)];
    [headerTitleView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UILabel *titlePersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titlePersonLabel setCenter:CGPointMake(tableView.frame.size.width/6, 15)];
    titlePersonLabel.font = [UIFont systemFontOfSize:14];
    titlePersonLabel.text = [_isVIPBid boolValue] ? @"申请人" : @"投资人";
    titlePersonLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titlePersonLabel];
    
    UILabel *titleStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titleStatusLabel setCenter:CGPointMake(tableView.frame.size.width/2, 15)];
    titleStatusLabel.font = [UIFont systemFontOfSize:14];
    titleStatusLabel.text = [_isVIPBid boolValue] ? @"状态" : @"投资金额";
    titleStatusLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleStatusLabel];
    
    UILabel *titleTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 30)];
    [titleTimeLabel setCenter:CGPointMake(tableView.frame.size.width*5/6, 15)];
    titleTimeLabel.font = [UIFont systemFontOfSize:14];
    titleTimeLabel.text = [_isVIPBid boolValue] ? @"申请时间" : @"投资时间";
    titleTimeLabel.textAlignment = NSTextAlignmentCenter;
    [headerTitleView addSubview:titleTimeLabel];
    
    [view addSubview:headerTitleView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_isVIPBid boolValue])
    {
        return 120;
    }
    else
    {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![_financeProduct.draftState isEqualToString:@"release"])
    {
        return nil;
    }
    if([_financeProduct.progress floatValue] >= 100.f)
    {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    if ([_isVIPBid boolValue])
    {
        if (!_hasTicketBtn)
        {
            _hasTicketBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
            [_hasTicketBtn setBackgroundImage:[UIImage imageNamed:@"icon_hasticketn"] forState:UIControlStateNormal];
            _hasTicketBtn.restorationIdentifier = @"icon_hasticketn";

            [_hasTicketBtn setBackgroundColor:[UIColor redColor]];
            [_hasTicketBtn addTarget:self action:@selector(checkHasTicket:) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:_hasTicketBtn];
        
        if (!_hasTicketLabel)
        {
            _hasTicketLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 10, 100, 15)];
            
            _hasTicketLabel.font = [UIFont systemFontOfSize:14.f];
            _hasTicketLabel.text = @"是否持票";
        }
        [view addSubview:_hasTicketLabel];
        
        if (!_checkTextField)
        {
            _checkTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, 90, 20)];
            _checkTextField.returnKeyType = UIReturnKeyDone;
            [_checkTextField setBackgroundColor:[UIColor whiteColor]];
            _checkTextField.delegate = self;
        }
        [view addSubview:_checkTextField];
        [_checkTextField setHidden:YES];
        
        if (!_verifyImageView)
        {
            _verifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 80, 20)];
            
            AccountInfo *accountInfo = [[AccountInfo alloc] init];
            [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
            NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:@"/common/img/vipCode.jpeg?d=%f&memberId=%@"];
            
            NSString *path = [NSString stringWithFormat:urlPath, [[NSDate date] timeIntervalSince1970], accountInfo.userId];
            
            [_verifyImageView sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 NSLog(@"这里可以在图片加载完成之后做些事情");
             }];
        }
        [view addSubview:_verifyImageView];
        [_verifyImageView setHidden:YES];
        
        if (!_clickChangeLabel)
        {
            _clickChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 30, 100, 20)];
            _clickChangeLabel.font = [UIFont systemFontOfSize:14.f];
            _clickChangeLabel.text = @"点击更换";
        }
        [view addSubview:_clickChangeLabel];
        [_clickChangeLabel setHidden:YES];
        
        if (!_clickChangeBtn)
        {
            _clickChangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 260, 30)];
            [_clickChangeBtn addTarget:self action:@selector(changeVerifyImage) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:_clickChangeBtn];
        [_clickChangeBtn setHidden:YES];
    }
    
    if (_buyBtn)
    {
        [_buyBtn removeFromSuperview];
    }
    _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, [_isVIPBid boolValue] ? 60 : 0, tableView.frame.size.width - 20, 40)];
    [_buyBtn setTitle: [_isVIPBid boolValue] ? ((_financeProductDetail.bidCount == 0) ? @"立即申请" :@"已申请") :@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setEnabled:[_isVIPBid boolValue] ? ((_financeProductDetail.bidCount == 0) ? YES :NO) : YES];
    [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [_buyBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    [_buyBtn setBackgroundColor:[UIColor redColor]];
    [_buyBtn addTarget:self action:@selector(buyBid:) forControlEvents:UIControlEventTouchUpInside];
    _buyBtn.layer.masksToBounds = YES;
    _buyBtn.layer.cornerRadius = 5.f;
    
    [view addSubview:_buyBtn];

    return view;
    
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_infoType == 0)
    {
        return 1;
    }
    if (_infoType == 1)
    {
        return 1;
    }
    if (_infoType == 2)
    {
        return [_personList count];
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    UITableViewCell *cell = [tableView makeCellByIdentifier:@"BuyingBidCell"];
    _nibViews = [[NSBundle mainBundle] loadNibNamed:@"BidDetail" owner:self options:nil]; //通过这个方法,取得我们的视图
    UITableViewCell *cell = [_nibViews objectAtIndex:_infoType];
    
    if (_infoType == 0)
    {
        UILabel *valueDateLabel = [cell viewWithTag:10];
        valueDateLabel.text = [NSString stringWithFormat:@"到期日期%@", _financeProduct.valueDate];
        
        UILabel *ceaseDateLabel = [cell viewWithTag:20];
        ceaseDateLabel.text = [NSString stringWithFormat:@"起息日期%@", _financeProduct.ceaseDate];
        
        UILabel *latestRepaymentDateLabel = [cell viewWithTag:30];
        latestRepaymentDateLabel.text = [NSString stringWithFormat:@"还款日期%@", _financeProduct.latestRepaymentDate];
    }
    else if (_infoType == 1)
    {
        UIImageView *imageView = [cell viewWithTag:10];
        
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:_financeProduct.imgPath];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (!image) {
                 UIImage *newImg = [UIImage imageNamed:@"ico_ticket_example"];
                 [newImg setAccessibilityIdentifier:@"ico_ticket_example"];
                 
                 imageView.image = newImg;
             }
             NSLog(@"这里可以在图片加载完成之后做些事情");
         }];
    }
    else if (_infoType == 2)
    {
        FinancePersonEntity *person = [_personList objectAtIndex:indexPath.row];
        
        UILabel *valueDateLabel = [cell viewWithTag:10];
        valueDateLabel.text = person.name;
        
        UILabel *ceaseDateLabel = [cell viewWithTag:20];
        ceaseDateLabel.text = [_isVIPBid boolValue] ? person.appVersion : [NSString stringWithFormat:@"%d", person.amount];
        
        UILabel *latestRepaymentDateLabel = [cell viewWithTag:30];
        latestRepaymentDateLabel.text = person.timeStr;
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    if (_infoType == 1)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = [cell viewWithTag:10];
        if ([[imageView.image accessibilityIdentifier] isEqualToString:@"ico_ticket_example"])
        {
            [self performSegueWithIdentifier:@"Amplified" sender:@"ico_ticket_example"];
        }
        else
        {
            [self performSegueWithIdentifier:@"Amplified" sender:_financeProduct.imgPath];
        }
    }
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
}

#pragma mark -- UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if(aTextfield.editing)
    {
        [_checkTextField resignFirstResponder];
    }
    return YES;
}

@end

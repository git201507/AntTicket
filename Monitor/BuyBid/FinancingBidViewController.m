//
//  FinancingBidViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "FinancingBidViewController.h"
#import "UITableView+Cell.h"
#import "CircleLoaderView.h"
#import "MJRefresh.h"               // 下拉刷新
#import "BasicUserInterFace.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "LoadingView.h"
#import "BasicToastInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "BasicMessageInterFace.h"
#import "GlobleData.h"
#import "UIColor+Hex.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicViewCellUPDownAdmin.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicMoneyAccountDef.h"

@interface FinancingBidViewController ()
{
@private
    NSString *_couponAmount;
    NSString *_salaryAmount;
    
    NSString *_ipsAccount;
    int _bidType;
    int _pageNo;
    
    NSMutableArray *_productList;
    NSString *_newBidNumberStr;
    NSString *_generalBidNumberStr;
    NSString *_vipBidNumberStr;
    
    FinanceProductDetail *_financeProductSelectedDetail;
}

@property (nonatomic, strong) UIRefreshControl *refresher;
@property (nonatomic, strong) BasicViewCell *instructionBackView;
@end

@implementation FinancingBidViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self setupRefresh];
    
    _productList = [[NSMutableArray alloc] initWithCapacity:0];
    
    //绑定账号切换消息
    [BasicMessageInterFace subMessage:self selector:@selector(accountChange) MessageID:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getFinanceProductNumbers];
    
    _bidType = 1;
    _pageNo = 1;
    [self getFinanceProductList:_bidType pageNo:_pageNo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BidDetail"])
    {
        id seg = segue.destinationViewController;
        
        NSNumber *indexPath = (NSNumber *)sender;
        
        FinanceProductEntity *item = [_productList objectAtIndex:[indexPath intValue]];
        
        [seg setValue:item forKey:@"financeProduct"];
        
        if (_bidType == 2)
        {
            [seg setValue:[NSNumber numberWithBool:YES] forKey:@"isVIPBid"];
        }
        else
        {
            [seg setValue:[NSNumber numberWithBool:NO] forKey:@"isVIPBid"];
        }
        
        if (_bidType == 0)
        {
            [seg setValue:[NSNumber numberWithBool:YES] forKey:@"isNewsBid"];
        }
        else
        {
            [seg setValue:[NSNumber numberWithBool:NO] forKey:@"isNewsBid"];
        }
    }
    if ([segue.identifier isEqualToString:@"buyNow"])
    {
        id seg = segue.destinationViewController;
        
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        UIButton *selectedBtn = (UIButton *)sender;
        
        FinanceProductEntity *item = [_productList objectAtIndex:selectedBtn.tag];
        
        [seg setValue:item forKey:@"financeProduct"];
        [seg setValue:_financeProductSelectedDetail forKey:@"financeDetail"];
        [seg setValue:accountInfo.userId forKey:@"memberId"];
        [seg setValue:item.uid forKey:@"draftId"];
        
        if (_bidType == 0)
        {
            [seg setValue:[NSNumber numberWithBool:YES] forKey:@"isNewsBid"];
        }
        else
        {
            [seg setValue:[NSNumber numberWithBool:NO] forKey:@"isNewsBid"];
        }
    }
}

#pragma mark - 与xib关联的方法
- (void)selectBidType:(UIButton *)sender
{
    if (sender == _aNewFishBidBtn)
    {
        if (_bidType == 0)
        {
            return;
        }
        _bidType = 0;
        _pageNo = 1;
        [self getFinanceProductList:_bidType pageNo:_pageNo];
        return;
    }
    if (sender == _optimalBidBtn)
    {
        if (_bidType == 1)
        {
            return;
        }
        _bidType = 1;
        _pageNo = 1;
        [self getFinanceProductList:_bidType pageNo:_pageNo];
        return;
    }
    if (sender == _vipBidBtn)
    {
        if (_bidType == 2)
        {
            return;
        }
        _bidType = 2;
        _pageNo = 1;
        [self getFinanceProductList:_bidType pageNo:_pageNo];
    }
}

#pragma mark - 自己的方法
- (void)buyNow:(UIButton *)sender
{
    FinanceProductEntity *productItem = [_productList objectAtIndex:sender.tag];
    if ([productItem.progress integerValue] >= 100)
    {
        [self performSegueWithIdentifier:@"BidDetail" sender:[NSNumber numberWithInt:sender.tag]];
        return;
    }
    
    MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
    if (!accountDetail.ipsAccount || [accountDetail.ipsAccount length] == 0)
    {
        [self performSegueWithIdentifier:@"toCertificate" sender:nil];
        return;
    }
    
    [self getFinanceProductDetail:sender];
}

- (void)getFinanceProductDetail:(UIButton *)sender
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    //    NSMutableDictionary *params = [@{@"draftId": _financeProduct.uid} mutableCopy];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    FinanceProductEntity *item = [_productList objectAtIndex:sender.tag];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Finance_ProductDetailURL(item.uid, accountInfo.userId)];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_GET parameters:nil succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinanceProductDetailReceiveInfo *info = [[FinanceProductDetailReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         _financeProductSelectedDetail = info.data;
         [self performSegueWithIdentifier:@"buyNow" sender:sender];
     }
                          failure:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)accountChange
{
    if ([BasicUserInterFace getLogInState] != BASICUSERLONGSTATE_NONE)
    {
        [self getFinanceProductNumbers];
        _pageNo = 1;
        [self getFinanceProductList:_bidType pageNo:_pageNo];
    }
}

- (void)getFinanceProductNumbers
{
    _newBidNumberStr = @"0";
    _generalBidNumberStr = @"0";
    _vipBidNumberStr = @"0";
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Finance_GetNewBidNumberURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:nil succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         VerifyVipCodeReceiveInfo *info = [[VerifyVipCodeReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             return;
         }
         if (!info.msg || info.msg.length < 5)
         {
             return;
         }
         
         _vipBidNumberStr = [info.msg substringWithRange:NSMakeRange(0, 1)];
         _generalBidNumberStr = [info.msg substringWithRange:NSMakeRange(2, 1)];
         _newBidNumberStr = [info.msg substringWithRange:NSMakeRange(4, 1)];
         
         [_tableView reloadData];
     }
         failure:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
     }];
}

- (void)getFinanceProductList:(int)type pageNo:(int)pageNo
{
    if (_pageNo == 1)
    {
        [_productList removeAllObjects];
        [_tableView reloadData];
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    //请求参数
    //    count	String
    //    start	String	页码数
    //    token	String
    NSString *lastUrl = Finance_FetchNewFishProductListURL;
    switch (_bidType)
    {
        case 1:
        {
            lastUrl = Finance_FetchGeneralProductListURL;
            break;
        }
        case 2:
        {
            lastUrl = Finance_FetchVIPProductListURL;
            break;
        }
        default:
        {
            break;
        }
    }
    
    NSMutableDictionary *params = [@{@"count": @"20", @"start":[NSString stringWithFormat:@"%d", pageNo], @"token":accountInfo.token} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:lastUrl];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         FinanceProductReceiveInfo *info = [[FinanceProductReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             _pageNo = 1;
             if([info.msg isEqualToString:@"当前用户登录状态异常!  "])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         
         [_productList addObjectsFromArray:info.data];
         [_tableView reloadData];
         
         //         if (_pageNo == 1)
         //         {
         //            [_tableView scrollRectToVisible:CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height) animated:YES];
         //         }
         
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
             _pageNo = 1;
             return;
         }
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         _pageNo = 1;
         //         [_tableView scrollRectToVisible:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) animated:YES];
     }];
}

- (void)showVIPInstruction:(UIButton *)sender
{
    if (!_instructionBackView)
    {
        _instructionBackView = [[BasicViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_instructionBackView setBackgroundColor:[UIColor clearColor]];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, self.view.bounds.size.height - 240)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, 20)];
        [titleLabel setCenter:CGPointMake(contentView.bounds.size.width/2, 25)];
        titleLabel.text = @"Vip标的优化";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        UIView *hLineView = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + 25, contentView.frame.size.width - 20, 1)];
        [hLineView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [contentView addSubview:hLineView];
        
//        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, hLineView.frame.origin.y + 10, contentView.frame.size.width-20, 200)];
//        
//        contentScrollView.contentSize = CGSizeMake(contentView.frame.size.width-20, 200);
//        contentScrollView.showsHorizontalScrollIndicator = NO;
//
//        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width-20, 400)];
//        
//        contentLabel.numberOfLines = 0;
//        contentLabel.text = @"为什么选VIP标\r\n1）VIP收益高，独享9.6%，10.6%，11.6%收益。\r\n2）可根据您理想的投资额度，投资天数，我们为您选择相应的票源， 您只需填写预购额度就会有客户经理与您联系，为您提供一对一专人服务， 专享通道直接帮您购买成功。同时会在平台VIP标的界面上发布可购买标的，供您选择。\r\n3）购标成功后，签订票据转让协议，直接买断，汇票可带走，可背书， 可银行托收，质押权在手，可以不通过蚂蚁宜票直接在银行行权。\r\n4）亲自审核票据及相关手续票据所有的背书人都有权还款，您可行使背书人一切权益； 等于您借助蚂蚁宜票平台，放债央企国企上市公司，您可以不通过蚂蚁宜票对票据行权。\r\n\r\n购买vip标的好处\r\n1）持票理财.赚取利息\r\n2）购票支付货款，赚取差价\r\n3）大票换小，减少利息支出\r\n\r\n对公账号\r\n账户名：透明(北京)信息咨询有限公司\r\n开户银行：中国民生银行股份有限公司北京昌平支行\r\n开户银行账号：150336538";
//        [contentScrollView addSubview:contentLabel];
//        [contentView addSubview:contentScrollView];
        
        //
        
        NSString *Content = @"为什么选VIP标\r\n1）VIP收益高，独享9.6%，10.6%，11.6%收益。\r\n2）可根据您理想的投资额度，投资天数，我们为您选择相应的票源， 您只需填写预购额度就会有客户经理与您联系，为您提供一对一专人服务， 专享通道直接帮您购买成功。同时会在平台VIP标的界面上发布可购买标的，供您选择。\r\n3）购标成功后，签订票据转让协议，直接买断，汇票可带走，可背书， 可银行托收，质押权在手，可以不通过蚂蚁宜票直接在银行行权。\r\n4）亲自审核票据及相关手续票据所有的背书人都有权还款，您可行使背书人一切权益； 等于您借助蚂蚁宜票平台，放债央企国企上市公司，您可以不通过蚂蚁宜票对票据行权。\r\n\r\n购买vip标的好处\r\n1）持票理财.赚取利息\r\n2）购票支付货款，赚取差价\r\n3）大票换小，减少利息支出\r\n\r\n对公账号\r\n账户名：透明(北京)信息咨询有限公司\r\n开户银行：中国民生银行股份有限公司北京昌平支行\r\n开户银行账号：150336538";
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, hLineView.frame.origin.y + 10, contentView.frame.size.width-20, self.view.bounds.size.height - 350)];
        UILabel *label = [[UILabel alloc] init];
        
        NSDictionary *options = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f] };
        CGRect s = [Content boundingRectWithSize:CGSizeMake(contentView.frame.size.width-20, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:options context:nil];//求文本的大小
        
        label.font =[UIFont systemFontOfSize:14];//不能少这句话，与上边的字大小一致
        label.frame =CGRectMake(0, 0, s.size.width, s.size.height);//这里要计算出label的frame大小，能够完全显示所有字符。
        label.text =Content;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.backgroundColor =[UIColor clearColor];
        scrollView.contentSize = label.frame.size;//这里赋值label的frame大小，以支持滚动浏览。
        [scrollView addSubview:label];

        [contentView addSubview:scrollView];
        //

        UIButton *closeBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width - 70.f, 30)];
        [closeBtn setCenter:CGPointMake(contentView.bounds.size.width/2, contentView.bounds.size.height - 30)];
        [closeBtn setBackgroundColor:[UIColor redColor]];
        [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeInstruction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:closeBtn];
        
        [_instructionBackView addSubview:contentView];
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addViewCellToManger:(BasicViewCell *)_instructionBackView animated:nil];
}
- (void)closeInstruction:(id)sender
{
    [_instructionBackView.viewCellManger popToLastViewCell:nil];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addFooterWithTarget:self action:@selector(pullTable)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.footerPullToRefreshText = @"上拉加载更多..";
    self.tableView.footerReleaseToRefreshText = @"释放加载";
    self.tableView.footerRefreshingText = @"加载中..";
    
    /*
     [self.tableView addHeaderWithTarget:self action:@selector(refreshData) dateKey:@"table"];
     
     // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
     self.tableView.headerPullToRefreshText = @"下拉即可刷新";
     self.tableView.headerReleaseToRefreshText = @"松开即可刷新";
     self.tableView.headerRefreshingText = @"正在刷新";
     */
}

/*
 - (void)refreshData
 {
 [self.tableView headerEndRefreshing];
 _pageNo = 1;
 [self getFinanceProductList:_bidType pageNo:_pageNo];
 }
 */

- (void)pullTable
{
    [self.tableView footerEndRefreshing];
    
    [self getFinanceProductList:_bidType pageNo:_pageNo];
}

#pragma mark - 代理方法
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bidType == 0 || _bidType == 1)
    {
        return 126;
    }
    else
    {
        return 170;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 60;
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
    return [_productList count];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIView *selectTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [selectTypeView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *newFishBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
    [newFishBidLabel setCenter:CGPointMake(self.view.bounds.size.width/6, 20)];
    newFishBidLabel.textColor = [UIColor blackColor];
    newFishBidLabel.font = [UIFont systemFontOfSize:18.f];
    newFishBidLabel.text = @"新手标";
    newFishBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:newFishBidLabel];
    
    if ([_newBidNumberStr intValue]> 0) {
        UILabel *orderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(newFishBidLabel.frame.origin.x + 60, 13, 15, 15)];
        orderLabel1.textColor = [UIColor redColor];
        orderLabel1.font = [UIFont systemFontOfSize:14.f];
        orderLabel1.text = _newBidNumberStr;
        orderLabel1.backgroundColor = [UIColor whiteColor];
        orderLabel1.textAlignment = NSTextAlignmentCenter;
        orderLabel1.layer.masksToBounds = YES;
        orderLabel1.layer.borderColor = [UIColor redColor].CGColor;
        orderLabel1.layer.borderWidth = 1.f;
        orderLabel1.layer.cornerRadius = 7.5f;
        [selectTypeView addSubview:orderLabel1];
    }

    
    UILabel *optimalBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
    [optimalBidLabel setCenter:CGPointMake(self.view.bounds.size.width/2, 20)];
    optimalBidLabel.textColor = [UIColor blackColor];
    optimalBidLabel.font = [UIFont systemFontOfSize:18.f];
    optimalBidLabel.text = @"优选标";
    optimalBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:optimalBidLabel];
    
    if ([_generalBidNumberStr intValue] > 0)
    {
        UILabel *orderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(optimalBidLabel.frame.origin.x + 60, 13, 15, 15)];
        orderLabel2.textColor = [UIColor redColor];
        orderLabel2.font = [UIFont systemFontOfSize:14.f];
        orderLabel2.text = _generalBidNumberStr;
        orderLabel2.backgroundColor = [UIColor whiteColor];
        orderLabel2.textAlignment = NSTextAlignmentCenter;
        orderLabel2.layer.masksToBounds = YES;
        orderLabel2.layer.borderColor = [UIColor redColor].CGColor;
        orderLabel2.layer.borderWidth = 1.f;
        orderLabel2.layer.cornerRadius = 7.5f;
        [selectTypeView addSubview:orderLabel2];
    }
    
    UILabel *vipBidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 15)];
    [vipBidLabel setCenter:CGPointMake(self.view.bounds.size.width*5/6, 20)];
    vipBidLabel.textColor = [UIColor blackColor];
    vipBidLabel.font = [UIFont systemFontOfSize:18.f];
    vipBidLabel.text = @"VIP精选标";
    vipBidLabel.backgroundColor = [UIColor clearColor];
    [selectTypeView addSubview:vipBidLabel];
    
    if ([_vipBidNumberStr intValue] > 0)
    {
        UILabel *orderLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(vipBidLabel.frame.origin.x + 85, 13, 15, 15)];
        orderLabel4.textColor = [UIColor redColor];
        orderLabel4.font = [UIFont systemFontOfSize:14.f];
        orderLabel4.text = _vipBidNumberStr;
        orderLabel4.backgroundColor = [UIColor whiteColor];
        orderLabel4.textAlignment = NSTextAlignmentCenter;
        orderLabel4.layer.masksToBounds = YES;
        orderLabel4.layer.borderColor = [UIColor redColor].CGColor;
        orderLabel4.layer.borderWidth = 1.f;
        orderLabel4.layer.cornerRadius = 7.5f;
        [selectTypeView addSubview:orderLabel4];
    }
    
    _aNewFishBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/3, 40)];
    [_aNewFishBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_aNewFishBidBtn];
    [_aNewFishBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel1.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel1];
    [_hLineLabel1 setHidden:YES];
    
    _optimalBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 40)];
    [_optimalBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_optimalBidBtn];
    [_optimalBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel2.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel2];
    [_hLineLabel2 setHidden:YES];
    
    _vipBidBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3, 40)];
    [_vipBidBtn setBackgroundColor:[UIColor clearColor]];
    [selectTypeView addSubview:_vipBidBtn];
    [_vipBidBtn addTarget:self action:@selector(selectBidType:) forControlEvents:UIControlEventTouchUpInside];
    
    _hLineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*2/3, 39, self.view.bounds.size.width/3, 1)];
    _hLineLabel3.backgroundColor = [UIColor redColor];
    [selectTypeView addSubview:_hLineLabel3];
    [_hLineLabel3 setHidden:YES];
    
    
    [view addSubview:selectTypeView];
    
    UIButton *vipInstructionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 40, 100, 25)];
    [vipInstructionBtn setBackgroundColor:[UIColor redColor]];
    [vipInstructionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vipInstructionBtn setTitle:@"VIP说明" forState:UIControlStateNormal];
    vipInstructionBtn.layer.masksToBounds = YES;
    vipInstructionBtn.layer.cornerRadius = 12.f;
    [vipInstructionBtn addTarget:self action:@selector(showVIPInstruction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:vipInstructionBtn];
    [vipInstructionBtn setHidden:YES];
    
    switch (_bidType)
    {
        case 0:
        {
            [_hLineLabel1 setHidden:NO];
            break;
        }
            break;
        case 1:
        {
            [_hLineLabel2 setHidden:NO];
            break;
        }
        case 2:
        {
            [_hLineLabel3 setHidden:NO];
            [vipInstructionBtn setHidden:NO];
            break;
        }
        default:
        {
            break;
        }
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell;
    
    FinanceProductEntity *item = [_productList objectAtIndex:indexPath.row];
    
    if (_bidType == 0 || _bidType == 1)
    {
        cell = [tableView makeCellByIdentifier:@"BuyingBidCell"];
        
        UILabel *progressLabel = [cell viewWithTag:50];
        progressLabel.text = ([item.progress floatValue] >= 100.f) ? @"已满标\r\n100%" : [NSString stringWithFormat:@"立即购买\r\n%0.2f%%",[item.progress floatValue]];
        
        
        if ([cell viewWithTag:60])
        {
            [[cell viewWithTag:60] removeFromSuperview];
        }
        
        //设置视图大小
        CircleLoaderView *circle=[[CircleLoaderView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 92, 45, 70, 70)];
        //设置轨道颜色
        circle.trackTintColor=[UIColor colorWithRed:165.f/255.f green:134.f/255.f blue:58.f/255.f  alpha:0.8f];
        //设置进度条颜色
        circle.progressTintColor=[UIColor redColor];
        //设置轨道宽度
        circle.lineWidth=3.f;
        //设置进度
        circle.progressValue=[item.progress floatValue]/100.f;
        //设置是否转到 YES进度不用设置
        circle.animationing=NO;
        //添加中间图片  不设置则不显示
        //    circle.centerImage=[UIImage imageNamed:@"yzp_loading"];
        circle.tag = 60;
        //添加视图
        [cell addSubview:circle];
        
        //视图上覆盖按钮
        UIButton *circleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 92, 45, 70, 70)];
        [circleBtn addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
        circleBtn.tag = indexPath.row;
        [cell addSubview:circleBtn];
    }
    else
    {
        cell = [tableView makeCellByIdentifier:@"BuyingVipCell"];
        
        UILabel *applyLabel = [cell viewWithTag:50];
        applyLabel.layer.masksToBounds = YES;
        applyLabel.layer.cornerRadius = 10.f;
        
        UILabel *vipLabel = [cell viewWithTag:60];
        vipLabel.layer.masksToBounds = YES;
        vipLabel.layer.borderWidth = 1.f;
        vipLabel.layer.borderColor = [UIColor redColor].CGColor;
        vipLabel.layer.cornerRadius = 10.f;
    }
    UILabel *nameLabel = [cell viewWithTag:10];
    nameLabel.text = item.name;
    
    NSDictionary *options = @{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f] };
    CGRect boundingRect = [item.name boundingRectWithSize:CGSizeMake(NSIntegerMax, 21) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:options context:nil];
    
    if([cell viewWithTag:100])
    {
        [[cell viewWithTag:100] removeFromSuperview];
    }
    
    if([item.rzCoupon isEqualToString:@"1"] && _bidType == 1)
    {
        UIImageView *prizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + boundingRect.size.width + 10.f, nameLabel.frame.origin.y, 21.f, 21.f)];
        prizeImageView.image = [UIImage imageNamed:@"icon_bid_prize"];

        [prizeImageView setTag:100];
        [cell addSubview:prizeImageView];
    }
    
    UILabel *profitLabel = [cell viewWithTag:20];
    
    NSString *tempProfitStr = [NSString stringWithFormat:@"%0.2f",[item.profit floatValue]];
    unichar n1 = [tempProfitStr characterAtIndex:tempProfitStr.length-2];
    unichar n2 = [tempProfitStr characterAtIndex:tempProfitStr.length-1];

    if (n1 == 48 && n2 == 48)
    {
        tempProfitStr = [tempProfitStr substringWithRange:NSMakeRange(0, tempProfitStr.length-3)];
    }
    
    profitLabel.text = [NSString stringWithFormat:@"%@%%", tempProfitStr];
    
    UILabel *financeAmountLabel = [cell viewWithTag:30];
    financeAmountLabel.text = [NSString stringWithFormat:@"%@元",[item.financing stringValue]];
    
    UILabel *financeDaysLabel = [cell viewWithTag:40];
    
    if (_bidType == 2)
    {
        //        financeDaysLabel.text = [NSString stringWithFormat:@"理财期%d天 到期收益%0.2f元",item.financeDays, [item.expectIncome floatValue]];
        //        
        NSMutableAttributedString *noticeStr1 = [[NSMutableAttributedString alloc] initWithString:@"理财期 "];
        [noticeStr1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, noticeStr1.length)];
        
        NSMutableAttributedString *noticeStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", item.financeDays]];
        [noticeStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, noticeStr2.length)];
        NSMutableAttributedString *noticeStr3 = [[NSMutableAttributedString alloc] initWithString:@" 天 到期收益 "];
        [noticeStr3 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, noticeStr3.length)];
        
        NSMutableAttributedString *noticeStr4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f", [item.expectIncome floatValue]]];
        [noticeStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, noticeStr4.length)];
        
        NSMutableAttributedString *noticeStr5 = [[NSMutableAttributedString alloc] initWithString:@" 元"];
        [noticeStr5 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, noticeStr5.length)];
        
        [noticeStr1 appendAttributedString:noticeStr2];
        [noticeStr1 appendAttributedString:noticeStr3];
        [noticeStr1 appendAttributedString:noticeStr4];
        [noticeStr1 appendAttributedString:noticeStr5];
        financeDaysLabel.attributedText = noticeStr1;
        
        UILabel *buyLabel = [cell viewWithTag:50];
        
//        if ([item.draftState isEqualToString:@"finsh"])

        if([item.progress floatValue] >= 100.f || ![item.draftState isEqualToString:@"release"])
        {
            [buyLabel setBackgroundColor:[UIColor colorWithHexString:@"#acacac"]];
            buyLabel.text = @"已售罄";
        }
        else
        {
            [buyLabel setBackgroundColor:[UIColor redColor]];
            buyLabel.text = @"我要申请";
        }
    }
    else
    {
        financeDaysLabel.text = [NSString stringWithFormat:@"%d天",item.financeDays];
    }
    
    return cell;
}

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //VIP标的详情查看需要实名认证权限校验
    if (_bidType == 2)
    {
        MyAccountDetail *accountDetail = [UserMoneyAccountUpdater fetchUserMoneyAccountDetail];
        if (!accountDetail.ipsAccount || [accountDetail.ipsAccount length] == 0)
        {
            [self performSegueWithIdentifier:@"toCertificate" sender:nil];
            return;
        }
    }
    
    [self performSegueWithIdentifier:@"BidDetail" sender:[NSNumber numberWithInt:indexPath.row]];
}

@end

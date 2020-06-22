//
//  MessageListViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "MessageListViewController.h"
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

@interface MessageListViewController ()
{
    NSMutableArray *_msgList;
    int _pageNo;
}

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self setupMJRefresh];
    _msgList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _pageNo = 1;
    [self getMessageCenterList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destViewController = [segue destinationViewController];
    MessageEntity *msg = (MessageEntity *)sender;
    [destViewController setValue:msg forKey:@"messageEntity"];
}

- (void)getMessageCenterList
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
    
    NSMutableDictionary *params = [@{@"readStateType": @"all", @"pageNo":[NSString stringWithFormat:@"%d", _pageNo], @"pageSize":CountSizeInPageList, @"ownerId":accountInfo.userId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:MessageCenter_FetchMsgListURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         MessageListReceiveInfo *info = [[MessageListReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             _pageNo = 1;
             [_tableView reloadData];
             return;
         }
         
         if (!_msgList)
         {
             _msgList = [[NSMutableArray alloc] initWithCapacity:0];
         }
         
         if (_pageNo == 1)
         {
             [_msgList removeAllObjects];
         }
         
         [_msgList addObjectsFromArray:info.data.result];
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
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         [_msgList removeAllObjects];
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
    
    [self getMessageCenterList];
}

#pragma mark -- UITableViewDataSource
//tableview的高度设定
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//tableview的section设定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_msgList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITableViewCell *cell = [tableView makeCellByIdentifier:@"MessageListCell"];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    MessageEntity *msg = [_msgList objectAtIndex:indexPath.section];
    
    if ([cell viewWithTag:40])
    {
        [[cell viewWithTag:40] removeFromSuperview];
    }
    
    NSDictionary *options = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f] };
    CGRect boundingRect = [[NSString stringWithFormat:@"%ld", (long)indexPath.section + 1] boundingRectWithSize:CGSizeMake(NSIntegerMax, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:options context:nil];
    
    if(boundingRect.size.width < 20.f)
    {
        boundingRect.size.width = 20.f;
    }
    
    UILabel *orderNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 18, boundingRect.size.width, boundingRect.size.width)];
    orderNameLabel.layer.cornerRadius = orderNameLabel.bounds.size.width/2;
    orderNameLabel.layer.masksToBounds = YES;
    orderNameLabel.layer.borderColor = [UIColor redColor].CGColor;
    orderNameLabel.layer.borderWidth = 1.f;
    orderNameLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.section + 1];
    orderNameLabel.textAlignment = NSTextAlignmentCenter;
    orderNameLabel.textColor = [UIColor redColor];
    orderNameLabel.tag = 40;
    orderNameLabel.font = [UIFont systemFontOfSize:14.f];
    [cell addSubview:orderNameLabel];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
    titleLabel.text = msg.title;
    if([msg.readState isEqualToString:@"0"])
    {
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    }
    else
    {
        titleLabel.font = [UIFont systemFontOfSize:18.f];
    }
    
    UILabel *sendTimeLabel = (UILabel *)[cell viewWithTag:20];
    sendTimeLabel.text = msg.sendTime;
    
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:30];
    contentLabel.text = msg.content;

    return cell;
}


#pragma mark -- UITableViewDelegate

//cell的按下操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    MessageEntity *msg = [_msgList objectAtIndex:indexPath.section];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:MessageCenter_ShowMsgDetailURL(msg.msgId)];
    [AFNRequestData requestURL:url
                    httpMethod:@"GET"
                        params:nil
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         MessageListReceiveInfo *info = [[MessageListReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         msg.readState = @"1";
         UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
         UILabel *titleLabel = (UILabel *)[cell viewWithTag:10];
         titleLabel.text = msg.title;

         titleLabel.font = [UIFont systemFontOfSize:18.f];
         
         [self performSegueWithIdentifier:@"showMsgDetail" sender:msg];
     }
                          fail:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
     }];
}

@end

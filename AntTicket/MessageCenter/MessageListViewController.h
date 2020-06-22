//
//  MessageListViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

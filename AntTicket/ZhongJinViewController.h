//
//  ZhongJinViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhongJinViewController : UIViewController

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *ipsAccount;

@property (nonatomic, copy) NSString *draftID;
@property (nonatomic, copy) NSString *gmUserID;

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *identNo;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

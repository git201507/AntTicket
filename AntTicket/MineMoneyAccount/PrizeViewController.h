//
//  PrizeViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrizeViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSNumber *isCommon;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIActivityViewController *activityController;

@end

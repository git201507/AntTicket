//
//  ProductAmplifiedImageViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAmplifiedImageViewController : UIViewController

@property (nonatomic, copy) NSString *imgUrlStr;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


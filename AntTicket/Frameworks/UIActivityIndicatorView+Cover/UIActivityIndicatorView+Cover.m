//
//  UIActivityIndicatorView+Cover.m
//  MedicareButler
//
//  Created by 王 夏阳 on 16/4/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "UIActivityIndicatorView+Cover.h"
#import "BasicDriver.h"
#import "BasicWindowInterFace.h"
#import "UIColor+Hex.h"

@implementation UIActivityIndicatorView (Cover)

- (void)startCoverAnimating
{
    UIView *coverView = [[UIView alloc] init];
    switch ([BasicDriver getPhoneScreenType])
    {
        case PHONESCREEN_4:
        {
            coverView.frame = PhoneRectSize_4;
            break;
        }
        case PHONESCREEN_5:
        {
            coverView.frame = PhoneRectSize_5;
            break;
        }
        case PHONESCREEN_6:
        {
            coverView.frame = PhoneRectSize_6;
            break;
        }
        case PHONESCREEN_6Pluse:
        {
            coverView.frame = PhoneRectSize_6s;
            break;
        }
        default:
        {
            break;
        }
    }
    [coverView setBackgroundColor:[UIColor colorWithHexString:@"686868" alpha:0.9]];
    coverView.tag = 10000;
    
    UIViewController *topCon = [BasicWindowInterFace getCurTopController];
    [topCon.view addSubview:coverView];
    
    [self setCenter:CGPointMake(topCon.view.bounds.size.width/2, topCon.view.bounds.size.height/3)];
    [topCon.view addSubview:self];
    
    [self startAnimating];
}

- (void)stopCoverAnimating
{
    [self stopAnimating];
    [self removeFromSuperview];
    
    UIViewController *topCon = [BasicWindowInterFace getCurTopController];
    [[topCon.view viewWithTag:10000] removeFromSuperview];
}

@end

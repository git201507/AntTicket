//
//  UserMoneyAccountUpdater.h
//  AntTicket
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MyAccountDetail;
@interface UserMoneyAccountUpdater : NSObject
{
@private
    MyAccountDetail *userMoneyAccountDetail;
}
+ (UserMoneyAccountUpdater *)instance;

+ (void)getUserMoneyAccountByToken:(NSString *)token;
+ (MyAccountDetail *)fetchUserMoneyAccountDetail;

@end
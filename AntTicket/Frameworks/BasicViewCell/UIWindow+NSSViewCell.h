//
//  UIWindow+NSSViewCell.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewCellManger.h"

@interface UIWindow (NSSViewCell)

- (BasicViewCellManger *)addViewCellToManger:(BasicViewCell *)ViewCell animated:(Class)NSSViewCellAdminClass;

@end

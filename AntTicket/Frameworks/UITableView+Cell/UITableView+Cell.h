//
//  UITableView+Cell.h
//  MedicareButler
//
//  Created by 王 夏阳 on 16/4/15.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITableView (Cell)
@property(nonatomic, strong) UINib *nib;
- (UITableViewCell *)makeCellByIdentifier: (NSString *)identifier;
- (UITableViewCell *)makeCellByNibName: (NSString *)nibName identifier:(NSString *) identifier;
@end

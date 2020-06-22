//
//  BasicViewCellManger.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicViewCellManger : BasicViewCell <UINavigationControllerDelegate>
{
@private
    __weak BasicViewCell *_rootViewCell;
}
@property (nonatomic, strong) NSArray *viewCells;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, weak) UIView *pushView;
@property (nonatomic, weak) BasicViewCell *rootViewCell;


- (void)pushViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass;
- (void)popToViewCell:(BasicViewCell *)viewCell animated:(Class)BasicViewCellAdminClass;
- (void)popToLastViewCell:(Class)BasicViewCellAdminClass;
- (void)setViewCell:(NSArray *)viewCellArray animated:(Class)BasicViewCellAdminClass;
- (void)popToRootViewCell:(Class)BasicViewCellAdminClass;
//直接返回controll或者window
- (void)popToOriginal:(Class)BasicViewCellAdminClass;

//移除shapView
- (void)removeViewCellShapView:(UIViewController *)viewCon;
//从window迁移到BasicViewCell的迁移到ViewController
- (void)pushWindowViewCellToController:(UIViewController *)viewController admin:(BOOL)admin;
- (void)popControllerToLastWindowViewCell:(BOOL)admin;

@end

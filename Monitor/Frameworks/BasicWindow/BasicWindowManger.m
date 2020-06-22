//
//  BasicWindowManger.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicWindowManger.h"

@implementation BasicWindowManger

+ (BasicWindowManger *) Instance
{
    static BasicWindowManger *obj = nil;
    @synchronized([BasicWindowManger class])
    {
        if (obj == nil)
        {
            obj = [[BasicWindowManger alloc] init];
        }
        
    }
    return obj;
}

- (instancetype)init
{
    id obj = [super init];
    
    if (obj)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:BasicWINDOWLEVEL_END];
        
        for (int i = 0; i < BasicWINDOWLEVEL_END; i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            
            UIWindow *window =  [UIApplication sharedApplication].keyWindow;
            [window addSubview:view];
            [array addObject:view];
        }
        
        _levelArray = [NSArray arrayWithArray:array];
    }
    
    return obj;
}

- (BOOL)addViewToWindow:(UIView *)view level:(BasicWindowLevel)level
{
    BOOL rlt = YES;
    
    UIWindow *window =  [UIApplication sharedApplication].keyWindow;
    
    for (int i = 0; i < BasicWINDOWLEVEL_END; i++)
    {
        if (i == level)
        {
            UIView *levelView = [_levelArray objectAtIndex:i];
            NSInteger num = [window.subviews indexOfObject:levelView];
            if (num != NSNotFound)
            {
                [window insertSubview:view atIndex:num];
            }
            break;
        }
    }
    
    return rlt;
}

- (UIWindow *)getMainWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)getCurTopController
{
    UIWindow *win = [self getMainWindow];
    UINavigationController *rootCon = (UINavigationController *)win.rootViewController;
    UIViewController *topCon = [rootCon topViewController];
    
    return topCon;
}



@end

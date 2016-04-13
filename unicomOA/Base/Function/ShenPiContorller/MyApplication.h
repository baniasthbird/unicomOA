//
//  MyApplication.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//我的申请
@class MyApplication;
@protocol MyApplicationDelegate <NSObject>

-(void)PassArray:(NSMutableArray*)arr__MyApplication;

@end

@interface MyApplication : UIViewController

@property (nonatomic,strong) id<MyApplicationDelegate> delegate;

@end

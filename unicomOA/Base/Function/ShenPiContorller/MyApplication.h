//
//  MyApplication.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

//我的申请
@class MyApplication;
@protocol MyApplicationDelegate <NSObject>

-(void)PassArray:(NSMutableArray*)arr__MyApplication;

@end

@interface MyApplication : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) id<MyApplicationDelegate> delegate;

//提交申请
@property (nonatomic,strong) NSMutableArray *arr_MyApplication;

//筛选结果
@property (nonatomic,strong) NSMutableArray *arr_MySearchResult;

@end

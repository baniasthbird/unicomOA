//
//  PrintApplication.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintService.h"
#import "UserInfo.h"

@class PrintApplication;

@protocol PrintApplicationDelegate <NSObject>

-(void)PassPrintValue:(NSString*)str_title PrintObject:(PrintService*)service;

@end

//复印申请

@interface PrintApplication : UIViewController

//是否包含打印文件
@property BOOL b_hasFile;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,unsafe_unretained) id<PrintApplicationDelegate> delegate;

//复印详情
@property (nonatomic,strong) PrintService *service;

@end

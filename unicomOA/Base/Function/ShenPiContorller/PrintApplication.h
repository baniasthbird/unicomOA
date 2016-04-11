//
//  PrintApplication.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrintApplication;

@protocol PrintApplicationDelegate <NSObject>

-(void)PassPrintValue:(NSString*)str_title;

@end

//复印申请

@interface PrintApplication : UIViewController

//是否包含打印文件
@property BOOL b_hasFile;

//发起人
@property NSString *str_name;

//所在部门
@property NSString *str_department;

//联系电话
@property NSString *str_phonenum;

@property (nonatomic,unsafe_unretained) id<PrintApplicationDelegate> delegate;

@end

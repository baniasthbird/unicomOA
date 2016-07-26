//
//  NewsDisplayViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/3/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "BaseViewController.h"
@import WebKit;

@protocol FocusNewsPassDelegate

-(void)passFocusValue:(NSString*)str_title;

@end

@interface NewsDisplayViewController : BaseViewController

@property BOOL b_News;

@property (strong,nonatomic) NSString *str_label;

@property (strong,nonatomic) NSString *str_depart;

@property (strong,nonatomic) NSString *str_operator;

@property (strong,nonatomic) NSString *str_time;

@property (strong,nonatomic) UILabel *lbl_label;

@property (strong,nonatomic) WKWebView *wb_content;

@property (strong,nonatomic) UILabel *lbl_depart;

@property (assign) NSInteger news_index;

@property (strong,nonatomic) UserInfo *userInfo;

@property (retain,nonatomic) id <FocusNewsPassDelegate> delegate;

@end

//
//  NewsDisplayViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/3/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FocusNewsPassDelegate

-(void)passFocusValue:(NSString*)str_title;

@end

@interface NewsDisplayViewController : UIViewController

@property (strong,nonatomic) NSString *str_label;

@property (strong,nonatomic) NSString *str_depart;

@property (strong,nonatomic) UILabel *lbl_label;

@property (strong,nonatomic) UITextView *txt_content;

@property (strong,nonatomic) UILabel *lbl_depart;

@property (assign) NSInteger *news_index;

@property (retain,nonatomic) id <FocusNewsPassDelegate> delegate;

@end

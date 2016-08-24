//
//  BaseFunction.h
//  unicomOA
//
//  Created by hnsi-03 on 16/7/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFunction : NSObject

-(NSString*)GetValueFromDic:(NSDictionary*)dic_tmp key:(NSString*)str_key;

-(NSString*)GetValueFromArray:(NSArray*)arr_tmp index:(NSInteger)i_index;

#pragma mark 刷新统一管理
-(UIActivityIndicatorView*)AddLoop;

-(CGFloat)cellHeightForNews:(NSInteger)i_index titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont array:(NSMutableArray*)arr_list keywordtitle:(NSString*)str_keywordTitle keywordName:(NSString*)str_keywordName keywordTime:(NSString*)str_keywordTime;

-(NSString*)GetConnectionStatus;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

#pragma 正则匹配手机号
+(BOOL)checkTelNumber:(NSString *) telNumber;

#pragma 正则匹配用户密码6-18位数字和字母组合
+(BOOL)checkPassword:(NSString*)password;



@end

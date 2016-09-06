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

#pragma 正则匹配数字
- (BOOL)validateNumber:(NSString *)textString;

#pragma mark 查找指定字符串出现次数
- (NSInteger)countOccurencesOfString:(NSString*)searchString length:(NSString*)str_orglength;

#pragma mark 查找指定字符串出现的所有位置
-(NSMutableArray*)GetAllSubString:(NSString*)str_origin key:(NSString*)str_key;

@end

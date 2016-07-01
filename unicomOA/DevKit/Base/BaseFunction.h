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

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

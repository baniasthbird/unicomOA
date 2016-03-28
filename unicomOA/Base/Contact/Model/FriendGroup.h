//
//  FriendGroup.h
//  QQ好友列表
//
//  Created by TianGe-ios on 14-8-21.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>

@interface FriendGroup : NSObject

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger online;

@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)friendGroupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

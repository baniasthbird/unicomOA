//
//  CLTreeView_LEVEL0_Model.h
//  CLTreeView
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTreeView_LEVEL0_Model : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *headImgPath;//本地图片名,若不为空则优先于远程图片加载
@property (strong,nonatomic) NSURL *headImgUrl;//远程图片链接
@property (strong,nonatomic) NSString *num;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

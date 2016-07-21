//
//  CLTreeViewNode.h
//  CLTreeView
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTreeViewNode : NSObject

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int type; //节点类型
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点
@property (nonatomic) int tag;      //节点tag
@property (nonatomic) BOOL isStat;    //是否是统计数据

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

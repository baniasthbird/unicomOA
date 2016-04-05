//
//  CLTreeView_LEVEL0_Cell.h
//  这个cell可以作为树形列表的根节点或者第二层节点
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTreeViewNode.h"

@interface CLTreeView_LEVEL0_Cell : UITableViewCell

@property (retain,strong,nonatomic) CLTreeViewNode *node; //data
@property (strong,nonatomic) IBOutlet UIImageView *imgView;
@property (strong,nonatomic) IBOutlet UIImageView *arrowView; //箭头
@property (strong,nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *staffnum;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

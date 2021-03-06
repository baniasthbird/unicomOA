//
//  CLTreeView_LEVEL2_Model.h
//  CLTreeView
//
//  Created by 钟由 on 14-9-9.
//  Copyright (c) 2014年 flywarrior24@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLTreeView_LEVEL2_Model : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *signture;
@property (strong,nonatomic) NSString *headImgPath;//本地图片名,若不为空则优先于远程图片加载
@property (strong,nonatomic) NSURL *headImgUrl;//远程图片链接
@property (strong,nonatomic) NSString *gender;
@property (strong,nonatomic) NSString *department;
@property (strong,nonatomic) NSString *cellphonenum;
@property (strong,nonatomic) NSString *phonenum;
@property (strong,nonatomic) NSString *email;
@property(nonatomic, strong) NSData *icon;//头像图片
@property (strong,nonatomic) NSString *parentlevel;   //父节点等级
//@property (strong,nonatomic) UserImg  *user_Img;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

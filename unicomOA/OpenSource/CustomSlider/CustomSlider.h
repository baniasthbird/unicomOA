//
//  CustomSlider.h
//  自制下载进度条
//
//  Created by 华相强 on 16/4/13.
//  Copyright © 2016年 华相强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSlider : UIView
//自制进度条上面有两个视图，左视图显示下载量，有视图显示未下载的内容。还有一个label显示下载的进度值。再次也设定一个最大值
@property(nonatomic, strong)UIImageView *leftView;
@property(nonatomic, strong)UIImageView *rightView;
@property(nonatomic, strong)UILabel *ValueLabel;
@property(nonatomic, assign)int MaxValue;
-(void)setLeftFrame:(int)tempValue;
@end

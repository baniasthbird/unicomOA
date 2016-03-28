//
//  LogoView.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoView : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*) str_Name withImage:(NSString*) str_img;

@end

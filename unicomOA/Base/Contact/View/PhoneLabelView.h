//
//  PhoneLabelView.h
//  unicomOA
//
//  Created by zr-mac on 16/4/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneLabelView : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withTtile:(NSString*)str_Title withName:(NSString*) str_Name withCallImage:(NSString*) str_callimg withMessageImage:(NSString*)str_messageimg;

@end

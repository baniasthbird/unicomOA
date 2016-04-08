//
//  AddPrintRadioCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioBox.h"
#import "RadioGroup.h"

@interface AddPrintRadioCell : UITableViewCell

/** 快速创建cell的方法*/
+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withSelectedValue:(int)value;

@property (nonatomic,strong) RadioGroup* radioGroup1;

@end

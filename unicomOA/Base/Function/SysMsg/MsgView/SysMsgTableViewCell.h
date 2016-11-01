//
//  SysMsgTableViewCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SysMsgTableViewCell : UITableViewCell



@property (nonatomic,assign) NSInteger myTag;

@property (nonatomic,strong) UILabel *lbl_Title;

@property (nonatomic,strong) UILabel *lbl_Category;
@property (nonatomic,strong) UILabel *lbl_sendName;
@property (nonatomic,strong) UILabel *lbl_time;
/**快速建立cell的方法*/

+(instancetype)cellWithTable:(UITableView*)tableView withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withSendName:(NSString*)str_sendName withTime:(NSString*)str_time titleFont:(NSInteger)i_titleFont otherFont:(NSInteger)i_otherFont;

@end

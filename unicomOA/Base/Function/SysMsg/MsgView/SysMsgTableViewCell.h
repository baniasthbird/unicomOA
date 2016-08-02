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


/**快速建立cell的方法*/

+(instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withSendName:(NSString*)str_sendName titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont;

@end

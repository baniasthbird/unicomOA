//
//  CommentCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/25.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

/**快速创建cell的方法*/
//参数包括tableview,员工姓名，时间，评论内容，员工头像，点赞以及追加评论
+ (instancetype)cellWithTable:(UITableView*)tableView staff:(NSString*)str_name time:(NSString*)str_time content:(NSString*)str_content image:(NSString*)str_image thumbnum:(NSInteger)i_thumb atIndexPath:(NSIndexPath*)indexPath;


//点赞
@property (nonatomic,strong) UIButton *btn_thumb;



@end

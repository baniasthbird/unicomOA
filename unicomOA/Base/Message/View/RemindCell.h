//
//  RemindCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemindCell;
@protocol RemindCellDelegate <NSObject>

-(void)PassNavToShenPi;

@end

@interface RemindCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView*)tableView DocNum:(NSInteger)i_doc_num FlowNum:(NSInteger)i_flow_num MsgNum:(NSInteger)i_msg_num;

@property (nonatomic,strong) id<RemindCellDelegate> delegate;

@end

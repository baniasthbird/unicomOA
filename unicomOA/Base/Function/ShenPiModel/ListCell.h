//
//  ListCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/6/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label withDetailLabel:(NSString*)str_detail_label index:(NSIndexPath*)indexPath listData:(NSArray*)arr_listData mutiSelect:(BOOL)b_Multi;

@end

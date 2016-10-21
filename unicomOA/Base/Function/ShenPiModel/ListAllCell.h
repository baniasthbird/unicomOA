//
//  ListAllCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListAllCell : UITableViewCell

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label withDetailLabel:(NSString*)str_detail_label index:(NSIndexPath*)indexPath;

@end

//
//  SwitchCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>

-(void)PassSwitchValueDelegate:(NSDictionary*)dic_value;

@end

@interface SwitchCell : UITableViewCell

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label index:(NSIndexPath*)indexPath withValue:(NSInteger)i_value;

@property (nonatomic,strong) id<SwitchCellDelegate> delegate;

@property (nonatomic,strong) NSString *str_keyword;

@end

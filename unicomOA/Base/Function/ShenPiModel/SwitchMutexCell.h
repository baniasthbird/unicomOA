//
//  SwitchMutexCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchMutexCellDelegate <NSObject>

-(void)PassSwitchMutexValueDelegate:(NSArray*)arr_value;

@end

@interface SwitchMutexCell : UITableViewCell

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label index:(NSIndexPath*)indexPath withValue:(NSInteger)i_value;

@property (nonatomic,strong) id<SwitchMutexCellDelegate> delegate;

@property (nonatomic,strong) NSString *str_keyword1;

@property (nonatomic,strong) NSString *str_keyword2;

@end

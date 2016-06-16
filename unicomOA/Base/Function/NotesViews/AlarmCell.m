//
//  AlarmCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/6/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AlarmCell.h"

@implementation AlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView cellHeight:(CGFloat)i_cellHeight switch:(BOOL)b_switch indexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    AlarmCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    cell=[[AlarmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:i_cellHeight switch:b_switch];
    
    return  cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight switch:(BOOL)b_switch{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text=@"设置提醒";
        self.imageView.image=[UIImage imageNamed:@"alarm.png"];
        UISwitch *sw_alarm=[[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 15, 50, 50)];
        [sw_alarm setOn:b_switch animated:YES];
        self.accessoryView=sw_alarm;
        
    }
    return self;
}

@end

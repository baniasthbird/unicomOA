//
//  SwitchCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label index:(NSIndexPath*)indexPath withValue:(NSInteger)i_value {
    static NSString *cellID=@"cellID";
    SwitchCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[SwitchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withLabel:str_label withValue:i_value];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabel:(NSString*)str_label  withValue:(NSInteger)i_value
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text=str_label;
        UISwitch *sw_switch= [[UISwitch alloc] initWithFrame:CGRectMake(Width-85.0f, 5.0f, 50.0f, 28.0f)];
        if (i_value==0) {
            [sw_switch setOn:NO];
        }
        else {
            [sw_switch setOn:YES];
        }
        [sw_switch addTarget:self action:@selector(RowEnable:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:sw_switch];
    }
    return self;
}

-(void)RowEnable:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSDictionary *dic_value=[NSDictionary dictionaryWithObjectsAndKeys:_str_keyword,@"label",@"1",@"value", nil];
        [_delegate PassSwitchValueDelegate:dic_value];
    }
    else {
        NSDictionary *dic_value=[NSDictionary dictionaryWithObjectsAndKeys:_str_keyword,@"label",@"0",@"value", nil];
        [_delegate PassSwitchValueDelegate:dic_value];
    }
}

@end

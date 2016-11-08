//
//  SwitchMutexCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SwitchMutexCell.h"

@implementation SwitchMutexCell {
    NSIndexPath *g_IndexPath;
}

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
    SwitchMutexCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[SwitchMutexCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withLabel:str_label withValue:i_value withIndexPath:(NSIndexPath*)indexPath];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabel:(NSString*)str_label  withValue:(NSInteger)i_value withIndexPath:(NSIndexPath*)indexPath {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        g_IndexPath=indexPath;
        self.textLabel.text=str_label;
        UISwitch *sw_switch= [[UISwitch alloc] initWithFrame:CGRectMake(Width-85.0f, 5.0f, 50.0f, 28.0f)];
        if (i_value==0) {
            [sw_switch setOn:NO];
        }
        else {
            [sw_switch setOn:YES];
        }
        [sw_switch addTarget:self action:@selector(RowEnableMutex:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:sw_switch];
    }
    return self;
}

-(void)RowEnableMutex:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
        if (isButtonOn) {
            NSDictionary *dic_value=[NSDictionary dictionaryWithObjectsAndKeys:_str_keyword1,@"keyword1",_str_keyword2,@"keyword2",@"1",@"value", nil];
            NSDictionary *dic_switch=[NSDictionary dictionaryWithObjectsAndKeys:_str_switch_key,@"label",@"1",@"value",g_IndexPath,@"Index",nil];
            [_delegate PassSwitchMutexValueDelegate:dic_value switchmutex:dic_switch];
        }
        else {
          NSDictionary *dic_value=[NSDictionary dictionaryWithObjectsAndKeys:_str_keyword1,@"keyword1",_str_keyword2,@"keyword2",@"0",@"value", nil];
            NSDictionary *dic_switch=[NSDictionary dictionaryWithObjectsAndKeys:_str_switch_key,@"label",@"0",@"value",g_IndexPath,@"Index",nil];
            [_delegate PassSwitchMutexValueDelegate:dic_value switchmutex:dic_switch];
        }
    

    
}



@end

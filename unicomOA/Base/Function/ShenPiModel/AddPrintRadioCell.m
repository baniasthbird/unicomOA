//
//  AddPrintRadioCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AddPrintRadioCell.h"


@interface AddPrintRadioCell()



@end

@implementation AddPrintRadioCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withSelectedValue:(int)value{
    static NSString *cellID=@"cellID";
    AddPrintRadioCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[AddPrintRadioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withSelectedValue:value];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_Name withSelectedValue:(int)value {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_Name;
        
        RadioBox *radio1;
        RadioBox *radio2;
        
        radio1=[[RadioBox alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
        radio2=[[RadioBox alloc]initWithFrame:CGRectMake(100,10 , 100, 30)];
        
        radio1.text=@"是";
        radio2.text=@"否";
        
        radio1.value=0;
        radio2.value=1;
        
        NSArray *controls=[NSArray arrayWithObjects:radio1,radio2, nil];
        
        
        
        if (iPhone4_4s || iPhone5_5s || iPhone6) {
           _radioGroup1 =[[RadioGroup alloc]initWithFrame:CGRectMake(108, 0, 160, 30) WithControl:controls];
        }
        else if (iPhone6_plus) {
            _radioGroup1 =[[RadioGroup alloc]initWithFrame:CGRectMake(113, 0, 160, 30) WithControl:controls];
        }
        
        [_radioGroup1 addSubview:radio1];
        [_radioGroup1 addSubview:radio2];
        
        _radioGroup1.backgroundColor=[UIColor clearColor];
        _radioGroup1.textFont=[UIFont systemFontOfSize:14];
        _radioGroup1.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];;
        _radioGroup1.selectValue=value;
        
        [self.contentView addSubview:_radioGroup1];
    }
    return  self;
}

@end

//
//  MyShenPi.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyShenPi.h"

@implementation MyShenPi

-(void)awakeFromNib {
    [super awakeFromNib];
}


//类型，状态，标题，时间
+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withStatus:(NSString *)str_status isUsingCar:(BOOL)b_Category withTime:(NSString*)str_time{
    static NSString *cellID=@"cellID";
    MyShenPi *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MyShenPi alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isUsingCar:b_Category withTitle:str_Title withStatus:str_status withTime:str_time];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isUsingCar:(BOOL)b_Category withTitle:(NSString*)str_Title withStatus:(NSString *)str_status withTime:(NSString *)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 80, 18)];
        UILabel *lbl_status=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.85, 2, self.frame.size.width*0.15, 18)];
        UIView *view_seperator=[[UIView alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width, 1)];
        view_seperator.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        if (b_Category==YES) {
            lbl_category.text=@"预约用车";
        }
        else {
            lbl_category.text=@"复印";
        }
        lbl_status.text=@"审批中";
        lbl_category.textColor=[UIColor blackColor];
        lbl_category.font=[UIFont systemFontOfSize:13];
        lbl_category.textAlignment=NSTextAlignmentCenter;
        lbl_status.textColor=[UIColor colorWithRed:247/255.0f green:153/255.0f blue:4/255.0f alpha:1];
        lbl_status.font=[UIFont systemFontOfSize:13];
        lbl_status.textAlignment=NSTextAlignmentCenter;

        
        UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.frame.size.width, 40)];
        lbl_title.textColor=[UIColor blackColor];
        lbl_title.textAlignment=NSTextAlignmentLeft;
        lbl_title.font=[UIFont systemFontOfSize:13];
        lbl_title.text=str_Title;
        
        
        UILabel *lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, self.frame.size.width, 20)];
        lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        lbl_time.font=[UIFont systemFontOfSize:13];
        lbl_time.textAlignment=NSTextAlignmentLeft;
        lbl_time.text=str_time;
        
        [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:lbl_status];
        [self.contentView addSubview:lbl_title];
        [self.contentView addSubview:lbl_time];
        
        
    }
    return self;
}


@end

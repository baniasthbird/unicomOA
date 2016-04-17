//
//  MyShenPi.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyApplicationCell.h"

@implementation MyApplicationCell

-(void)awakeFromNib {
    [super awakeFromNib];
}


//类型，状态，标题，时间
+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withStatus:(NSString *)str_status isUsingCar:(BOOL)b_Category withTime:(NSString*)str_time{
    static NSString *cellID=@"cellID";
    MyApplicationCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
   // if (!cell) {
        cell=[[MyApplicationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isUsingCar:b_Category withTitle:str_Title withStatus:str_status withTime:str_time];
    //}
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isUsingCar:(BOOL)b_Category withTitle:(NSString*)str_Title withStatus:(NSString *)str_status withTime:(NSString *)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 80, 18)];
        UILabel *lbl_status=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_status setFrame:CGRectMake(260, 2, 50, 18)];
        }
        else if (iPhone6) {
            [lbl_status setFrame:CGRectMake(280, 2, 50, 18)];
        }
        else {
            [lbl_status setFrame:CGRectMake(300, 2, 50, 18)];
        }
        UIView *view_seperator=[[UIView alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
             [view_seperator setFrame:CGRectMake(0, 20, 320, 1)];
        }
        else if (iPhone6){
            [view_seperator setFrame:CGRectMake(0, 20, 375, 1)];
        }
        else {
            [view_seperator setFrame:CGRectMake(0, 20, 414, 1)];
        }
       
        view_seperator.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        //view_seperator.backgroundColor=[UIColor blackColor];
        if (b_Category==YES) {
            lbl_category.text=@"预约用车";
        }
        else {
            lbl_category.text=@"复印";
        }
        lbl_status.text=str_status;
        lbl_category.textColor=[UIColor blackColor];
        lbl_category.font=[UIFont systemFontOfSize:13];
        lbl_category.textAlignment=NSTextAlignmentCenter;
        
        
        lbl_status.font=[UIFont systemFontOfSize:13];
        lbl_status.textAlignment=NSTextAlignmentCenter;
        if ([lbl_status.text isEqualToString:@"同意"]) {
            lbl_status.textColor=[UIColor colorWithRed:103/255.0f green:204/255.0f blue:0 alpha:1];
        }
        else if ([lbl_status.text isEqualToString:@"不同意"]) {
            lbl_status.textColor=[UIColor colorWithRed:226/255.0f green:19/255.0f blue:20/255.0f alpha:1];
        }
        else {
            lbl_status.textColor=[UIColor colorWithRed:247/255.0f green:153/255.0f blue:4/255.0f alpha:1];
        }
        

        
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
        [self.contentView addSubview:view_seperator];
        
        
    }
    return self;
}


@end

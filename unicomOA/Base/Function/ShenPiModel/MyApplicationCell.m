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
        UILabel *lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(5, 11, 80, 18)];
        lbl_category.textAlignment=NSTextAlignmentLeft;
        UILabel *lbl_status=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_status setFrame:CGRectMake(270, 11, 50, 18)];
        }
        else if (iPhone6) {
            [lbl_status setFrame:CGRectMake(325, 11, 50, 18)];
        }
        else {
            [lbl_status setFrame:CGRectMake(364, 11, 50, 18)];
        }
        UIView *view_seperator=[[UIView alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
             [view_seperator setFrame:CGRectMake(70, 20, 180, 1)];
        }
        else if (iPhone6){
            [view_seperator setFrame:CGRectMake(70, 20, 235, 1)];
        }
        else {
            [view_seperator setFrame:CGRectMake(70, 20, 274, 1)];
        }
       
        view_seperator.backgroundColor=[UIColor whiteColor];
        
        UIView *view_bg=[[UIView alloc]init];
        
        if (iPhone5_5s || iPhone4_4s) {
            [view_bg setFrame:CGRectMake(0, 0, 320, 40)];
            
        }
        else if (iPhone6){
            [view_bg setFrame:CGRectMake(0, 0, 375, 40)];
        }
        else {
            [view_bg setFrame:CGRectMake(0, 0, 414, 40)];
        }
        
        
        //view_seperator.backgroundColor=[UIColor blackColor];
        if (b_Category==YES) {
            lbl_category.text=@"预约用车";
        }
        else {
            lbl_category.text=@"复印";
        }
        lbl_status.text=str_status;
        lbl_category.textColor=[UIColor whiteColor];
        lbl_category.font=[UIFont systemFontOfSize:15];
        
        
        lbl_status.font=[UIFont systemFontOfSize:15];
        lbl_status.textAlignment=NSTextAlignmentLeft;
        lbl_status.textColor=[UIColor whiteColor];
        if ([lbl_status.text isEqualToString:@"已办"]) {
            view_bg.backgroundColor=[UIColor colorWithRed:61/255.0f green:189/255.0f blue:143/255.0f alpha:1];
        }
        else if ([lbl_status.text isEqualToString:@"待办"]) {
            view_bg.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
        }
        else {
            view_bg.backgroundColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1];
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
        
        [self.contentView addSubview:view_bg];
        [self.contentView sendSubviewToBack:view_bg];
        [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:lbl_status];
        [self.contentView addSubview:lbl_title];
        [self.contentView addSubview:lbl_time];
        [self.contentView addSubview:view_seperator];
        
        
        
    }
    return self;
}


@end

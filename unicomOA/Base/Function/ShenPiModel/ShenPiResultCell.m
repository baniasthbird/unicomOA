//
//  ShenPiResultCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiResultCell.h"

@interface ShenPiResultCell()

@end

@implementation ShenPiResultCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withImage:(NSString *)str_Image withName:(NSString *)str_Name withStatus:(NSString *)str_status withTime:(NSString *)str_time ActivityName:(NSString *)str_activename  atIndex:(NSIndexPath*)indexPath{
    static NSString *cellID=@"cellID";
    ShenPiResultCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
       // cell=[ShenPiResultCell cellWithTable:tableView withImage:str_Image withName:str_Name withStatus:str_status withTime:str_time];
        cell=[[ShenPiResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withStatus:str_status      ActivityName:(NSString*)str_activename withTime:str_time];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  withName:(NSString*)str_Name withStatus:(NSString*)str_status ActivityName:(NSString*)str_activename withTime:(NSString*)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lbl_bg=[[UILabel alloc]init];
        [lbl_bg setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        /*
        if (iPhone5_5s || iPhone4_4s) {
            [lbl_bg setFrame:CGRectMake(0, 0, 320, 30)];
        }
        else if (iPhone6) {
            [lbl_bg setFrame:CGRectMake(0, 0, 375, 30)];
        }
        else {
            [lbl_bg setFrame:CGRectMake(0, 0, 414, 30)];
        }
        */
        lbl_bg.textAlignment=NSTextAlignmentCenter;
        lbl_bg.font=[UIFont systemFontOfSize:16];
        lbl_bg.textColor=[UIColor whiteColor];
        lbl_bg.text=@"审核结果";
        //同意
        if ([str_status isEqualToString:@"1"]) {
            lbl_bg.backgroundColor=[UIColor colorWithRed:61/255.0f green:189/255.0f blue:143/255.0f alpha:1];
        }
        //退回
        else if ([str_status isEqualToString:@"2"]) {
            lbl_bg.backgroundColor=[UIColor colorWithRed:247/255.0f green:35/255.0f blue:0/255.0f alpha:1];
        }
        //暂存
        else if ([str_status isEqualToString:@"0"]) {
            lbl_bg.backgroundColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1];
        }
        //废弃
        else if ([str_status isEqualToString:@"3"]) {
            lbl_bg.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
        }
        
        
        UILabel *lbl_name=[[UILabel alloc]init];
        UILabel *lbl_active=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_name setFrame:CGRectMake(20, 40, 80, 30)];
            [lbl_active setFrame:CGRectMake(20, 70, 80, 30)];
        }
        else if (iPhone6) {
            [lbl_name setFrame:CGRectMake(30, 40, 80, 30)];
            [lbl_active setFrame:CGRectMake(30, 70, 80, 30)];
        }
        else {
            [lbl_name setFrame:CGRectMake(40, 40, 80, 30)];
            [lbl_active setFrame:CGRectMake(40, 70, 80, 30)];
        }
        
        lbl_name.textColor=[UIColor blackColor];
        lbl_name.textAlignment=NSTextAlignmentCenter;
        lbl_name.font=[UIFont systemFontOfSize:16];
        lbl_name.text=str_Name;
        
        lbl_active.textColor=[UIColor blackColor];
        lbl_active.textAlignment=NSTextAlignmentCenter;
        lbl_active.font=[UIFont systemFontOfSize:12];
        lbl_active.text=str_activename;
        lbl_active.numberOfLines=0;
        
        _lbl_time=[[UILabel alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
            [_lbl_time setFrame:CGRectMake(100, 40, 100, 60)];
        }
        else if (iPhone6) {
            [_lbl_time setFrame:CGRectMake(130, 40, 115, 60)];
        }
        else {
            [_lbl_time setFrame:CGRectMake(140, 40, 134, 60)];
        }
        
        
        _lbl_time.text=str_time;
        _lbl_time.textAlignment=NSTextAlignmentCenter;
        _lbl_time.font=[UIFont systemFontOfSize:16];
        _lbl_time.numberOfLines=0;
        _lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        
        _lbl_status=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [_lbl_status setFrame:CGRectMake(220, 40, 60, 60)];
        }
        else if (iPhone6) {
            [_lbl_status setFrame:CGRectMake(280, 40, 60, 60)];
        }
        else {
            [_lbl_status setFrame:CGRectMake(320, 40, 60, 60)];
        }
        
        if ([str_status isEqualToString:@"1"]) {
            _lbl_status.text=@"同意";
        }
        else if ([str_status isEqualToString:@"2"]) {
            _lbl_status.text=@"退回";
        }
        else if ([str_status isEqualToString:@"3"]) {
            _lbl_status.text=@"废弃";
        }
        else if ([str_status isEqualToString:@"0"]) {
            _lbl_status.text=@"暂存";
        }
        _lbl_status.textAlignment=NSTextAlignmentCenter;
        _lbl_status.font=[UIFont systemFontOfSize:16];
        if ([_lbl_status.text isEqualToString:@"同意"]) {
            _lbl_status.textColor=[UIColor colorWithRed:61/255.0f green:189/255.0f blue:143/255.0f alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"审批中"]) {
            _lbl_status.textColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"不同意"]) {
            _lbl_status.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
        }
        
        self.contentView.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];

        [self.contentView addSubview:lbl_bg];
        [self.contentView sendSubviewToBack:lbl_bg];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:lbl_active];
        [self.contentView addSubview:_lbl_status];
        [self.contentView addSubview:_lbl_time];
    }
    return self;
}


@end

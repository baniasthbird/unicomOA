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

+(instancetype)cellWithTable:(UITableView *)tableView withImage:(NSString *)str_Image withName:(NSString *)str_Name withStatus:(NSString *)str_status withTime:(NSString *)str_time atIndex:(NSIndexPath*)indexPath{
    static NSString *cellID=@"cellID";
    ShenPiResultCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
       // cell=[ShenPiResultCell cellWithTable:tableView withImage:str_Image withName:str_Name withStatus:str_status withTime:str_time];
        cell=[[ShenPiResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withImage:str_Image withName:str_Name withStatus:str_status withTime:str_time];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImage:(NSString*)str_Image withName:(NSString*)str_Name withStatus:(NSString*)str_status withTime:(NSString*)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img_Logo=[[UIImageView alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
            [img_Logo setFrame:CGRectMake(20, 20, 60, 60)];
        }
        else if (iPhone6) {
            [img_Logo setFrame:CGRectMake(40, 20, 60, 60)];
        }
        else {
            [img_Logo setFrame:CGRectMake(50, 20, 60, 60)];
        }
        
        img_Logo.image=[UIImage imageNamed:str_Image];
        
        UILabel *lbl_name=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_name setFrame:CGRectMake(90, 20, 40, 60)];
        }
        else if (iPhone6) {
            [lbl_name setFrame:CGRectMake(110, 20, 40, 60)];
        }
        else {
            [lbl_name setFrame:CGRectMake(120, 20, 40, 60)];
        }
        
        lbl_name.textColor=[UIColor blackColor];
        lbl_name.textAlignment=NSTextAlignmentCenter;
        lbl_name.font=[UIFont systemFontOfSize:13];
        lbl_name.text=str_Name;
        
        _lbl_status=[[UILabel alloc]init];
        if (iPhone4_4s || iPhone5_5s) {
            [_lbl_status setFrame:CGRectMake(140, 20, 40, 60)];
        }
        else if (iPhone6) {
            [_lbl_status setFrame:CGRectMake(160, 20, 40, 60)];
        }
        else {
            [_lbl_status setFrame:CGRectMake(170, 20, 40, 60)];
        }
        
        _lbl_status.text=str_status;
        _lbl_status.textAlignment=NSTextAlignmentCenter;
        _lbl_status.font=[UIFont systemFontOfSize:13];
        if ([_lbl_status.text isEqualToString:@"同意"]) {
            _lbl_status.textColor=[UIColor colorWithRed:103/255.0f green:204/255.0f blue:0 alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"审批中"]) {
            _lbl_status.textColor=[UIColor colorWithRed:251/255.0f green:151/255.0f blue:0 alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"不同意"]) {
            _lbl_status.textColor=[UIColor colorWithRed:226/255.0f green:19/255.0f blue:20/255.0f alpha:1];
        }
        
        _lbl_time=[[UILabel alloc]init];
        if (iPhone5_5s || iPhone4_4s) {
            [_lbl_time setFrame:CGRectMake(220, 20, 80, 60)];
        }
        else if (iPhone6) {
            [_lbl_time setFrame:CGRectMake(250, 20, 80, 60)];
        }
        else {
            [_lbl_time setFrame:CGRectMake(280, 20, 80, 60)];
        }
        
        
        _lbl_time.text=str_time;
        _lbl_time.textAlignment=NSTextAlignmentCenter;
        _lbl_time.font=[UIFont systemFontOfSize:13];
        _lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];

        [self.contentView addSubview:img_Logo];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:_lbl_status];
        [self.contentView addSubview:_lbl_time];
    }
    return self;
}

@end

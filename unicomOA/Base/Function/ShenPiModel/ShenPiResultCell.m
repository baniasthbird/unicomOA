//
//  ShenPiResultCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiResultCell.h"
#import "LogTriangleView.h"

@interface ShenPiResultCell()

@end

@implementation ShenPiResultCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withContent:str_Content withName:(NSString *)str_Name withStatus:(NSString *)str_status withTime:(NSString *)str_time ActivityName:(NSString *)str_activename atIndex:(NSIndexPath *)indexPath withCellHeight:(CGFloat)i_Height{
    static NSString *cellID=@"cellID";
    ShenPiResultCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        // cell=[ShenPiResultCell cellWithTable:tableView withImage:str_Image withName:str_Name withStatus:str_status withTime:str_time];
        cell=[[ShenPiResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withContent:str_Content withName:str_Name withStatus:str_status  ActivityName:(NSString*)str_activename withTime:str_time withCellHeight:(CGFloat)i_Height];
    }
    return cell;
}




-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withContent:str_Content withName:(NSString*)str_Name withStatus:(NSString*)str_status ActivityName:(NSString*)str_activename withTime:(NSString*)str_time withCellHeight:(CGFloat)i_Height{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self) {
        UILabel *lbl_name=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.05+50, 5, [UIScreen mainScreen].bounds.size.width*0.4, 20)];
        lbl_name.textColor=[UIColor colorWithRed:94/255.0f green:145/255.0f blue:172/255.0f alpha:1];
        lbl_name.font=[UIFont systemFontOfSize:16];
        lbl_name.textAlignment=NSTextAlignmentLeft;
        lbl_name.text=str_Name;
        [lbl_name sizeToFit];
        
        UILabel *lbl_time=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.5, i_Height-20, [UIScreen mainScreen].bounds.size.width*0.45, 10)];
        lbl_time.textColor=[UIColor colorWithRed:177/255.0f green:177/255.0f blue:177/255.0f alpha:1];
        lbl_time.font=[UIFont systemFontOfSize:14];
        lbl_time.textAlignment=NSTextAlignmentRight;
        lbl_time.text=str_time;
        //[lbl_time sizeToFit];
        
        UILabel *lbl_info=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.5, 5, [UIScreen mainScreen].bounds.size.width*0.45, 20)];
        lbl_info.textColor=[UIColor colorWithRed:94/255.0f green:145/255.0f blue:172/255.0f alpha:1];
        lbl_info.font=[UIFont systemFontOfSize:16];
        lbl_info.numberOfLines=1;
        lbl_info.textAlignment=NSTextAlignmentRight;
        NSString *str_info=str_activename;
        lbl_info.text=str_info;
       // [lbl_info sizeToFit];
        
        UILabel *lbl_content=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.05+50, 25, [UIScreen mainScreen].bounds.size.width*0.9-100, i_Height-55)];
        lbl_content.textColor=[UIColor blackColor];
        lbl_content.text=str_Content;
        lbl_content.textAlignment=NSTextAlignmentLeft;
        lbl_content.font=[UIFont systemFontOfSize:16];
        
        CGFloat i_left=80;
        if (iPhone5_5s) {
            i_left=50;
        }
        
        LogTriangleView *logView=[[LogTriangleView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        logView.backgroundColor=[UIColor whiteColor];
        logView.str_decision=str_status;
        
    //    UILabel *lbl_decision=[[UILabel alloc]initWithFrame:CGRectMake(8, -32,[UIScreen mainScreen].bounds.size.width*0.3, 30)];
        UILabel *lbl_decision=[[UILabel alloc]init];
        if (iPhone6_plus) {
            [lbl_decision setFrame:CGRectMake(8, -37,[UIScreen mainScreen].bounds.size.width*0.3, 30)];
        }
        else if (iPhone6) {
            [lbl_decision setFrame:CGRectMake(6, -32,[UIScreen mainScreen].bounds.size.width*0.3, 30)];
        }
        else if (iPhone5_5s) {
            [lbl_decision setFrame:CGRectMake(8, -27,[UIScreen mainScreen].bounds.size.width*0.3, 30)];
        }
        else if (iPad) {
            [lbl_decision setFrame:CGRectMake(18, -75,[UIScreen mainScreen].bounds.size.width*0.3, 30)];
        }
        
        lbl_decision.textColor=[UIColor whiteColor];
        lbl_decision.textAlignment=NSTextAlignmentLeft;
        lbl_decision.font=[UIFont systemFontOfSize:12];
        lbl_decision.transform=CGAffineTransformMakeRotation(-M_PI/4);
        NSInteger i_status=[str_status integerValue];
        if (i_status==1 || i_status>3) {
          //  lbl_decision.backgroundColor=[UIColor colorWithRed:61/255.0f green:189/255.0f blue:143/255.0f alpha:1];
            lbl_decision.text=@"同意";
            
        }
        else if (i_status==2) {
        //    lbl_decision.backgroundColor=[UIColor colorWithRed:247/255.0f green:35/255.0f blue:0/255.0f alpha:1];
            lbl_decision.text=@"退回";
        }
        
        else if (i_status==3) {
        //    lbl_decision.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
                lbl_decision.text=@"废弃";
        }
        
        else if (i_status==0) {
       //     lbl_decision.backgroundColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1];
                lbl_decision.text=@"暂存";
        }
        /*
        else {
      //      lbl_decision.backgroundColor=[UIColor colorWithRed:137/255.0f green:207/255.0f blue:240/255.0f alpha:1];
            lbl_decision.font=[UIFont systemFontOfSize:9.5];
                            lbl_decision.text=@"未处理";
        }
        */
    //    lbl_decision.layer.cornerRadius=5;
    //    lbl_decision.layer.masksToBounds=YES;
        
        
        [self.contentView addSubview:logView];
        [self.contentView sendSubviewToBack:logView];
             // [self addSubview:lbl_title];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:lbl_info];
        [self.contentView addSubview:lbl_time];
        [self.contentView addSubview:lbl_decision];
        [self.contentView addSubview:lbl_content];

        
        /*
        UILabel *lbl_bg=[[UILabel alloc]init];
        [lbl_bg setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
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
        else if ([_lbl_status.text isEqualToString:@"退回"]) {
            _lbl_status.textColor=[UIColor colorWithRed:247/255.0f green:35/255.0f blue:0/255.0f alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"废弃"]) {
            _lbl_status.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"暂存"]) {
            _lbl_status.textColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1];
        }
        
        self.contentView.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];

        [self.contentView addSubview:lbl_bg];
        [self.contentView sendSubviewToBack:lbl_bg];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:lbl_active];
        [self.contentView addSubview:_lbl_status];
        [self.contentView addSubview:_lbl_time];
         */
    }
    return self;
}


@end

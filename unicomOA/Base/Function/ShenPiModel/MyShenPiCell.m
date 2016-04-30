//
//  MyShenPiCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyShenPiCell.h"

@implementation MyShenPiCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withImage:(NSString *)str_Image withName:(NSString *)str_Name withCategroy:(NSString *)str_Categroy withStatus:(NSString *)str_status withTitle:(NSString *)str_Title withTime:(NSString *)str_time atIndex:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    MyShenPiCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[MyShenPiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withImage:str_Image withName:str_Name withCategrory:str_Categroy withStatus:str_status withTitle:str_Title withTime:str_time];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImage:(NSString*)str_Image withName:(NSString *)str_Name withCategrory:(NSString *)str_Categroy withStatus:(NSString *)str_status withTitle:(NSString*)str_Title withTime:(NSString*)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img_Logo=[[UIImageView alloc]init];
        UILabel *lbl_name=[[UILabel alloc]init];
        UILabel *lbl_category=[[UILabel alloc]init];
        _lbl_status=[[UILabel alloc]init];
        UIView  *view_line=[[UIView alloc]init];
        UILabel *lbl_Title=[[UILabel alloc]init];
        UILabel *lbl_time=[[UILabel alloc]init];
        
        img_Logo.layer.cornerRadius=30.0f;
        [img_Logo.layer setMasksToBounds:YES];
        [lbl_Title setFrame:CGRectMake(10, 60, 200, 20)];
        [lbl_time setFrame:CGRectMake(10, 90, 200, 20)];
        if (iPhone4_4s || iPhone5_5s) {
            [img_Logo setFrame:CGRectMake(20, 5, 60, 60)];
            [_lbl_status setFrame:CGRectMake(250, 0, 70, 110)];
            [view_line setFrame:CGRectMake(0, 70, 250, 1)];
            [lbl_name setFrame:CGRectMake(100, 20, 100, 10)];
            [lbl_category setFrame:CGRectMake(100, 45, 60, 10)];
            
        }
        else if (iPhone6) {
            [img_Logo setFrame:CGRectMake(30, 5, 60, 60)];
            [_lbl_status setFrame:CGRectMake(300, 0, 75, 110)];
            [view_line setFrame:CGRectMake(0, 70, 300, 1)];
            [lbl_name setFrame:CGRectMake(130, 20, 100, 10)];
            [lbl_category setFrame:CGRectMake(130, 45, 60, 10)];
            }
        else {
            [img_Logo setFrame:CGRectMake(40, 5, 60, 60)];
            [_lbl_status setFrame:CGRectMake(350, 0, 64, 110)];
            [view_line setFrame:CGRectMake(0, 70, 350, 1)];
            [lbl_name setFrame:CGRectMake(150, 20, 100, 10)];
            [lbl_category setFrame:CGRectMake(150, 45, 60, 10)];
        }
        img_Logo.image=[UIImage imageNamed:str_Image];
        lbl_name.textColor=[UIColor blackColor];
        lbl_category.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_Title.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        view_line.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        
        if ([_lbl_status.text isEqualToString:@"已办"]) {
            _lbl_status.backgroundColor=[UIColor colorWithRed:61/255.0f green:189/255.0f blue:144/255.0f alpha:1];
        }
        else if ([_lbl_status.text isEqualToString:@"待办"]) {
            _lbl_status.backgroundColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
        }
        else {
            _lbl_status.backgroundColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:57/255.0f alpha:1];

        }
        
        
        lbl_name.font=[UIFont systemFontOfSize:16];
        lbl_category.font=[UIFont systemFontOfSize:16];
        _lbl_status.font=[UIFont systemFontOfSize:16];
        lbl_Title.font=[UIFont systemFontOfSize:13];
        lbl_time.font=[UIFont systemFontOfSize:13];
        
        lbl_name.text=[NSString stringWithFormat:@"%@:%@",@"申请人",str_Name];
        lbl_category.text=str_Categroy;
        _lbl_status.text=str_status;
        lbl_Title.text=str_Title;
        lbl_time.text=str_time;
        _lbl_status.textColor=[UIColor whiteColor];
        _lbl_status.textAlignment=NSTextAlignmentCenter;
       
        
        [self.contentView addSubview:img_Logo];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:_lbl_status];
        [self.contentView addSubview:view_line];
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_time];
    }
    return self;
}

@end

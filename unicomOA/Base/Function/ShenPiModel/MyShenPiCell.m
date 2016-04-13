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
        UILabel *lbl_status=[[UILabel alloc]init];
        UIView  *view_line=[[UIView alloc]init];
        UILabel *lbl_Title=[[UILabel alloc]init];
        UILabel *lbl_time=[[UILabel alloc]init];
        [img_Logo setFrame:CGRectMake(10, 5, 40, 40)];
        [lbl_name setFrame:CGRectMake(60, 10, 50, 10)];
        [lbl_category setFrame:CGRectMake(60, 35, 60, 10)];
        [lbl_Title setFrame:CGRectMake(10, 60, 200, 20)];
        [lbl_time setFrame:CGRectMake(10, 90, 200, 20)];
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_status setFrame:CGRectMake(250, 20, 50, 20)];
            [view_line setFrame:CGRectMake(0, 50, 320, 1)];
            
        }
        else if (iPhone6) {
            [lbl_status setFrame:CGRectMake(300, 20, 50, 20)];
            [view_line setFrame:CGRectMake(0, 50, 375, 1)];
            }
        else {
            [lbl_status setFrame:CGRectMake(350, 20, 50, 20)];
            [view_line setFrame:CGRectMake(0, 50, 414, 1)];
        }
        img_Logo.image=[UIImage imageNamed:str_Image];
        lbl_name.textColor=[UIColor blackColor];
        lbl_category.textColor=[UIColor blackColor];
        lbl_status.textColor=[UIColor colorWithRed:255/255.0f green:161/255.0f blue:0 alpha:1];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        view_line.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        
        lbl_name.font=[UIFont systemFontOfSize:13];
        lbl_category.font=[UIFont systemFontOfSize:13];
        lbl_status.font=[UIFont systemFontOfSize:13];
        lbl_Title.font=[UIFont systemFontOfSize:13];
        lbl_time.font=[UIFont systemFontOfSize:13];
        
        lbl_name.text=str_Name;
        lbl_category.text=str_Categroy;
        lbl_status.text=str_status;
        lbl_Title.text=str_Title;
        lbl_time.text=str_time;
        
        [self.contentView addSubview:img_Logo];
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:lbl_status];
        [self.contentView addSubview:view_line];
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_time];
    }
    return self;
}

@end

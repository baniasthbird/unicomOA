//
//  SysMsgTableViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgTableViewCell.h"

#define WHScreenW [UIScreen mainScreen].bounds.size.width

@implementation SysMsgTableViewCell {
    UIImageView *img_Category;
    
}

+(instancetype)cellWithTable:(UITableView*)tableView withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withSendName:(NSString*)str_sendName withTime:(NSString*)str_time isRead:(BOOL)b_Read titleFont:(NSInteger)i_titleFont otherFont:(NSInteger)i_otherFont {
    static NSString *cellID=@"TapCell";
    SysMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
  //  cell=[[SysMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitle:str_title withCategory:str_category withSendName:str_sendName titleFont:i_titleFont otherFont:i_otherFont];
    cell=[[SysMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTitle:str_title withCategory:str_category withSendName:str_sendName withTime:str_time isRead:b_Read titleFont:i_titleFont otherFont:i_otherFont];
    return cell;
   
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withSendName:(NSString*)str_sendName withTime:(NSString*)str_time isRead:(BOOL)b_Read titleFont:(NSInteger)i_titleFont otherFont:(NSInteger)i_otherFont{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat i_left=Width*0.1573;
        if (b_Read==NO) {
            i_left=0.18*Width;
            UIView *view_bluedot=[[UIView alloc]initWithFrame:CGRectMake(0.145*Width, 20, 8, 8)];
            view_bluedot.backgroundColor=[UIColor colorWithRed:28/255.0f green:173/255.0f blue:248/255.0f alpha:1];
            view_bluedot.layer.cornerRadius=4;
            [self.contentView addSubview:view_bluedot];
        }
        CGFloat i_width=Width*0.52;
        if (iPad) {
            i_left=32;
            i_width=Width-80;
        }
        
        _lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(i_left, 16, i_width, 17)];
        _lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        _lbl_Title.textColor=[UIColor blackColor];
        _lbl_Title.numberOfLines=2;
        _lbl_Title.attributedText= str_title;
        _lbl_Title.lineBreakMode=NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [_lbl_Title sizeToFit];
        
        _lbl_Category=[[UILabel alloc] initWithFrame:CGRectMake(i_left, 60, Width*0.35, 14)];
        _lbl_Category.font=[UIFont systemFontOfSize:i_otherFont];
        _lbl_Category.textColor=[UIColor colorWithRed:171/255.0f green:171/255.0f blue:171/255.0f alpha:1];
        _lbl_Category.text=str_category;
        _lbl_Category.textAlignment=NSTextAlignmentLeft;
        [_lbl_Category sizeToFit];
        
        CGFloat i_r_left=Width*0.6927;
        _lbl_sendName=[[UILabel alloc]initWithFrame:CGRectMake(i_r_left, 60, Width*0.2, 14)];
        _lbl_sendName.font=[UIFont systemFontOfSize:i_otherFont];
        _lbl_sendName.textColor=[UIColor colorWithRed:171/255.0f green:171/255.0f blue:171/255.0f alpha:1];
        _lbl_sendName.text=str_sendName;
        _lbl_sendName.textAlignment=NSTextAlignmentRight;
        [_lbl_sendName sizeToFit];
        
        _lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(i_r_left, 16, Width*0.15, 17)];
        _lbl_time.font=[UIFont systemFontOfSize:i_titleFont];
        _lbl_time.textColor=[UIColor colorWithRed:171/255.0f green:171/255.0f blue:171/255.0f alpha:1];
        _lbl_time.text=str_time;
        _lbl_time.textAlignment=NSTextAlignmentRight;
        [_lbl_time sizeToFit];
        
        img_Category=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 0.1027*Width, 0.1027*Width)];
        if ([str_category isEqualToString:@"流程反馈"]) {
            img_Category.image=[UIImage imageNamed:@"SysMsg_1"];
        }
        else if ([str_category isEqualToString:@"项目反馈"]) {
            img_Category.image=[UIImage imageNamed:@"SysMsg_2"];
        }
        else if ([str_category isEqualToString:@"普通消息"]) {
            img_Category.image=[UIImage imageNamed:@"SysMsg_3"];
        }
        
        [self.contentView addSubview:_lbl_Title];
        [self.contentView addSubview:_lbl_Category];
        [self.contentView addSubview:_lbl_sendName];
        [self.contentView addSubview:_lbl_time];
        [self.contentView addSubview:img_Category];
    }
    
    return self;
}

-(void)awakeFromNib {
    //Initialization code
}



@end

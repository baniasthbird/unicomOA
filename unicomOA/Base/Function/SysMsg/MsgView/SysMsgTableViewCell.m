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
    UILabel *lbl_Title;
    UILabel *lbl_Category;
    UILabel *lbl_sendName;
}

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withTitle:(NSMutableAttributedString *)str_title withCategory:(NSString *)str_category withSendName:(NSString *)str_sendName titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
    static NSString *cellID=@"TapCell";
    SysMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    cell=[[SysMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitle:str_title withCategory:str_category withSendName:str_sendName titleFont:i_titleFont otherFont:i_otherFont];
    return cell;
   
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withSendName:(NSString*)str_sendName titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat i_left=17;
        CGFloat i_width=WHScreenW-34;
        if (iPad) {
            i_left=32;
            i_width=WHScreenW-80;
        }
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(i_left, 5, i_width, cellHeight/2-5)];
        lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=2;
        lbl_Title.attributedText= str_title;
        lbl_Title.lineBreakMode=NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [lbl_Title sizeToFit];
        
        lbl_Category=[[UILabel alloc] initWithFrame:CGRectMake(i_left, lbl_Title.frame.size.height+20, WHScreenW*0.35, cellHeight/2-5)];
        lbl_Category.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_Category.textColor=[UIColor lightGrayColor];
        lbl_Category.text=str_category;
        lbl_Category.textAlignment=NSTextAlignmentLeft;
        [lbl_Category sizeToFit];
        
        CGFloat i_r_left=Width*0.65;
        if (iPhone5_5s) {
            i_r_left=Width*0.6;
        }
        lbl_sendName=[[UILabel alloc]initWithFrame:CGRectMake(i_r_left, lbl_Title.frame.size.height+20, Width*0.3, cellHeight/2-5)];
        lbl_sendName.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_sendName.textColor=[UIColor lightGrayColor];
        lbl_sendName.text=str_sendName;
        lbl_sendName.textAlignment=NSTextAlignmentRight;
        [lbl_sendName sizeToFit];
        
        
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_Category];
        [self.contentView addSubview:lbl_sendName];
    }
    
    return self;
}

-(void)awakeFromNib {
    //Initialization code
}



@end

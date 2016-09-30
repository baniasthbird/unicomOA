//
//  NewsNewsTableViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/9/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsNewsTableViewCell.h"

@interface NewsNewsTableViewCell()

@property (nonatomic,strong)  UILabel *lbl_Title;

@property (nonatomic,strong)  UIImageView *img_News;

@property (nonatomic,strong)  UILabel *lbl_category;

@property (nonatomic,strong)  UILabel *lbl_dapartment;


@end

@implementation NewsNewsTableViewCell

@synthesize lbl_Title,img_News,lbl_category,lbl_dapartment;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString *)str_title withCategory:(NSString *)str_category withDepart:(NSString *)str_depart withDate:(NSString *)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont withImage:(NSString *)str_Image {
    static NSString *cellID=@"cellNews";
    NewsNewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    cell=[[NewsNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitleHeight:h_title withButtonHeight:h_depart withCateGory:str_category withDate:str_date withTitle:str_title withDepartment:str_depart titleFont:i_titleFont otherFont:i_otherFont withImage:str_Image];
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withCateGory:(NSString*)str_category withDate:(NSString*)str_date withTitle:(NSMutableAttributedString*)str_title withDepartment:(NSString*)str_department titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont withImage:(NSString*)str_Image {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        DataBase *db=[DataBase sharedinstanceDB];
        NSMutableArray *arr_ip=[db fetchIPAddress];
        arr_ip=[arr_ip objectAtIndex:0];
        NSString *str_ip=[arr_ip objectAtIndex:0];
        NSString *str_port = [arr_ip objectAtIndex:1];
        img_News=[[UIImageView alloc]initWithFrame:CGRectMake(0.04*Width, 5, (cellHeight-10)*209/155.0f, cellHeight-10)];
        NSString *str_url=[NSString stringWithFormat:@"%@%@%@%@%@",@"http://",str_ip,@":",str_port,str_Image];
        UIImage *img_src=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str_url]]];
        [img_News setImage:img_src];
       // img_News.image=[UIImage imageNamed:str_Image];
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.3493*Width, 5, 0.6107*Width, h_title)];
        lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=2;
        lbl_Title.attributedText = str_title;
        lbl_Title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [lbl_Title sizeToFit];
        
        lbl_category = [[UILabel alloc] initWithFrame:CGRectMake(0.3493*Width, cellHeight-h_depart-5, 0.1467*Width, h_depart)];
        lbl_category.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_category.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_category.text=str_category;
        lbl_category.textAlignment= NSTextAlignmentLeft;
        [lbl_category sizeToFit];
        
        
        lbl_dapartment=[[UILabel alloc]initWithFrame:CGRectMake(0.5667*Width, cellHeight-h_depart-5, 0.3947*Width, h_depart)];
        lbl_dapartment.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_dapartment.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_dapartment.text=str_department;
        lbl_dapartment.textAlignment=NSTextAlignmentLeft;
        [lbl_dapartment sizeToFit];
        
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_dapartment];
        [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:img_News];
    }
    return self;
}

@end

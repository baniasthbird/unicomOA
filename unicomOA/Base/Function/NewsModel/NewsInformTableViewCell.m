//
//  NewsInformTableViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/9/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsInformTableViewCell.h"

@interface NewsInformTableViewCell()



//@property (nonatomic,strong) UILabel *lbl_Category;

@property (nonatomic,strong) UIImageView *img_category;

@property (nonatomic,strong) UILabel *lbl_dapartment;

@end


@implementation NewsInformTableViewCell

@synthesize lbl_Title,img_category,lbl_dapartment;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString *)str_title withCategory:(NSString *)str_category withDepart:(NSString *)str_depart withDate:(NSString *)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont atIndexPath:(NSIndexPath*)indexPath {
    static NSString *cellID=@"cellInform";
    NewsInformTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
          cell=[[NewsInformTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitleHeight:h_title withButtonHeight:h_depart withCategory:str_category withTitle:str_title withDepartment:str_depart titleFont:i_titleFont otherFont:i_otherFont];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withCategory:(NSString*)str_category withTitle:(NSMutableAttributedString*)str_title withDepartment:(NSString*)str_department titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, 10, 0.92*Width, h_title)];
        lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        lbl_Title.textColor=[UIColor colorWithRed:0/255.0f green:49/255.0f blue:119/255.0f alpha:1];
        lbl_Title.numberOfLines=2;
        [str_title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0f green:49/255.0f blue:119/255.0f alpha:1] range:NSMakeRange(0, str_title.length)];
        lbl_Title.attributedText= str_title;
        lbl_Title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [lbl_Title sizeToFit];
        
        if ([str_category isEqualToString:@"公司通知"]) {
            img_category=[[UIImageView alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-8, 3.46875*h_depart, h_depart)];
            img_category.image=[UIImage imageNamed:@"img_cate_company"];
        }
        else if ([str_category isEqualToString:@"部门通知"]) {
           // lbl_Category=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-5, 3.46875*h_depart, h_depart)];
           // lbl_Category.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
           // lbl_Category.font=[UIFont systemFontOfSize:i_otherFont];
           // lbl_Category.text=str_category;
            img_category=[[UIImageView alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-8, 3.46875*h_depart, h_depart)];
            img_category.image=[UIImage imageNamed:@"img_cate_depart"];
        }
        
        lbl_dapartment=[[UILabel alloc]initWithFrame:CGRectMake(0.5667*Width, cellHeight-h_depart-8, 0.3947*Width, h_depart)];
        lbl_dapartment.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_dapartment.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_dapartment.text=str_department;
        lbl_dapartment.textAlignment=NSTextAlignmentLeft;
        [lbl_dapartment sizeToFit];
        
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_dapartment];
        //if (img_category!=nil) {
            [self.contentView addSubview:img_category];
       // }
       // else if (lbl_Category!=nil) {
       //     [self.contentView addSubview:lbl_Category];
       // }

    }
    return self;
}

@end

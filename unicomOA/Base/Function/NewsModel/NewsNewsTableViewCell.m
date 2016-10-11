//
//  NewsNewsTableViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/9/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsNewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NewsNewsTableViewCell()



@property (nonatomic,strong)  UIImageView *img_News;

//@property (nonatomic,strong) UIImageView *img_category;

@property (nonatomic,strong)  UILabel *lbl_dapartment;

@property (nonatomic,strong) UILabel *lbl_category;


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

+(instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString *)str_title withCategory:(NSString *)str_category withDepart:(NSString *)str_depart withDate:(NSString *)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont withImage:(NSString *)str_Image atIndexPath:(NSIndexPath*)indexPath {
    NSString *cellID=[NSString stringWithFormat:@"%@_%ld_%ld",@"cellNews",(long)indexPath.section,(long)indexPath.row];
    //NewsNewsTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NewsNewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[NewsNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitleHeight:h_title withButtonHeight:h_depart withCateGory:str_category withDate:str_date withTitle:str_title withDepartment:str_depart titleFont:i_titleFont otherFont:i_otherFont withImage:str_Image atIndexPath:indexPath];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withCateGory:(NSString*)str_category withDate:(NSString*)str_date withTitle:(NSMutableAttributedString*)str_title withDepartment:(NSString*)str_department titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont withImage:(NSString*)str_Image atIndexPath:(NSIndexPath*)indexPath {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        DataBase *db=[DataBase sharedinstanceDB];
        NSMutableArray *arr_ip=[db fetchIPAddress];
        arr_ip=[arr_ip objectAtIndex:0];
        NSString *str_ip=[arr_ip objectAtIndex:0];
        NSString *str_port = [arr_ip objectAtIndex:1];
        NSString *str_url=[NSString stringWithFormat:@"%@%@%@%@%@",@"http://",str_ip,@":",str_port,str_Image];
        if ([str_Image isEqualToString:@""]) {
            lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, 10, 0.92*Width, h_title)];
            lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-8, 3.46875*h_depart, h_depart)];
            lbl_dapartment=[[UILabel alloc]initWithFrame:CGRectMake(0.5667*Width, cellHeight-h_depart-8, 0.3947*Width, h_depart)];
        }
        else {
            NSString *str_img_name=[str_title string];
            str_img_name=[NSString stringWithFormat:@"%@%@%@%@",str_img_name,@"_",str_date,@".png"];
            NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_img_name];
            UIImage *img_src=[[UIImage alloc]initWithContentsOfFile:fullPath];
          //  UIImage *img_src=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fullPath];
            if (img_src==nil) {
               // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    img_src=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str_url]]];
                    NSData *imageData=UIImagePNGRepresentation(img_src);  //1为不缩放保存
                    [imageData writeToFile:fullPath atomically:NO];
               // });
            }
            if (img_src!=nil) {
                img_News=[[UIImageView alloc]initWithFrame:CGRectMake(0.04*Width, 10, (cellHeight-20)*209/155.0f, cellHeight-20)];
                lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.3493*Width, 10, 0.6107*Width, h_title)];
                // lbl_category = [[UILabel alloc] initWithFrame:CGRectMake(0.3493*Width, cellHeight-h_depart-5, 0.1467*Width, h_depart)];
                lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(0.3493*Width, cellHeight-h_depart-8, 3.46875*h_depart, h_depart)];
                lbl_dapartment=[[UILabel alloc]initWithFrame:CGRectMake(0.5667*Width, cellHeight-h_depart-8, 0.3947*Width, h_depart)];
                [img_News setImage:img_src];
            }
            else {
                lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, 10, 0.92*Width, h_title)];
                lbl_category=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-8, 3.46875*h_depart, h_depart)];
                lbl_dapartment=[[UILabel alloc]initWithFrame:CGRectMake(0.5667*Width, cellHeight-h_depart-8, 0.3947*Width, h_depart)];
            }
        }
        
       // img_News.image=[UIImage imageNamed:str_Image];
        
        lbl_Title.font=[UIFont systemFontOfSize:i_titleFont];
        lbl_Title.textColor=[UIColor blackColor];
        lbl_Title.numberOfLines=2;
        lbl_Title.attributedText = str_title;
        lbl_Title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [lbl_Title sizeToFit];
        
       
        lbl_category.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_category.font=[UIFont systemFontOfSize:i_otherFont];
        lbl_category.text=str_category;
        lbl_category.textAlignment= NSTextAlignmentLeft;
        [lbl_category sizeToFit];
        /*
        if ([str_category isEqualToString:@"内部新闻"]) {
            img_category.image=[UIImage imageNamed:@"img_news_inner"];
        }
        else if ([str_category isEqualToString:@"内部新闻"]) {
            img_category.image=[UIImage imageNamed:@"img_news_outer"];
        }
        */
        
        
       
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

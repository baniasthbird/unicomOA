//
//  MyShenPiCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyShenPiCell.h"
#import "UILabel+LabelHeightAndWidth.h"

@implementation MyShenPiCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withImage:(NSString *)str_Image withCellHeight:(CGFloat)cellHeight withName:(NSString *)str_Name withCategroy:(NSString *)str_Categroy withStatus:(NSString *)str_status withTitle:(NSString *)str_Title withTime:(NSString *)str_time atIndex:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    MyShenPiCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    //if (!cell) {
    cell=[[MyShenPiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withImage:str_Image withName:str_Name withCategrory:str_Categroy withStatus:str_status withTitle:str_Title withTime:str_time];
    //}
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withImage:(NSString*)str_Image withName:(NSString *)str_Name withCategrory:(NSString *)str_Categroy withStatus:(NSString *)str_status withTitle:(NSString*)str_Title withTime:(NSString*)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img_Logo=[[UIImageView alloc]init];
        UILabel *lbl_name=[[UILabel alloc]init];
        UILabel *lbl_category=[[UILabel alloc]init];
        _lbl_status=[[UILabel alloc]init];
        UIView  *view_line=[[UIView alloc]init];
        UILabel *lbl_Title=[[UILabel alloc]init];
        UILabel *lbl_under_left=[[UILabel alloc]init];
        UILabel *lbl_under_right=[[UILabel alloc]init];
        
        img_Logo.layer.cornerRadius=30.0f;
        [img_Logo.layer setMasksToBounds:YES];
       // [lbl_Title setFrame:CGRectMake(10, 75, 200, 20)];
        [lbl_under_left setFrame:CGRectMake(10, cellHeight-25, [UIScreen mainScreen].bounds.size.width/2, 15)];
        [lbl_under_right setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, cellHeight-25, [UIScreen mainScreen].bounds.size.width/2-10, 15)];
        [img_Logo setFrame:CGRectMake(10, 15, 60, 60)];
        [lbl_category setFrame:CGRectMake(75, 5, 120, 10)];
        if (iPad) {
            [_lbl_status setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-76, 10, 56, 30)];
            _lbl_status.layer.cornerRadius=2;
            _lbl_status.layer.masksToBounds=YES;
        }
        else {
            [_lbl_status setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-66, 10, 46, 20)];
            _lbl_status.layer.cornerRadius=2;
            _lbl_status.layer.masksToBounds=YES;
        }
       
        if (iPhone4_4s || iPhone5_5s) {
           // [_lbl_status setFrame:CGRectMake(250, 0, 70, cellHeight)];
            [view_line setFrame:CGRectMake(0, cellHeight-20, 250, 1)];
            [lbl_name setFrame:CGRectMake(100, 20, [UIScreen mainScreen].bounds.size.width-160, 70)];
            
        }
        else if (iPhone6) {
           // [_lbl_status setFrame:CGRectMake(300, 0, 75, cellHeight)];
            [view_line setFrame:CGRectMake(0, cellHeight-20, 300, 1)];
            [lbl_name setFrame:CGRectMake(130, 20, [UIScreen mainScreen].bounds.size.width-160, 70)];
            [lbl_category setFrame:CGRectMake(75, 5, 120, 10)];
            }
        else if (iPhone6_plus) {
           // [_lbl_status setFrame:CGRectMake(350, 0, 64, cellHeight)];
            [view_line setFrame:CGRectMake(0, cellHeight-20, 350, 1)];
            [lbl_name setFrame:CGRectMake(150, 20, [UIScreen mainScreen].bounds.size.width-160, 70)];
            [lbl_category setFrame:CGRectMake(75, 5, 120, 10)];
        }
        else if (iPad) {
            
        }
        if (str_Image!=nil) {
             img_Logo.image=[UIImage imageNamed:str_Image];
        }
        lbl_name.textColor=[UIColor blackColor];
        lbl_category.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_Title.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        lbl_under_left.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        lbl_under_right.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        view_line.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        
        if ([str_status isEqualToString:@"已办"]) {
            _lbl_status.backgroundColor=[UIColor colorWithRed:21/255.0f green:189/255.0f blue:144/255.0f alpha:1];
        }
        else if ([str_status isEqualToString:@"待办"]) {
            _lbl_status.backgroundColor=[UIColor colorWithRed:256/255.0f green:187/255.0f blue:67/255.0f alpha:1];
        }
        else {
            _lbl_status.backgroundColor=[UIColor colorWithRed:246/255.0f green:187/255.0f blue:57/255.0f alpha:1];

        }
        
        if (iPad) {
            lbl_name.font=[UIFont systemFontOfSize:24];
            lbl_category.font=[UIFont systemFontOfSize:20];
            _lbl_status.font=[UIFont systemFontOfSize:18];
            lbl_Title.font=[UIFont systemFontOfSize:16];
            lbl_under_left.font=[UIFont systemFontOfSize:18];
            lbl_under_right.font=[UIFont systemFontOfSize:18];
        }
        else {
            lbl_name.font=[UIFont systemFontOfSize:14];
            lbl_category.font=[UIFont systemFontOfSize:16];
            _lbl_status.font=[UIFont systemFontOfSize:16];
            lbl_Title.font=[UIFont systemFontOfSize:13];
            lbl_under_left.font=[UIFont systemFontOfSize:14];
            lbl_under_right.font=[UIFont systemFontOfSize:14];
            
        }
       
        
        NSString *str_name=[NSString stringWithFormat:@"%@:%@",@"标题",str_Name];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_name];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_name length])];
        lbl_name.attributedText=attributedString;
        lbl_name.numberOfLines=0;
        
        
        lbl_category.text=str_Categroy;
        CGFloat h_cate=0;
        if (iPad) {
             h_cate =[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_Categroy font:[UIFont systemFontOfSize:20]];
        }
        else {
            h_cate =[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_Categroy font:[UIFont systemFontOfSize:16]];
        }
       
        [lbl_category setFrame:CGRectMake(75, 5, [UIScreen mainScreen].bounds.size.width-100, h_cate)];
        _lbl_status.text=str_status;
        lbl_Title.text=str_Title;
        [lbl_name setFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-85, 70)];
        [lbl_name sizeToFit];

        lbl_under_left.text=str_Categroy;
        lbl_under_right.text=str_time;
        _lbl_status.textColor=[UIColor whiteColor];
        _lbl_status.textAlignment=NSTextAlignmentCenter;
       
        
       // [self.contentView addSubview:img_Logo];
        [self.contentView addSubview:lbl_name];
       // [self.contentView addSubview:lbl_category];
        [self.contentView addSubview:_lbl_status];
       // [self.contentView addSubview:view_line];
        [self.contentView addSubview:lbl_Title];
        [self.contentView addSubview:lbl_under_left];
        [self.contentView addSubview:lbl_under_right];
    }
    return self;
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}
*/

@end

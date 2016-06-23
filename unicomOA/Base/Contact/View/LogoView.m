//
//  LogoView.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LogoView.h"

@interface LogoView()

@property (nonatomic,strong) UIImageView *img_Head;

@property (nonatomic,strong) UILabel *lbl_name;

@end

@implementation LogoView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 创建cell
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*) str_Name withImage:(NSString*) str_img
{
    static NSString *cellID = @"sideslipCell";
    LogoView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LogoView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withImage:str_img];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *) str_name withImage:(NSString*)str_img {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat i_Width=320;
        CGFloat i_Height=100;
        if (iPhone5_5s || iPhone4_4s) {
            i_Width=320;
            i_Height=112;
        }
        else if (iPhone6) {
            i_Width=375;
            i_Height=133;
        }
        else if (iPhone6_plus) {
            i_Width=414;
            i_Height=147;
        }
        else if (iPad) {
            i_Width=768;
            i_Height=292;
        }
        UIImageView *img_bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, i_Width, i_Height)];
        if (iPad) {
            img_bgView.image=[UIImage imageNamed:@"logoimage-IPad.png"];

        }
        else {
            img_bgView.image=[UIImage imageNamed:@"logoimage.png"];
        }
        
        self.backgroundView=img_bgView;
        _lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.65, self.frame.size.height*0.5, self.frame.size.width/3, self.frame.size.height)];
       
        
        UIImage *imageHead=[UIImage imageNamed:str_img];
        _img_Head=[[UIImageView alloc]initWithImage:imageHead];
        _img_Head.backgroundColor=[UIColor clearColor];
        if (iPhone4_4s || iPhone5_5s) {
            [_img_Head setFrame:CGRectMake(115, 20, 88, 88)];
            _img_Head.layer.cornerRadius=44.0f;
        }
        else if (iPhone6) {
            [_img_Head setFrame:CGRectMake(134, 25, 105, 105)];
            _img_Head.layer.cornerRadius=52.5f;
        }
        else if (iPhone6_plus) {
            [_img_Head setFrame:CGRectMake(146, 33, 120, 120)];
            _img_Head.layer.cornerRadius=60.0f;
        }
        else if (iPad) {
            [_img_Head setFrame:CGRectMake(284,75,200,200)];
            _img_Head.layer.cornerRadius=100.0f;
        }
        _lbl_name.text=str_name;
        _lbl_name.textAlignment=NSTextAlignmentCenter;
        _lbl_name.font=[UIFont systemFontOfSize:24];
        _lbl_name.textColor=[UIColor colorWithRed:86/255.0f green:130/255.0f blue:240/255.0f alpha:1];
        [_img_Head.layer setMasksToBounds:YES];
        _img_Head.userInteractionEnabled=YES;
        
        [self.contentView addSubview:_lbl_name];
        [self.contentView addSubview:_img_Head];
        
    }
    
    return self;
}



@end

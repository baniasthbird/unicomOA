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
        _lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.65, self.frame.size.height*0.5, self.frame.size.width/3, self.frame.size.height)];
        _lbl_name.text=str_name;
        _lbl_name.textAlignment=NSTextAlignmentLeft;
        _lbl_name.font=[UIFont systemFontOfSize:24];
        _lbl_name.textColor=[UIColor blackColor];
        
        UIImage *imageHead=[UIImage imageNamed:str_img];
        _img_Head=[[UIImageView alloc]initWithImage:imageHead];
        [_img_Head setFrame:CGRectMake(self.frame.size.width*0.05, 0, imageHead.size.width, imageHead.size.height)];
        _img_Head.userInteractionEnabled=YES;
        
        [self.contentView addSubview:_lbl_name];
        [self.contentView addSubview:_img_Head];
        
    }
    
    return self;
}



@end

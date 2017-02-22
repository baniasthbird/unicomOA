//
//  PushMsgCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2017/2/22.
//  Copyright © 2017年 zr-mac. All rights reserved.
//

#import "PushMsgCell.h"

@interface PushMsgCell()

@property (nonatomic,strong) UILabel *lbl_title;

@property (nonatomic,strong) UILabel *lbl_time;

@end

@implementation PushMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString *)str_title withDate:(NSString *)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont atIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=[NSString stringWithFormat:@"%@_%ld_%ld",@"cellNews",(long)indexPath.section,(long)indexPath.row];
    //NewsNewsTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    PushMsgCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PushMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withCellHeight:cellHeight withTitleHeight:h_title withButtonHeight:h_depart withDate:str_date withTitle:str_title titleFont:i_titleFont otherFont:i_otherFont atIndexPath:indexPath];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withDate:(NSString*)str_date withTitle:(NSMutableAttributedString*)str_title  titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont atIndexPath:(NSIndexPath*)indexPath {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, 10, 0.92*Width, h_title)];
        _lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(0.04*Width, cellHeight-h_depart-8, 0.5*Width, h_depart)];
        _lbl_title.font=[UIFont systemFontOfSize:i_titleFont];
        _lbl_title.textColor=[UIColor blackColor];
        [str_title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str_title.length)];
        _lbl_title.attributedText=str_title;
        _lbl_title.numberOfLines=2;
        _lbl_title.lineBreakMode= NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [_lbl_title sizeToFit];
        
        _lbl_time.textColor=[UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1];
        _lbl_time.font=[UIFont systemFontOfSize:i_otherFont];
        _lbl_time.text=str_date;
        _lbl_time.textAlignment=NSTextAlignmentLeft;
        [_lbl_time sizeToFit];
        
        [self.contentView addSubview:_lbl_title];
        [self.contentView addSubview:_lbl_time];
        
    }
    return self;
}

@end

//
//  PositionCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/17.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PositionCell.h"

@implementation PositionCell

+(instancetype)cellWithTable:(UITableView *)tableView location:(NSString *)str_location_content cellHeight:(CGFloat)i_cellHeight indexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    PositionCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    cell=[[PositionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID location:str_location_content cellHeight:i_cellHeight];
    
    return cell;
    
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier location:(NSString*)str_location_content cellHeight:(CGFloat)i_cellHeight {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *img_position=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+10, self.contentView.frame.origin.y+i_cellHeight/2-22, 44, 44)];
        img_position.image=[UIImage imageNamed:@"position.png"];
        UILabel *lbl_text=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+80,self.contentView.frame.origin.y, [UIScreen mainScreen].bounds.size.width-100, i_cellHeight)];
        if (str_location_content!=nil) {
            lbl_text.numberOfLines=0;
            lbl_text.text=[NSString stringWithFormat:@"%@%@",@"位置信息:",str_location_content];
        }
        else {
             lbl_text.text=@"位置信息:";
        }
        lbl_text.font=[UIFont systemFontOfSize:18];
        
        [self.contentView addSubview:img_position];
        [self.contentView addSubview:lbl_text];
    }
    return self;
    
}

@end

//
//  AlarmCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/6/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AlarmCell.h"

@implementation AlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView cellHeight:(CGFloat)i_cellHeight switch:(BOOL)b_switch indexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    AlarmCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    cell=[[AlarmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:i_cellHeight switch:b_switch];
    
    return  cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight switch:(BOOL)b_switch{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // self.textLabel.text=@"设置提醒";
        UIImageView *img_alarm=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+10, self.contentView.frame.origin.y+3, self.contentView.frame.size.height, self.contentView.frame.size.height)];
        img_alarm.image=[UIImage imageNamed:@"alarm.png"];
        
         UILabel *lbl_text=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+80,self.contentView.frame.origin.y+3, [UIScreen mainScreen].bounds.size.width-100, self.contentView.frame.size.height)];
        lbl_text.text=@"设置提醒";
       //self.imageView.image=[UIImage imageNamed:@"alarm.png"];
        UISwitch *sw_alarm=[[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, cellHeight, cellHeight)];
        [sw_alarm setOn:b_switch animated:YES];
        [sw_alarm addTarget:self action:@selector(Actiondo:) forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        self.accessoryView=sw_alarm;
        if (b_switch==YES) {
            if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
                [self.delegate tapCell:self atIndex:4];
                //NSLog(@"%ld,%@",(long)self.myTag,@"进入");
            }
        }
      //  [self.contentView addsu]
        [self.contentView addSubview:lbl_text];
        [self.contentView addSubview:img_alarm];
        [self.contentView addGestureRecognizer:tapGesture];
        
    }
    return self;
}

-(void)Actiondo:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapCell:atIndex:)]) {
        [self.delegate tapCell:self atIndex:4];
        //NSLog(@"%ld,%@",(long)self.myTag,@"进入");
    }
}



@end

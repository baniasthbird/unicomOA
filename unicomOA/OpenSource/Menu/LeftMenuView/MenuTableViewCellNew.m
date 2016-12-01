//
//  MenuTableViewCell.m
//  QQ侧滑菜单Demo
//
//  Created by MCL on 16/7/18.
//  Copyright © 2016年 CHLMA. All rights reserved.
//

#import "MenuTableViewCellNew.h"


@implementation MenuTableViewCellNew {
    UILabel *lbl_label;
    UILabel *lbl_count;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (lbl_label.text.length>8) {
        lbl_label.frame=CGRectMake(10.0f, 2.0f, self.contentView.frame.size.width*0.5, self.contentView.frame.size.height-4.0f);
    }
    else {
        lbl_label.frame=CGRectMake(10.0f, 2.0f, self.contentView.frame.size.width*0.7, self.contentView.frame.size.height-4.0f);
    }

    lbl_count.frame=CGRectMake(self.contentView.frame.size.width*0.85, 2.0f,self.contentView.frame.size.width*0.1 , self.contentView.frame.size.height-4.0f);
}

+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withCount:(NSString*)str_count withLabel:(NSString*)str_Label atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    MenuTableViewCellNew *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[MenuTableViewCellNew alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withTitle:str_Title withCount:str_count withLabel:str_Label];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSString*)str_Title withCount:(NSString*)str_count  withLabel:(NSString*)str_Label {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        lbl_label=[[UILabel alloc]init];
        lbl_count=[[UILabel alloc]init];
        lbl_label.textColor=[UIColor whiteColor];
        lbl_count.textColor=[UIColor whiteColor];
        lbl_label.textAlignment=NSTextAlignmentLeft;
        lbl_count.textAlignment=NSTextAlignmentRight;
        lbl_label.font=[UIFont systemFontOfSize:15.0f];
        lbl_count.font=[UIFont boldSystemFontOfSize:15.0f];
        lbl_label.numberOfLines=2;
        
        lbl_label.text=str_Title;
        lbl_count.text=str_count;
        
        self.accessibilityHint=str_Label;
        
        [self.contentView addSubview:lbl_label];
        [self.contentView addSubview:lbl_count];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

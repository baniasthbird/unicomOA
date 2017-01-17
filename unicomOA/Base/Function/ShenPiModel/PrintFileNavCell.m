//
//  PrintFileNavCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintFileNavCell.h"

@implementation PrintFileNavCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withTileName:(NSString *)str_TitleName withLabel:(NSString*)str_Label atIndexPath:(NSIndexPath *)indexPath Category:(NSString *)str_category{
    static NSString *cellID=@"cellID";
    PrintFileNavCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintFileNavCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withTitleName:str_TitleName withLabel:str_Label Category:str_category];
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTtile:(NSString*)str_Title withTitleName:(NSString*)str_TitleName withLabel:(NSString*)str_label Category:(NSString*)str_category{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0.0459*Width, 0, 0.908*Width, self.contentView.frame.size.height)];
        bgView.backgroundColor=[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        bgView.layer.borderColor=[[UIColor colorWithRed:233.0/255.0f green:233.0/255.0f blue:233.0/255.0f alpha:1] CGColor];
        bgView.layer.borderWidth=0.5;
        [self.contentView addSubview:bgView];
        [self.contentView sendSubviewToBack:bgView];
        /*
        self.backgroundColor=[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        self.layer.borderWidth=1;
        self.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        */
       // self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor=[UIColor colorWithRed:53/255.0f green:98/255.0f blue:222/255.0f alpha:1];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        NSInteger i_TitleName=[str_TitleName integerValue];
        i_TitleName=i_TitleName+1;
        str_TitleName=[NSString stringWithFormat:@"%ld",(long)i_TitleName];
        NSString *str_text=[NSString stringWithFormat:@"%@%@%@%@",str_label,@"表(第",str_TitleName,@"行)"];
        UILabel *lbl_textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.2142*Width, 0, 0.5*Width, self.contentView.frame.size.height)];
        lbl_textLabel.font=[UIFont systemFontOfSize:16];
        lbl_textLabel.textColor=[UIColor blackColor];
        UIImageView *img_label=[[UIImageView alloc]initWithFrame:CGRectMake(0.145*Width, (self.contentView.frame.size.height-0.0515*Width)/2, 0.0515*Width, 0.0515*Width)];
        if ([str_category isEqualToString:@"tableView"]) {
            lbl_textLabel.text=str_text;
            img_label.image=[UIImage imageNamed:@"tableViewLogo"];
            
        }
        else if ([str_category isEqualToString:@"tableFiles"]) {
            lbl_textLabel.text=str_Title;
            img_label.image=[UIImage imageNamed:@"tableViewTitleCell"];
        }
      //  self.textLabel.text=str_text;
      //  self.imageView.image=[UIImage imageNamed:@"tablerow.png"];
        
        [self.contentView addSubview:lbl_textLabel];
        [self.contentView addSubview:img_label];
    }
    return self;
}

@end

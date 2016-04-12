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

+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withPages:(int)str_Pages withCopies:(int)str_copies atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    PrintFileNavCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintFileNavCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withPages:str_Pages withCopies:str_copies];
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTtile:(NSString*)str_Title withPages:(int)i_Pages withCopies:(int)i_copies {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lbl_filename=[[UILabel alloc]init];
        UILabel *lbl_pages=[[UILabel alloc]init];
        UILabel *lbl_pages_num=[[UILabel alloc]init];
        UILabel *lbl_copies=[[UILabel alloc]init];
        UILabel *lbl_copies_num=[[UILabel alloc]init];
        
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_filename setFrame:CGRectMake(0, 0, 320, 40)];
            [lbl_pages setFrame:CGRectMake(60, 50, 60,40 )];
            [lbl_pages_num setFrame:CGRectMake(125, 50, 25, 40)];
            [lbl_copies setFrame:CGRectMake(170, 50, 50, 40)];
            [lbl_copies_num setFrame:CGRectMake(225, 50, 25, 40)];
        }
        else if (iPhone6) {
            [lbl_filename setFrame:CGRectMake(0, 0, 375, 40)];
            [lbl_pages setFrame:CGRectMake(95, 50, 60,40 )];
            [lbl_pages_num setFrame:CGRectMake(160, 50, 25, 40)];
            [lbl_copies setFrame:CGRectMake(190, 50, 50, 40)];
            [lbl_copies_num setFrame:CGRectMake(245, 50, 25, 40)];
        }
        else {
            [lbl_filename setFrame:CGRectMake(0, 0, 414, 40)];
            [lbl_pages setFrame:CGRectMake(109, 50, 60,40 )];
            [lbl_pages_num setFrame:CGRectMake(174, 50, 25, 40)];
            [lbl_copies setFrame:CGRectMake(215, 50, 50, 40)];
            [lbl_copies_num setFrame:CGRectMake(270, 50, 25, 40)];
        }
        
        lbl_filename.textColor=[UIColor blackColor];
        lbl_pages.textColor=[UIColor blackColor];
        lbl_pages_num.textColor=[UIColor blackColor];
        lbl_copies.textColor=[UIColor blackColor];
        lbl_copies_num.textColor=[UIColor blackColor];
        
        lbl_filename.font=[UIFont systemFontOfSize:13];
        lbl_pages.font=[UIFont systemFontOfSize:13];
        lbl_pages_num.font=[UIFont systemFontOfSize:13];
        lbl_copies.font=[UIFont systemFontOfSize:13];
        lbl_copies_num.font=[UIFont systemFontOfSize:13];
        
        lbl_filename.text=str_Title;
        lbl_filename.textAlignment=NSTextAlignmentCenter;
        lbl_pages.text=@"复印页数";
        lbl_pages_num.text=[NSString stringWithFormat:@"%d",i_Pages];
        lbl_copies.text=@"份数";
        lbl_copies_num.text=[NSString stringWithFormat:@"%d",i_copies];
        
        [self.contentView addSubview:lbl_filename];
        [self.contentView addSubview:lbl_pages];
        [self.contentView addSubview:lbl_pages_num];
        [self.contentView addSubview:lbl_copies];
        [self.contentView addSubview:lbl_copies_num];
    }
    return self;
}

@end

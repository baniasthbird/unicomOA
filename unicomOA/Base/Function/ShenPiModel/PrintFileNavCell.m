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

+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withTileName:(NSString *)str_TitleName withLabel:(NSString*)str_Label atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    PrintFileNavCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintFileNavCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withTtile:str_Title withTitleName:str_TitleName withLabel:str_Label];
    }
    return cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTtile:(NSString*)str_Title withTitleName:(NSString*)str_TitleName withLabel:(NSString*)str_label {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UILabel *lbl_filename=[[UILabel alloc]init];
        
        if (iPhone4_4s || iPhone5_5s) {
            [lbl_filename setFrame:CGRectMake(0, 0, 320, 40)];
        }
        else if (iPhone6) {
            [lbl_filename setFrame:CGRectMake(0, 0, 375, 40)];
        }
        else {
            [lbl_filename setFrame:CGRectMake(0, 0, 414, 40)];
        }
        
        lbl_filename.textColor=[UIColor blackColor];
        
        lbl_filename.font=[UIFont systemFontOfSize:13];
    
        
        lbl_filename.text=[NSString stringWithFormat:@"%@:%@     %@",str_label,str_TitleName,str_Title];
        lbl_filename.textAlignment=NSTextAlignmentCenter;
       
        
        [self.contentView addSubview:lbl_filename];
    }
    return self;
}

@end

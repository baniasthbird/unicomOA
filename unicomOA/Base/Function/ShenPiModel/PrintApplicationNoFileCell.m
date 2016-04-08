//
//  PrintApplicationNoFileCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationNoFileCell.h"

@interface PrintApplicationNoFileCell()

//无文件时显示
@property (strong,nonatomic) UILabel *lbl_nofile_label;

@end

@implementation PrintApplicationNoFileCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name {
    static NSString *cellID=@"cellID";
    PrintApplicationNoFileCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PrintApplicationNoFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    else {
        if (![cell isMemberOfClass:[PrintApplicationNoFileCell class]]) {
            cell=[[PrintApplicationNoFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
    }
    return  cell;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (iPhone5_5s || iPhone4_4s) {
            _lbl_nofile_label=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, 220, 70)];
        }
        else if (iPhone6) {
            _lbl_nofile_label=[[UILabel alloc]initWithFrame:CGRectMake(57, 30, 260, 70)];
        }
        else {
            _lbl_nofile_label=[[UILabel alloc]initWithFrame:CGRectMake(67, 30, 280, 70)];
        }
        self.backgroundColor=[UIColor clearColor];
        _lbl_nofile_label.text=@"无复印文件，请点击右上角“添加”按钮，进行文件添加";
        _lbl_nofile_label.font=[UIFont systemFontOfSize:14];
        _lbl_nofile_label.enabled=NO;
        _lbl_nofile_label.backgroundColor=[UIColor clearColor];
        _lbl_nofile_label.textColor=[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
        _lbl_nofile_label.numberOfLines=0;
        _lbl_nofile_label.textAlignment=NSTextAlignmentCenter;
        
        
        [self.contentView addSubview:_lbl_nofile_label];
    }
    return self;
}



@end

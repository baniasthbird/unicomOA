//
//  DirectoryViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "DirectoryViewCell.h"

@implementation DirectoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name index:(NSIndexPath*)indexPath withPath:(NSString*)str_Path {
    static NSString *cellID=@"cellID";
    DirectoryViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[DirectoryViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withName:str_Name];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_Name {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:112/255.0f green:207/255.0f blue:249/255.0f alpha:1];
        UILabel *lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 0.3*Width, 40)];
        lbl_name.textColor=[UIColor lightGrayColor];
        lbl_name.font=[UIFont systemFontOfSize:16];
        lbl_name.text=str_Name;
        
        [self.contentView addSubview:lbl_name];
    }
    return self;
}

@end

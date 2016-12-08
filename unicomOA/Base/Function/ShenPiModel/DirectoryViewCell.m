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

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name index:(NSIndexPath*)indexPath withPath:(NSString*)str_Path withHeight:(CGFloat)i_Height{
    static NSString *cellID=@"cellID";
    DirectoryViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[DirectoryViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withName:str_Name withHeight:(CGFloat)i_Height];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_Name withHeight:(CGFloat)i_Height{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // self.backgroundColor=[UIColor colorWithRed:112/255.0f green:207/255.0f blue:249/255.0f alpha:1];
        self.selectedBackgroundView=[[UIView alloc]initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
        UILabel *lbl_name=[[UILabel alloc]initWithFrame:CGRectMake(0.2*Width, 0, 0.3*Width, i_Height)];
        lbl_name.textColor=[UIColor blackColor];
        lbl_name.font=[UIFont boldSystemFontOfSize:16];
        lbl_name.text=str_Name;
        
        UIImageView *img_Folder=[[UIImageView alloc]initWithFrame:CGRectMake(0.0644*Width, 0.273*i_Height,0.092592592592593*Width, 0.463414634146341*i_Height)];
        img_Folder.image=[UIImage imageNamed:@"foldercellLogo"];
        
        [self.contentView addSubview:lbl_name];
        [self.contentView addSubview:img_Folder];
    }
    return self;
}

@end

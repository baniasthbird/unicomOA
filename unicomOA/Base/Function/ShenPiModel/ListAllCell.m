//
//  ListAllCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ListAllCell.h"

@implementation ListAllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString*)str_label withDetailLabel:(NSString*)str_detail_label index:(NSIndexPath*)indexPath {
    static NSString *cellID=@"cellID";
    ListAllCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[ListAllCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withLabel:str_label withDetailLabel:str_detail_label];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabel:(NSString*)str_list_label withDetailLabel:(NSString*)str_detail_label  {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.text=str_list_label;
        //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UILabel *lbl_list_label=[[UILabel alloc]initWithFrame:CGRectMake(Width/2, 7, Width-40,30)];
        lbl_list_label.font=[UIFont systemFontOfSize:16];
        lbl_list_label.text=str_detail_label;
        lbl_list_label.textAlignment=NSTextAlignmentRight;
        self.accessibilityHint=@"alllist";
        [self.contentView addSubview:lbl_list_label];
    }
    return self;
}

@end

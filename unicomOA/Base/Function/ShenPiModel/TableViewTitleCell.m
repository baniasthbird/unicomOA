//
//  TableViewTitleCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/12/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "TableViewTitleCell.h"

@implementation TableViewTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    TableViewTitleCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[TableViewTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID title:str_Title];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString*)str_title {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image=[UIImage imageNamed:@"tableViewTitleCell"];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.text=str_title;
    }
    return self;
}


@end

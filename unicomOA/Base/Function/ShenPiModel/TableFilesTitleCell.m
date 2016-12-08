//
//  TableFilesTitleCell.m
//  unicomOA
//
//  Created by hnsi-03 on 2016/12/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "TableFilesTitleCell.h"

@implementation TableFilesTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    TableFilesTitleCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[TableFilesTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image=[UIImage imageNamed:@"attachmentTitleCell"];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.text=@"附件信息表";
    }
    return self;
}


@end

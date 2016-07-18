//
//  ListCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/6/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withLabel:(NSString *)str_list_label withDetailLabel:(NSString*)str_detail_label index:(NSIndexPath *)indexPath listData:(NSArray *)arr_listData mutiSelect:(BOOL)b_Multi{
    static NSString *cellID=@"cellID";
    ListCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell=[[ListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID withLabel:str_list_label withDetailLabel:str_detail_label listData:arr_listData mutiSelect:b_Multi];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLabel:(NSString*)str_list_label withDetailLabel:(NSString*)str_detail_label listData:(NSArray *)arr_listData mutiSelect:(BOOL)b_Multi{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.text=str_list_label;
        //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UILabel *lbl_list_label=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 7, [UIScreen mainScreen].bounds.size.width/2-40,30)];
       // lbl_list_label.backgroundColor=[UIColor colorWithRed:69/255.0f green:115/255.0f blue:230/255.0f alpha:1];
        lbl_list_label.textColor=[UIColor colorWithRed:69/255.0f green:115/255.0f blue:230/255.0f alpha:1];
        lbl_list_label.font=[UIFont systemFontOfSize:16];
        lbl_list_label.text=str_detail_label;
        lbl_list_label.textAlignment=NSTextAlignmentRight;
        
        if (arr_listData.count>0) {
            self.accessibilityElements=arr_listData;
            self.accessibilityHint=@"canPopList";
            if (b_Multi==YES) {
                self.accessibilityIdentifier=@"YES";
            }
            else {
                self.accessibilityIdentifier=@"NO";
            }
        }
        
        [self.contentView addSubview:lbl_list_label];
        
    }
    return self;
}

@end

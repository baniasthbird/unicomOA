//
//  PrintApplicationDetailCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationDetailCell.h"

@interface PrintApplicationDetailCell()<UITextViewDelegate>

@property (strong,nonatomic) UITextView *txt_detail;

@end

@implementation PrintApplicationDetailCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name {
    static NSString *cellID=@"cellID";
    PrintApplicationDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
      //  cell=[[PrintApplicationDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name];
    }
    return cell;
}

/*
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_name {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        self.textLabel.font=[UIFont systemFontOfSize:13];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_name;
        
        _txt_detail=[[UITextView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.348, 0, self.frame.size.width*.652, self.frame.size.height)];
        _txt_detail.textColor
        
    }
}
*/

@end

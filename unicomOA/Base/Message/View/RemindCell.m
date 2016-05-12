//
//  RemindCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "RemindCell.h"

@interface RemindCell()

@property (nonatomic,strong) UILabel *lbl_count;

@end

@implementation RemindCell

+(instancetype)cellWithTable:(UITableView *)tableView Count:(NSInteger)count {
    static NSString *cellID=@"cellID";
    RemindCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID Count:count];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Count:(NSInteger)count {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.text=@"工作提醒:";
        self.imageView.image=[UIImage imageNamed:@"remind.png"];
        _lbl_count=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 10, 30, 30)];
        _lbl_count.backgroundColor=[UIColor redColor];
        _lbl_count.text=[NSString stringWithFormat:@"%lu",count];
        _lbl_count.textAlignment=NSTextAlignmentCenter;
        _lbl_count.textColor=[UIColor whiteColor];
        _lbl_count.font=[UIFont systemFontOfSize:13];
        
        _lbl_count.layer.cornerRadius=15.0f;
        [_lbl_count.layer setMasksToBounds:YES];
        
        [self.contentView addSubview:_lbl_count];
    }
    return self;
}
                
@end

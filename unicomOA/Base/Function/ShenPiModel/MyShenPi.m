//
//  MyShenPi.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyShenPi.h"

@implementation MyShenPi

-(void)awakeFromNib {
    [super awakeFromNib];
}


//类型，状态，标题，时间
+(instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString *)str_Title withStatus:(NSString *)str_status isUsingCar:(BOOL)b_Category withTime:(NSString*)str_time{
    static NSString *cellID=@"cellID";
    MyShenPi *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MyShenPi alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isUsingCar:b_Category withTitle:str_Title withStatus:str_status withTime:str_time];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isUsingCar:(BOOL)b_Category withTitle:(NSString*)str_Title withStatus:(NSString *)str_status withTime:(NSString *)str_time {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


@end

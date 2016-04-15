//
//  CarDeployCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarDeployCell.h"



@implementation CarDeployCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withID:(NSString *)str_ID withBrand:(NSString *)str_Brand withColor:(NSString *)str_Color withDriver:(NSString *)str_driver {
    static NSString *cellID=@"cellID";
    CarDeployCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[CarDeployCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withID:str_ID withBrand:str_Brand withColor:str_Color withDriver:str_driver];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withID:(NSString *)str_ID withBrand:(NSString *)str_Brand withColor:(NSString*)str_Color withDriver:(NSString*)str_driver {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _lbl_ID=[[UILabel alloc]init];
        _lbl_Brand=[[UILabel alloc]init];
        _lbl_Color=[[UILabel alloc]init];
        _lbl_driver=[[UILabel alloc]init];
        UIView *lbl_seperator1=[[UIView alloc]init];
        UIView *lbl_seperator2=[[UIView alloc]init];
        UIView *lbl_seperator3=[[UIView alloc]init];
        
        if (iPhone4_4s || iPhone5_5s) {
            [_lbl_ID setFrame:CGRectMake(5, 5, 70, 30)];
            [_lbl_Brand setFrame:CGRectMake(85, 5, 70, 30)];
            [_lbl_Color setFrame:CGRectMake(165, 5, 70, 30)];
            [_lbl_driver setFrame:CGRectMake(245, 5, 70, 30)];
            [lbl_seperator1 setFrame:CGRectMake(79, 0, 1, 40)];
            [lbl_seperator2 setFrame:CGRectMake(159, 0, 1, 40)];
            [lbl_seperator3 setFrame:CGRectMake(239, 0, 1, 40)];
        }
        else if (iPhone6) {
            [_lbl_ID setFrame:CGRectMake(12.5, 5, 80, 30)];
            [_lbl_Brand setFrame:CGRectMake(102.5, 5, 80, 30)];
            [_lbl_Color setFrame:CGRectMake(192.5, 5, 80, 30)];
            [_lbl_driver setFrame:CGRectMake(282.5, 5, 80, 30)];
            [lbl_seperator1 setFrame:CGRectMake(96.5, 0, 1, 40)];
            [lbl_seperator2 setFrame:CGRectMake(186.5, 0, 1, 40)];
            [lbl_seperator3 setFrame:CGRectMake(276.5, 0, 1, 40)];
        }
        else if (iPhone6_plus) {
            [_lbl_ID setFrame:CGRectMake(12, 5, 90, 30)];
            [_lbl_Brand setFrame:CGRectMake(112, 5, 90, 30)];
            [_lbl_Color setFrame:CGRectMake(212, 5, 90, 30)];
            [_lbl_driver setFrame:CGRectMake(312, 5, 90, 30)];
            [lbl_seperator1 setFrame:CGRectMake(106, 0, 1, 40)];
            [lbl_seperator2 setFrame:CGRectMake(206, 0, 1, 40)];
            [lbl_seperator3 setFrame:CGRectMake(306, 0, 1, 40)];
        }
        _lbl_ID.text=str_ID;
        _lbl_Brand.text=str_Brand;
        _lbl_Color.text=str_Color;
        _lbl_driver.text=str_driver;
        
        _lbl_ID.textAlignment=NSTextAlignmentCenter;
        _lbl_Brand.textAlignment=NSTextAlignmentCenter;
        _lbl_Color.textAlignment=NSTextAlignmentCenter;
        _lbl_driver.textAlignment=NSTextAlignmentCenter;
        
        _lbl_ID.textColor=[UIColor blackColor];
        _lbl_Brand.textColor=[UIColor blackColor];
        _lbl_Color.textColor=[UIColor blackColor];
        _lbl_driver.textColor=[UIColor blackColor];
        
        _lbl_ID.font=[UIFont systemFontOfSize:13];
        _lbl_Brand.font=[UIFont systemFontOfSize:13];
        _lbl_Color.font=[UIFont systemFontOfSize:13];
        _lbl_driver.font=[UIFont systemFontOfSize:13];
        
        lbl_seperator1.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        lbl_seperator2.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        lbl_seperator3.backgroundColor=[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
        
        [self.contentView addSubview:_lbl_ID];
        [self.contentView addSubview:_lbl_Brand];
        [self.contentView addSubview:_lbl_Color];
        [self.contentView addSubview:_lbl_driver];
        [self.contentView addSubview:lbl_seperator1];
        [self.contentView addSubview:lbl_seperator2];
        [self.contentView addSubview:lbl_seperator3];
        
    }
    return  self;
    
}

@end

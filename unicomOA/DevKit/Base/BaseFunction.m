//
//  BaseFunction.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "BaseFunction.h"
#import "UILabel+LabelHeightAndWidth.h"

@implementation BaseFunction

-(NSString*)GetValueFromDic:(NSDictionary*)dic_tmp key:(NSString*)str_key {
    NSObject *obj_tmp=[dic_tmp objectForKey:str_key];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    return str_tmp;
}

-(NSString*)GetValueFromArray:(NSArray*)arr_tmp index:(NSInteger)i_index {
    NSObject *obj_tmp=[arr_tmp objectAtIndex:i_index];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    
    return str_tmp;
}

//添加菊花等待图标
-(UIActivityIndicatorView*)AddLoop {
    //初始化:
    UIActivityIndicatorView *l_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    l_indicator.tag = 103;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    l_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    //设置背景色
    l_indicator.backgroundColor = [UIColor blackColor];
    
    //设置背景透明
    l_indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    l_indicator.layer.cornerRadius = 6;
    l_indicator.layer.masksToBounds = YES;
    //设置显示位置
    [l_indicator setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/ 2.0, [UIScreen mainScreen].bounds.size.height/ 2.0)];
    return l_indicator;
}


-(CGFloat)cellHeightForNews:(NSInteger)i_index titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont array:(NSMutableArray*)arr_list keywordtitle:(NSString*)str_keywordTitle keywordName:(NSString*)str_keywordName keywordTime:(NSString*)str_keywordTime  {
    NSDictionary *dic_content=[arr_list objectAtIndex:i_index];
    
    CGFloat h_Title;
    if (iPad) {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:[dic_content objectForKey:str_keywordTitle] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    else {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:[dic_content objectForKey:str_keywordTitle] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    
    NSString *str_department = [dic_content objectForKey:str_keywordName];
    CGFloat h_depart=0;
    CGFloat h_height=0;
    if (str_department!=nil) {
        CGFloat w_depart=[UILabel getWidthWithTitle:[dic_content objectForKey:str_keywordName] font:[UIFont systemFontOfSize:i_otherFont]];
        h_depart=[UILabel getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
        h_height=h_Title+h_depart;
    }
    else {
        CGFloat w_depart=[UILabel getWidthWithTitle:[dic_content objectForKey:str_keywordTime] font:[UIFont systemFontOfSize:i_otherFont]];
        str_department=[dic_content objectForKey:str_keywordTime];
        h_depart=[UILabel getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
        h_height=h_Title+h_depart;
    }
    
    if (iPad) {
        if (h_Title>60) {
            return 88+h_depart;
        }
        else {
            return h_height+30;
        }
    }
    else {
        if (h_Title>45) {
            return 71+h_depart;
        }
        else {
            return h_height+30;
        }
    }
    
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

#pragma 正则匹配手机号

-(BOOL)checkTelNumber:(NSString *)telNumber {
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

-(BOOL)checkPassword:(NSString *)password {
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,18}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATHCES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

- (NSInteger)countOccurencesOfString:(NSString*)searchString length:(NSString*)str_orglength {
    NSInteger strCount = [str_orglength length] - [[str_orglength stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}

-(NSMutableArray*)GetAllSubString:(NSString*)str_origin key:(NSString*)str_key {
    NSRange searchRange = NSMakeRange(0,str_origin.length);
    NSMutableArray *arr_Range=[[NSMutableArray alloc]init];
    NSRange foundRange;
    NSInteger i_count=0;
    while (searchRange.location < str_origin.length) {
        searchRange.length = str_origin.length-searchRange.location;
        foundRange = [str_origin rangeOfString:str_key options:NSCaseInsensitiveSearch range:searchRange];
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring! do stuff here
           
            NSInteger i_loc=foundRange.location;
         //   NSString *str_tmp=[str_origin substringToIndex:i_loc];
            i_count++;
            NSString *str_loc=[NSString stringWithFormat:@"%ld",(long)i_loc];
            [arr_Range addObject:str_loc];
            
             searchRange.location = foundRange.location+1;
        } else {
            // no more substring to find
            break;
        }
    }
    
    return arr_Range;
    
}

//测试是否能获取新闻图片
-(BOOL)getImgFromNews:(NSDictionary*)dic_content ip_addr:(NSString*)str_ip port_addr:(NSString*)str_port {
    NSString *str_imgsrc=[self GetValueFromDic:dic_content key:@"imgsrc"];
    if ([str_imgsrc isEqualToString:@""]) {
        return NO;
    }
    else {
        return YES;
        /*
        NSString *str_url=[NSString stringWithFormat:@"%@%@%@%@%@",@"http://",str_ip,@":",str_port,str_imgsrc];
        UIImage *img_src=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str_url]]];
        if (img_src!=nil) {
            return YES;
        }
        else {
            return NO;
        }
        */
    }
}


@end

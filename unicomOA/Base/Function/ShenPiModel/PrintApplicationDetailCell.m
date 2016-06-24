//
//  PrintApplicationDetailCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationDetailCell.h"

@interface PrintApplicationDetailCell()<UITextViewDelegate>



@property (strong,nonatomic) UILabel *lbl_count;

@property (strong,nonatomic) UILabel *lbl_tip;

@end

@implementation PrintApplicationDetailCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withPlaceHolder:(NSString *)str_placeHolder  withText:(NSString*)str_text atIndexPath:(NSIndexPath *)indexPath atHeight:(CGFloat)i_Height{
    static NSString *cellID=@"cellID";
    PrintApplicationDetailCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintApplicationDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withPlaceholder:str_placeHolder withText:str_text atHeight:i_Height];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString*)str_name withPlaceholder:(NSString*)str_placeholder withText:(NSString*)str_text atHeight:(CGFloat)i_Height{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_name;
        */
        
        CGFloat i_left=15;
        if (iPad) {
            i_left=50;
        }

        
        UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(i_left, 10, [UIScreen mainScreen].bounds.size.width-20, 15)];
        lbl_title.textColor=[UIColor blackColor];
        lbl_title.font=[UIFont systemFontOfSize:16];
        lbl_title.textAlignment=NSTextAlignmentLeft;
        lbl_title.text=str_name;
        
        
        _txt_detail=[[UITextView alloc]initWithFrame:CGRectMake(i_left, 35, [UIScreen mainScreen].bounds.size.width-2*i_left, i_Height-50)];
        
        _txt_detail.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        _txt_detail.textAlignment=NSTextAlignmentLeft;
        _txt_detail.font=[UIFont systemFontOfSize:16];
        _txt_detail.text=@"";
        _txt_detail.autocorrectionType=UITextAutocorrectionTypeNo;
        _txt_detail.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _txt_detail.keyboardType=UIKeyboardTypeDefault;
        _txt_detail.returnKeyType=UIReturnKeyDone;
        _txt_detail.scrollEnabled=YES;
        _txt_detail.delegate=self;
        _txt_detail.layer.borderWidth=1;
        _txt_detail.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
        if (str_text!=nil) {
            _txt_detail.text=str_text;
        }
        
       
        //自定义文本框placeholder
       
        
        _lbl_tip=[[UILabel alloc]initWithFrame:CGRectMake(i_left+2,35,200,40)];
        _lbl_tip.text=str_placeholder;
        _lbl_tip.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        _lbl_tip.textAlignment=NSTextAlignmentLeft;
        _lbl_tip.font=[UIFont systemFontOfSize:16];
        _lbl_tip.backgroundColor=[UIColor clearColor];
        _lbl_tip.enabled=NO;
        _lbl_tip.numberOfLines=0;

        
        
        //自定义文本框字数统计
        CGFloat i_right=50;
        if (iPad) {
            i_right=100;
        }
        _lbl_count=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-i_right, i_Height-45,32 ,20)];
        _lbl_count.text=@"500";
        _lbl_count.textAlignment=NSTextAlignmentRight;
        _lbl_count.font=[UIFont systemFontOfSize:13];
        _lbl_count.textColor=[UIColor blackColor];
        _lbl_count.backgroundColor=[UIColor clearColor];
        _lbl_count.enabled=NO;
        
        [self.contentView addSubview:lbl_title];
        [self.contentView addSubview:_txt_detail];
        [self.contentView addSubview:_lbl_tip];
        [self.contentView addSubview:_lbl_count];
    }
    return self;
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location<500) {
        return YES;
    } else {
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    _lbl_count.text=[NSString stringWithFormat:@"%u",500-_txt_detail.text.length];
    if (textView.text.length==0) {
        [_lbl_tip setHidden:NO];
        _lbl_tip.text=@"请输入备注信息，最多500个字";
    }
    else {
        _lbl_tip.text=@"";
        [_lbl_tip setHidden:YES];
       // [_delegate sendCellValue:textView.text indexPath:];
        [_delegate sendCellValue:textView.text indexPath:_i_indexPath];
    }
}



@end

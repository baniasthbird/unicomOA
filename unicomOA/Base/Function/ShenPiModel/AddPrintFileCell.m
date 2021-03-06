//
//  AddPrintFileCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AddPrintFileCell.h"

@interface AddPrintFileCell()<UITextFieldDelegate>



@end

@implementation AddPrintFileCell
-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withPlaceHolder:(NSString *)str_placeholder {
    static NSString *cellID=@"cellID";
    AddPrintFileCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[AddPrintFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withPlaceHolder:str_placeholder];
    }
    return cell;
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withText:(NSString *)str_text {
    static NSString *cellID=@"cellID";
    AddPrintFileCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[AddPrintFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withText:str_text];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *)str_Name withPlaceHolder:(NSString*)str_placeholder {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_Name;
        
        if (iPhone6) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 5, 255, 40)];
        }
        else if (iPhone5_5s || iPhone4_4s) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 5, 200, 40)];
        }
        else {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(117, 5, 288, 40)];
        }
        
        _txt_title.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _txt_title.textAlignment=NSTextAlignmentLeft;
        _txt_title.font=[UIFont systemFontOfSize:16];
        _txt_title.placeholder=str_placeholder;
        _txt_title.autocorrectionType=UITextAutocorrectionTypeNo;
        _txt_title.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _txt_title.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
        _txt_title.layer.borderWidth=1;
        _txt_title.layer.borderColor=[[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1] CGColor];
        if ([str_Name isEqualToString:@"文件名称"])
        {
            _txt_title.keyboardType=UIKeyboardTypeDefault;
        }
        else {
            _txt_title.keyboardType=UIKeyboardTypePhonePad;
        }
        _txt_title.returnKeyType=UIReturnKeyDone;
        _txt_title.clearButtonMode=UITextFieldViewModeWhileEditing;
        [_txt_title addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _txt_title.delegate=self;
        [self.contentView addSubview:_txt_title];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *)str_Name withText:(NSString*)str_text {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_Name;
        
        if (iPhone6) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 5, 255, 40)];
        }
        else if (iPhone5_5s || iPhone4_4s) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 5, 200, 40)];
        }
        else {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(117, 5, 288, 40)];
        }

        
        _txt_title.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _txt_title.textAlignment=NSTextAlignmentLeft;
        _txt_title.font=[UIFont systemFontOfSize:16];
        _txt_title.text=str_text;
        _txt_title.autocorrectionType=UITextAutocorrectionTypeNo;
        _txt_title.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _txt_title.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
        _txt_title.layer.borderWidth=1;
        _txt_title.layer.borderColor=[[UIColor colorWithRed:187/255.0f green:187/255.0f blue:187/255.0f alpha:1] CGColor];
        if ([str_Name isEqualToString:@"文件名称"])
        {
            _txt_title.keyboardType=UIKeyboardTypeDefault;
        }
        else {
            _txt_title.keyboardType=UIKeyboardTypePhonePad;
        }
        _txt_title.returnKeyType=UIReturnKeyDone;
        _txt_title.clearButtonMode=UITextFieldViewModeWhileEditing;
        [_txt_title addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _txt_title.delegate=self;
        [self.contentView addSubview:_txt_title];
    }
    return self;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txt_title resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.txt_title) {
        if (string.length==0) return YES;
        
        NSInteger existedLength=textField.text.length;
        NSInteger selectedLength=range.length;
        NSInteger replaceLength=string.length;
        if (existedLength-selectedLength+replaceLength>50) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.txt_title) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    }
}

@end

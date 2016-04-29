//
//  PrintApplicationTitleCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationTitleCell.h"

@interface PrintApplicationTitleCell()<UITextFieldDelegate>




@end

@implementation PrintApplicationTitleCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withPlaceHolder:(NSString *)str_Placeholder atIndexPath:(NSIndexPath *)indexPath keyboardType:(UIKeyboardType)type{
    static NSString *cellID=@"cellID";
    //PrintApplicationTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    PrintApplicationTitleCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintApplicationTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withPlaceHolder:str_Placeholder keyboardType:type];
    }
    /*
    else {
        if (![cell isMemberOfClass:[PrintApplicationTitleCell class]]) {
            cell=[[PrintApplicationTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name];
        }
    }
     */
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *) str_name  withPlaceHolder:(NSString*)str_PlaceHolder keyboardType:(UIKeyboardType)type{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_name;
        
        if (iPhone6) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, -3, 264, self.frame.size.height+3)];
        }
        else if (iPhone5_5s || iPhone4_4s) {
             _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, -3, 209, self.frame.size.height+3)];
        }
        else {
             _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(116, -3, 298, self.frame.size.height+3)];
        }
        
        _txt_title.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _txt_title.textAlignment=NSTextAlignmentLeft;
        _txt_title.font=[UIFont systemFontOfSize:16];
        _txt_title.placeholder=str_PlaceHolder;
        _txt_title.autocorrectionType=UITextAutocorrectionTypeNo;
        _txt_title.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _txt_title.returnKeyType=UIReturnKeyDone;
        _txt_title.clearButtonMode=UITextFieldViewModeWhileEditing;
        _txt_title.keyboardType=type;
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

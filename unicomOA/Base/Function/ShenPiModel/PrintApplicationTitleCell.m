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

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name withPlaceHolder:(NSString *)str_Placeholder withText:(NSString*)str_text atIndexPath:(NSIndexPath *)indexPath keyboardType:(UIKeyboardType)type{
    static NSString *cellID=@"cellID";
    //PrintApplicationTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    PrintApplicationTitleCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[PrintApplicationTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name withPlaceHolder:str_Placeholder withText:str_text  keyboardType:type];
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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *) str_name  withPlaceHolder:(NSString*)str_PlaceHolder withText:(NSString*)str_text keyboardType:(UIKeyboardType)type{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor blackColor];
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_name;
        
        _txt_title.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _txt_title.textAlignment=NSTextAlignmentLeft;
        _txt_title.font=[UIFont systemFontOfSize:16];
        if (iPhone6) {
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 0, 264, 40)];
            
        }
        else if (iPhone5_5s || iPhone4_4s) {
             _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(111, 0, 209, 40)];
        }
        else if (iPhone6_plus){
            _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(116, 0, 298, 40)];
        }
        if (str_PlaceHolder!=nil && str_text==nil) {
            _txt_title.attributedPlaceholder =[[NSAttributedString alloc] initWithString:str_PlaceHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        }
        else if (str_text!=nil) {
            _txt_title.text=str_text;
            _txt_title.font=[UIFont systemFontOfSize:16];
        }
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

//
//  PrintApplicationTitleCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationTitleCell.h"

@interface PrintApplicationTitleCell()<UITextFieldDelegate>


@property (nonatomic,strong) UITextField *txt_title;

@end

@implementation PrintApplicationTitleCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)cellWithTable:(UITableView *)tableView withName:(NSString *)str_Name {
    static NSString *cellID=@"cellID";
    PrintApplicationTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PrintApplicationTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withName:str_Name];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withName:(NSString *) str_name {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        self.textLabel.font=[UIFont systemFontOfSize:13];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.text=str_name;
        
        _txt_title=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width*0.348, 0, self.frame.size.width*0.652, self.frame.size.height)];
        _txt_title.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _txt_title.textAlignment=NSTextAlignmentLeft;
        _txt_title.font=[UIFont systemFontOfSize:13];
        _txt_title.placeholder=@"请输入复印标题，最多50个字";
        _txt_title.autocorrectionType=UITextAutocorrectionTypeNo;
        _txt_title.autocapitalizationType=UITextAutocapitalizationTypeNone;
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

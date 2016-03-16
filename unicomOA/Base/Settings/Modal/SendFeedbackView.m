//
//  SendFeedbackView.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SendFeedbackView.h"

@interface SendFeedbackView()

@property (nonatomic,weak) UILabel *placeholderLabel;

@end

@implementation SendFeedbackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel *placeholderLabel=[[UILabel alloc]init];  //添加一个占位label
        
        placeholderLabel.backgroundColor=[UIColor clearColor];
        
        placeholderLabel.numberOfLines=0;   //设置可以输入多行蚊子时可以自动换行
        
        [self addSubview:placeholderLabel];
        
        self.placeholderLabel=placeholderLabel;  //赋值保存
        
        self.myPlaceholderColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
        
        self.font=[UIFont systemFontOfSize:14];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

#pragma mark- 监听文字改变
-(void)textDidChange {
    self.placeholderLabel.hidden=self.hasText;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self.placeholderLabel setFrame:CGRectMake(5, -50, self.frame.size.width-10, 40)];

    
}

-(void)setMyPlaceholder:(NSString *)myPlaceholder {
    _myPlaceholder=[myPlaceholder copy];
    self.placeholderLabel.text=myPlaceholder;
    
    //重新计算子控件frame
    [self setNeedsLayout];
}

-(void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor {
    _myPlaceholderColor=myPlaceholderColor;
    
    //设置颜色
    self.placeholderLabel.textColor=myPlaceholderColor;
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font=font;
    
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification通知的回调
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
}

@end

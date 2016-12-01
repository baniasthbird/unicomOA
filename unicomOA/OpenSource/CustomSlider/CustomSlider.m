//
//  CustomSlider.m
//  自制下载进度条
//
//  Created by 华相强 on 16/4/13.
//  Copyright © 2016年 华相强. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor lightGrayColor];
    self.leftView = [[UIImageView alloc]init];
    self.leftView.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    self.leftView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.leftView];
    self.ValueLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.ValueLabel.textAlignment = NSTextAlignmentCenter;
    self.ValueLabel.font = [UIFont systemFontOfSize:17];
    self.ValueLabel.textColor = [UIColor redColor];
    [self addSubview:self.ValueLabel];
    return self;
}
-(void)setLeftFrame:(int)tempValue{
    NSLog(@"----");
    _ValueLabel.text = [NSString stringWithFormat:@"%.d%%", tempValue];
    self.leftView.frame = CGRectMake(0, 0, self.frame.size.width * (tempValue / 100.0), self.frame.size.height);
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

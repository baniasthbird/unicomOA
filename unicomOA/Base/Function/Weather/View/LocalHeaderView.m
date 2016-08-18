//
//  LocalHeaderView.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/18.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LocalHeaderView.h"
#import "CitiesGroup.h"

@interface LocalHeaderView()

@property (nonatomic, weak) UIButton *namebtn;

@end


@implementation LocalHeaderView

+(instancetype) headerWithTableView:(UITableView *)tableview
{
    static NSString *ID =@"header";
    LocalHeaderView *header = [tableview dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[LocalHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *namebtn = [[UIButton alloc] init];
        
        [namebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        namebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //设置按钮的内容左对齐
        namebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        namebtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        [self.contentView addSubview:namebtn];
        self.namebtn = namebtn;
    }
    
    return self;
}


-(void)setGroups:(CitiesGroup *)groups {
    _groups = groups;
    
    [self.namebtn setTitle:groups.state forState:UIControlStateNormal];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.namebtn.frame = self.bounds;
}

@end

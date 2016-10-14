//
//  FFDropDownMenuCell.m
//  FFDropDownMenuDemo
//
//  Created by mac on 16/7/31.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "FFDropDownMenuCell.h"

//model
#import "FFDropDownMenuModel.h"

//other
#import "FFDropDownMenu.h"

@interface FFDropDownMenuCell ()

/** 图片 */
@property (weak, nonatomic) UIImageView *customImageView;

/** 标题 */
@property (weak, nonatomic) UILabel *customTitleLabel;


@property (weak, nonatomic) UILabel *customCountLabel;

/** 底部分割线 */
@property (nonatomic, weak) UIView *separaterView;
@end

@implementation FFDropDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化子控件
        UIImageView *customImageView = [[UIImageView alloc] init];
        customImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:customImageView];
        self.customImageView = customImageView;
        
        UILabel *customTitleLabel = [[UILabel alloc] init];
        customTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:customTitleLabel];
        self.customTitleLabel = customTitleLabel;
        
        UILabel *customCountLabel = [[UILabel alloc] init];
        customCountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:customCountLabel];
        self.customCountLabel = customCountLabel;
        
        UIView *separaterView = [[UIView alloc] init];
       // separaterView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
        separaterView.backgroundColor = [UIColor clearColor];
        [self addSubview:separaterView];
        self.separaterView = separaterView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //frame的赋值
    CGFloat separaterHeight = 1; //底部分割线高度
    
    //图片 customImageView
    CGFloat imageViewMargin = 11;
    if (iPhone6_plus) {
        imageViewMargin = 13;
    }
    else if (iPhone5_5s) {
        imageViewMargin = 9;
    }
    CGFloat imageViewH = self.frame.size.height - 2 * imageViewMargin;
    self.customImageView.frame = CGRectMake(10, imageViewMargin, imageViewH, imageViewH);
    
    //标题
    CGFloat labelX = CGRectGetMaxX(self.customImageView.frame) + 10;
    self.customTitleLabel.frame = CGRectMake(labelX, 0, self.frame.size.width*0.6 - labelX, self.frame.size.height - separaterHeight);
    
    
    CGFloat labelX_2=CGRectGetMaxX(self.customTitleLabel.frame) + 10;
    self.customCountLabel.frame = CGRectMake(labelX_2, 0, self.frame.size.width - labelX_2, self.frame.size.height - separaterHeight);
    
    self.customCountLabel.textAlignment=NSTextAlignmentCenter;
    
    //分割线
    self.separaterView.frame = CGRectMake(0, self.frame.size.height - separaterHeight, self.frame.size.width, separaterHeight);
}


- (void)setMenuModel:(id)menuModel {
    _menuModel = menuModel;
    
    FFDropDownMenuModel *realMenuModel = (FFDropDownMenuModel *)menuModel;
    self.customTitleLabel.text = realMenuModel.menuItemTitle;
    
    self.customCountLabel.text = realMenuModel.menuItemCount;
    
    //给imageView赋值
    if (realMenuModel.menuItemIconName.length) {
        self.customImageView.image = [UIImage imageNamed:realMenuModel.menuItemIconName];
        
    } else {
        FFLog(@"您传入的图片为空图片,框架内部默认不做任何处理。若您的确不想传入图片，则请忽略此处打印");
    }
    
}

@end

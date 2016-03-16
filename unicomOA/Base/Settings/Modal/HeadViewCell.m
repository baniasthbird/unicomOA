//
//  HeadViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "HeadViewCell.h"

@implementation HeadViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width/3, self.frame.size.height)];
        _lbl_title.text=@"  头像";
        _lbl_title.textAlignment=NSTextAlignmentLeft;
        _lbl_title.font=[UIFont systemFontOfSize:24];
        _lbl_title.textColor=[UIColor blackColor];
        
        UIImage *imageHead=[UIImage imageNamed:@"me.png"];
        _img_Head=[[UIImageView alloc]initWithImage:imageHead];
        [_img_Head setFrame:CGRectMake(self.frame.size.width*0.8, 0, imageHead.size.width, imageHead.size.height)];
        _img_Head.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed:)];
        
        [_img_Head addGestureRecognizer:singleTap1];
        
        [self.contentView addSubview:_lbl_title];
        [self.contentView addSubview:_img_Head];
        
    }
    
    return self;
}

-(void)buttonPressed:(UITapGestureRecognizer *)gestrueRecognizer {
    NSLog(@"已点击图片");
}


@end

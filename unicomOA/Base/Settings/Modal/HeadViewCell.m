//
//  HeadViewCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "HeadViewCell.h"
#import "LZActionSheet.h"

@interface HeadViewCell() <LZActionSheetDelegate>

@end

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
        
        UIImage *imageHead=[UIImage imageNamed:@"headLogo.png"];
        _img_Head=[[UIImageView alloc]initWithImage:imageHead];
        if (iPhone6 || iPhone6_plus)
        {
            [_img_Head setFrame:CGRectMake(self.frame.size.width*0.86, self.frame.size.height*0.13, self.frame.size.width*0.28, self.frame.size.width*0.28)];
        }
        else if (iPhone5_5s || iPhone4_4s) {
            [_img_Head setFrame:CGRectMake(self.frame.size.width*0.68, self.frame.size.height*0.13, self.frame.size.width*0.28, self.frame.size.width*0.28)];

        }
        
        _img_Head.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed:)];
        
        [_img_Head addGestureRecognizer:singleTap1];
        
        [self.contentView addSubview:_lbl_title];
        [self.contentView addSubview:_img_Head];
        
    }
    
    return self;
}

-(void)buttonPressed:(UITapGestureRecognizer *)gestrueRecognizer {
    LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"拍照",@"从相册中选择"]];
    
    [sheet show];
    NSLog(@"已点击图片");
}

-(void)LZActionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            break;
        case 1:
            break;
        default:
            break;
    }
}

@end

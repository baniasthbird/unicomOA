//
//  CommentCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/25.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()

//头像
@property (nonatomic,strong) UIImageView *img_View;

//人名
@property (nonatomic,strong) UILabel *lbl_title;

//时间
@property (nonatomic,strong) UILabel *lbl_time;

//内容
@property (nonatomic,strong) UILabel *lbl_content;


@end

//评论区的cell

@implementation CommentCell

+(instancetype)cellWithTable:(UITableView *)tableView staff:(NSString *)str_name time:(NSString *)str_time content:(NSString *)str_content image:(NSString *)str_image thumbnum:(NSInteger)i_thumb atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"cellID";
    CommentCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID staff:str_name time:str_time content:str_content image:str_image thumbnum:i_thumb];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier staff:(NSString *)str_name time:(NSString*)str_time content:(NSString*)str_content image:(NSString*)str_image thumbnum:(NSInteger)i_thumb  {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _img_View=[[UIImageView alloc]init];
    _lbl_time=[[UILabel alloc]init];
    _lbl_title=[[UILabel alloc]init];
    _lbl_content=[[UILabel alloc]init];
    _btn_thumb=[[UIButton alloc]init];
    if (self) {
        if (iPhone4_4s || iPhone5_5s) {
            [_img_View setFrame:CGRectMake(5, 5, 30, 30)];
            [_lbl_title setFrame:CGRectMake(50, 10, 250, 10)];
            [_lbl_time setFrame:CGRectMake(50, 25, 100, 10)];
            [_lbl_content setFrame:CGRectMake(50, 45, 250, 20)];
            [_btn_thumb setFrame:CGRectMake(280, 75, 40, 20)];
            _img_View.layer.cornerRadius=15.0f;
            _lbl_title.font=[UIFont systemFontOfSize:18];
            _lbl_time.font=[UIFont systemFontOfSize:12];
            _lbl_content.font=[UIFont systemFontOfSize:12];
            _btn_thumb.titleLabel.font=[UIFont systemFontOfSize:12];
        }
        else if (iPhone6) {
            [_img_View setFrame:CGRectMake(5, 5, 40, 40)];
            [_lbl_title setFrame:CGRectMake(60, 13, 240, 15)];
            [_lbl_time setFrame:CGRectMake(60, 33, 120, 15)];
            [_lbl_content setFrame:CGRectMake(60, 53, 300, 25)];
            [_btn_thumb setFrame:CGRectMake(325, 83, 45, 25)];
            _img_View.layer.cornerRadius=20.0f;
            _lbl_title.font=[UIFont systemFontOfSize:20];
            _lbl_time.font=[UIFont systemFontOfSize:14];
            _lbl_content.font=[UIFont systemFontOfSize:14];
             _btn_thumb.titleLabel.font=[UIFont systemFontOfSize:14];
        }
        else {
            [_img_View setFrame:CGRectMake(5, 5, 50, 50)];
            [_lbl_title setFrame:CGRectMake(70, 20, 230, 20)];
            [_lbl_time setFrame:CGRectMake(70, 45, 150, 20)];
            [_lbl_content setFrame:CGRectMake(70, 70, 330, 30)];
            [_btn_thumb setFrame:CGRectMake(355, 110, 50, 30)];
            _img_View.layer.cornerRadius=25.0f;
            _lbl_title.font=[UIFont systemFontOfSize:22];
            _lbl_time.font=[UIFont systemFontOfSize:15];
            _lbl_content.font=[UIFont systemFontOfSize:15];
            _btn_thumb.titleLabel.font=[UIFont systemFontOfSize:15];
        }
        [_img_View.layer setMasksToBounds:YES];
        _img_View.image=[UIImage imageNamed:str_image];
        _lbl_title.textColor=[UIColor blackColor];
        _lbl_time.textColor=[UIColor colorWithRed:75/255.0f green:75/255.0f blue:75/255.0f alpha:1];
        _lbl_content.textColor=[UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1];
        _lbl_title.text=str_name;
        _lbl_time.text=str_time;
        _lbl_content.text=str_content;
        _lbl_content.numberOfLines=0;
        [_btn_thumb setImage:[UIImage imageNamed:@"thumb_selected"] forState:UIControlStateSelected];
        [_btn_thumb setImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
        [_btn_thumb setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [_btn_thumb setTitle:[NSString stringWithFormat:@"(%ld)",(long)i_thumb+1] forState:UIControlStateSelected];
        [_btn_thumb setTitle:[NSString stringWithFormat:@"(%ld)",(long)i_thumb] forState:UIControlStateNormal];
        [_btn_thumb setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btn_thumb setTitleColor:[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1] forState:UIControlStateSelected];
        //[_btn_thumb addTarget:self action:@selector(Thumb:) forControlEvents:UIControlEventTouchUpInside];
        _btn_thumb.backgroundColor=[UIColor clearColor];
        
        
        [self.contentView addSubview:_img_View];
        [self.contentView addSubview:_lbl_title];
        [self.contentView addSubview:_lbl_time];
        [self.contentView addSubview:_lbl_content];
        [self.contentView addSubview:_btn_thumb];
    
        
    }
    return self;
}


-(void)Thumb:(UIButton*)sender {
    
}

-(void)CommentAdd:(UIButton*)sender {
    
}

@end

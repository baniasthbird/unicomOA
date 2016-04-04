//
//  PhoneLabelView.m
//  unicomOA
//
//  Created by zr-mac on 16/4/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PhoneLabelView.h"

@interface PhoneLabelView()

@property (nonatomic,strong) UIImageView *img_call;

@property (nonatomic,strong) UIImageView *img_message;

//@property (nonatomic,strong) UILabel *lbl_title;

//@property (nonatomic,strong) UILabel *lbl_num;

@end

@implementation PhoneLabelView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTable:(UITableView *)tableView withTtile:(NSString *)str_Title withName:(NSString *)str_Name withCallImage:(NSString *)str_callimg withMessageImage:(NSString *)str_messageimg {
    static NSString *cellID = @"cell";
    PhoneLabelView *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[PhoneLabelView alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID withTitle:str_Title withName:str_Name withCallImage:str_callimg withMessageImage:str_messageimg];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSString*)str_Title withName:(NSString*)str_num withCallImage:(NSString*)str_callImage withMessageImage:(NSString*)str_messageImage {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (iPhone5_5s || iPhone4_4s) {
            /*
            _lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.3, self.frame.size.height)];
            _lbl_title.font=[UIFont systemFontOfSize:20];
            _lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5, 0, self.frame.size.width*0.3, self.frame.size.height)];
             */
            
            _img_message=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.73, self.frame.size.height*0.28, 30, 30)];
            _img_call=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.86, self.frame.size.height*0.28, 30, 30)];
        }
        else if (iPhone6) {
            /*
            _lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.35, self.frame.size.height)];
            _lbl_title.font=[UIFont systemFontOfSize:22];
            _lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5, 0, self.frame.size.width*0.35, self.frame.size.height)];
             */
            _img_message=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.83, self.frame.size.height*0.26, 40, 40)];
            _img_call=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, self.frame.size.height*0.26, 40, 40)];
        }
        else if (iPhone6_plus) {
            /*
            _lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.4, self.frame.size.height)];
            _lbl_title.font=[UIFont systemFontOfSize:22];
            _lbl_num=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5, 0, self.frame.size.width*0.4, self.frame.size.height)];
             */
            _img_message=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.83, self.frame.size.height*0.24, 50, 50)];
            _img_call=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, self.frame.size.height*0.24, 50, 50)];
        }
        
        /*
        _lbl_title.text=str_Title;
        _lbl_title.textColor=[UIColor blackColor];
        _lbl_num.text=str_num;
        _lbl_num.textColor=[UIColor colorWithRed:54/255.0f green:155/255.0f blue:213/255.0f alpha:1];
        _lbl_title.textAlignment=NSTextAlignmentLeft;
        _lbl_num.textAlignment=NSTextAlignmentLeft;
         */
        self.textLabel.text=str_Title;
        self.detailTextLabel.text=str_num;
        self.textLabel.font=[UIFont systemFontOfSize:16];
        self.detailTextLabel.font=[UIFont systemFontOfSize:16];
        self.textLabel.textAlignment=NSTextAlignmentLeft;
        self.textLabel.textColor=[UIColor blackColor];
        self.detailTextLabel.textColor=[UIColor colorWithRed:22/255.0f green:155/255.0f blue:213/255.0f alpha:1];
        _img_message.image=[UIImage imageNamed:str_messageImage];
        _img_call.image=[UIImage imageNamed:str_callImage];
        _img_message.userInteractionEnabled=YES;
        _img_call.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *singleTapMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTap:)];
        UITapGestureRecognizer *singleTapCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CallTap:)];
        
        [_img_call addGestureRecognizer:singleTapCall];
        [_img_message addGestureRecognizer:singleTapMessage];
        
        
        
       // [self.contentView addSubview:_lbl_title];
        //[self.contentView addSubview:_lbl_num];
        [self.contentView addSubview:_img_call];
        [self.contentView addSubview:_img_message];
    }
    return self;
}


//点击电话触发事件
-(void)CallTap:(UIImageView*)sender  {
    
}

//点击消息触发事件
-(void)messageTap:(UIImageView*)sender {
    
}

@end

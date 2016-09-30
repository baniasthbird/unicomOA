//
//  RemindCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "RemindCell.h"
#import "UILabel+LabelHeightAndWidth.h"


@interface RemindCell()

@property (nonatomic,strong) UILabel *lbl_count;

@end

@implementation RemindCell

+(instancetype)cellWithTable:(UITableView *)tableView DocNum:(NSInteger)i_doc_num FlowNum:(NSInteger)i_flow_num MsgNum:(NSInteger)i_msg_num {
    static NSString *cellID=@"cellID";
    RemindCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    //if (!cell) {
        cell=[[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID DocNum:i_doc_num FlowNum:i_flow_num MsgNum:i_msg_num];
    //}
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier DocNum:(NSInteger)i_doc_num FlowNum:(NSInteger)i_flow_num MsgNum:(NSInteger)i_msg_num {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加两条竖线
        UIView *seperatorline1=[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, 1, 40)];
        seperatorline1.backgroundColor=[UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
        UIView *seperatorline2=[[UIView alloc]initWithFrame:CGRectMake(2*[UIScreen mainScreen].bounds.size.width/3, 0, 1, 40)];
        seperatorline2.backgroundColor=[UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
        
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, 30)];
        view1.backgroundColor=[UIColor clearColor];
        view1.userInteractionEnabled=YES;
        
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, [UIScreen mainScreen].bounds.size.width/3, 30)];
        view2.backgroundColor=[UIColor clearColor];
        view2.userInteractionEnabled=YES;
        
        UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(2*[UIScreen mainScreen].bounds.size.width/3, 0, [UIScreen mainScreen].bounds.size.width/3, 30)];
        view3.backgroundColor=[UIColor clearColor];
        view3.userInteractionEnabled=YES;
        
        //添加tapGesture
        UITapGestureRecognizer *singelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NavToShenPi:)];
        singelTap.numberOfTapsRequired=1;
        singelTap.numberOfTouchesRequired=1;
        singelTap.delegate=self;
        
        UITapGestureRecognizer *singleTap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NavToChuanYue:)];
        singleTap2.numberOfTapsRequired=1;
        singleTap2.numberOfTouchesRequired=1;
        singleTap2.delegate=self;
        
        
        UITapGestureRecognizer *singleTap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NavToMessage:)];
        singleTap3.numberOfTapsRequired=1;
        singleTap3.numberOfTouchesRequired=1;
        singleTap3.delegate=self;
        
        
        UIButton *btn_title1=[self CreateButton:@"待办流程" num:i_flow_num];
        [btn_title1 addTarget:self action:@selector(MoveToShenPi:) forControlEvents:UIControlEventTouchUpInside];
        
            /*
        btn_title1.font=[UIFont systemFontOfSize:16];
        btn_title1.textColor=[UIColor blackColor];
        btn_title1.text=@"待办流程";
        lbl_title1.textAlignment=NSTextAlignmentCenter;
        */
        
        UIButton *btn_title2 =[self CreateButton:@"公文传阅" num:i_doc_num];
        [btn_title2 addTarget:self action:@selector(MoveToChuanYue:) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        UILabel *lbl_title2=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width/3, 20)];
        lbl_title2.font=[UIFont systemFontOfSize:16];
        lbl_title2.textColor=[UIColor blackColor];
        lbl_title2.text=@"公文传阅";
        lbl_title2.textAlignment=NSTextAlignmentCenter;
         */
        
        UIButton *btn_title3 = [self CreateButton:@"系统消息" num:i_msg_num];
        [btn_title3 addTarget:self action:@selector(MoveToMessage:) forControlEvents:UIControlEventTouchUpInside];
        /*
        UILabel *lbl_title3=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width/3, 20)];
        lbl_title3.font=[UIFont systemFontOfSize:16];
        lbl_title3.textColor=[UIColor blackColor];
        lbl_title3.text=@"系统消息";
        lbl_title3.textAlignment=NSTextAlignmentCenter;
        */
        
        UILabel *lbl_num1=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width/3, 30)];
        lbl_num1.font=[UIFont systemFontOfSize:16];
        lbl_num1.backgroundColor=[UIColor colorWithRed:254/255.0f green:83/255.0f blue:81/255.0f alpha:1];
        lbl_num1.textColor=[UIColor whiteColor];
        lbl_num1.text=[NSString stringWithFormat:@"%ld",(long)i_flow_num];
        lbl_num1.textAlignment=NSTextAlignmentCenter;
        CGFloat width_1=[UILabel getWidthWithTitle:lbl_num1.text font:[UIFont systemFontOfSize:16]];
        width_1=width_1+20;
        CGFloat height_1=[UILabel getHeightByWidth:width_1 title:lbl_num1.text font:[UIFont systemFontOfSize:16]];
        [lbl_num1 setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/6-width_1/2, 40, width_1, height_1)];
       // [lbl_num1 sizeToFit];
        lbl_num1.layer.cornerRadius=10;
        lbl_num1.layer.masksToBounds=YES;
        
        UILabel *lbl_num2=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width/3, 30)];
        lbl_num2.font=[UIFont systemFontOfSize:16];
        lbl_num2.backgroundColor=[UIColor colorWithRed:254/255.0f green:83/255.0f blue:81/255.0f alpha:1];
        lbl_num2.textColor=[UIColor whiteColor];
        lbl_num2.text=[NSString stringWithFormat:@"%ld",(long)i_doc_num];
        lbl_num2.textAlignment=NSTextAlignmentCenter;
        CGFloat width_2=[UILabel getWidthWithTitle:lbl_num2.text font:[UIFont systemFontOfSize:16]];
        width_2=width_2+20;
        CGFloat height_2=[UILabel getHeightByWidth:width_2 title:lbl_num2.text font:[UIFont systemFontOfSize:16]];
        [lbl_num2 setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/6-width_2/2, 40, width_2, height_2)];
      //  [lbl_num2 sizeToFit];

        lbl_num2.layer.cornerRadius=10;
        lbl_num2.layer.masksToBounds=YES;
        
        
        UILabel *lbl_num3=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width/3, 30)];
        lbl_num3.font=[UIFont systemFontOfSize:16];
        lbl_num3.backgroundColor=[UIColor colorWithRed:254/255.0f green:83/255.0f blue:81/255.0f alpha:1];
        lbl_num3.textColor=[UIColor whiteColor];
        lbl_num3.text=[NSString stringWithFormat:@"%ld",(long)i_msg_num];
        lbl_num3.textAlignment=NSTextAlignmentCenter;
        CGFloat width_3=[UILabel getWidthWithTitle:lbl_num3.text font:[UIFont systemFontOfSize:16]];
        width_3=width_3+20;
        CGFloat height_3=[UILabel getHeightByWidth:width_3 title:lbl_num3.text font:[UIFont systemFontOfSize:16]];
        [lbl_num3 setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/6-width_3/2, 40, width_3, height_3)];
       // [lbl_num3 sizeToFit];
        lbl_num3.layer.cornerRadius=10;
        lbl_num3.layer.masksToBounds=YES;
        

     //   [view1 addGestureRecognizer:singelTap];
     //   [view2 addGestureRecognizer:singleTap2];
      //  [view3 addGestureRecognizer:singleTap3];
        
        [self.contentView addSubview:seperatorline1];
        [self.contentView addSubview:seperatorline2];
        [view1 addSubview:btn_title1];
       // [view1 addSubview:lbl_num1];
        [self.contentView addSubview:view1];
        
        [view2 addSubview:btn_title2];
       // [view2 addSubview:lbl_num2];
        [self.contentView addSubview:view2];
        
        [view3 addSubview:btn_title3];
      //  [view3 addSubview:lbl_num3];
        [self.contentView addSubview:view3];
       // [self.contentView addSubview:lbl_title1];
       // [self.contentView addSubview:lbl_title2];
       // [self.contentView addSubview:lbl_title3];
      //  [self.contentView addSubview:lbl_num1];
        
      //  [self.contentView addSubview:lbl_num2];
       // [self.contentView addSubview:lbl_num3];
        
        
        /*
        //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font=[UIFont systemFontOfSize:13];
        self.detailTextLabel.font=[UIFont systemFontOfSize:13];
        //self.textLabel.text=@"工作提醒:待办流程";
        //[self.textLabel sizeToFit];
        NSString *str_doc_num=[NSString stringWithFormat:@"%lu",(long)i_doc_num];
        int i_doc_length=(int)str_doc_num.length;
        NSString *str_flow_num=[NSString stringWithFormat:@"%lu",(long)i_flow_num];
        int i_flow_length=(int)str_flow_num.length;
        NSString *str_msg_num=[NSString stringWithFormat:@"%lu",(long)i_msg_num];
        int i_msg_length=(int)str_msg_num.length;
        
        NSString *str_content=[NSString stringWithFormat:@"%@%lu%@%lu%@%lu%@",@"工作提醒:待办流程",(long)i_flow_num,@"个，公文传阅",i_doc_num,@"个,系统消息",i_msg_num,@"个"];
        NSMutableAttributedString *str_lbl=[[NSMutableAttributedString alloc]initWithString:str_content];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor blackColor] range:NSMakeRange(0, 8)];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:NSMakeRange(9, i_flow_length)];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor blackColor] range:NSMakeRange(9+i_flow_length, 5)];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:NSMakeRange(15+i_flow_length, i_doc_length)];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor blackColor] range:NSMakeRange(16+i_flow_length+i_doc_length, 5)];
        [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:NSMakeRange(21+i_doc_length+i_flow_length, i_msg_length)];
        //[str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor blackColor] range:NSMakeRange(25, 1)];
        
        self.textLabel.attributedText=str_lbl;
        self.textLabel.numberOfLines=0;
       // [self.detailTextLabel sizeToFit];
        
        self.imageView.image=[UIImage imageNamed:@"remind.png"];
        _lbl_count=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 10, 30, 30)];
        _lbl_count.backgroundColor=[UIColor redColor];
        _lbl_count.text=[NSString stringWithFormat:@"%lu",(long)i_flow_num];
        _lbl_count.textAlignment=NSTextAlignmentCenter;
        _lbl_count.textColor=[UIColor whiteColor];
        _lbl_count.font=[UIFont systemFontOfSize:13];
        CGSize titleSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        CGFloat width1=[UILabel_LabelHeightAndWidth getWidthWithTitle:_lbl_count.text font:_lbl_count.font];
        _lbl_count.frame=CGRectMake(titleSize.width+55, 10, width1, width1);
        
        
        _lbl_count.layer.cornerRadius=width1/2;
        [_lbl_count.layer setMasksToBounds:YES];
        */
       // [self.contentView addSubview:_lbl_count];
    }
    return self;
}


-(UIButton*)CreateButton:(NSString*)str_title num:(NSInteger)i_num {
    UIButton *btn_title1=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width/3, 20)];
    [btn_title1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_title1 setTitle:str_title forState:UIControlStateNormal];
    btn_title1.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_title1 setBackgroundColor:[UIColor clearColor]];
    btn_title1.titleLabel.textAlignment=NSTextAlignmentCenter;
  //  [btn_title1 addTarget:self action:@selector(MoveToShenPi:) forControlEvents:UIControlEventTouchUpInside];
    
    if (i_num!=0) {
        CATextLayer  *_badgeLayer = [[CATextLayer alloc] init];
        _badgeLayer.backgroundColor=[UIColor redColor].CGColor;
        _badgeLayer.foregroundColor = [UIColor blackColor].CGColor;
        _badgeLayer.alignmentMode = kCAAlignmentCenter;
        [_badgeLayer setFrame:CGRectMake(0, 0, 6, 6)];
        _badgeLayer.position=CGPointMake(btn_title1.frame.size.width/2+30, 0);
        _badgeLayer.wrapped = YES;
        _badgeLayer.cornerRadius = 3.0f;
        // [_badgeLayer setFontSize:16];
        // [_badgeLayer setString:@"4"];
        _badgeLayer.anchorPoint=CGPointZero;
        _badgeLayer.contentsScale = [[UIScreen mainScreen] scale];
        [btn_title1.layer addSublayer:_badgeLayer];
    }
    return btn_title1;
}

-(void)MoveToShenPi:(UIButton*)sender {
    [_delegate PassNavToShenPi];
}

-(void)MoveToChuanYue:(UIButton*)sender {
    [_delegate PassNavToChuanYue];
}

-(void)MoveToMessage:(UIButton*)sender {
    [_delegate PassNaveToMessage];

}

-(void)NavToShenPi:(UITapGestureRecognizer*)sender {
    [_delegate PassNavToShenPi];
  
}

-(void)NavToMessage:(UITapGestureRecognizer*)sender {
    [_delegate PassNaveToMessage];
}

-(void)NavToChuanYue:(UITapGestureRecognizer*)sender {
    [_delegate PassNavToChuanYue];
}
                
@end

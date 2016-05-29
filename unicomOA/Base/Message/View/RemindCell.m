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
    if (!cell) {
        cell=[[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID DocNum:i_doc_num FlowNum:i_flow_num MsgNum:i_msg_num];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier DocNum:(NSInteger)i_doc_num FlowNum:(NSInteger)i_flow_num MsgNum:(NSInteger)i_msg_num {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font=[UIFont systemFontOfSize:13];
        self.detailTextLabel.font=[UIFont systemFontOfSize:13];
        //self.textLabel.text=@"工作提醒:待办流程";
        //[self.textLabel sizeToFit];
        NSString *str_doc_num=[NSString stringWithFormat:@"%lu",i_doc_num];
        int i_doc_length=(int)str_doc_num.length;
        NSString *str_flow_num=[NSString stringWithFormat:@"%lu",i_flow_num];
        int i_flow_length=(int)str_flow_num.length;
        NSString *str_msg_num=[NSString stringWithFormat:@"%lu",i_msg_num];
        int i_msg_length=(int)str_msg_num.length;
        
        NSString *str_content=[NSString stringWithFormat:@"%@%lu%@%lu%@%lu%@",@"工作提醒:待办流程",i_flow_num,@"个，公文传阅",i_doc_num,@"个,系统消息",i_msg_num,@"个"];
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
        _lbl_count.text=[NSString stringWithFormat:@"%lu",i_flow_num];
        _lbl_count.textAlignment=NSTextAlignmentCenter;
        _lbl_count.textColor=[UIColor whiteColor];
        _lbl_count.font=[UIFont systemFontOfSize:13];
        CGSize titleSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        //   CGSize titleSize= self.textLabel.text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>
        CGFloat width1=[UILabel_LabelHeightAndWidth getWidthWithTitle:_lbl_count.text font:_lbl_count.font];
        _lbl_count.frame=CGRectMake(titleSize.width+55, 10, width1, width1);
        
        
        _lbl_count.layer.cornerRadius=width1/2;
        [_lbl_count.layer setMasksToBounds:YES];
        
       // [self.contentView addSubview:_lbl_count];
    }
    return self;
}
                
@end

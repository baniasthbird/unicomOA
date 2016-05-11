//
//  FlowListCell.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "FlowListCell.h"

@implementation FlowListCell

+(instancetype)cellWithTable:(UITableView *)tableView dic:(NSDictionary *)dic_flowcontent cellHeight:(CGFloat)i_cellHeight {
    static NSString *cellID=@"cellID";
    FlowListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell=[[FlowListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID dic:dic_flowcontent cellHeight:i_cellHeight];
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dic:(NSDictionary *)dic_flowContent cellHeight:(CGFloat)i_cellHeight{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //流程类别
        NSString *str_processChName=[dic_flowContent objectForKey:@"processChName"];
        //流程标题
        NSString *str_processInstName=[dic_flowContent objectForKey:@"processInstName"];
        //当前节点名称
        NSString *str_workItemName=[dic_flowContent objectForKey:@"workItemName"];
        //时间
        NSString *str_startTime=[dic_flowContent objectForKey:@"startTime"];
        //流程类别Label
        UILabel *lbl_processChName=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y
                                                                            , [UIScreen mainScreen].bounds.size.width/2, i_cellHeight/2-5)];
        lbl_processChName.text=[NSString stringWithFormat:@"%@%@",@"流程类别:",str_processChName];
        lbl_processChName.font=[UIFont systemFontOfSize:10];
        lbl_processChName.textAlignment=NSTextAlignmentLeft;
        
        //流程标题Label
        UILabel *lbl_processInstName=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+[UIScreen mainScreen].bounds.size.width/2, self.contentView.frame.origin.y, [UIScreen mainScreen].bounds.size.width/2, i_cellHeight/2)];
        lbl_processInstName.text=[NSString stringWithFormat:@"%@%@",@"流程标题:",str_processInstName];
        lbl_processInstName.font=[UIFont systemFontOfSize:10];
        lbl_processInstName.textAlignment=NSTextAlignmentLeft;
        
        //当前节点名称
        UILabel *lbl_workItemName=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y+ i_cellHeight/2, [UIScreen mainScreen].bounds.size.width/2, i_cellHeight/2)];
        lbl_workItemName.text=[NSString stringWithFormat:@"%@%@",@"当前节点:",str_workItemName];
        lbl_workItemName.font=[UIFont systemFontOfSize:10];
        lbl_workItemName.textAlignment=NSTextAlignmentLeft;
        
        UILabel *lbl_startTime=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x+[UIScreen mainScreen].bounds.size.width/2, self.contentView.frame.origin.y+i_cellHeight/2, [UIScreen mainScreen].bounds.size.width/2, i_cellHeight/2)];
        lbl_startTime.text=[NSString stringWithFormat:@"%@%@",@"时间:",str_startTime];
        lbl_startTime.font=[UIFont systemFontOfSize:10];
        lbl_startTime.textAlignment=NSTextAlignmentLeft;

        
        [self.contentView addSubview:lbl_processChName];
        [self.contentView addSubview:lbl_processInstName];
        [self.contentView addSubview:lbl_workItemName];
        [self.contentView addSubview:lbl_startTime];
    }
    return self;
}

@end

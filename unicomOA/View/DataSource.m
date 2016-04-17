//
//  DataSource.m
//  unicomOA
//
//  Created by zr-mac on 16/4/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "DataSource.h"
#import "CLTree.h"
#import "MemberInfoViewController.h"

@interface DataSource()



@end

@implementation DataSource

//添加演示数据 (先根据demo在代码中添加，再组成plist文件以方便调整)
-(NSMutableArray*) addTestData {
    
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
#pragma mark 组织架构
    CLTreeViewNode *node1=[self CreateLevel0Node:@"第一设计分公司" staff_num:@"2"];
    CLTreeViewNode *node2=[self CreateLevel0Node:@"软信科技子公司" staff_num:@"10"];
    CLTreeViewNode *node3=[self CreateLevel0Node:@"综合管理部" staff_num:@"0"];
    
#pragma mark 第一设计分公司
    CLTreeViewNode *node1_2_0=[self CreateLevel2Node:@"崔红涛" signture:@"分公司总经理" headImgPath:@"head1.jpg" headImgUrl:nil gender:@"男" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node1_2_1=[self CreateLevel2Node:@"孙晓巍" signture:@"员工" headImgPath:@"head2.jpg" headImgUrl:nil gender:@"女" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    
#pragma mark 软信第二级组织架构
    CLTreeViewNode *node2_0=[self CreateLevel1Node:@"综合部" sonCnt:@"3"];
    CLTreeViewNode *node2_1=[self CreateLevel1Node:@"市场部" sonCnt:@"2"];
    CLTreeViewNode *node2_2=[self CreateLevel1Node:@"产品部" sonCnt:@"5"];
    CLTreeViewNode *node2_3=[self CreateLevel1Node:@"开发部" sonCnt:@"8"];
    
#pragma mark 软信员工
    CLTreeViewNode *node2_0_0=[self CreateLevel2Node:@"刘佳" signture:@"综合部部长" headImgPath:@"head1.jpg" headImgUrl:nil gender:@"女" department:@"综合部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_0_1=[self CreateLevel2Node:@"张三" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"综合部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_0=[self CreateLevel2Node:@"李四" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"女" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_1=[self CreateLevel2Node:@"王五" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_1_2=[self CreateLevel2Node:@"冀明哲" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"市场部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_0=[self CreateLevel2Node:@"刘攀攀" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_1=[self CreateLevel2Node:@"朱培配" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_2=[self CreateLevel2Node:@"李忻雨" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_3=[self CreateLevel2Node:@"张曙光" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_2_4=[self CreateLevel2Node:@"赵睿" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"产品部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_3_0=[self CreateLevel2Node:@"乔帮主" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"开发部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node2_3_1=[self CreateLevel2Node:@"周大" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"开发部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    
    node1.sonNodes=[NSMutableArray arrayWithObjects:node1_2_0,node1_2_1, nil];
    node2.sonNodes=[NSMutableArray arrayWithObjects:node2_0,node2_1,node2_2,node2_3, nil];
    node2_0.sonNodes=[NSMutableArray arrayWithObjects:node2_0_0,node2_0_1, nil];
    node2_1.sonNodes=[NSMutableArray arrayWithObjects:node2_1_0,node2_1_1,node2_1_2, nil];
    node2_2.sonNodes=[NSMutableArray arrayWithObjects:node2_2_0,node2_2_1,node2_2_2,node2_2_3,node2_2_4, nil];
    node2_3.sonNodes=[NSMutableArray arrayWithObjects:node2_3_0,node2_3_1, nil];
    
    
    arr_tmp=[NSMutableArray arrayWithObjects:node1,node2,node3, nil];
    
    return  arr_tmp;
    
    
}

-(CLTreeViewNode*)CreateLevel0Node:(NSString*)str_name staff_num:(NSString*)staff_num {
    CLTreeViewNode *node0=[[CLTreeViewNode alloc]init];
    node0.nodeLevel=0;
    node0.type=0;
    node0.sonNodes=nil;
    node0.isExpanded=FALSE;
    CLTreeView_LEVEL0_Model *tmp0=[[CLTreeView_LEVEL0_Model alloc]init];
    tmp0.name=str_name;
    tmp0.num=staff_num;
    // tmp0.headImgPath=@"contacts_major.png";
    //tmp0.headImgPath=nil;
    // tmp0.headImgUrl=nil;
    node0.nodeData=tmp0;
    
    return node0;
    
}

-(CLTreeViewNode*)CreateLevel1Node:(NSString*)str_name sonCnt:(NSString*)str_soncnt {
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 1;
    node0.type = 1;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    CLTreeView_LEVEL1_Model *tmp0 =[[CLTreeView_LEVEL1_Model alloc]init];
    tmp0.name = str_name;
    tmp0.sonCnt = str_soncnt;
    node0.nodeData = tmp0;
    
    return node0;
}

-(CLTreeViewNode*)CreateLevel2Node:(NSString*)str_name signture:(NSString*)str_signture headImgPath:(NSString*)str_headImgPath headImgUrl:(NSString*)str_headImgUrl gender:(NSString*)str_gender department:(NSString*)str_department cell:(NSString*)str_cellphone phone:(NSString*)str_phonenum email:(NSString*)str_email{
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 2;
    node0.type = 2;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    CLTreeView_LEVEL2_Model *tmp0 =[[CLTreeView_LEVEL2_Model alloc]init];
    tmp0.name = str_name;
    tmp0.signture = str_signture;
    tmp0.headImgPath = str_headImgPath;
    tmp0.headImgUrl = nil;
    tmp0.gender=str_gender;
    tmp0.department=str_department;
    tmp0.cellphonenum=str_cellphone;
    tmp0.phonenum=str_phonenum;
    tmp0.email=str_email;
    node0.nodeData = tmp0;
    
    return node0;
}


@end

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
#import "AFNetworking.h"
#import "DataBase.h"




@interface DataSource()



@end

@implementation DataSource {
    NSInteger i_ungroup_num;
    
}




//添加真实数据
-(NSMutableArray*)addRealData:(NSMutableArray*)staffArray departArray:(NSMutableArray*)departArray {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    if (staffArray!=nil && departArray!=nil) {
        //遍历部门数组，建立一级组织架构
        for (int i=0;i<[departArray count];i++) {
            NSDictionary *tmp_dic=(NSDictionary*)[departArray objectAtIndex:i];
            NSObject *parentID=[tmp_dic objectForKey:@"parentorgid"];
            if (parentID!=[NSNull null])
            {
                long l_parentID=[(NSNumber*)parentID longLongValue];
                if (l_parentID==1) {
                    NSString *str_orgname=[tmp_dic objectForKey:@"orgname"];
                    CLTreeViewNode *node=[self CreateLevel0Node:str_orgname stat:NO];
                    NSString *str_orgid=[tmp_dic objectForKey:@"orgid"];
                    node.tag=[str_orgid intValue];
                    node=[self AddSubNode:node departarray:departArray];
                    if (node.sonNodes==nil) {
                       node=[self AddStaff:node staffArray:staffArray];
                       [self SetNode0Num:node num:node.sonNodes.count];
                    }
                    else {
                        NSMutableArray *arr_subnodes=[[NSMutableArray alloc]init];
                        NSInteger i_count=0;
                        for (int i=0;i<node.sonNodes.count;i++) {
                            CLTreeViewNode *subNodes=[node.sonNodes objectAtIndex:i];
                            subNodes=[self AddStaff:subNodes staffArray:staffArray];
                            [arr_subnodes addObject:subNodes];
                            [self SetNode0Num:subNodes num:subNodes.sonNodes.count];
                            i_count=i_count+subNodes.sonNodes.count;
                        }
                        node.sonNodes=arr_subnodes;
                        node=[self AddStaff:node staffArray:staffArray];
                        i_count=i_count+i_ungroup_num;
                        [self SetNode0Num:node num:i_count];
                        
                       // CLTreeViewNode  *newnode=[self AddStaff:node staffArray:staffArray];
                       // [self SetNode0Num:newnode num:newnode.sonNodes.count];

                        
                    }
                   // [self AddStaff:node staffArray:staffArray];
                    [arr_tmp addObject:node];
                }
                
            }
          
        }
        
        NSString *str_staffcount=[NSString stringWithFormat:@"%lu%@",(unsigned long)staffArray.count,@"位联系人"];
        CLTreeViewNode *node_staffcount=[self CreateLevel0Node:str_staffcount stat:YES];
        node_staffcount.tag=1000;
        [arr_tmp addObject:node_staffcount];
    }
    return arr_tmp;
}

/*
//添加演示数据 (先根据demo在代码中添加，再组成plist文件以方便调整)
-(NSMutableArray*) addTestData {
    
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
   // 组织架构
    CLTreeViewNode *node1=[self CreateLevel0Node:@"第一设计分公司" staff_num:@"2"];
    CLTreeViewNode *node2=[self CreateLevel0Node:@"软信科技子公司" staff_num:@"10"];
    CLTreeViewNode *node3=[self CreateLevel0Node:@"综合管理部" staff_num:@"0"];
    
    
// 第一设计分公司
    CLTreeViewNode *node1_2_0=[self CreateLevel2Node:@"崔红涛" signture:@"分公司总经理" headImgPath:@"head1.jpg" headImgUrl:nil gender:@"男" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    CLTreeViewNode *node1_2_1=[self CreateLevel2Node:@"孙晓巍" signture:@"员工" headImgPath:@"head2.jpg" headImgUrl:nil gender:@"女" department:@"第一设计分公司" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
    
// 软信第二级组织架构
    CLTreeViewNode *node2_0=[self CreateLevel1Node:@"综合部" sonCnt:@"3"];
    CLTreeViewNode *node2_1=[self CreateLevel1Node:@"市场部" sonCnt:@"2"];
    CLTreeViewNode *node2_2=[self CreateLevel1Node:@"产品部" sonCnt:@"5"];
    CLTreeViewNode *node2_3=[self CreateLevel1Node:@"开发部" sonCnt:@"8"];
    
// 软信员工
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
*/
#pragma mark 添加真实数据所需的方法
//添加第0级菜单
-(CLTreeViewNode*)CreateLevel0Node:(NSString*)str_name stat:(BOOL)b_stat{
    CLTreeViewNode *node0=[[CLTreeViewNode alloc]init];
    node0.nodeLevel=0;
    node0.type=0;
    node0.sonNodes=nil;
    node0.isExpanded=FALSE;
    node0.isStat=b_stat;
    CLTreeView_LEVEL0_Model *tmp0=[[CLTreeView_LEVEL0_Model alloc]init];
    tmp0.name=str_name;
    tmp0.num=@"0";
    // tmp0.headImgPath=@"contacts_major.png";
    //tmp0.headImgPath=nil;
    // tmp0.headImgUrl=nil;
    node0.nodeData=tmp0;
    
    return node0;
}

//添加第1级菜单
-(CLTreeViewNode*)CreateLevel1Node:(NSString*)str_name {
    CLTreeViewNode *node0=[[CLTreeViewNode alloc]init];
    node0.nodeLevel=0;
    node0.type=0;
    node0.sonNodes=nil;
    node0.isExpanded=FALSE;
    CLTreeView_LEVEL1_Model *tmp0=[[CLTreeView_LEVEL1_Model alloc]init];
    tmp0.name=str_name;
    tmp0.sonCnt = @"0";
    // tmp0.headImgPath=@"contacts_major.png";
    //tmp0.headImgPath=nil;
    // tmp0.headImgUrl=nil;
    node0.nodeData=tmp0;
    
    return node0;
}


-(void)SetNode0Num:(CLTreeViewNode*)tmpTree num:(NSInteger)i_num {
    NSObject *tmp=tmpTree.nodeData;
    if ([tmp isMemberOfClass:[CLTreeView_LEVEL0_Model class]]) {
        CLTreeView_LEVEL0_Model *tmp0=(CLTreeView_LEVEL0_Model*)tmp;
        NSString *str_num=[NSString stringWithFormat:@"%ld",(long)i_num];
        tmp0.num=str_num;
    }
    else if ([tmp isMemberOfClass:[CLTreeView_LEVEL1_Model class]]) {
        CLTreeView_LEVEL1_Model *tmp0=(CLTreeView_LEVEL1_Model*)tmp;
        NSString *str_num=[NSString stringWithFormat:@"%ld",(long)i_num];
        tmp0.sonCnt=str_num;
    }
}

//添加二级部门
-(CLTreeViewNode*)AddSubNode:(CLTreeViewNode*)node departarray:(NSMutableArray*)departArray{
    int i_orgid=node.tag;
    NSMutableArray *arr_sub_node=[[NSMutableArray alloc]init];
    //遍历部门列表，添加二级部门
    for (int i=0;i<[departArray count]; i++) {
        NSDictionary *dic_sub=(NSDictionary*)[departArray objectAtIndex:i];
        NSObject *obj= [dic_sub objectForKey:@"parentorgid"];
        if (obj!=[NSNull null]) {
            long i_parentid=[(NSNumber*)obj longLongValue];
            if (i_parentid==i_orgid) {
                NSString *str_orgname=[dic_sub objectForKey:@"orgname"];
                CLTreeViewNode *sub_node=[self CreateLevel1Node:str_orgname sonCnt:@"0"];
                NSString *str_orgid=[dic_sub objectForKey:@"orgid"];
                int i_orgid=[str_orgid intValue];
                sub_node.tag=i_orgid;
                [arr_sub_node addObject:sub_node];
            }
        }
    }
    if ([arr_sub_node count]>0) {
        node.sonNodes=arr_sub_node;
    }
    return node;
}

//添加职员
-(CLTreeViewNode*)AddStaff:(CLTreeViewNode*)node staffArray:(NSMutableArray*)staffArray {
    int i_orgid=node.tag;
    
    NSMutableArray *arr_staff=[[NSMutableArray alloc]init];
    //暂时不处理人员的orgid为1的情况
    for (int i=0;i<[staffArray count];i++) {
        NSDictionary *dic=[staffArray objectAtIndex:i];
        NSString *str_orgid= [dic objectForKey:@"orgid"];
        int i_staff_orgid=[str_orgid intValue];
        if (i_orgid==i_staff_orgid) {
            // CLTreeViewNode *node2_3_1=[self CreateLevel2Node:@"周大" signture:@"员工" headImgPath:@"headLogo.png" headImgUrl:nil gender:@"男" department:@"开发部" cell:@"18600697151" phone:@"0371-65106156" email:@"2002-sunshine@163.com"];
            NSString *str_name=[dic objectForKey:@"empname"];
            NSString *str_sex=[dic objectForKey:@"sex"];
            NSString *str_position=[dic objectForKey:@"posiname"];
            NSString *str_department=[dic objectForKey:@"orgname"];
            NSObject *obj_cell=[dic objectForKey:@"mobileno"];
            NSObject *obj_phone=[dic objectForKey:@"otel"];
            NSObject *obj_email=[dic objectForKey:@"oemail"];
            NSObject *obj_photo=[dic objectForKey:@"img"];
            NSString *str_cell;
            NSString *str_phone;
            NSString *str_email;
            NSString *str_img;
            NSString *str_level;
            if (obj_cell==[NSNull null]) {
                str_cell=nil;
            }
            else {
                str_cell=(NSString*)obj_cell;
            }
            if (obj_phone==[NSNull null]) {
                str_phone=nil;
            }
            else {
                str_phone=(NSString*)obj_phone;
            }
            if (obj_email==[NSNull null]) {
                str_email=nil;
            }
            else {
                str_email=(NSString*)obj_email;
            }
            str_img =(NSString*)obj_photo;
            if ([str_img isEqualToString:@""] || str_img==nil) {
                obj_photo=[dic objectForKey:@"headimg"];
                if (obj_photo!=[NSNull null] && obj_photo!=nil) {
                    str_img=(NSString*)obj_photo;
                    [self DownloadImage:str_img name:str_name];
                }
                else {
                    str_img=@"";
                }
                
            }
            else {
                str_img=(NSString*)obj_photo;
                [self DownloadImage:str_img name:str_name];
            }
            
            if (node.nodeLevel==0) {
                str_level=@"0";
            }
            else if (node.nodeLevel==1) {
                str_level=@"1";
            }
            //   CLTreeViewNode *node=[self CreateLevel2Node:str_name signture:str_position headImgPath:@"headLogo.png" headImgUrl:nil gender:str_sex department:str_department cell:str_cell phone:str_phone email:str_email];
            CLTreeViewNode *node=[self CreateLevel2Node:str_name signture:str_position headImgPath:nil headImgUrl:str_img gender:str_sex department:str_department cell:str_cell phone:str_phone email:str_email parentLevel:str_level];
            [arr_staff addObject:node];
            
        }
    }
    if (node.sonNodes==nil) {
        node.sonNodes=arr_staff;
    }
    else {
        //zr 0824
        for (int i=0;i<[arr_staff count];i++) {
            CLTreeViewNode *subNode=[arr_staff objectAtIndex:i];
            [node.sonNodes addObject:subNode];
        }
        i_ungroup_num=[arr_staff count];
        //[node.sonNodes addObject:arr_staff];
        /*
        i_ungroup_num=0;
        CLTreeViewNode *node_tree=[node.sonNodes objectAtIndex:0];
        if (node_tree.nodeLevel==1) {
            NSUInteger i_count= [arr_staff count];
            NSString *str_count=[NSString stringWithFormat:@"%lu",(unsigned long)i_count];
            CLTreeViewNode *sub_node=[self CreateLevel1Node:@"未分组" sonCnt:str_count];
            sub_node.sonNodes=arr_staff;
            [node.sonNodes addObject:sub_node];
            i_ungroup_num=i_count;
        }
        */
        
    }
    
    return node;
}



#pragma mark 添加假数据所需的方法
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

-(CLTreeViewNode*)CreateLevel2Node:(NSString*)str_name signture:(NSString*)str_signture headImgPath:(NSString*)str_headImgPath headImgUrl:(NSString*)str_headImgUrl gender:(NSString*)str_gender department:(NSString*)str_department cell:(NSString*)str_cellphone phone:(NSString*)str_phonenum email:(NSString*)str_email parentLevel:(NSString*)str_level{
    CLTreeViewNode *node0 = [[CLTreeViewNode alloc]init];
    node0.nodeLevel = 2;
    node0.type = 2;
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;
    CLTreeView_LEVEL2_Model *tmp0 =[[CLTreeView_LEVEL2_Model alloc]init];
    tmp0.name = str_name;
    tmp0.signture = str_signture;
    tmp0.headImgPath = str_headImgPath;
    tmp0.headImgUrl = [NSURL URLWithString:str_headImgUrl];
    tmp0.gender=str_gender;
    tmp0.department=str_department;
    tmp0.cellphonenum=str_cellphone;
    tmp0.phonenum=str_phonenum;
    tmp0.email=str_email;
    tmp0.parentlevel=str_level;
    node0.nodeData = tmp0;
    
    return node0;
}


-(void)DownloadImage:(NSString*)str_img_link name:(NSString*)str_name {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    DataBase *db=[DataBase sharedinstanceDB];
    NSMutableArray *t_array=[db fetchIPAddress];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    
    [self RemoveLocalLogo:str_name];

    str_img_link=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_img_link];
    NSURL *URL = [NSURL URLWithString:str_img_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSString *str_filename=[NSString stringWithFormat:@"%@%@",str_name,@".jpg"];
        return [documentsDirectoryURL URLByAppendingPathComponent:str_filename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSString *str_filename=[NSString stringWithFormat:@"%@%@",str_name,@".jpg"];
        NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_filename];
        UIImage *img=[UIImage imageWithContentsOfFile:fullPath];
        if (img==nil) {
            
        }
       
        
    }];
    [downloadTask resume];
}

//zr 0811 当发现下载图片与已有图片有冲突时，先删除已有图片
-(void)RemoveLocalLogo:(NSString*)str_name {
    NSString *str_picname=[NSString stringWithFormat:@"%@.%@",str_name,@"jpg"];
    NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
    UIImage *img=[UIImage imageWithContentsOfFile:fullPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL bExist=[fileManager fileExistsAtPath:fullPath];
    if (bExist) {
        NSError *err;
        [fileManager removeItemAtPath:fullPath error:&err];
    }
    
}

@end

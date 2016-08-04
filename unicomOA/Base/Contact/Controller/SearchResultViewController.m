//
//  SearchResultViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/19.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MemberInfoViewController.h"

@implementation SearchResultViewController

-(void)viewDidLoad {
    //self.tableView.frame=CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic=self.dataArray[indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"empname"];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic=self.dataArray[indexPath.row];
    MemberInfoViewController *vc=[[MemberInfoViewController alloc]init];
    vc.str_Name=[dic objectForKey:@"empname"];
    vc.str_Gender=[dic objectForKey:@"sex"];
    vc.str_img=@"headLogo.png";
    vc.str_department=[dic objectForKey:@"orgname"];
    vc.str_carrer=[dic objectForKey:@"posiname"];
    NSObject *obj_cell=[dic objectForKey:@"mobileno"];
    NSObject *obj_tel=[dic objectForKey:@"otel"];
    NSObject *obj_email=[dic objectForKey:@"oemail"];
    NSString *str_cell=@"";
    NSString *str_tel=@"";
    NSString *str_email=@"";
    if (obj_cell!=[NSNull null]) {
        str_cell=(NSString*)obj_cell;
    }
    if (obj_tel!=[NSNull null]) {
        str_tel=(NSString*)obj_tel;
    }
    if (obj_email!=[NSNull null]) {
        str_email=(NSString*)obj_email;
    }
    vc.str_cellphone=str_cell;
    vc.str_phonenum=str_tel;
    vc.str_email=str_email;
    if (_nav!=nil) {
        [_nav pushViewController:vc animated:NO];
    }
    //[self.navigationController pushViewController:vc animated:YES];
    
   // [self presentViewController:vc animated:YES completion:nil];
    
}

@end

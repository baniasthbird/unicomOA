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
    vc.str_img=@"head.png";
    vc.str_department=[dic objectForKey:@"orgname"];
    vc.str_carrer=[dic objectForKey:@"posiname"];
    vc.str_cellphone=[dic objectForKey:@"mobileno"];
    vc.str_phonenum=[dic objectForKey:@"otel"];
    vc.str_email=[dic objectForKey:@"oemail"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

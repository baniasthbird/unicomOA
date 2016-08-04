//
//  SysMsgResultVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgResultVc.h"
#import "SysMsgDisplayController.h"

@implementation SysMsgResultVc

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSDictionary *dic=self.dataArray[indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"sendEmpname"];
    cell.detailTextLabel.text=[dic objectForKey:@"title"];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=self.dataArray[indexPath.row];
    SysMsgDisplayController *vc=[[SysMsgDisplayController alloc]init];
    NSString *str_id=[dic objectForKey:@"id"];
    vc.i_id=[str_id integerValue];
    vc.str_title=@"系统消息内容";
    vc.str_label=[dic objectForKey:@"title"];
    if (_nav!=nil) {
        [_nav pushViewController:vc animated:NO];
        // [self..navigationController pushViewController:vc animated:YES];
        [self.view setHidden:YES];
        UISearchController *searchControl=(UISearchController*)self.parentViewController;
        searchControl.active=NO;
    }

}

@end

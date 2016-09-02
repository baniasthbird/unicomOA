//
//  SearchResultViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/19.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MemberInfoViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "BaseFunction.h"

@implementation SearchResultViewController {
    UserInfo *usrInfo;
    BaseFunction *baseFunc;
}

-(void)viewDidLoad {
    //self.tableView.frame=CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height);
    [super viewDidLoad];
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
     usrInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    baseFunc=[[BaseFunction alloc]init];
   
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dic=self.dataArray[indexPath.row];
    NSString *str_name=[dic objectForKey:@"empname"];
    NSString *str_mobile=[baseFunc GetValueFromDic:dic key:@"mobileno"];
    NSString *str_tel=[baseFunc GetValueFromDic:dic key:@"otel"];
    NSString *str_num=[NSString stringWithFormat:@"%@    %@",str_mobile,str_tel];
    NSMutableAttributedString *str_lbl_name=[[NSMutableAttributedString alloc]initWithString:str_name];
    NSMutableAttributedString *str_lbl=[[NSMutableAttributedString alloc]initWithString:str_num];
    
    if ([baseFunc validateNumber:_str_key]) {
        NSInteger i_count =[baseFunc countOccurencesOfString:_str_key length:str_num];
        NSString *str_tmp=str_num;
        for (int i=0;i<i_count;i++) {
            NSRange rangeNum=[str_tmp rangeOfString:_str_key];
            if (rangeNum.location!=NSNotFound) {
                [str_lbl addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithRed:81/255.0f green:192/255.0f blue:251/255.0f alpha:1] range:NSMakeRange(rangeNum.location, rangeNum.length)];
            }
            str_tmp=[str_num substringFromIndex:(rangeNum.location+rangeNum.length)];
        }
    }
    else {
        [self ColorKeyWord:str_name label:str_lbl_name];
        
    }
    cell.textLabel.attributedText=str_lbl_name;
    cell.detailTextLabel.attributedText=str_lbl;
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
    //vc.str_img=@"headLogo.png";
   // if ([vc.str_Name isEqualToString:usrInfo.str_name]) {
    NSString *str_picname=[NSString stringWithFormat:@"%@.%@",vc.str_Name,@"jpg"];
    NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
    UIImage *img=[UIImage imageWithContentsOfFile:fullPath];
    if (img!=nil) {
         vc.str_img=fullPath;
    }
    else {
        vc.str_img=@"headLogo.png";
    }
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
        
        if (f_v<9.0) {
            //zr 0809  不能直接传uinavigationcontroller
            AppDelegate *app=[[UIApplication sharedApplication] delegate];
            UINavigationController *nav=[[app.window.rootViewController.childViewControllers objectAtIndex:1].childViewControllers objectAtIndex:1];
            [nav pushViewController:vc animated:YES];

        }
        else {
            [_nav pushViewController:vc animated:NO];
        }
        
    }
    //[self.navigationController pushViewController:vc animated:YES];
    
   // [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)dealloc {
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
}

//强调关键字
-(void)ColorKeyWord:(NSString*)str_org label:(NSMutableAttributedString*)lbl_org{
    NSInteger i_count =[baseFunc countOccurencesOfString:_str_key length:str_org];
    NSString *str_tmp=str_org;
    for (int i=0;i<i_count;i++) {
        NSRange range=[str_tmp rangeOfString:_str_key];
        if (range.location!=NSNotFound) {
            [lbl_org addAttribute:NSForegroundColorAttributeName  value:[UIColor colorWithRed:81/255.0f green:192/255.0f blue:251/255.0f alpha:1] range:NSMakeRange(range.location, range.length)];
        }
        str_tmp=[str_org substringFromIndex:(range.location+range.length)];
    }

}


@end

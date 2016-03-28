//
//  SettingViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SettingViewController.h"
#import "LGSettingItem.h"
#import "LGSettingSection.h"
#import "NewsSettingViewController.h"
#import "PasswordViewController.h"
#import "SendFeedBackViewController.h"
#import "AboutViewController.h"
#import "StaffInfoViewController.h"


@interface SettingViewController ()
@property (strong,nonatomic) NSMutableArray *groups;
@end

@implementation SettingViewController


- (NSMutableArray *) groups
{
    if (!_groups) {
        _groups=[NSMutableArray array];
    }
    return _groups;
}

-(instancetype)init {
    
    
    self.title = @"我";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    
    //设置样式
    return [self initWithStyle:UITableViewStyleGrouped];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.title = @"我";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    [self.navigationItem setHidesBackButton:YES];
    
    //添加第一组
    LGSettingSection *section1=[LGSettingSection initWithHeaderTitle:@"Demo" footerTitle:nil];
    //添加行
    LGSettingItem *item1=[LGSettingItem initWithtitle:@"张三"];
    item1.image=[UIImage imageNamed:@"me"];
    item1.height=64;
    [section1 addItem:item1];
    //保存到groups数组
    [self.groups addObject:section1];
    
    //添加第二组
    LGSettingSection *section2=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
    [section2 addItemWithTitle:@"新消息通知"];
    [section2 addItemWithTitle:@"修改密码"];
    [section2 addItemWithTitle:@"清除缓存"];
    [self.groups addObject:section2];
    
    //添加第三组
    LGSettingSection *section3=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
    [section3 addItemWithTitle:@"意见反馈"];
    [section3 addItemWithTitle:@"关于"];
    [self.groups addObject:section3];
    
    //添加第四组
    LGSettingSection *section4=[LGSettingSection initWithHeaderTitle:@"" footerTitle:@"2016 河南软信"];
    //添加行
    LGSettingItem *item4=[LGSettingItem initWithtitle:@"                          退出当前账号"];
   // item4.type=UITableViewCellAccessoryDetailDisclosureButton;
    [section4 addItem:item4];

   // [section4 addItemWithTitle:@"退出当前账号"];
    [self.groups addObject:section4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Table view data source

/**
 设置数组
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}


/**
 设置行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LGSettingSection *group=self.groups[section];
    return group.items.count;
}

/**
 设置每行内容
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    LGSettingSection *section=self.groups[indexPath.section];
    LGSettingItem *item= section.items[indexPath.row];
    
    //设置Cell的标题
    cell.textLabel.text=item.title;
    //设置Cell左边的图标
    cell.imageView.image=item.image;
    //设置cell右边的图标
    cell.accessoryType=item.type;
    
    if (indexPath.section==3 && indexPath.row==0) {
        cell.textLabel.textColor=[UIColor redColor];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LGSettingSection *group=self.groups[section];
    return  group.headerTitle;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    LGSettingSection *group=self.groups[section];
    return group.footerTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LGSettingSection *section=self.groups[indexPath.section];
    LGSettingItem *item=section.items[indexPath.row];
    return item.height;
}


#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"点击了第%ld组，第%ld行",indexPath.section,indexPath.row);
    if (indexPath.section==0 && indexPath.row==0) {
        StaffInfoViewController *staffController=[[StaffInfoViewController alloc]init];
        [self.navigationController pushViewController:staffController animated:YES];
    }
    else if (indexPath.section==1 && indexPath.row==0) {
        NewsSettingViewController *newsController=[[NewsSettingViewController alloc]init];
        [self.navigationController pushViewController:newsController animated:YES];
    }
    else if (indexPath.section==1 && indexPath.row==1) {
        PasswordViewController *passwordController=[[PasswordViewController alloc]init];
        [self.navigationController pushViewController:passwordController animated:YES];
    }
    else if (indexPath.section==1 && indexPath.row==2) {
        NSString *alert_title=@"警告";
        NSString *alert_message=@"是否清空所有的缓存数据";
        NSString *cancelButtonTitle=@"否";
        NSString *otherButtonTitle=@"是";
        
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:alert_title message:alert_message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }];
        
        UIAlertAction *otherAction=[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"点击了确定按钮");
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

        
    }
    else if (indexPath.section==2 && indexPath.row==0) {
        SendFeedBackViewController *sendController=[[SendFeedBackViewController alloc]init];
        [self.navigationController pushViewController:sendController animated:YES];
    }
    else if (indexPath.section==2 && indexPath.row==1) {
        AboutViewController *aboutController=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    else {
        NSLog(@"点击了第%ld组，第%ld行",indexPath.section,indexPath.row);
    }
}
/*
 
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

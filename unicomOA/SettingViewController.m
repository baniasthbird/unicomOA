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
#import "LXAlertView.h"
#import "AFHTTPSessionManager.h"
#import "DataBase.h"
#import "LoginViewController.h"


@interface SettingViewController ()
@property (strong,nonatomic) NSMutableArray *groups;

//连接
@property (nonatomic,strong) AFHTTPSessionManager *session;
@end

@implementation SettingViewController {
    DataBase *db;
}

static NSString *kServerSessionCookie=@"JSESSIONID";

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
    
    self.view.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    //添加第一组
    LGSettingSection *section1=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
    LGSettingItem *item1=[LGSettingItem initWithtitle:_userInfo.str_name];
    item1.image=[UIImage imageNamed:_userInfo.str_Logo];
    if (iPhone5_5s || iPhone4_4s) {
        item1.height=112;
    }
    else if (iPhone6) {
        item1.height=133;
    }
    else {
        item1.height=147;
    }
    item1.type=UITableViewCellAccessoryNone;
    [section1 addItem:item1];
    //保存到groups数组
    [self.groups addObject:section1];
    
    //添加第二组
    LGSettingSection *section2=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
   // [section2 addItemWithTitle:@"新消息通知"];
    [section2 addItemWithTitle:@"修改密码"];
    [section2 addItemWithTitle:@"清除缓存"];
    [self.groups addObject:section2];
    
    //添加第三组
    LGSettingSection *section3=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
  //  [section3 addItemWithTitle:@"意见反馈"];
    [section3 addItemWithTitle:@"关于"];
    [self.groups addObject:section3];
    
    
    //添加第四组
    LGSettingSection *section4=[LGSettingSection initWithHeaderTitle:@"" footerTitle:@""];
    //添加行
    LGSettingItem *item4=[LGSettingItem initWithtitle:@""];

    item4.type=UITableViewCellAccessoryNone   ;
    [section4 addItem:item4];
    

   // [section4 addItemWithTitle:@"退出当前账号"];
    [self.groups addObject:section4];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=NO;
     
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
    
    
    
    if (indexPath.section==0 && indexPath.row==0) {
        
        UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-item.height*0.8)/2, item.height*0.2, item.height*0.8, item.height*0.8)];
        img_View.layer.cornerRadius=item.height*0.4;
        
        img_View.layer.masksToBounds=YES;
        
        UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, item.height*0.77, 100, 20)];
        
        if (self.userInfo!=nil) {
            img_View.image=item.image;
            lbl_title.text=item.title;
        }
        else {
        
        }

        
        lbl_title.textColor=[UIColor colorWithRed:72/255.0f green:117/255.0f blue:230/255.0f alpha:1];
        lbl_title.font=[UIFont systemFontOfSize:20];
        [cell addSubview:lbl_title];
       // cell.textLabel.textColor=[UIColor colorWithRed:72/255.0f green:117/255.0f blue:230/255.0f alpha:1];
        [cell addSubview:img_View];
        UIImageView *img_bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        img_bgView.image=[UIImage imageNamed:@"logoimage.png"];
        cell.backgroundView=img_bgView;
        
    }
    else {
        //设置Cell的标题
        cell.textLabel.text=item.title;

        cell.textLabel.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
    }
    //设置Cell左边的图标
   // cell.imageView.image=item.image;
    //设置cell右边的图标
    cell.accessoryType=item.type;
    
    
    
    if (indexPath.section==3 && indexPath.row==0) {
        UIButton *btn=[[UIButton alloc]init];
        [btn setFrame:CGRectMake(self.view.frame.size.width*0.15, cell.frame.origin.y, self.view.frame.size.width*0.7, cell.frame.size.height)];
        [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius=25.0f;
        [btn setBackgroundColor:[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1]];
        [btn addTarget:self action:@selector(QuitUser:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        cell.backgroundColor=[UIColor clearColor];
       // cell.textLabel.textColor=[UIColor redColor];
       // cell.textLabel.textAlignment=NSTextAlignmentCenter;
        
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
    if (indexPath.section==0 && indexPath.row==0) {
        if (iPhone4_4s || iPhone5_5s)
           return 122;
        else if (iPhone6) {
            return 143;
        }
        else {
            return 157;
        }
    }
    else {
        LGSettingSection *section=self.groups[indexPath.section];
        LGSettingItem *item=section.items[indexPath.row];
        return item.height;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==3) {
        return 60;
    }
    else if (section==0) {
        return 0.1;
    }
    else if (section==1 || section==2){
        return 10;
    }
    else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
        
}


#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"点击了第%ld组，第%ld行",indexPath.section,indexPath.row);
    
    if (indexPath.section==0 && indexPath.row==0) {
        StaffInfoViewController *staffController=[[StaffInfoViewController alloc]init];
        staffController.userInfo=_userInfo;
        [self.navigationController pushViewController:staffController animated:YES];
    }
    /*
    else if (indexPath.section==0 && indexPath.row==0) {
        NewsSettingViewController *newsController=[[NewsSettingViewController alloc]init];
        [self.navigationController pushViewController:newsController animated:YES];
    }
    */
    else if (indexPath.section==1 && indexPath.row==0) {
        PasswordViewController *passwordController=[[PasswordViewController alloc]init];
        [self.navigationController pushViewController:passwordController animated:YES];
    }
    else if (indexPath.section==1 && indexPath.row==1) {
        /*
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
        
        
        
        [otherAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        */
        
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"是否清空所有缓存数据" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
             NSLog(@"点击index====%ld",clickIndex);
        }];
        [alert showLXAlertView];
        
    }
    else if (indexPath.section==2 && indexPath.row==0) {
      //  SendFeedBackViewController *sendController=[[SendFeedBackViewController alloc]init];
      //  [self.navigationController pushViewController:sendController animated:YES];
        AboutViewController *aboutController=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    /*
    else if (indexPath.section==2 && indexPath.row==1) {
        AboutViewController *aboutController=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    */
    else {
        NSLog(@"点击了第%ld组，第%ld行",indexPath.section,indexPath.row);
    }
}



-(void)QuitUser:(UIButton*)sender {
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_interface=[db fetchInterface:@"Logout"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_interface];
        
        [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功:%@",responseObject);
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求JSON成功:%@",JSON);
            NSString *str_success= [JSON objectForKey:@"success"];
            int i_success=[str_success intValue];
            if (i_success==1) {
                NSLog(@"退出成功");
                //显示登陆
                //显示未登陆
               // [self ClearUserInfo];
                [self QuitApp];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //离线模式
            
        }];
    
    
}

//退出应用
-(void)QuitApp {
    
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"是否确定退出应用？" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex==0) {
            return;
        }
        else if (clickIndex==1) {
            //清除所有的存储本地的数据
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [defaults dictionaryRepresentation];
            for (id  key in dic) {
                [defaults removeObjectForKey:key];
            }
            [defaults synchronize];
            LoginViewController *login=[[LoginViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
            [[UIApplication sharedApplication] keyWindow].rootViewController=nav;
            
            [self presentViewController:[[UIApplication sharedApplication] keyWindow].rootViewController animated:YES completion:nil];
           // NSArray *arr_vc=[NSArray arrayWithObjects:vc, nil];
           // [self.navigationController setViewControllers:arr_vc animated:YES];
        }
    }];
    [alert showLXAlertView];
}


//更改UserInfo为空，显示未登录
-(void)ClearUserInfo {
    self.userInfo=nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"user"];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lbl_txt=(UILabel*)[cell.subviews objectAtIndex:2];
    lbl_txt.text=@"";
    UIImageView *img=(UIImageView*)[cell.subviews objectAtIndex:3];
    img.image=nil;
    //NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}


//判断是在线还是离线
-(BOOL)isLocal {
    NSString *File=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithContentsOfFile:File];
    BOOL isLocal=  [dict objectForKey:@"blocal"];
    return isLocal;
    
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

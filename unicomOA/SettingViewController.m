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
#import "YBMonitorNetWorkState.h"
#import "UIImageView+WebCache.h"


@interface SettingViewController ()<YBMonitorNetWorkStateDelegate>
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
    
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }

    
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

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"出现");
       [self.tableView reloadData];
    /*
    NSIndexPath *i_in、？dexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:i_indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.title = @"我";
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }

    
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
    LGSettingItem *item1=[LGSettingItem initWithtitle:_userInfo.str_name type:UITableViewCellAccessoryNone];
    NSString *str_tmp_picname=[NSString stringWithFormat:@"%@%@",_userInfo.str_name,@".jpg"];
    if ([_userInfo.str_Logo isEqualToString:@"headLogo.png"]) {
        item1.image=[UIImage imageNamed:_userInfo.str_Logo];
    }
    else if ([_userInfo.str_Logo isEqualToString:str_tmp_picname]) {
        /*
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_userInfo.str_imgurl]];
        
        item1.image = [UIImage imageWithData:data];
         */
        /*
        UIImageView *img_View=[[UIImageView alloc]init];
      //  [img_View sd_setImageWithURL:[NSURL URLWithString:_userInfo.str_imgurl] placeholderImage:[UIImage imageNamed:str_tmp_picname]];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:_userInfo.str_imgurl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                img_View.image=image;
            }
        }];
        */
        
        NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_tmp_picname];
        UIImage *saveImage=[[UIImage alloc]initWithContentsOfFile:fullPath];
        if (saveImage!=nil) {
             item1.image=saveImage;
        }
        else {
            item1.image=[UIImage imageNamed:@"headLogo.png"];
        }
       
        
        
    }
    else {
        //item1.image=[UIImage imageWithContentsOfFile:_userInfo.str_Logo];
        NSString *str_picname=[NSString stringWithFormat:@"%@.%@",_userInfo.str_username,@"png"];
        NSString *fullPath=  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:str_picname];
        UIImage *saveImage=[[UIImage alloc]initWithContentsOfFile:fullPath];
        
        item1.image=saveImage;
    }
    
    if (iPhone5_5s || iPhone4_4s) {
        item1.height=112;
    }
    else if (iPhone6) {
        item1.height=133;
    }
    else if (iPhone6_plus) {
        item1.height=147;
    }
    else if (iPad) {
        item1.height=292;
    }
    item1.type=UITableViewCellAccessoryNone;
    [section1 addItem:item1];
    //保存到groups数组
    [self.groups addObject:section1];
    
    //添加第二组
    LGSettingSection *section2=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
   // [section2 addItemWithTitle:@"新消息通知"];
    [section2 addItemWithTitle:@"修改密码" type:UITableViewCellAccessoryDisclosureIndicator];
    [section2 addItemWithTitle:@"清除缓存" type:UITableViewCellAccessoryNone];
    [self.groups addObject:section2];
    
    //添加第三组
    LGSettingSection *section3=[LGSettingSection initWithHeaderTitle:@"" footerTitle:nil];
    //添加行
  //  [section3 addItemWithTitle:@"意见反馈"];
    [section3 addItemWithTitle:@"关于" type:UITableViewCellAccessoryDisclosureIndicator];
    [self.groups addObject:section3];
    
    
    //添加第四组
    LGSettingSection *section4=[LGSettingSection initWithHeaderTitle:@"" footerTitle:@""];
    //添加行
    LGSettingItem *item4=[LGSettingItem initWithtitle:@"" type:UITableViewCellAccessoryNone];

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
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    LGSettingSection *section=self.groups[indexPath.section];
    LGSettingItem *item= section.items[indexPath.row];
    
    
    
    if (indexPath.section==0 && indexPath.row==0) {
        
        UIImageView *img_View;
        if (iPad) {
            img_View=[[UIImageView alloc]initWithFrame:CGRectMake(284, 75, 200, 200)];
            img_View.layer.cornerRadius=100.0f;
        }
        else {
            img_View=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-item.height*0.8)/2, item.height*0.2, item.height*0.8, item.height*0.8)];
            img_View.layer.cornerRadius=item.height*0.4;

        }
        
        
        img_View.layer.masksToBounds=YES;
        
        UILabel *lbl_title;
        if (iPad) {
             lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(50,200, 150, 40)];
        }
        else {
            lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05,item.height*0.77, 100, 20)];
        }
        
        
        if (self.userInfo!=nil) {
            img_View.image=item.image;
            lbl_title.text=item.title;
        }
        else {
        
        }

        
        lbl_title.textColor=[UIColor colorWithRed:72/255.0f green:117/255.0f blue:230/255.0f alpha:1];
        if (!iPad) {
            lbl_title.font=[UIFont systemFontOfSize:20];
            UIImageView *img_bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            img_bgView.image=[UIImage imageNamed:@"logoimage.png"];
            cell.backgroundView=img_bgView;
        }
        else {
            lbl_title.font=[UIFont systemFontOfSize:26];
            UIImageView *img_bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 292)];
            img_bgView.image=[UIImage imageNamed:@"logoimage-IPad.png"];
            cell.backgroundView=img_bgView;
        }
       
        [cell addSubview:lbl_title];
       // cell.textLabel.textColor=[UIColor colorWithRed:72/255.0f green:117/255.0f blue:230/255.0f alpha:1];
        [cell addSubview:img_View];
        
        
        
    }
    else {
        //设置Cell的标题
        cell.textLabel.text=item.title;
        if ([item.title isEqualToString:@"清除缓存"]) {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"(%.2fM)",[self filePath]];
            
        }

        cell.textLabel.textColor=[UIColor colorWithRed:174/255.0f green:174/255.0f blue:174/255.0f alpha:1];
        if (iPad) {
            cell.textLabel.font=[UIFont systemFontOfSize:26];
        }
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
        if (iPad) {
            btn.titleLabel.font=[UIFont systemFontOfSize:26];
        }
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
        else if (iPhone6_plus) {
            return 157;
        }
        else {
            return 292;
        }
    }
    else {
        LGSettingSection *section=self.groups[indexPath.section];
        LGSettingItem *item=section.items[indexPath.row];
        if (!iPad) {
            return item.height;
        }
        else {
            return 80;
        }
        
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==3) {
        if (iPhone5_5s) {
            return 130;
        }
        else if (iPhone6) {
            return 190;
        }
        else if (iPhone6_plus) {
            return 240;
        }
        else if (iPad){
            return 300;
        }
        else {
            return 60;
        }
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
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:staffController animated:NO];
    }
    /*
    else if (indexPath.section==0 && indexPath.row==0) {
        NewsSettingViewController *newsController=[[NewsSettingViewController alloc]init];
        [self.navigationController pushViewController:newsController animated:YES];
    }
    */
    else if (indexPath.section==1 && indexPath.row==0) {
        PasswordViewController *passwordController=[[PasswordViewController alloc]init];
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:passwordController animated:NO];
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
        /*
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"是否清空所有缓存数据" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex==1) {
                NSLog(@"点击index====%ld",(long)clickIndex);
                [alert setHidden:YES];
            }
             NSLog(@"点击index====%ld",(long)clickIndex);
        }];
        [alert showLXAlertView];
        */
         [self clearFile];
    }
    else if (indexPath.section==2 && indexPath.row==0) {
      //  SendFeedBackViewController *sendController=[[SendFeedBackViewController alloc]init];
      //  [self.navigationController pushViewController:sendController animated:YES];
        AboutViewController *aboutController=[[AboutViewController alloc]init];
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:aboutController animated:NO];
    }
    /*
    else if (indexPath.section==2 && indexPath.row==1) {
        AboutViewController *aboutController=[[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    */
    else {
        NSLog(@"点击了第%ld组，第%ld行",(long)indexPath.section,indexPath.row);
    }
}



-(void)QuitUser:(UIButton*)sender {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
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
    else {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
    
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
                if ([key isEqualToString:@"name"] || [key isEqualToString:@"password"] || [key isEqualToString:@"everLaunched"] || [key isEqualToString:@"systemversion"] || [key isEqualToString:@"firstLaunch"] || [key isEqualToString:@"connection"]) {
                    continue;
                }
                else {
                    [defaults removeObjectForKey:key];
                }
            }
            [defaults synchronize];
            
            LoginViewController *login=[[LoginViewController alloc]init];
            login.b_update=NO;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
            [[UIApplication sharedApplication] keyWindow].rootViewController=nav;
            
            [self presentViewController:[[UIApplication sharedApplication] keyWindow].rootViewController animated:NO completion:nil];
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




-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}



- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
        
    }
    
    return 0;
}

-( float )folderSizeAtPath:(NSString*)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFielsEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    
    long long folderSize=0;
    
    while ((fileName=[childFielsEnumerator nextObject])!=nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
}

//显示缓存大小
-(float)filePath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    float f_cache=[self folderSizeAtPath:cachePath];
    float f_doc=[self folderSizeAtPath:docPath];
    float f_path=f_cache+f_doc;
    return f_path;
}

//清理缓存
-(void)clearFile {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"cachePath = %@", cachePath);
    
    for (NSString *p in files) {
        NSError *error = nil;
        NSString *path = [cachePath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *doc_files=[[NSFileManager defaultManager] subpathsAtPath:docPath];
    NSLog(@"cachePath = %@", docPath);
    for (NSString *p in doc_files) {
        NSError *error = nil;
        NSString *path = [docPath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }

    [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
}

-(void)clearCacheSuccess {
    NSLog(@"清理成功");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存清理完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [self.tableView reloadData];
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

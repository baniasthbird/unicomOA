//
//  MessageViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MessageViewController.h"
#import "RemindViewController.h"
#import "RemindCell.h"
#import "NewsListCell.h"



@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property  NSInteger count;

@property int i_doc_num;

@property int i_flow_num;

@property int i_msg_num;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSArray *arr_NewsList;

@property CGFloat i_Height;

@end

@implementation MessageViewController {
    DataBase *db;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title = @"消息";

    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    _i_Height=0;
    if (iPhone6) {
        _i_Height=50;
    }
    else if (iPhone5_5s) {
        _i_Height=37;
    }
    else if (iPhone6_plus) {
        _i_Height=55;
    }
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    
    [self.view addSubview:_tableView];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    /*
    if ([self isLocal]) {
        _count=5;
    }
    else {
     */
        [self NewsCount];
    [self NewsList];
    //}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获得最新消息
-(void)NewsCount {
    NSString *str_taskCount= [db fetchInterface:@"TaskCount"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url1=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_taskCount];
       [_session POST:str_url1 parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSLog(@"请求未读消息成功:%@",responseObject);
           NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           NSString *str_success= [JSON objectForKey:@"success"];
           int i_success=[str_success intValue];
           if (i_success==1) {
               NSString *str_docnum= [JSON objectForKey:@"docNum"];
               NSString *str_flownum= [JSON objectForKey:@"flowNum"];
               NSString *str_msgnum= [JSON objectForKey:@"msgNum"];
               _i_doc_num=[str_docnum intValue];
               _i_flow_num=[str_flownum intValue];
               _i_msg_num=[str_msgnum intValue];
               _count=_i_doc_num+_i_flow_num+_i_msg_num;
               NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
               [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
           }
           
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"请求失败");
       }];
}


//获得最新新闻
-(void)NewsList {
    NSString *str_newsList= [db fetchInterface:@"NewsList"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsList];
    [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取新闻列表成功:%@",responseObject);
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        int i_success=[str_success intValue];
        if (i_success==1) {
             _arr_NewsList=[JSON objectForKey:@"list"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50;
    }
    else {
        return _i_Height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 30;
    }
    else {
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 30;
    }
    else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section==0) {
            RemindCell *r_cell=[RemindCell cellWithTable:tableView Count:_count];
            return r_cell;
        }
        else {
            if (_arr_NewsList==nil) {
                cell.textLabel.text=@"aaa";
            }
            else {
                NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.row];
                NewsListCell *cell=[NewsListCell cellWithTable:tableView dic:dic_content cellHeight:_i_Height];
                return cell;
                
            }
        }
    }
    
    
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frameRect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
    
    label.textAlignment=NSTextAlignmentLeft;
    
    CGFloat i_Float=0;
    if (iPhone4_4s || iPhone5_5s) {
        i_Float=16;
    }
    else {
        i_Float=20;
    }
    
    label.font=[UIFont systemFontOfSize:i_Float];
    
   // label.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    
    if (section==1) {
        label.text=@"    新闻公告";
    }
   
    return label;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view_end=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view_end.backgroundColor=[UIColor whiteColor];
    if (section==0) {
        return view_end;
    }
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            RemindViewController *viewController=[[RemindViewController alloc]init];
            viewController.userInfo=_userInfo;
            //传入各个新闻的数量 zr 0504
            viewController.i_index1=_i_flow_num;
            viewController.i_index2=_i_doc_num;
            viewController.i_index3=_i_msg_num;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
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

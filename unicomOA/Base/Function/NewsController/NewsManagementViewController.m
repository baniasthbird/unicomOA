//
//  NewsManagementViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/9.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsManagementViewController.h"
#import "NewsFocusViewController.h"
#import "NIDropDown.h"
#import "NewsManagementTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "NewsDisplayViewController.h"
#import "UIView+Frame.h"
#import "WZLBadgeImport.h"
#import "UIImageButton.h"


@interface NewsManagementViewController ()

@property (strong,nonatomic) NSMutableArray *arr_News;

@property (strong,nonatomic) NSMutableArray *arr_Focus;

@end

@implementation NewsManagementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"公告";
    
    UIButton *btn_focus=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [btn_focus setTitle:@"关注列表" forState:UIControlStateNormal];
    [btn_focus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_focus addTarget:self action:@selector(FocusNews:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_focus];
    
    
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    
    [self buildView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)buildDataSource {
    
}

-(void)buildView {
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.005, self.view.frame.size.height/5, self.view.frame.size.width*0.99, self.view.frame.size.height) style:UITableViewStylePlain];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.dataSource=self;
    
    _tableView.delegate=self;
    
    if (iPhone4_4s || iPhone5_5s) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.123, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.115, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.113, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    
    [_btn_Select setTitle:@"类别" forState:UIControlStateNormal];
    [_btn_Select setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btn_Select setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1]];
    _btn_Select.layer.borderWidth=1;
    _btn_Select.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _btn_Select.layer.cornerRadius=5;
    [_btn_Select addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone4_4s || iPhone5_5s) {
       _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.123, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.115, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
        _txt_Search=[[UITextField alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.113, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    
    _txt_Search.layer.borderWidth=1;
    _txt_Search.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _txt_Search.layer.cornerRadius=5;
    _txt_Search.placeholder=@"请输入搜索关键字";
    [_txt_Search setTextColor:[UIColor blackColor]];
    
    
    [self.view addSubview:_btn_Select];
    [self.view addSubview:_tableView];
    [self.view addSubview:_txt_Search];
    
    self.view.backgroundColor=[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0 alpha:1];
    
    _arr_News=[NSMutableArray arrayWithCapacity:2];
    
    
    _arr_Focus=[NSMutableArray arrayWithCapacity:0];
}

-(void)FocusNews:(UIButton*)Btn {
    NewsFocusViewController *focusViewController=[[NewsFocusViewController alloc]init];
    [self.navigationController pushViewController:focusViewController animated:YES];
    
}

-(void)BackToAppCenter:(UIButton*)Btn {
   
    [self.delegate ClearNewsRedDot];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma tableView必备方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsManagementTableViewCell *cell;
    if (iPhone6 || iPhone6_plus)
    {
         cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width*0.4 TimeH:40.0f];
    }
    
   
    cell.delegate=self;
    cell.myTag=indexPath.row;
    cell.lbl_Title.text=[NSString stringWithFormat:@"%@|%ld",@"国家发展改革委关于放开部分建设项目服务收费标准有关问题的通知",(long)indexPath.row];
    cell.lbl_department.text=@"综合管理部 张三";
    cell.lbl_time.text=@"2016-01-26 16:45";
    
    if (_b_hasnews==NO) {
        if (indexPath.section==0 && indexPath.row==1) {
            cell.backgroundColor=[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
        }
    }
    
    
    return cell;
    
    /*
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    return cell;
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
      return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)selectClicked:(UIButton*)sender {
    NSArray *arr=[[NSArray alloc]init];
    arr=[NSArray arrayWithObjects:@"全部",@"公司通知",@"部门通知",@"内部新闻",@"外部新闻",@"规章制度",nil];
    NSArray *arrImage=[[NSArray alloc]init];
    arrImage=[NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],nil];
    if (dropDown==nil) {
        CGFloat f=240;
        dropDown =[[NIDropDown alloc] showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate=self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(void)rel {
    dropDown=nil;
}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender {
    [self rel];
    NSLog(@"%@",_btn_Select.titleLabel.text);
}

-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    
}

-(void)tapCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
#pragma mark 红点通知消除
    if (_b_hasnews==NO) {
        if (cell.backgroundColor!=[UIColor clearColor])
        {
            NSString *str_badgevalue= [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue;
            int i_badgevalue=[str_badgevalue intValue];
            i_badgevalue=i_badgevalue-1;
            [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue=[NSString stringWithFormat:@"%d",i_badgevalue];
            cell.backgroundColor=[UIColor clearColor];
            
        }
    }
    
    
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    news_controller.news_index=&(index);
    news_controller.str_label=cell.lbl_Title.text;
    news_controller.str_depart=cell.lbl_department.text;
    news_controller.delegate=self;
    [self.navigationController pushViewController:news_controller animated:YES];
    
}

-(void)passFocusValue:(NSString *)str_title {
    if (str_title!=nil) {
        [_arr_Focus addObject:str_title];
    }
    NSLog(@"传值成功");
}

@end

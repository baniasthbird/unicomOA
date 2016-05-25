//
//  LYThreeViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/5/3.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LYThreeViewController.h"
#import "UnReadMessageCell.h"
#import "AFHTTPSessionManager.h"
#import "DataBase.h"
#import "LXAlertView.h"


@interface LYThreeViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSString *str_totalPage;

@property (nonatomic,strong) NSMutableArray *arr_ContentList;

@property CGFloat i_Height;

@property NSInteger i_index;

@property NSMutableDictionary *param;

@property (nonatomic,strong) UITextField *txt_pages;

@property (nonatomic,strong) UILabel *lbl_totalpages;


//连接
@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation LYThreeViewController {
    DataBase *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    _i_Height=0;
    if (iPhone6) {
        _i_Height=70;
    }
    else if (iPhone5_5s) {
        _i_Height=50;
    }
    else if (iPhone6_plus) {
        _i_Height=80;
    }
    _arr_ContentList=[[NSMutableArray alloc]init];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    _param=[NSMutableDictionary dictionary];
    _i_index=1;
    _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_index];
    [self GetFlowList:_param];
    
    
    
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-140) style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
     _tableview.allowsSelection=NO;
    
    [self.view addSubview:_tableview];
    
    
    UIButton *btn_previous=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.15, self.view.frame.size.height-190,self.view.frame.size.width*0.2, 25)];
    [btn_previous setTitle:@"上一步" forState:UIControlStateNormal];
    [btn_previous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // btn_previous.layer.borderWidth=1;
    [btn_previous addTarget:self action:@selector(Previous:) forControlEvents:UIControlEventTouchUpInside];
    //[btn_previous setBackgroundColor:[UIColor yellowColor]];
    
    UIButton *btn_next=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.65, self.view.frame.size.height-190, self.view.frame.size.width*0.2, 25)];
    [btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    [btn_next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // btn_previous.layer.borderWidth=1;
    [btn_next addTarget:self action:@selector(Next:) forControlEvents:UIControlEventTouchUpInside];
    //[btn_next setBackgroundColor:[UIColor lightGrayColor]];
    
    _lbl_totalpages=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5,self.view.frame.size.height-190 , self.view.frame.size.width*0.1, 25)];
    _lbl_totalpages.font=[UIFont systemFontOfSize:10];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _txt_pages=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.45,self.view.frame.size.height-190,self.view.frame.size.width*0.05, 25)];
    _txt_pages.placeholder=@"1";
    _txt_pages.delegate=self;
    _txt_pages.keyboardType=UIKeyboardTypePhonePad;
    _txt_pages.font=[UIFont systemFontOfSize:10];
    //  [_txt_pages addTarget:self action:@selector(ValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //[self.view addSubview:btn_previous];
   // [self.view addSubview:btn_next];
   // [self.view addSubview:_lbl_totalpages];
   // [self.view addSubview:_txt_pages];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)GetFlowList:(NSMutableDictionary*)param {
    db=[DataBase sharedinstanceDB];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_FlowList=[db fetchInterface:@"UnreadMessage"];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_FlowList];
    [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求未读消息成功:%@",responseObject);
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success=[JSON objectForKey:@"success"];
        int i_success=[str_success intValue];
        if (i_success==1) {
            _str_totalPage=[JSON objectForKey:@"totalPage"];
            _lbl_totalpages.text=[NSString stringWithFormat:@"%@%@",@"\\",_str_totalPage];
            NSArray *arr_tmp=[JSON objectForKey:@"list"];
            for (int i=0;i<[arr_tmp count];i++) {
                [_arr_ContentList addObject:[arr_tmp objectAtIndex:i]];
            }
            //[_arr_ContentList addObject:arr_tmp];
            [self.tableview reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        
    }];
    
}



#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_ContentList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_arr_ContentList!=nil) {
        NSDictionary *dic_content=[_arr_ContentList objectAtIndex:indexPath.row];
        UnReadMessageCell *cell=[UnReadMessageCell cellWithTable:tableView dic:dic_content cellHeight:_i_Height];
        return cell;
    }
    else {
        static NSString *ID=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:16];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.textColor=[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1];
            cell.textLabel.text=@"工作";
            cell.detailTextLabel.text=@"流程";
        }
        return cell;
    }

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _i_Height;
}


-(void)Previous:(UIButton*)sender {
    if (_i_index>1) {
        _i_index=_i_index-1;
        _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_index];
        [self GetFlowList:_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_index];
    }
    
}

-(void)Next:(UIButton*)sender {
    if (_i_index<[_str_totalPage integerValue]) {
        _i_index=_i_index+1;
        _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_index];
        [self GetFlowList:_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_index];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_txt_pages resignFirstResponder];
    return YES;
}





-(IBAction)textFieldDidEndEditing:(UITextField *)textField {
    NSString *str_text=_txt_pages.text;
    NSInteger i_text=[str_text integerValue];
    if (i_text>[_str_totalPage integerValue]) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"输入页数超过范围" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            _txt_pages.text=@"1";
        }];
        [alert showLXAlertView];
    }
    else {
        _i_index=[str_text integerValue];
        _param[@"pageIndex"]=str_text;
        [self GetFlowList:_param];
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        //  NSLog((@"end of table"));
        if (_i_index<[_str_totalPage integerValue]) {
            _i_index=_i_index+1;
            _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_index];
            [self GetFlowList:_param];
            //self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_index];
        }
    }
}



@end

//
//  CommentViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CommentViewController.h"
//#import "IQKeyboardManager.h"
//#import "IQKeyboardReturnKeyHandler.h"
//#import "IQUIView+IQKeyboardToolbar.h"
#import "CommentCell.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arr_comment;

@property (nonatomic,strong) UITextField *txt_comment;

@property (nonatomic,strong) NSMutableArray *arr_comment_add;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableDictionary *param;

@property (nonatomic,strong) NSMutableDictionary *addComment_param;

@property (nonatomic,strong) UILabel *lbl_label;

@property (nonatomic,strong) UITextField *txt_pages;

//评论数量多时的页面总数
@property NSInteger i_totalPage;

//评论数量多时引用的索引
@property NSInteger i_pageIndex;

@end

@implementation CommentViewController
{
    int prewTag;
    float prewMoveY;
   // IQKeyboardReturnKeyHandler *returnKeyHandler;
    DataBase *db;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title=@"评论";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];

    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    CGFloat i_Height=0;
    if (iPhone6) {
        i_Height=self.view.frame.size.height*0.82;
    }
    else if (iPhone6_plus) {
        i_Height=self.view.frame.size.height*0.85;
    }
    else {
        i_Height=self.view.frame.size.height*0.8;
    }
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    _param=[NSMutableDictionary dictionary];
    _param[@"pageIndex"]=@"1";
    _param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
    _i_pageIndex=1;
    [self CommentDisplay:_param];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, i_Height) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorColor=[UIColor blackColor];
    
    [self.view addSubview:self.tableView];
    
    
    UIButton *btn_previous=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.15, i_Height+self.view.frame.size.height*0.01,self.view.frame.size.width*0.2, 25)];
    [btn_previous setTitle:@"上一页" forState:UIControlStateNormal];
    [btn_previous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_previous.layer.borderWidth=1;
    [btn_previous addTarget:self action:@selector(Previous:) forControlEvents:UIControlEventTouchUpInside];
    [btn_previous setBackgroundColor:[UIColor yellowColor]];
    
    UIButton *btn_next=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.65, i_Height+self.view.frame.size.height*0.01, self.view.frame.size.width*0.2, 25)];
    [btn_next setTitle:@"下一页" forState:UIControlStateNormal];
    btn_previous.layer.borderWidth=1;
    [btn_next addTarget:self action:@selector(Next:) forControlEvents:UIControlEventTouchUpInside];
    [btn_next setBackgroundColor:[UIColor lightGrayColor]];
    
    _lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5,i_Height+self.view.frame.size.height*0.01 , self.view.frame.size.width*0.1, 25)];
    _lbl_label.font=[UIFont systemFontOfSize:10];
    
    
    _txt_pages=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.45,i_Height+self.view.frame.size.height*0.01,self.view.frame.size.width*0.05, 25)];
    _txt_pages.placeholder=@"1";
    _txt_pages.delegate=self;
    _txt_pages.keyboardType=UIKeyboardTypePhonePad;
    _txt_pages.font=[UIFont systemFontOfSize:10];
    
   // [self.view addSubview:btn_previous];
   // [self.view addSubview:btn_next];
   // [self.view addSubview:_lbl_label];
   // [self.view addSubview:_txt_pages];
    
    UIView *lbl_line=[[UIView alloc]initWithFrame:CGRectMake(0, i_Height+0.05, self.view.frame.size.width, 1)];
    lbl_line.backgroundColor=[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
    
    [self.view addSubview:lbl_line];
    
    UIButton *btn_comment=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8, i_Height+self.view.frame.size.height*0.06, self.view.frame.size.width*0.18, self.view.frame.size.height*0.05)];
    btn_comment.backgroundColor=[UIColor colorWithRed:99/255.0f green:115/255.0f blue:230/255.0f alpha:1];
    [btn_comment setTitle:@"发表" forState:UIControlStateNormal];
    [btn_comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_comment addTarget:self action:@selector(Comment:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.view addSubview:btn_comment];
    
    _txt_comment=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.03, i_Height+self.view.frame.size.height*0.06, self.view.frame.size.width*0.75, self.view.frame.size.height*0.05)];
    _txt_comment.delegate=self;
    _txt_comment.backgroundColor=[UIColor whiteColor];
    _txt_comment.layer.borderWidth=1;
    _txt_comment.layer.borderColor=[[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1] CGColor];
    _txt_comment.placeholder=@"  在此评论";
    
    [self.view addSubview:_txt_comment];
    
    _arr_comment=[[NSMutableArray alloc]initWithCapacity:5];
 
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    _arr_comment_add=[[NSMutableArray alloc]initWithCapacity:5];
    [_arr_comment_add addObject:@"党的政策好|综合部张三"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    [_arr_comment_add addObject:@"服从领导，坚决贯彻|开发部王五"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    
    //returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    //[returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_comment.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    NSString *str_display=[_arr_comment objectAtIndex:indexPath.row];
    NSArray *arr_display=[str_display componentsSeparatedByString:@"|"];
    
    cell.textLabel.text=[arr_display objectAtIndex:0];
    cell.detailTextLabel.text=[arr_display objectAtIndex:1];
    
    // Configure the cell...
    
    return cell;
     */
    
    
    NSDictionary *dic_display=[_arr_comment objectAtIndex:indexPath.row];
    NSString *str_staff=[dic_display objectForKey:@"operatorName"];
    NSString *str_time=[dic_display objectForKey:@"addTime"];
    NSString *str_content=[dic_display objectForKey:@"content"];
    
    CommentCell *cell=[CommentCell cellWithTable:tableView staff:str_staff time:str_time content:str_content image:@"head1.jpg" thumbnum:8 atIndexPath:indexPath];
    
    
    [cell.btn_thumb addTarget:self action:@selector(Thumb:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone5_5s || iPhone4_4s) {
        return 95;
    }
    else if (iPhone6) {
        return 108;
    }
    else {
        return 140;
    }
    
}

-(void)Comment:(UIButton*)sender {
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    NSString *str_comment=[NSString stringWithFormat:@"%@|%@%@|%@",_txt_comment.text,_userInfo.str_department,_userInfo.str_name,locationString];
    [_arr_comment addObject:str_comment];
    [self.tableView reloadData];
    
    _addComment_param=[NSMutableDictionary dictionary];
    _addComment_param[@"content"]=_txt_comment.text;
    _addComment_param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
    [self AddComment:_addComment_param];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(keyboardWillShow:)
     //                                            name:UIKeyboardWillShowNotification
      //                                         object:nil];
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CommentDisplay:(NSMutableDictionary*)param {
    NSString *str_newsComment= [db fetchInterface:@"NewsComment"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsComment];
    [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取评论列表成功");
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        int i_success=[str_success intValue];
        if (i_success==1) {
            NSArray *arr_tmp=[JSON objectForKey:@"list"];
            for (int i=0;i<[arr_tmp count];i++) {
                [_arr_comment addObject:[arr_tmp objectAtIndex:i]];
            }
            NSObject *obj=[JSON objectForKey:@"totalPage"];
            NSNumber *l_totalPage=(NSNumber*)obj;
            _i_totalPage=[l_totalPage integerValue];
            _lbl_label.text=[NSString stringWithFormat:@"/%ld",(long)_i_totalPage];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取评论列表失败");
    }];
}

-(void)AddComment:(NSMutableDictionary*)param {
    NSString *str_AddComment= [db fetchInterface:@"AddComment"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_AddComment];
    [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"追加评论成功");
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        int i_success=[str_success intValue];
        if (i_success==1) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"追加评论失败");
    }];
}

//program UITextField delegate
/*
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height -= keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = newFrame;  
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    
}


-

(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}
  */

-(void)dealloc {
   // returnKeyHandler=nil;
}


-(void)Thumb:(UIButton*)btn {
    if (btn.isSelected==NO) {
         btn.selected=YES;
    }
    else {
        btn.selected=NO;
    }
   
}

-(void)Previous:(UIButton*)btn {
    if (_i_pageIndex>1) {
        _i_pageIndex=_i_pageIndex-1;
        _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
        [self CommentDisplay:_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
    }
}

-(void)Next:(UIButton*)btn {
    if (_i_pageIndex<_i_totalPage) {
        _i_pageIndex=_i_pageIndex+1;
        _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
        [self CommentDisplay:_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
    }
    
}

-(IBAction)textFieldDidEndEditing:(UITextField *)textField {
    NSString *str_text=_txt_pages.text;
    NSInteger i_text=[str_text integerValue];
    if (i_text>_i_totalPage) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"输入页数超过范围" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            _txt_pages.text=@"1";
        }];
        [alert showLXAlertView];
    }
    else {
        _i_pageIndex=[str_text integerValue];
        _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
        [self CommentDisplay:_param];
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        //  NSLog((@"end of table"));
        if (_i_pageIndex<_i_totalPage) {
            _i_pageIndex=_i_pageIndex+1;
            _param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
            _param[@"newsId"]=[NSString stringWithFormat:@"%ld",(long)_news_index];
            [self CommentDisplay:_param];
            //self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        }
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

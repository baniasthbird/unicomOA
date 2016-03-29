//
//  CommentViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arr_comment;

@property (nonatomic,strong) UITextField *txt_comment;

@end

@implementation CommentViewController

int prewTag;
float prewMoveY;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title=@"评论";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    self.view.backgroundColor=[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.85) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorColor=[UIColor blackColor];
    
    [self.view addSubview:self.tableView];
    
    UIButton *btn_comment=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8, self.view.frame.size.height*0.86, self.view.frame.size.width*0.15, self.view.frame.size.height*0.05)];
    [btn_comment setTitle:@"发表" forState:UIControlStateNormal];
    [btn_comment setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
    [btn_comment addTarget:self action:@selector(Comment:) forControlEvents:UIControlEventTouchUpInside];
    btn_comment.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:btn_comment];
    
    _txt_comment=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.03, self.view.frame.size.height*0.86, self.view.frame.size.width*0.75, self.view.frame.size.height*0.05)];
    _txt_comment.delegate=self;
    _txt_comment.backgroundColor=[UIColor whiteColor];
    _txt_comment.placeholder=@"在此评论";
    
    [self.view addSubview:_txt_comment];
    
    _arr_comment=[[NSMutableArray alloc]initWithCapacity:5];
    [_arr_comment addObject:@"党的政策好|综合部张三"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    [_arr_comment addObject:@"服从领导，坚决贯彻|开发部王五"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    
    
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
    
}

-(void)Comment:(UIButton*)sender {
    NSString *str_comment=[NSString stringWithFormat:@"%@|%@",_txt_comment.text,@"研发部李四"];
    [_arr_comment addObject:str_comment];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

//program UITextField delegate

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

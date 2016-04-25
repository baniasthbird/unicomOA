//
//  CommentViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CommentViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "CommentCell.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arr_comment;

@property (nonatomic,strong) UITextField *txt_comment;

@property (nonatomic,strong) NSMutableArray *arr_comment_add;

@end

@implementation CommentViewController
{
    int prewTag;
    float prewMoveY;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
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
        i_Height=self.view.frame.size.height*0.75;
    }
    else if (iPhone6_plus) {
        i_Height=self.view.frame.size.height*0.78;
    }
    else {
        i_Height=self.view.frame.size.height*0.735;
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, i_Height) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorColor=[UIColor blackColor];
    
    [self.view addSubview:self.tableView];
    
    UIView *lbl_line=[[UIView alloc]initWithFrame:CGRectMake(0, i_Height, self.view.frame.size.width, 1)];
    lbl_line.backgroundColor=[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
    
    [self.view addSubview:lbl_line];
    
    UIButton *btn_comment=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8, i_Height+self.view.frame.size.height*0.01, self.view.frame.size.width*0.18, self.view.frame.size.height*0.05)];
    btn_comment.backgroundColor=[UIColor colorWithRed:99/255.0f green:115/255.0f blue:230/255.0f alpha:1];
    [btn_comment setTitle:@"发表" forState:UIControlStateNormal];
    [btn_comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_comment addTarget:self action:@selector(Comment:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.view addSubview:btn_comment];
    
    _txt_comment=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.03, i_Height+self.view.frame.size.height*0.01, self.view.frame.size.width*0.75, self.view.frame.size.height*0.05)];
    _txt_comment.delegate=self;
    _txt_comment.backgroundColor=[UIColor whiteColor];
    _txt_comment.layer.borderWidth=1;
    _txt_comment.layer.borderColor=[[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1] CGColor];
    _txt_comment.placeholder=@"  在此评论";
    
    [self.view addSubview:_txt_comment];
    
    _arr_comment=[[NSMutableArray alloc]initWithCapacity:5];
    [_arr_comment addObject:@"党的政策好|综合部张三"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    [_arr_comment addObject:@"服从领导，坚决贯彻|开发部王五"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    [_arr_comment addObject:@"绝对支持|开发部李四"];
    
    _arr_comment_add=[[NSMutableArray alloc]initWithCapacity:5];
    [_arr_comment_add addObject:@"党的政策好|综合部张三"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    [_arr_comment_add addObject:@"服从领导，坚决贯彻|开发部王五"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    [_arr_comment_add addObject:@"绝对支持|开发部李四"];
    
    returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    
    
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
    NSString *str_display=[_arr_comment objectAtIndex:indexPath.row];
    NSArray *arr_display=[str_display componentsSeparatedByString:@"|"];
    CommentCell *cell;
    if (arr_display.count==2) {
        cell=[CommentCell cellWithTable:tableView staff:[arr_display objectAtIndex:1] time:@"2016-01-27" content:[arr_display objectAtIndex:0] image:@"head1.jpg" thumbnum:8 atIndexPath:indexPath];
    }
    else {
        cell=[CommentCell cellWithTable:tableView staff:[arr_display objectAtIndex:1] time:[arr_display objectAtIndex:2] content:[arr_display objectAtIndex:0] image:@"head1.jpg" thumbnum:0 atIndexPath:indexPath];
    }
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
    returnKeyHandler=nil;
}


-(void)Thumb:(UIButton*)btn {
    if (btn.isSelected==NO) {
         btn.selected=YES;
    }
    else {
        btn.selected=NO;
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

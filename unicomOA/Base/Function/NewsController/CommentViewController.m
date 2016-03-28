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

@end

@implementation CommentViewController

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
    
    UITextField *txt_comment=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.03, self.view.frame.size.height*0.86, self.view.frame.size.width*0.75, self.view.frame.size.height*0.05)];
    txt_comment.delegate=self;
    txt_comment.backgroundColor=[UIColor whiteColor];
    txt_comment.placeholder=@"在此评论";
    
    [self.view addSubview:txt_comment];
    
    
    
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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text=@"好好好";
    cell.textLabel.textColor=[UIColor blackColor];
    
    // Configure the cell...
    
    return cell;
    
}

-(void)Comment:(UIButton*)sender {
    
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

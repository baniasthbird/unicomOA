//
//  NotesViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NotesViewController.h"
#import "NewNotesViewController.h"
#import "FunctionViewController.h"
#import "UserEntity.h"


@interface NotesViewController()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *arr_Notes;

@end

static int i_count =0;
@implementation NotesViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"备忘录";
    
    UIButton *btn_new=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_new setTitle:@"新建" forState:UIControlStateNormal];
    [btn_new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_new addTarget:self action:@selector(NewNotes:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_new];
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"返回" forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_back];
    
    self.tableView.backgroundColor=[UIColor whiteColor];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    _arr_Notes=[NSMutableArray arrayWithCapacity:1];
    _arr_Notes[0]=@"";
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_Notes count];
}


-(void)NewNotes:(UIButton *)newBtn {
    NewNotesViewController *viewController=[[NewNotesViewController alloc]init];
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
   // [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

-(void)BackToAppCenter:(UIButton*)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text= [_arr_Notes objectAtIndex:(_arr_Notes.count-1-indexPath.row)];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *str_text=cell.textLabel.text;
    NSArray *array= [str_text componentsSeparatedByString:@","];
    
    
    
    
    NewNotesViewController *new_controller=[[NewNotesViewController alloc]init];
    
    new_controller.str_FenLei=[array objectAtIndex:0];
    new_controller.str_noteContent=[array objectAtIndex:1];
    new_controller.str_time=[array objectAtIndex:2];
    
    [self.navigationController pushViewController:new_controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}



-(void)passValue:(NSString *)str_FenLei Content:(NSString *)str_Content Time:(NSString *)str_curTime{
    
    NSString *str_tmp=[NSString stringWithFormat:@"%@,%@,%@",str_FenLei,str_Content,str_curTime];
    
    [_arr_Notes addObject:str_tmp];
    
    NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [indexPaths addObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
   /*
    [self.tableView setEditing:YES];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[NSString stringWithFormat:@"%@,%@,%@",str_FenLei,str_Content,str_curTime];
        [_arr_Notes addObject:cell];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        cell=[self.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text=[NSString stringWithFormat:@"%@,%@,%@",str_FenLei,str_Content,str_curTime];
        [self.tableView endUpdates];
    }
  */
    
   // UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i_count inSection:0]];
    //cell布局
    
    
    
    NSLog(@"the get value is %@ %@ %@",str_FenLei,str_Content,str_curTime);
    }
@end

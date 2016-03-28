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

NSInteger i_count=0;

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
    
    _arr_Notes=[NSMutableArray arrayWithCapacity:0];
    
    
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
    NotesTableVIewCell *cell=[NotesTableVIewCell cellWithTable:tableView withCellHeight:180];
    cell.delegate=self;
    cell.myTag= indexPath.row;
    NSString *str_note = [_arr_Notes objectAtIndex:(_arr_Notes.count-1-indexPath.row)];
   // cell.textLabel.text=str_note;
    NSArray *arr_note= [str_note componentsSeparatedByString:@","];
    if (arr_note.count==3) {
        cell.lbl_arrangement.text=[arr_note objectAtIndex:0];
        cell.lbl_content.text=[arr_note objectAtIndex:1];
        cell.lbl_time.text=[arr_note objectAtIndex:2];
    }
    else {
        cell.lbl_arrangement.text=@"";
        cell.lbl_content.text=@"";
        cell.lbl_time.text=@"";
    }
    
    return cell;
    /*
    static NSString *cellIdentifier = @"cell";
    
    NotesTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[NotesTableVIewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str_note = [_arr_Notes objectAtIndex:(_arr_Notes.count-1-indexPath.row)];
       // cell.textLabel.text=str_note;
        NSArray *arr_note= [str_note componentsSeparatedByString:@","];
        if (arr_note.count==3) {
            cell.lbl_arrangement.text=[arr_note objectAtIndex:0];
            cell.lbl_content.text=[arr_note objectAtIndex:1];
            cell.lbl_time.text=[arr_note objectAtIndex:2];
        }
        else {
            cell.lbl_arrangement.text=@"";
            cell.lbl_content.text=@"";
            cell.lbl_time.text=@"";
        }
        
    }
    
    return cell;
     */
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
    /*
    NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [indexPaths addObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    */
    [self.tableView reloadData];
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


-(void)sideslipCellRemoveCell:(NotesTableVIewCell *)cell atIndex:(NSInteger)index {

    [self.arr_Notes removeObjectAtIndex:_arr_Notes.count-1-index];
    [self.tableView reloadData];
    
}


-(void)tapCell:(NotesTableVIewCell*)cell atIndex:(NSInteger)index {
    
    NewNotesViewController *new_controller=[[NewNotesViewController alloc]init];
    
    new_controller.str_FenLei=cell.lbl_arrangement.text;
    new_controller.str_noteContent=cell.lbl_content.text;  new_controller.str_time=cell.lbl_time.text;
    
    [self.navigationController pushViewController:new_controller animated:YES];

    
}
@end

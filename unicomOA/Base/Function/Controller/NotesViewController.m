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
#import "LZActionSheet.h"
#import "DataBase.h"


@interface NotesViewController()<UITableViewDelegate,UITableViewDataSource,LZActionSheetDelegate>

@property (strong,nonatomic) NSMutableArray *arr_Notes;

@end

NSInteger i_count=0;

@implementation NotesViewController {
    DataBase *db;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"备忘录";
    
    UIButton *btn_new=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_new setTitle:@"新建" forState:UIControlStateNormal];
    [btn_new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_new addTarget:self action:@selector(NewNotes:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_new];
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_back];
    
    self.tableView.backgroundColor=[UIColor whiteColor];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    db=[DataBase sharedinstanceDB];
    
    _arr_Notes=[db fetchAllNotes];
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
    viewController.usrInfo=_user_Info;
    viewController.i_index=[self newDay];
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:NO];
   // [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

-(void)BackToAppCenter:(UIButton*)btn {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

//判断是否是新的一天
-(NSInteger)newDay {
    NSDate *now_date=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: now_date];
    NSDate *localeDate = [now_date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormatter stringFromDate:localeDate];
    NSArray *arr_day=[dateString componentsSeparatedByString:@" "];
    NSString *str_day=[arr_day objectAtIndex:0];

    NSMutableArray *arr_notes=[db fetchAllNotes];
    BOOL b_Day=NO;
    for (int i=0;i<arr_notes.count;i++)
    {
        NSMutableDictionary *dic=(NSMutableDictionary*)[arr_notes objectAtIndex:i];
        if (dic!=nil) {
            NSString *str_notes_date=[dic objectForKey:@"notes_date"];
            NSArray *arr_notes_day=[str_notes_date componentsSeparatedByString:@" "];
            NSString *str_notes_day=[arr_notes_day objectAtIndex:0];
            if ([str_notes_day isEqualToString:str_day]) {
                i_count=i_count+1;
                b_Day=YES;
            }
        }
    }
    if (b_Day==NO) {
        i_count=0;
    }
    
    return i_count;
    
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotesTableVIewCell *cell=[NotesTableVIewCell cellWithTable:tableView withCellHeight:180 atIndexPath:indexPath];
    cell.delegate=self;
    cell.myTag= indexPath.row;
    NSDictionary *dic_note = [_arr_Notes objectAtIndex:(_arr_Notes.count-1-indexPath.row)];
   // cell.textLabel.text=str_note;
    NSString *str_fenlei=[dic_note objectForKey:@"fenlei"];
    if ([str_fenlei isEqualToString:@"(null)"]) {
        str_fenlei=@"";
    }
    cell.lbl_arrangement.text=str_fenlei;
    
    NSString *str_content=[dic_note objectForKey:@"content"];
    if ([str_content isEqualToString:@"(null)"]) {
        str_content=@"";
    }
    cell.lbl_content.text=str_content;
    
    
    NSString *str_notes_date=[dic_note objectForKey:@"notes_date"];
    if ([str_notes_date isEqualToString:@"(null)"]) {
        str_notes_date=@"";
    }
    cell.lbl_time2.text=str_notes_date;
    
    NSString *str_meeting_date=[dic_note objectForKey:@"meeting_date"];
    if ([str_meeting_date isEqualToString:@"(null)"]) {
        str_meeting_date=@"";
    }
    cell.lbl_time.text=str_meeting_date;
    
    NSString *str_index=[dic_note objectForKey:@"index"];
    if ([str_index isEqualToString:@"(null)"]) {
        str_index=@"";
    }
    cell.tag=[str_index integerValue];
    cell.myNotes=dic_note;
   
    /*
    if (arr_note.count==4) {
        [cell.view_bg setFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y,self.view.frame.size.width,40)];
        cell.lbl_arrangement.text=[arr_note objectAtIndex:0];
        cell.lbl_content.text=[arr_note objectAtIndex:1];
        cell.lbl_time.text=[arr_note objectAtIndex:2];
        cell.lbl_time2.text=[arr_note objectAtIndex:3];
    }
    else {
        cell.lbl_arrangement.text=@"";
        cell.lbl_content.text=@"";
        cell.lbl_time.text=@"";
        cell.lbl_time2.text=@"";
    }
    */
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
    NotesTableVIewCell *cell=(NotesTableVIewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic_note=cell.myNotes;
    
    NewNotesViewController *new_controller=[[NewNotesViewController alloc]init];
    
    new_controller.dic_notes=dic_note;
    
   
    
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:new_controller animated:NO];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}


-(void)passValue:(NSString *)str_FenLei Content:(NSString *)str_Content Time:(NSString *)str_curTime TimeNow:(NSString *)str_nowTime PicPath:(NSString *)str_picpath coordx:(NSString *)coord_x coordy:(NSString *)coord_y address:(NSString *)str_address index:(NSString *)str_index{
   // NSString *str_tmp=[NSString stringWithFormat:@"%@,%@,%@,%@",str_FenLei,str_Content,str_curTime,str_nowTime];
    NSMutableDictionary *dic_notes=[NSMutableDictionary dictionaryWithCapacity:9];
    [dic_notes setValue:str_FenLei forKey:@"fenlei"];
    [dic_notes setValue:str_Content forKey:@"content"];
    [dic_notes setValue:str_nowTime forKey:@"notes_date"];
    [dic_notes setValue:str_curTime forKey:@"meeting_date"];
    [dic_notes setValue:str_picpath forKey:@"pic_path"];
    [dic_notes setValue:coord_x forKey:@"coord_x"];
    [dic_notes setValue:coord_y forKey:@"coord_y"];
    [dic_notes setValue:str_index forKey:@"index"];
    [dic_notes setValue:str_address forKey:@"address"];
    
    BOOL b_Add=NO;
    for (int i=0;i<_arr_Notes.count;i++) {
        NSDictionary *dic_tmp=(NSDictionary*)[_arr_Notes objectAtIndex:i];
        NSString *str_tmpindex=(NSString*)[dic_tmp objectForKey:@"index"];
        NSInteger i_tmpindex=[str_tmpindex integerValue];
        NSInteger i_index=[str_index integerValue];
        if (i_tmpindex==i_index) {
            [_arr_Notes replaceObjectAtIndex:i withObject:dic_notes];
            b_Add=YES;
            break;
        }
    }
    if (b_Add==NO) {
       [_arr_Notes addObject:dic_notes];
    }
    [self.tableView reloadData];
}

-(void)passValue:(NSString *)str_FenLei Content:(NSString *)str_Content Time:(NSString *)str_curTime TimeNow:(NSString *)str_nowTime{
    
   
    /*
    NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [indexPaths addObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    */
    
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
    
    NSInteger del_index=cell.tag;
    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)del_index];
   // NSString *str_index=cell.lbl_time2.text;
    [db DeleteNotesTable:str_index];
    [self.arr_Notes removeObjectAtIndex:_arr_Notes.count-1-index];
    [self.tableView reloadData];
    
}


-(void)tapCell:(NotesTableVIewCell*)cell atIndex:(NSInteger)index {
    
    UIColor *other_color=[UIColor colorWithRed:81/255.0f green:127/255.0f blue:238/255.0f alpha:1];
    UIColor *cancel_color=[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1];
    LZActionSheet *sheet=[LZActionSheet showActionSheetWithDelegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"编辑备忘录",@"删除备忘录"] cancelButtonColor:cancel_color otherButtonColor:other_color];
    sheet.notes_tag=cell;
    sheet.note_index=index;
    [sheet show];
   
}

-(void)LZActionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            NewNotesViewController *new_controller=[[NewNotesViewController alloc]init];
            NotesTableVIewCell *cell=(NotesTableVIewCell*)actionSheet.notes_tag;
            NSDictionary *dic_note=(NSDictionary*)cell.myNotes;
            new_controller.dic_notes=dic_note;
            new_controller.delegate=self;
            if (f_v<9.0) {
                self.navigationController.delegate=nil;
            }
            [self.navigationController pushViewController:new_controller animated:NO];
            break;
        }
        case 1: {
            NotesTableVIewCell *cell=(NotesTableVIewCell*)actionSheet.notes_tag;
            NSInteger del_index=cell.tag;
            NSString *str_index=[NSString stringWithFormat:@"%ld",(long)del_index];
            [db DeleteNotesTable:str_index];
            [self.arr_Notes removeObjectAtIndex:_arr_Notes.count-1-actionSheet.note_index];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}
@end

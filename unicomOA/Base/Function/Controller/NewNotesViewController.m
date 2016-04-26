//
//  NewNotesViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewNotesViewController.h"
#import "NotesViewController.h"
#import "MenuItemModel.h"
#import "CellModel.h"
#import "MenuTableViewCell.h"
#import "UserEntity.h"
#import "TableViewCell.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"

#define TABLEVIEW_CELL_RESUSE_ID @"TABLEVIEW_CELL_REUSE_ID"

typedef enum
{
    DateArrangeMent=0,
    WorkingNotes,
    TourismPlan,
    MeetingArrangement,
    DiningService
}OperationType;

@interface NewNotesViewController()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,MenuTableViewCellDelegate,MenutableViewCellDataSource>
    
//列表
@property (strong,nonatomic) UITableView *tableView;

//已经打开下拉菜单的单元格
@property (strong,nonatomic) MenuTableViewCell *openedMenuCell;

//已经打开下拉菜单的单元格的位置
@property (strong,nonatomic) NSIndexPath *openedMenuCellIndex;

//列表数据源
@property (strong,nonatomic) NSMutableArray *dataSourceArray;

//下拉菜单数据源
@property (strong,nonatomic) NSMutableArray *menuItemDataSourceArray;

@property (strong,nonatomic) NSIndexPath *selectedRowIndexPath;


@end

@implementation NewNotesViewController {
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

@synthesize delegate;


-(void)viewDidLoad {
    self.title=@"新建备忘录";
    
    UIButton *btn_Finish=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
    [btn_Finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_Finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_Finish addTarget:self action:@selector(FinishNotes:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_Finish];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    //[barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    [self buildDataSource];
    [self buildView];
    
    returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    
    
    
}




-(void)FinishNotes:(UIButton*)sender {
    
    MenuTableViewCell *menuCell=(MenuTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *str_notesFenLei= menuCell.indexPathLabel.text;
    
    
    UITableViewCell *cell=(UITableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UILabel *lbl_date=cell.subviews[1];
    NSString *curTime=lbl_date.text;
    
    //self.arr_passvalue=[[NSArray alloc]initWithObjects:str_notesFenLei,str_notesContent,curTime, nil];
    
    //self.arr_passvalue=@[str_notesFenLei,str_notesContent,curTime];
    
   // [delegate passValue:self.arr_passvalue];
    [delegate passValue:str_notesFenLei Content:_str_noteContent Time:curTime];
    
    //NotesViewController *viewController=[[NotesViewController alloc]initWithNibName:@"ValueInputView" bundle:[NSBundle mainBundle]];
    
    //[self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)buildDataSource {
    //构建单元格下拉列表数据源
    self.menuItemDataSourceArray=[NSMutableArray arrayWithCapacity:0];
    MenuItemModel *favItemModel=[[MenuItemModel alloc] initWithNormalImageName:@"calendar" withHighLightedImageName:@"calendar" withItemText:@"日程安排"];
    [self.menuItemDataSourceArray addObject:favItemModel];
    
    MenuItemModel *albItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"notes" withHighLightedImageName:@"notes" withItemText:@"工作笔记"];
    [self.menuItemDataSourceArray addObject:albItemModel];
    
    MenuItemModel *dldItemModel=[[MenuItemModel alloc] initWithNormalImageName:@"travel" withHighLightedImageName:@"travel" withItemText:@"差旅安排"];
    [self.menuItemDataSourceArray addObject:dldItemModel];
    
    MenuItemModel *artistItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"meeting" withHighLightedImageName:@"meeting" withItemText:@"会议记录"];
    [self.menuItemDataSourceArray addObject:artistItemModel];
    
    MenuItemModel *dltItemModel=[[MenuItemModel alloc]initWithNormalImageName:@"dinner" withHighLightedImageName:@"dinner" withItemText:@"宴会安排"];
    [self.menuItemDataSourceArray addObject:dltItemModel];
    
    //构建列表数据源
    self.dataSourceArray=[NSMutableArray arrayWithCapacity:0];
    for (int index=0; index<10; index++) {
        CellModel *cellModel=[[CellModel alloc]initWithImageName:@"foxgirl.jpg" labelText:@""];
        [self.dataSourceArray addObject:cellModel];
    }
    
}

//搭建界面
-(void)buildView {
    //列表
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -110, self.view.frame.size.width, self.view.frame.size.height+110) style:UITableViewStylePlain];
   // [self.tableView setSeparatorColor:[UIColor blueColor]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:TABLEVIEW_CELL_RESUSE_ID];
    
    [self.view addSubview:self.tableView];
    
    UIView *tableFootView=[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView=tableFootView;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if (range.location>=500) {
        return NO;
    }
    //_str_noteContent=text;
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedRowIndexPath) {
        return 6;
    }
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MenuTableViewCell *menuCell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL_RESUSE_ID forIndexPath:indexPath];
        menuCell.delegate = self;
        menuCell.dataSource = self;
        menuCell.moreBtn.tag = indexPath.row;
        //需要手动绘制下拉菜单视图，通过xib创建视图的时候cell的delegate和dataSource尚未确定
        [menuCell buildMenuView];
        if (indexPath.row < [self.dataSourceArray count] && self.str_FenLei!=nil) {
            CellModel *cellModel = [self.dataSourceArray objectAtIndex:indexPath.row];
            menuCell.headImageView.image = [UIImage imageNamed:cellModel.imageName];
            menuCell.indexPathLabel.text=self.str_FenLei;
        }
        if (indexPath.row < [self.dataSourceArray count] && self.str_FenLei==nil)
        {
            CellModel *cellModel = [self.dataSourceArray objectAtIndex:indexPath.row];
            menuCell.headImageView.image = [UIImage imageNamed:cellModel.imageName];
            menuCell.indexPathLabel.text = cellModel.labelText;
        }
        
        return menuCell;
    }
    else if (indexPath.row==1) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UITextView *textView=nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.textLabel.text=@"备忘录记录";
            textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height)];
            [textView setTextColor:[UIColor blackColor]];
            [textView setFont:[UIFont systemFontOfSize:12.0f]];
            [textView setBackgroundColor:[UIColor clearColor]];
            textView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            textView.hidden=NO;
            textView.layer.borderColor=[[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
            textView.layer.borderWidth=3.0;
            textView.layer.cornerRadius=8.0f;
            [textView.layer setMasksToBounds:YES];
            textView.delegate=self;
            [textView setTag:1];
            if (self.str_noteContent==nil) {
                [textView setText:@"请输入内容"];
            }
            else {
                textView.text=self.str_noteContent;
            }
            
            [textView setEditable:YES];
            [[cell contentView]addSubview:textView];
            
        }
        
        return cell;
    }
    else if (indexPath.row==2) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CGRect imageFrame=CGRectMake(10, 10, 100, 80);
        UIImageView *image=[[UIImageView alloc]initWithFrame:imageFrame];
        [image setImage:[UIImage imageNamed:@"me.png"]];
        //cell.textLabel.text=@"今后更新用于地图开发";
        [cell addSubview:image];
        return cell;
    }
    else if (indexPath.row==3) {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.textLabel.text=@"日期";
        UILabel *lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(100,10,2*cell.frame.size.width/3, cell.frame.size.height)];
        if (self.str_time==nil) {
            NSDate *date=[NSDate date];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString=[dateFormatter stringFromDate:date];
            lbl_time.textColor=[UIColor blackColor];
            lbl_time.text=dateString;
        }
        else if (self.str_time!=nil) {
            lbl_time.textColor=[UIColor blackColor];
            lbl_time.text=self.str_time;
        }
       
        [cell addSubview:lbl_time];

        return cell;
        
    }
    else if (indexPath.row==4 && self.selectedRowIndexPath==nil)  {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text=@"设置提醒";
        UISwitch *sw_alarm=[[UISwitch alloc]initWithFrame:CGRectMake(120, 15, 50, 50)];
       
    
        [sw_alarm setOn:NO animated:NO];
        [sw_alarm addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        //[cell addSubview:sw_alarm];
        cell.accessoryView=sw_alarm;
        return  cell;
        
    }
    else if ([self isExtendedCellIndexPath:indexPath])
    {
        NSString *identifier = [TableViewCell reusableIdentifier];
        TableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]objectAtIndex:0];
        [cell addcontentView:[self viewForContainerAtIndexPath:indexPath]];
        return cell;
        
    }
    else {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
    }
    
}

-(void)textViewDidChange:(UITextView *)textView {
    self.str_noteContent=textView.text;
}


- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.openedMenuCell != nil)&&
        (self.openedMenuCell.isOpenMenu = YES)&&
        (self.openedMenuCellIndex.row == indexPath.row))
    {
        return 114.0;
    }else if (indexPath.row==1)
    {
        return 180;
    }
    else if (indexPath.row==2)
    {
        return 100;
    }
    else if ([self isExtendedCellIndexPath:indexPath]) {
        return 180;
    }
    else
    {
        return 64.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==3 && indexPath.section==0) {
        [self extendCellAtIndexPath:indexPath];
    }
    /*
    if (indexPath.row!=3) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[FullTimeView class]]) {
                [view removeFromSuperview];
            }
        }
    }
     */
    
}


#pragma mark -MenutableViewCellDataSource
-(NSMutableArray *)dataSourceForMenuItem {
    return self.menuItemDataSourceArray;
}

#pragma mark -MenuTableVieCellDelegate 

-(void)didOpenMenuAtCell:(MenuTableViewCell *)menuTableViewCell withMoreButton:(UIButton *)moreButton {
    NSIndexPath *openedIndexPath=[NSIndexPath indexPathForRow:moreButton.tag inSection:0];
    
    if ((self.openedMenuCell!=nil) && (self.openedMenuCell.isOpenMenu==YES) && (self.openedMenuCellIndex.row==openedIndexPath.row)) {
        //如果点的是同一个cell关闭下拉菜单并且不刷新新的cell
        self.openedMenuCell = nil;
        [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        MenuTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.indexPathLabel.text=menuTableViewCell.indexPathLabel.text;
        self.openedMenuCellIndex=nil;
        return;
    }
    
    //刷新新的cell
    self.openedMenuCell=menuTableViewCell;
    self.openedMenuCellIndex=openedIndexPath;
    [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    MenuTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.indexPathLabel.text=menuTableViewCell.indexPathLabel.text;
    [self.tableView scrollToRowAtIndexPath:self.openedMenuCellIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)menuTableViewCell:(MenuTableViewCell *)menuTableViewCell didSeletedMentItemAtIndex:(NSInteger)menuItemIndex
{
    //首先关闭打开的下拉菜单
    /*
    if ((self.openedMenuCell!=nil)&& (self.openedMenuCell.isOpenMenu==YES) && (self.openedMenuCellIndex.row == menuTableViewCell.moreBtn.tag)) {
        //如果点的是同一个CELL关闭下拉菜单并且不刷新新的cell
        self.openedMenuCell=nil;
        [self.tableView reloadRowsAtIndexPaths:@[self.openedMenuCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.openedMenuCellIndex=nil;
    }
     */
    
    switch (menuItemIndex) {
        case DateArrangeMent:
            menuTableViewCell.indexPathLabel.text=@"日程安排";
            break;
        case WorkingNotes:
            menuTableViewCell.indexPathLabel.text=@"工作笔记";
            break;
        case TourismPlan:
            menuTableViewCell.indexPathLabel.text=@"差旅安排";
            break;
        case MeetingArrangement:
            menuTableViewCell.indexPathLabel.text=@"会议记录";
            break;
        case DiningService:
            menuTableViewCell.indexPathLabel.text=@"宴会安排";
            break;
        default:
            break;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入内容"]) {
        textView.text=@"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text=@"请输入内容";
    }
}



-(UIView*)viewForContainerAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isExtendedCellIndexPath:indexPath]) {
        UIDatePicker *datePicker=[[UIDatePicker alloc]init];
       // [datePicker setLocale:[NSLocale alloc]:@"zh_Hans_CN"];
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        UIView *dropDownView=datePicker;
        
        return dropDownView;
    }
    else {
        return nil;
    }
}

//点击时间后下拉扩展cell事件
-(void)extendCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3 && indexPath.section==0) {
        [self.tableView beginUpdates];
        
        if (self.selectedRowIndexPath) {
            if ([self isSelectedRowIndexPath:indexPath]) {
                NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
                self.selectedRowIndexPath=nil;
                [self removeCellBelowIndexPath:tempIndexPath];
            }
            else if ([self isExtendedCellIndexPath:indexPath]);
            else {
                NSIndexPath *tempIndexPath=self.selectedRowIndexPath;
                if (indexPath.row>self.selectedRowIndexPath.row && indexPath.section==self.selectedRowIndexPath.section) {
                    indexPath=[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
                }
                self.selectedRowIndexPath=indexPath;
                [self removeCellBelowIndexPath:tempIndexPath];
                [self insertCellBelowIndexPath:indexPath];
                
            }
            
        }
        else {
            self.selectedRowIndexPath=indexPath;
            [self insertCellBelowIndexPath:indexPath];
        }
        
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void)insertCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath=[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)removeCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath =[NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray=@[indexPath];
    [self.tableView deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)setSelectedRowIndexPath:(NSIndexPath *)selectedRowIndexPath {
    _selectedRowIndexPath=selectedRowIndexPath;
}

-(BOOL)isExtendedCellIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row+1 && indexPath.section==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isSelectedRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath) {
        if (indexPath.row==self.selectedRowIndexPath.row && indexPath.section ==self.selectedRowIndexPath.section) {
            return YES;
        }
    }
    return NO;
}

#pragma 日期
-(void)dateChanged:(UIDatePicker*)sender {
    NSDate *date=sender.date;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormatter stringFromDate:date];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    UILabel *lbl_date=cell.subviews[1];
    lbl_date.text=dateString;
    lbl_date.textColor=[UIColor blackColor];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

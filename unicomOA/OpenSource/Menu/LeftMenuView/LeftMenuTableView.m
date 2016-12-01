//
//  AppDelegate.h
//  QQ侧滑菜单Demo
//
//  Created by MCL on 16/7/13.
//  Copyright © 2016年 CHLMA. All rights reserved.
//

#import "LeftMenuTableView.h"
#import "MenuTableViewCellNew.h"
#import "BaseFunction.h"
#import "DataBase.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface LeftMenuTableView()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSArray *dataSourceArr;
//@property (nonatomic, strong) NSArray *imageSourceArr;
//@property (nonatomic, strong) NSArray *classSourceArr;

@end

@implementation LeftMenuTableView {
    BaseFunction *base_Func;
    DataBase *db;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self =[super initWithFrame:frame];
    if (self) {
        base_Func=[[BaseFunction alloc]init];
        db=[DataBase sharedinstanceDB];
        self.delegate=self;
        self.dataSource=self;
        self.scrollEnabled = YES;
        self.rowHeight=40;
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle= UITableViewCellSeparatorStyleNone;
       
        
       // self.dataSourceArr = @[@[@"cell_row_00",@"cell_row_01"], @[@"cell_row_10",@"cell_row_11",@"cell_row_12",@"cell_row_13"], @[@"cell_row_20"]];
       // self.imageSourceArr= @[@[@"image1", @"image2"], @[@"image3", @"image4", @"image5", @"image6"], @[@"image7"]];
        
       // self.classSourceArr= @[@[@"Action1", @"Action2"], @[@"Action3", @"Action4", @"Action5", @"Action6"], @[@"Action7"]];
        
        
        self.backgroundColor=[UIColor clearColor];
    }
    return  self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arr_menus!=nil) {
        return _arr_menus.count;
    }
    else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  static NSString *cellID = @"menu";
    NSString *str_label=@"";
    NSString *str_num=@"";
    NSString *str_title=@"";
    if (_arr_menus!=nil || [_arr_menus count]>0) {
        NSDictionary *dic_menuItem=[_arr_menus objectAtIndex:indexPath.row];
        str_label=[base_Func GetValueFromDic:dic_menuItem key:@"label"];
        str_num=[base_Func GetValueFromDic:dic_menuItem key:@"num"];
        
        if ([str_label isEqualToString:@"all"]) {
            str_title=@"全部";
        }
        else {
            str_title=[db fetchShiWu:str_label];
        }
    }
    MenuTableViewCellNew *cell = [MenuTableViewCellNew cellWithTable:tableView withTitle:str_title withCount:str_num withLabel:str_label atIndexPath:indexPath];
 
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了 tableView的第 %ld 个cell", (long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *str_hint=cell.accessibilityHint;
   // NSString *actionName = _classSourceArr[indexPath.section][indexPath.row];
    if (_menuActionBlock) {
        _menuActionBlock(str_hint);
    }
    
//    NSLog(@"点击了 tableView的第 %ld 个cell", (long)indexPath.row);
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *className = _classSourceArr[0];
//    UIViewController *vc = [[NSClassFromString(className) alloc] init];
//    [[AppDelegate appDelegate].home.navigationController pushViewController:vc animated:YES];
//    [[AppDelegate appDelegate].home.menuView closeLeftView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_arr_menus!=nil || [_arr_menus count]>0) {
        NSDictionary *dic_menuItem=[_arr_menus objectAtIndex:indexPath.row];
        NSString *str_label=[base_Func GetValueFromDic:dic_menuItem key:@"label"];
        NSString *str_title=[db fetchShiWu:str_label];
        if (str_title.length<=8) {
            return 30;
        }
        else {
            return 50;
        }
    }
    else {
        return 20;
    }
}

@end

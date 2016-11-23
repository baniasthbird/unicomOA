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
        self.rowHeight = 40;
        self.scrollEnabled = YES;
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle= UITableViewCellSeparatorStyleNone;
       
        
       // self.dataSourceArr = @[@[@"cell_row_00",@"cell_row_01"], @[@"cell_row_10",@"cell_row_11",@"cell_row_12",@"cell_row_13"], @[@"cell_row_20"]];
       // self.imageSourceArr= @[@[@"image1", @"image2"], @[@"image3", @"image4", @"image5", @"image6"], @[@"image7"]];
        
       // self.classSourceArr= @[@[@"Action1", @"Action2"], @[@"Action3", @"Action4", @"Action5", @"Action6"], @[@"Action7"]];
        
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor yellowColor];
        self.tableFooterView = footerView;
        
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
    
    static NSString *cellID = @"menu";
    MenuTableViewCellNew *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MenuTableViewCellNew alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:16];

    if (_arr_menus==nil || [_arr_menus count]==0) {
        cell.textLabel.text=@"差旅报销";
        cell.detailTextLabel.text=@"2";
        
    }
    else {
        NSDictionary *dic_menuItem=[_arr_menus objectAtIndex:indexPath.row];
        NSString *str_label=[base_Func GetValueFromDic:dic_menuItem key:@"label"];
        NSString *str_num=[base_Func GetValueFromDic:dic_menuItem key:@"num"];
        NSString *str_title;
        if ([str_label isEqualToString:@"all"]) {
            str_title=@"全部";
        }
        else {
            str_title=[db fetchShiWu:str_label];
        }
        cell.textLabel.text=str_title;
        cell.detailTextLabel.text=str_num;
        cell.accessibilityHint=str_label;
        //根据id比对
        
        
    }
    
   // cell.textLabel.text = _dataSourceArr[indexPath.section][indexPath.row];
 //   cell.textLabel.textColor = [UIColor blackColor];
 //   cell.textLabel.highlightedTextColor = RGBCOLOR(9, 235, 255);
 //   cell.textLabel.font = [UIFont systemFontOfSize:15];
  //  NSString *norImage = [NSString stringWithFormat:@"%@", _imageSourceArr[indexPath.section][indexPath.row]];
//    NSString *norImage = [NSString stringWithFormat:@"%@_nor", _imageSourceArr[indexPath.section][indexPath.row]];
//    NSString *selImage = [NSString stringWithFormat:@"%@_press", _imageSourceArr[indexPath.section][indexPath.row]];
  //  cell.imageView.image = [UIImage imageNamed:norImage];
//    cell.imageView.highlightedImage = [UIImage imageNamed:selImage];
    cell.selectedBackgroundView = [[UIView alloc] init];
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
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end

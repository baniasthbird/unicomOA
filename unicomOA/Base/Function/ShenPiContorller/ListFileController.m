//
//  ListFileController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ListFileController.h"

@interface ListFileController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) NSMutableDictionary *dic_backvalue;

@property (nonatomic,strong) NSIndexPath* i_selectedindexpath;



@end

@implementation ListFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_str_title;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(NewVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
  //  self.navigationItem.rightBarButtonItem = barButtonItem2;
    
    
    _dic_backvalue=[NSMutableDictionary dictionary];
    
    CGFloat i_Height=-10;
    if (iPhone5_5s) {
        i_Height=-10;
    }
    else if (iPhone6) {
        i_Height=-20;
    }
    else if (iPhone6_plus) {
        i_Height=-30;
    }
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, i_Height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_tableview];
    
    
    
    // Do any additional setup after loading the view.
}


-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NewVc:(UIButton*)sender {
    if ([_dic_backvalue count]!=0) {
        [_delegate sendBackValue:_dic_backvalue indexPath:_indexPath title:_str_title];
    }
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark tableview方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_value count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:110/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.font=[UIFont systemFontOfSize:16];
    
    UIImageView *img_logo=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-60, 10, 24, 24)];
    
    
    
    if (_mutliselect==NO) {
        if (indexPath==_i_selectedindexpath) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    NSDictionary *dic_value=[_arr_value objectAtIndex:indexPath.row];
    NSString *str_text=[dic_value objectForKey:@"label"];
    lbl_title.text=str_text;
    if ([_str_title isEqualToString:@"处理决策"]) {
        if ([str_text isEqualToString:@"同意"]) {
            lbl_title.textColor=[UIColor colorWithRed:26/255.0f green:189/255.0f blue:145/255.0f alpha:1];
            img_logo.image=[UIImage imageNamed:@"agree.png"];
        }
        else if ([str_text isEqualToString:@"不同意"]) {
            lbl_title.textColor=[UIColor colorWithRed:247/255.0f green:89/255.0f blue:89/255.0f alpha:1];
            img_logo.image=[UIImage imageNamed:@"disagree.png"];
        }
    }
    else {
        lbl_title.textColor=[UIColor colorWithRed:90/255.0f green:134/255.0f blue:243/255.0f alpha:1];
    }
   // cell.textLabel.text=[dic_value objectForKey:@"label"];
    NSString *str_value=[dic_value objectForKey:@"value"];
    cell.accessibilityIdentifier=str_text;
    cell.accessibilityHint=str_value;
    cell.textLabel.textColor=[UIColor blueColor];
    
    [cell.contentView addSubview:lbl_title];
    [cell.contentView addSubview:img_logo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    //NSString *str_text=cell.textLabel.text;
    NSString *str_value=cell.accessibilityHint;
    _dic_backvalue[@"title"]=_str_title;
    _dic_backvalue[@"text"]=cell.accessibilityIdentifier;
    _dic_backvalue[@"value"]=str_value;
    if (_mutliselect==NO) {
        _i_selectedindexpath=indexPath;
        [self.tableview reloadData];
    }
    if ([_dic_backvalue count]!=0) {
        [_delegate sendBackValue:_dic_backvalue indexPath:_indexPath title:_str_title];
    }
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
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

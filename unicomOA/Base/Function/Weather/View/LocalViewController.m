//
//  LocalViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//


#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "LocalViewController.h"
#import "CitiesGroup.h"
#import "MJExtension.h"
#import "WeatherViewController.h"
#import "LocalHeaderView.h"
#import "UIBarButtonItem+Weather.h"

@interface LocalViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *resultsData;
@property (nonatomic, strong) NSMutableArray *provinceResults;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) UISearchBar *mysearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@end

@implementation LocalViewController

- (NSMutableArray *) groups {
    if (_groups == nil) {
        NSArray *dictArray =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
        
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            CitiesGroup *group = [CitiesGroup mj_objectWithKeyValues:dict];
            [groupArray addObject:group];
        }
        _groups = groupArray;
    }
    return _groups;
}

-(NSMutableArray *)resultsData {
    if (!_resultsData) {
        _resultsData = [NSMutableArray array];
    }
    return _resultsData;
}

-(NSMutableArray *)provinceResults {
    if (!_provinceResults) {
        _provinceResults = [NSMutableArray array];
    }
    return _provinceResults;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str =@"当前城市-";
    self.title =[str stringByAppendingFormat:@"%@",_currentTitle];
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(dismissclick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    [self initTableView];
    [self initSearchBar];
}

-(void)initTableView {
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    self.tableview.sectionHeaderHeight = 30;
    self.tableview.rowHeight = 40;
}

-(void)initSearchBar {
    self.mysearchBar = [[UISearchBar alloc]init];
    self.mysearchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    self.mysearchBar.placeholder =@"搜索城市";
    self.mysearchBar.delegate = self;
    
    self.tableview.tableHeaderView = self.mysearchBar;
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.mysearchBar contentsController:self];
    self.searchDisplayController.delegate=self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate= self;
}

#pragma mark -- tableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return self.groups.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.resultsData.count;
    }
    else {
        CitiesGroup *group = self.groups[section];
        return group.cities.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = self.resultsData[indexPath.row];
        if (self.resultsData[indexPath.row] == nil) {
            NSLog(@"没结果");
        }
    }
    else {
        CitiesGroup *group = self.groups[indexPath.section];
        cell.textLabel.text = group.cities[indexPath.row];
    }
    
    return cell;
}


#pragma mark --- 点击事件，当监听到点击以后传智
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@" search    %@ , %@",self.resultsData[indexPath.row],self.provinceResults[indexPath.row]);
        if ([self.provinceResults[indexPath.row] isEqualToString:@"热门城市"]) {
            self.provinceResults[indexPath.row] = self.resultsData[indexPath.row];
        }
        if ([self.delegate respondsToSelector:@selector(localviewwithview:province:city:)]) {
            [self.delegate localviewwithview:self province:self.provinceResults[indexPath.row] city:self.resultsData[indexPath.row]];
        }
    }
    else {
        CitiesGroup *group = self.groups[indexPath.section];
        if (indexPath.section ==0) {
            group.state = group.cities[indexPath.row];
        }
        if ([self.delegate respondsToSelector:@selector(localviewwithview:province:city:)]) {
            [self.delegate localviewwithview:self province:group.state city:group.cities[indexPath.row]];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LocalHeaderView *header=[LocalHeaderView headerWithTableView:tableView];
    header.groups = self.groups[section];
    return  header;
}

#pragma mark - 是否包含或等于要搜索的字符串内容
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *tempResults =[NSMutableArray array];
    NSMutableArray *provinceResults = [NSMutableArray array];
    NSUInteger searchOption = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.groups.count; i++) {
        CitiesGroup *group = self.groups[i];
        
        for (int j = 0; j <  group.cities.count; j++) {
            NSString *storeString = group.cities[j];
            NSRange storeRange = NSMakeRange(0, storeString.length);
            NSRange foundRange = [storeString rangeOfString:searchText options:searchOption range:storeRange];
            if (foundRange.length) {
                [tempResults addObject:storeString];
                [provinceResults addObject:group.state];
            }
        }
    }
    
    [self.resultsData removeAllObjects];
    [self.resultsData addObjectsFromArray:tempResults];
    [self.provinceResults addObjectsFromArray:provinceResults];
}

#pragma mark -searchBar 开始编辑时改变取消按钮的文字
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mysearchBar.showsCancelButton = YES;
    
    NSArray *subViews = [(self.mysearchBar.subviews[0]) subviews];
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            
            break;
        }
    }

}

-(void)dismissclick:(UIButton*)Btn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

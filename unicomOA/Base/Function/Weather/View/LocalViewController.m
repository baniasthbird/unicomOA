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
#import "INTULocationManager.h"
#import "MBProgressHUD+MJ.h"

@interface LocalViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *resultsData;
@property (nonatomic, strong) NSMutableArray *provinceResults;
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) UISearchBar *mysearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic, assign) double lati;

@property (nonatomic, assign) double longi;

@property (nonatomic, strong) CLGeocoder *geocoder;

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
    [self setupLocation];
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
        return self.groups.count+1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.resultsData.count;
    }
    else {
        if (section==0) {
            return 1;
        }
        else {
            CitiesGroup *group = self.groups[section-1];
            return group.cities.count;
        }
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
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                cell.textLabel.text=self.city;
            }
        }
        else {
            CitiesGroup *group = self.groups[indexPath.section-1];
            cell.textLabel.text = group.cities[indexPath.row];
        }
        
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
        if (indexPath.section==0) {
            if ([self.delegate respondsToSelector:@selector(localviewwithview:province:city:)]) {
                [self.delegate localviewwithview:self province:self.province city:self.city];
            }
        }
        else {
            CitiesGroup *group = self.groups[indexPath.section-1];
            if (indexPath.section ==1) {
                group.state = group.cities[indexPath.row];
            }
            if ([self.delegate respondsToSelector:@selector(localviewwithview:province:city:)]) {
                [self.delegate localviewwithview:self province:group.state city:group.cities[indexPath.row]];
            }
        }
        
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UILabel *labelView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 30)];
        labelView.text=@"当前定位";
        return labelView;
    }
    else {
        LocalHeaderView *header=[LocalHeaderView headerWithTableView:tableView];
        header.groups = self.groups[section-1];
        return  header;
    }

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




-(void)setupLocation {
    INTULocationManager *mgr=[INTULocationManager sharedInstance];
    [mgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:20 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        NSLog(@"----%ld",(long)status);
        
        self.lati=currentLocation.coordinate.latitude;
        self.longi=currentLocation.coordinate.longitude;
        if (self.lati==0 && self.longi==0) {
            self.lati=34.774831;
            self.longi=113.681393;
        }
        
        if (status == 1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求超时"];
            return;
        }
        [self setupCity];
        
    }];
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)setupCity {
    CLLocationDegrees lati = self.lati;
    CLLocationDegrees longi = self.longi;
    CLLocation *loc =[[CLLocation alloc]initWithLatitude:lati longitude:longi];
    
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",error);
        }
        else {
            CLPlacemark *pm = [placemarks firstObject];
            
            NSLog(@"%@",pm.name);
            NSLog(@"%@ ,%@ ,%@",pm.locality,pm.country,pm.subLocality);
            
            if ([pm.name rangeOfString:@"市"].location != NSNotFound) {
                if ([pm.locality isEqualToString:@"上海市"] || [pm.locality isEqualToString:@"天津市"] || [pm.locality isEqualToString:@"北京市"] || [pm.locality isEqualToString:@"重庆市"]) {
                    NSRange range =[pm.locality rangeOfString:@"市"];
                    int loc= (int)range.location;
                    NSString *citystr =[pm.locality substringToIndex:loc];
                    
                    self.city= self.province = citystr;
                }
                else {
                    NSRange range= [pm.name rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *str= [pm.name substringToIndex:loc];
                    str = [str substringFromIndex:2];
                    
                    NSRange range1 = [str rangeOfString:@"省"];
                    int loc1 = (int)range1.location;
                    
                    if (range1.location != NSNotFound) {
                        NSLog(@"%@",str);
                        self.province = [str substringToIndex:loc1];
                        self.city = [str substringFromIndex:loc1+1];
                        
                        NSLog(@"%@,%@",[str substringToIndex:loc1],[str substringFromIndex:loc1]);
                    }
                    else if ([str isEqualToString:@"广西壮族自治区桂林"]) {
                        self.province=@"广西";
                        self.city=@"桂林";
                    }
                }
            }
            else {
                if ([pm.locality rangeOfString:@"市"].location != NSNotFound) {
                    NSLog(@"---%@",pm.locality);
                    NSRange range = [pm.locality rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *citystr = [pm.locality substringToIndex:loc];
                    self.city = citystr;
                    for (int i=0; i<[_groups count]; i++) {
                        CitiesGroup *cities=[_groups objectAtIndex:i];
                        for (int j=0;j<cities.cities.count;j++) {
                            NSString *str_city=[cities.cities objectAtIndex:j];
                            if ([str_city isEqualToString:citystr]) {
                                self.province=cities.state;
                                break;
                            }
                        }
                    }
                    
                    
                }
                else {
                    self.city = self.province = @"北京";
                }
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
          //  [self requestNet:self.province city:self.city];
            
           // [[NSUserDefaults standardUserDefaults]setObject:self.province forKey:@"省份"];
           // [[NSUserDefaults standardUserDefaults]setObject:self.city forKey:@"城市"];
        }
    }];
}



@end

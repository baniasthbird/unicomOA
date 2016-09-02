//
//  WeatherViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import "WeatherViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WeatherData.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
#import "INTULocationManager.h"
#import "LocalViewController.h"
#import "MJExtension.h"
#import "BaseFunction.h"
#import "UILabel+LabelHeightAndWidth.h"

@interface WeatherViewController()<CLLocationManagerDelegate,LocalViewControllerDelegate>

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *dt;    //当前日期
@property (nonatomic, strong) NSMutableArray *weatherArray;
@property (nonatomic, strong) WeatherData *wd;

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel * cityLabel;
@property (nonatomic, weak) UILabel * dateLabel;
@property (nonatomic, weak) UIImageView  *todayImg;
@property (nonatomic, weak) UILabel *temLabel;
//@property (nonatomic, weak) UILabel *climateLabel;
//@property (nonatomic, weak) UILabel *windLabel;
@property (nonatomic, weak) UILabel *pmLabel;

@property (nonatomic, weak) UIView *bottomV;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) double lati;

@property (nonatomic, assign) double longi;

@property (nonatomic, strong) BaseFunction *baseFunc;

@end


@implementation WeatherViewController

-(NSMutableArray *)weatherArray {
    if (!_weatherArray) {
        _weatherArray=[NSMutableArray array];
    }
    return  _weatherArray;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    _baseFunc=[[BaseFunction alloc]init];
    
    self.title=@"天气预报";
    
    [MBProgressHUD showMessage:@"正在加载"];
    NSString *pro =[[NSUserDefaults standardUserDefaults] objectForKey:@"省份"];
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"城市"];
    
    
   // if (pro && city) {
   //     [self requestNet:pro city:city];
   // }
   // else {
        [self setupLocation];
   // }
    
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
                    self.city = self.province = citystr;
                    
                }
                else {
                    self.city = self.province = @"北京";
                }
            }
            
            [self requestNet:self.province city:self.city];
            
            [[NSUserDefaults standardUserDefaults]setObject:self.province forKey:@"省份"];
            [[NSUserDefaults standardUserDefaults]setObject:self.city forKey:@"城市"];
        }
    }];
}


#pragma mark 请求网络
-(void)requestNet:(NSString *)pro city:(NSString *)city
{
    if ([city isEqualToString:@"郑州"] || [city isEqualToString:@"开封"] || [city isEqualToString:@"洛阳"] || [city isEqualToString:@"平顶山"] || [city isEqualToString:@"安阳"] || [city isEqualToString:@"鹤壁"] || [city isEqualToString:@"新乡"] || [city isEqualToString:@"焦作"] || [city isEqualToString:@"濮阳"] || [city isEqualToString:@"许昌"] || [city isEqualToString:@"漯河"] || [city isEqualToString:@"三门峡"] || [city isEqualToString:@"商丘"] || [city isEqualToString:@"济源"] || [city isEqualToString:@"驻马店"] || [city isEqualToString:@"南阳"] || [city isEqualToString:@"信阳"] || [city isEqualToString:@"周口"]) {
        pro=@"河南";
    }
    NSString *urlstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",pro,city];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [self.navigationController setNavigationBarHidden:YES];
        self.tabBarController.tabBar.hidden=YES;
      //  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        if (responseObject!=nil) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                self.dt = responseObject[@"dt"];
                NSString *str = [NSString stringWithFormat:@"%@|%@",pro,city];
                // NSArray *dataArray = [WeatherData objectArrayWithKeyValuesArray:responseObject[str]];
                NSDictionary *dic=(NSDictionary*)responseObject;
                NSArray *dataArray_tmp= [dic objectForKey:str];
                NSMutableArray *dataArray=[NSMutableArray arrayWithCapacity:[dataArray_tmp count]];
                for (int i=0;i<[dataArray_tmp count];i++) {
                    NSDictionary *dic_tmp=[dataArray_tmp objectAtIndex:i];
                    WeatherData *weather=[[WeatherData alloc]init];
                    weather.temperature=[dic_tmp objectForKey:@"temperature"];
                    weather.wind=[dic_tmp objectForKey:@"wind"];
                    weather.week=[dic_tmp objectForKey:@"week"];
                    weather.climate=[dic_tmp objectForKey:@"climate"];
                    weather.date=[dic_tmp objectForKey:@"date"];
                    [dataArray addObject:weather];
                }
                NSMutableArray *tempArray=[NSMutableArray array];
                
                for (WeatherData *weather in dataArray) {
                    [tempArray addObject:weather];
                }
                self.weatherArray = tempArray;
                
                //pm2d5
                NSDictionary *dic_pm2d5=[dic objectForKey:@"pm2d5"];
                WeatherData *wd=[[WeatherData alloc]init];
                NSObject *i_temperature =[dic objectForKey:@"rt_temperature"];
                NSString *str_temperature=@"";
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *num_temperature=(NSNumber*)i_temperature;
                str_temperature = [numberFormatter stringFromNumber:num_temperature];
                wd.temperature=[NSString stringWithFormat:@"%@%@",str_temperature,@"°"];
                wd.nbg2=[dic_pm2d5 objectForKey:@"nbg2"];
                wd.aqi=[dic_pm2d5 objectForKey:@"aqi"];
                wd.pm2_5=[dic_pm2d5 objectForKey:@"pm2_5"];
                // WeatherData *wd =[WeatherData mj_objectWithKeyValues:dic[@"pm2d5"]];
                self.wd=wd;
                
                [self initAll];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)initAll {
    
    if (self.view.subviews.count>0) {
        for (UIView *subview in self.view.subviews) {
            [self removeSubviews:subview];
        }
    }
    [self setupUI];            //设置顶部UI
    [self setupData];          //设置顶部UI数据
    [self bottomView];         //加载底部数据
}

-(void)removeSubviews:(UIView *)subView{
    if (subView.subviews.count>0)
    {
        for (UIView *subViews in subView.subviews)
        {
             [self removeSubviews:subViews];
        }
    }  else
    {
        NSLog(@"%lu",(unsigned long)subView.subviews.count);
        [subView removeFromSuperview];
    }
}

#pragma mark 顶部UI
-(void)setupUI {
    //背景
     self.view.backgroundColor=[UIColor whiteColor];
    CGRect img_bg=CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT*0.74137931034483);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:img_bg];
    imageV.image = [UIImage imageNamed:@"MoRen"];
    self.imageV= imageV;
    [self.view addSubview:imageV];
   
  
    
    
    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, 35, 40, 40);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    
    //城市名
    CGFloat cityLabelW = 150;
    CGFloat cityLabelH = 50;
    CGFloat cityLabelX = (SCREEN_WIDTH - cityLabelW)/2;
    CGFloat cityLabelY = 30;
    UILabel *cityLabel = [[UILabel alloc]init];
    [self setupWithLabel:cityLabel frame:CGRectMake(cityLabelX, cityLabelY, cityLabelW, cityLabelH) FontSize:24 view:self.view textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor]];
    self.cityLabel = cityLabel;
    
    //定位图标
    UIButton *locB = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityLabel.frame)+10, 45, 20 , 20)];
    [locB setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
    [locB addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locB];

    //温度
    CGFloat temLabelW = SCREEN_WIDTH*0.35;
    CGFloat temLabelH = SCREEN_HEIGHT*0.12;
    CGFloat temLabelX = (SCREEN_WIDTH-temLabelW)/2;
    CGFloat temLabelY = SCREEN_HEIGHT*0.17241379310345;
    UILabel *temLabel = [[UILabel alloc]init];
    [self setupWithLabel:temLabel frame:CGRectMake(temLabelX, temLabelY, temLabelW, temLabelH) FontSize:80 view:self.view textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor]];
    self.temLabel = temLabel;
    
    //天气图片
    CGFloat todayImgW = 70;
    CGFloat todayImgH = todayImgW;
    CGFloat todayImgX = SCREEN_WIDTH*0.63;
    CGFloat todayImgY= SCREEN_HEIGHT*0.21;
    
    UIImageView *todayImg = [[UIImageView alloc]initWithFrame:CGRectMake(todayImgX, todayImgY, todayImgW, todayImgH)];
    [self.view addSubview:todayImg];
    self.todayImg = todayImg;

    
    //日期
    CGFloat dateLW = SCREEN_WIDTH/2;
    CGFloat dateLH = 40;
    CGFloat dateLX = (SCREEN_WIDTH - dateLW)/2;
    CGFloat dateLY = CGRectGetMaxY(temLabel.frame)+20;
    UILabel *dateLabel = [[UILabel alloc]init];
    [self setupWithLabel:dateLabel frame:CGRectMake(dateLX, dateLY, dateLW, dateLH) FontSize:24 view:self.view textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor]];
    self.dateLabel = dateLabel;
    
    
    //天气
    
    UILabel *climateLabel = [[UILabel alloc]init];
    [self setupWithLabel:climateLabel frame:CGRectMake(SCREEN_WIDTH*0.15, CGRectGetMaxY(dateLabel.frame)+10, 40, 20) FontSize:24 view:self.view textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor]];
    
   // self.climateLabel = climateLabel;
    
    //风
    UILabel *windLabel = [[UILabel alloc]init];
    [self setupWithLabel:windLabel frame:CGRectMake(CGRectGetMaxX(climateLabel.frame)+5, CGRectGetMaxY(dateLabel.frame)+10, 80, 20) FontSize:24 view:self.view textAlignment:NSTextAlignmentLeft color:[UIColor whiteColor]];
   // self.windLabel = windLabel;
    
    //PM2.5
    UILabel *pmLabel = [[UILabel alloc]init];
    [self setupWithLabel:pmLabel frame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame)+10, SCREEN_WIDTH, 20) FontSize:24 view:self.view textAlignment:NSTextAlignmentCenter color:[UIColor whiteColor]];
    self.pmLabel = pmLabel;
    
}

#pragma mark 设置数据
-(void)setupData {
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"城市"];
    
    /** 加载数据 */
    /*
    NSURL *url_img=[NSURL URLWithString:self.wd.nbg2];
   // UIImage *img_org=[UIImage imageNamed:@"MoRen"];
    if (self.imageV!=nil) {
         NSData * data = [NSData dataWithContentsOfURL:url_img];
          UIImage *saveImage = [UIImage imageWithData:data];
        [self.imageV setImage:saveImage];
     //   [self.imageV sd_setImageWithURL:url_img placeholderImage:img_org];
    }
  //  [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.wd.nbg2] placeholderImage:[UIImage imageNamed:@"MoRen"]];
     */
    //城市
    self.cityLabel.text= city;
    
    //日期
    WeatherData *weatherdata = self.weatherArray[0];
    NSString *dtstr = [self.dt substringFromIndex:5];
    NSString *datestr = [dtstr stringByAppendingFormat:@"日 %@",weatherdata.week];
    datestr = [datestr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    self.dateLabel.text=datestr;
    
    //天气图片
    if ([weatherdata.climate isEqualToString:@"雷阵雨"]) {
        self.todayImg.image =[UIImage imageNamed:@"thunder_w"];
        [self.imageV setImage:[UIImage imageNamed:@"thunder_bg"]];
    }
    else if ([weatherdata.climate isEqualToString:@"晴"]) {
        self.todayImg.image = [UIImage imageNamed:@"sun_w"];
        [self.imageV setImage:[UIImage imageNamed:@"sun_bg"]];
    }
    else if ([weatherdata.climate isEqualToString:@"多云"]) {
        self.todayImg.image = [UIImage imageNamed:@"sunandcloud_w"];
        [self.imageV setImage:[UIImage imageNamed:@"sunandcloud_bg"]];
    }
    else if ([weatherdata.climate isEqualToString:@"阴"]) {
        self.todayImg.image = [UIImage imageNamed:@"cloud_w"];
        [self.imageV setImage:[UIImage imageNamed:@"cloud_bg"]];
    }
    //天气以雨为结尾
    else if ([weatherdata.climate hasSuffix:@"雨"]) {
        self.todayImg.image = [UIImage imageNamed:@"rain_w"];
        [self.imageV setImage:[UIImage imageNamed:@"rain_bg"]];
    }
    else if ([weatherdata.climate hasSuffix:@"雪"]) {
        self.todayImg.image = [UIImage imageNamed:@"snow_w"];
        [self.imageV setImage:[UIImage imageNamed:@"snow_bg"]];
    }
    else {
        self.todayImg.image = [UIImage imageNamed:@"sandfloat_w"];
        [self.imageV setImage:[UIImage imageNamed:@"sandfloat_bg"]];
    }
    
    
    //图片动画效果
    [UIView animateKeyframesWithDuration:0.9 delay:0.5 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.todayImg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.9 animations:^{
            self.todayImg.transform = CGAffineTransformIdentity;
        }];
    }];
    
    
    //温度
   // weatherdata.temperature = [weatherdata.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
   
   // self.temLabel.text = weatherdata.temperature;
   
    
    self.temLabel.text=self.wd.temperature;
    
    //天气 风和pm整合
 //   self.climateLabel.text = weatherdata.climate;
   // CGFloat i_width= [UILabel_LabelHeightAndWidth getWidthWithTitle:weatherdata.climate font:[UIFont systemFontOfSize:24]];
   // self.climateLabel setFrame:cgr
    
    //风
  //  self.windLabel.text = weatherdata.wind;
    //pm
    NSString *aqi;
    int pm = self.wd.pm2_5.intValue;
    if (pm < 50) {
        aqi =@"优";
    }
    else if (pm < 100) {
        aqi =@"良";
    }
    else {
        aqi = @"差";
    }
    NSString *pmstr=[NSString stringWithFormat:@"%@  %@  %@  %d  %@",weatherdata.climate,weatherdata.wind,@"PM2.5",pm,aqi];
   // pmstr = [pmstr stringByAppendingFormat:@"%@  %@   %d   %@",weatherdata.climate,weatherdata.wind,pm,aqi];
    self.pmLabel.text = pmstr;
    
    [self.temLabel sizeToFit];
    [self.dateLabel sizeToFit];
    
}

#pragma mark 加载底部数据
-(void)bottomView {
    for (int i = 1; i < 4; i++) {
        CGFloat vcW = SCREEN_WIDTH/3;
        CGFloat vcH = SCREEN_HEIGHT*0.25862068965517;
        CGFloat vcX = (i-1) * vcW;
        CGFloat vcY = SCREEN_HEIGHT - vcH;
        UIView *vc =[[UIView alloc]initWithFrame:CGRectMake(vcX, vcY, vcW, vcH)];
      //  vc.backgroundColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:0.2];
        
        [self.view addSubview:vc];
        self.bottomV = vc;
        
        //星期
        UILabel *weekLabel =[[UILabel alloc]init];
        [self setupWithLabel:weekLabel frame:CGRectMake(0, 15, vcW, 20) FontSize:14 view:vc textAlignment:NSTextAlignmentCenter color:[UIColor redColor]];
        //图片
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((vcW-60)/2, CGRectGetMaxY(weekLabel.frame)+5, 60, 60)];
        [vc addSubview:img];
        //温度
        UILabel *temLabel = [[UILabel alloc]init];
        [self setupWithLabel:temLabel frame:CGRectMake(0, CGRectGetMaxY(img.frame), vcW, 20) FontSize:20 view:vc textAlignment:NSTextAlignmentCenter color:[UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1]];
        //风、天气
        UILabel *cliwindLabel = [[UILabel alloc]init];
        cliwindLabel.numberOfLines = 0;
        CGFloat size_cliwind=12;
        CGFloat cliwindy=CGRectGetMaxY(temLabel.frame)-15;
        if (iPhone6_plus || iPhone6) {
            size_cliwind=14;
            cliwindy=CGRectGetMaxY(temLabel.frame);
        }
        [self setupWithLabel:cliwindLabel frame:CGRectMake(0, cliwindy, vcW, 50) FontSize:size_cliwind view:vc textAlignment:NSTextAlignmentCenter color:[UIColor blackColor]];
        
        
        /** 加载数据  */
        WeatherData *weatherdata = self.weatherArray[i];
        //星期
        weekLabel.text = weatherdata.week;
        //图片
        if ([weatherdata.climate isEqualToString:@"雷阵雨"]) {
            img.image = [UIImage imageNamed:@"thunder_b"];
        }else if ([weatherdata.climate isEqualToString:@"晴"]){
            img.image = [UIImage imageNamed:@"sun_b"];
        }else if ([weatherdata.climate isEqualToString:@"多云"]){
            img.image = [UIImage imageNamed:@"sunandcloud_b"];
        }else if ([weatherdata.climate isEqualToString:@"阴"]){
            img.image = [UIImage imageNamed:@"cloud_b"];
        }else if ([weatherdata.climate hasSuffix:@"雨"]){
            img.image = [UIImage imageNamed:@"rain_b"];
        }else if ([weatherdata.climate hasSuffix:@"雪"]){
            img.image = [UIImage imageNamed:@"snow_b"];
        }else{
            img.image = [UIImage imageNamed:@"sandfloat"];
        }
        //温度
        NSString *tem = [weatherdata.temperature stringByReplacingOccurrencesOfString:@"C" withString:@""];
        tem=[tem stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        temLabel.text=tem;
        //风、天气
     //   cliwindLabel.text = [weatherdata.climate stringByAppendingFormat:@"\n%@",weatherdata.wind];
        cliwindLabel.text=weatherdata.climate;

    }
}


#pragma mark 设置label属性
-(void)setupWithLabel:(UILabel *)label frame:(CGRect)frame FontSize:(CGFloat)fontSize view:(UIView *)view textAlignment:(NSTextAlignment)textAlignment color:(UIColor*)i_color{
    label.frame = frame;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = i_color;
    label.textAlignment = textAlignment;
    [view addSubview:label];
}

#pragma mark 返回按钮 
-(void)backClick {
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)locClick {
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:@"城市"];
    
    LocalViewController *localV= [[LocalViewController alloc]init];
    localV.currentTitle= city;
    localV.delegate=self;
    localV.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:localV];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}


-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(void)localviewwithview:(LocalViewController *)localviewcontrol province:(NSString *)province city:(NSString *)city
{
    self.weatherArray = nil;
    //    self.province = provice;
    //    self.city = city;
    [MBProgressHUD showMessage:@"正在加载..."];
    [self requestNet:province city:city];
    
    [[NSUserDefaults standardUserDefaults]setObject:province forKey:@"省份"];
    [[NSUserDefaults standardUserDefaults]setObject:city forKey:@"城市"];
}


@end

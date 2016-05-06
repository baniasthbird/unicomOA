//
//  MapViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MapViewController.h"



@interface MapViewController()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,strong) MKMapView *mapView;

@property (nonatomic,strong) CLGeocoder *geocoder;

@property (nonatomic,strong) CLLocation *location_now;

@end

@implementation MapViewController

-(void)viewDidLoad {
    
    self.title=@"位置选择";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;
    
    _geocoder=[[CLGeocoder alloc]init];
    [self getCoordinateByAddress:@"杭州"];
    
    self.mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_mapView setMapType:MKMapTypeStandard];
    
    UILongPressGestureRecognizer *lpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    
    lpress.minimumPressDuration=0.5;
    
    lpress.allowableMovement=5.0f;
    
    [_mapView addGestureRecognizer:lpress];
    
    _mapView.delegate=self;
    if (_touchMapCoord.longitude==0 && _touchMapCoord.latitude==0) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=34.7748310668;
        coordinate.longitude=113.6813931308;
        
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        
        MKCoordinateRegion region;
        region.center=coordinate;
        region.span=span;
        
        [_mapView setRegion:region];
        
         _mapView.userTrackingMode=MKUserTrackingModeFollow;
    }
    else {
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        
        MKCoordinateRegion region;
        region.center=_touchMapCoord;
        region.span=span;
        
        MKPointAnnotation *pointAnnotation=nil;
        
        pointAnnotation=[[MKPointAnnotation alloc]init];
        
        pointAnnotation.coordinate=_touchMapCoord;
        
        pointAnnotation.title=@"设置地点";
        
        [_mapView addAnnotation:pointAnnotation];
        
        [_mapView setRegion:region];
        
        _mapView.showsUserLocation=YES;

    }
    
    UIButton *btn_locate=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-145, 30, 30)];
    btn_locate.backgroundColor=[UIColor colorWithRed:75/255.0f green:187/255.0f blue:251/255.0f alpha:1];
    [btn_locate setBackgroundImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [btn_locate addTarget:self action:@selector(LocateNow:) forControlEvents:UIControlEventTouchUpInside];
    
   
    _manager=[[CLLocationManager alloc]init];
    
    //设置代理
    _manager.delegate=self;
    //设置定位精度
    _manager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
    _manager.distanceFilter=distance;

    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_manager requestWhenInUseAuthorization];
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_manager requestWhenInUseAuthorization];
    }
   // if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
     
              //启动跟踪定位
        [_manager startUpdatingLocation];
  //  }
    
    
    [self.view addSubview:_mapView];
    [_mapView addSubview:btn_locate];
}

-(void)LocateNow:(UIButton*)sender  {
    if (_location_now!=nil) {
       
        MKCoordinateSpan span;
        span.latitudeDelta=0.03;
        span.longitudeDelta=0.03;
        
        MKCoordinateRegion region;
        region.center= _location_now.coordinate;
        region.span=span;
        
        [_mapView setRegion:region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location=[locations lastObject];
    NSDate *eventDate=location.timestamp;
    NSTimeInterval howRecent=[eventDate timeIntervalSinceNow];
    if (fabs(howRecent)<15.0f) {
        _location_now=location;
        //If the event is recent, do something with it
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}







-(void)getCoordinateByAddress:(NSString *)address {
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //取得第一个地标，地标中存储了详细地址信息
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location; //位置
        
        CLRegion *region=placemark.region;  //区域
        
        NSDictionary *addressDic=placemark.addressDictionary;   //详细地址信息字典
        
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitutde:(CLLocationDegrees)longitude {
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        _placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",_placemark.addressDictionary);
    }];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@",userLocation);
}


-(void)longPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state==UIGestureRecognizerStateEnded) {
        return;
    }
    [_mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
            [_mapView removeAnnotation:obj];
        
    }];
    
    CGPoint touchPoint=[gestureRecognizer locationInView:_mapView];
    _touchMapCoord=[_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    [self getAddressByLatitude:_touchMapCoord.latitude longitutde:_touchMapCoord.longitude];
    
    MKPointAnnotation *pointAnnotation=nil;
    
    pointAnnotation=[[MKPointAnnotation alloc]init];
    
    pointAnnotation.coordinate=_touchMapCoord;
    
    pointAnnotation.title=@"设置地点";
    
    [_mapView addAnnotation:pointAnnotation];
}


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        return nil;
    }
    
    static NSString *AnnotationIdentifier=@"AnnotationIdentifier";
    
    MKPinAnnotationView *customPinView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!customPinView) {
        customPinView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"设置"];
        
        customPinView.pinColor=MKPinAnnotationColorRed;
        
        customPinView.animatesDrop=YES;
        
        customPinView.canShowCallout=YES;
        
        customPinView.draggable=YES;
        
        //添上tips按钮
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView=rightButton;
    }
    else {
        customPinView.annotation=annotation;
    }
    
    return customPinView;
}


-(void)showDetails:(UIButton*)sender {
    
}





-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)MoveNextVc:(UIButton*)sender {
   // [_delegate PassMapValue:_mapView];
    if (_placemark!=nil && _touchMapCoord.latitude!=0 && _touchMapCoord.longitude!=0) {
        [_delegate PassMapValue:_placemark Coordinate:_touchMapCoord];

    }
        [self.navigationController popViewControllerAnimated:YES];
}
@end

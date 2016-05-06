//
//  MapViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class  MapViewController;

@protocol MapViewControllerDelegate <NSObject>

-(void)PassMapValue:(CLPlacemark*)placemark Coordinate:(CLLocationCoordinate2D)touchmapcoord;

@end


@interface MapViewController : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,unsafe_unretained) id<MapViewControllerDelegate> delegate;

@property  CLLocationCoordinate2D touchMapCoord;

@property (nonatomic,strong) CLPlacemark *placemark;

@end

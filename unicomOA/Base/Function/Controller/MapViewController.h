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

@class  MapViewController;

@protocol MapViewControllerDelegate <NSObject>

-(void)PassMapValue:(MKMapView*)mapView;

@end


@interface MapViewController : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,unsafe_unretained) id<MapViewControllerDelegate> delegate;

@end

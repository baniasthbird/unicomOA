//
//  UserEntity.h
//  unicomOA
//
//  Created by zr-mac on 16/2/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#ifndef UserEntity_h
#define UserEntity_h
#import <CoreLocation/CoreLocation.h>


@interface UserEntity : NSObject

@property (nonatomic,strong) NSString *str_FenLei;

@property (nonatomic,strong) NSString *str_Content;

@property (nonatomic,strong) NSString *str_curdate;

//记录备忘录预约时间
@property (nonatomic,strong) NSDate   *date_meeting;

@property (nonatomic,strong) NSDate   *date_notes;

//照片地址
@property (nonatomic,strong) NSString *str_pic_path;

//位置坐标
@property  CLLocationCoordinate2D coord_placemark;


@end


#endif /* UserEntity_h */

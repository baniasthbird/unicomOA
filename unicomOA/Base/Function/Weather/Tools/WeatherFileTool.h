//
//  WeatherFileTool.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/22.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WeatherFileTool : NSObject

+(void)writeWeatherToFile:(WeatherData *)weather withCity:(NSString*)city;
+(WeatherData *)readWeatherFromFileWithCity:(NSString*)city;
+(void)writeCitysToFile:(NSMutableArray *)citys;
+(NSMutableArray *)readCitysFromFile;

@end

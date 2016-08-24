//
//  WeatherFileTool.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/22.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "WeatherFileTool.h"


@implementation WeatherFileTool

+(void)writeWeatherToFile:(WeatherData *)weather withCity:(NSString *)city {
    if (!city) {
        city=@"default";
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath =[paths objectAtIndex:0];
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:weather];
    NSString *filePath = [rootPath stringByAppendingPathComponent:city];
    [data writeToFile:filePath atomically:YES];
}

+(WeatherData*)readWeatherFromFileWithCity:(NSString *)city {
    if (!city) {
        city=@"default";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:city];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    WeatherData *weather = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return weather;
}

+(void)writeCitysToFile:(NSMutableArray *)citys{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:@"cityList"];
    [citys writeToFile:filePath atomically:YES];
}
+(NSMutableArray *)readCitysFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:@"cityList"];
    NSMutableArray *citys = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (!citys) {
        citys = [NSMutableArray array];
    }
    return citys;
}


@end

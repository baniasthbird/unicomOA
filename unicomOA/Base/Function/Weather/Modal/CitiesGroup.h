//
//  CitiesGroup.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/18.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitiesGroup : NSObject

@property (nonatomic , strong) NSArray *cities;
@property (nonatomic , copy)   NSString *state;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end

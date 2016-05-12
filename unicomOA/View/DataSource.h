//
//  DataSource.h
//  unicomOA
//
//  Created by zr-mac on 16/4/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

-(NSMutableArray*) addTestData;

-(NSMutableArray*)addRealData:(NSMutableArray*)staffArray departArray:(NSMutableArray*)departArray;

@end

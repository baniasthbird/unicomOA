//
//  DataBase.h
//  unicomOA
//
//  Created by zr-mac on 16/5/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

#import "FMDatabaseAdditions.h"

#import "UserEntity.h"

#import "CarService.h"


@interface DataBase : NSObject

@property (nonatomic,strong) FMDatabase *database;  //数据库操作对象

+(DataBase *)sharedinstanceDB;
-(void)initTables;
-(void)deallocDataBase;

-(void)InsertIPTable:(NSString*)str_ipaddr port:(NSString*)str_port IP_Mark:(NSString*)str_mark;
-(void)InsertInterFaceTable;
-(void)InsertNotesTable:(NSMutableDictionary *)dic_notes;
-(void)InsertCarApplicationTable;

-(void)UpdateIPTable:(NSString*)str_ipaddr port:(NSString*)str_port IP_Mark:(NSString*)str_mark;
-(void)UpdateInterFaceTable:(NSMutableDictionary*)dic_inerface;
-(void)UpdateNotesTable:(NSMutableDictionary*)dic_notes;
-(void)UpdateCarApplicationTable:(NSMutableDictionary*)dic_carApplication;

-(NSMutableArray*)fetchIPAddress;
-(NSMutableArray*)fetchAllInterface;
-(NSMutableArray*)fetchAllNotes;
-(NSMutableArray*)fetchAllCarApplication;


//获得单一数据
-(NSString*)fetchInterface:(NSString*)str_key;
//-(UserEntity*)fetchNotes:(NSString*)str_key;
//-(CarService*)fetchCarApplication:(NSString*)str_key;


@end

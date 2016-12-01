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

#import "BaseFunction.h"



@interface DataBase : NSObject

@property (nonatomic,strong) FMDatabase *database;  //数据库操作对象

@property (nonatomic,strong) BaseFunction *base_func;


+(DataBase *)sharedinstanceDB;
-(void)initTables;
-(void)deallocDataBase;

-(void)InsertIPTable:(NSString*)str_ipaddr port:(NSString*)str_port IP_Mark:(NSString*)str_mark;
-(void)InsertInterFaceTable;
-(void)InsertNotesTable:(NSMutableDictionary *)dic_notes;
//添加通讯录（首次登录时使用）
-(void)InserStaffTable:(NSMutableArray*)arr_staff;
//添加部门（首次登录时使用）
-(void)InserDepartMentTable:(NSMutableArray*)arr_department;
//添加已读消息
-(void)InsertSysMsg:(NSMutableArray*)arr_sysmsg;
//添加事务流程表数据
-(void)InsertShiwuTable;
//添加单个事务流程
-(void)InsertSingleShiWU:(NSMutableDictionary*)dic_shiwu;

-(void)addSingleSysMsg:(NSDictionary*)dic_sysmsg;

//更新通讯录
-(void)UpdateStaffTable:(NSMutableArray*)arr_staff;
-(void)UpdateDepartmentTable:(NSMutableArray*)arr_department;
//更新流程表
-(void)UpdateShiWuTable:(NSMutableArray*)flowArray;
//查询通讯录,根据条件
-(NSMutableArray*)GetPeopleByNum:(NSString*)str_condition con2:(NSString*)str_condition2 keyword:(NSString*)str_key;
-(NSMutableArray*)GetPeopleByName:(NSString*)str_condition keyword:(NSString *)str_key;

-(void)UpdateIPTable:(NSString*)str_ipaddr port:(NSString*)str_port IP_Mark:(NSString*)str_mark;
-(void)UpdateInterFaceTable:(NSMutableDictionary*)dic_inerface;
-(void)UpdateNotesTable:(NSMutableDictionary*)dic_notes;


-(NSMutableArray*)fetchIPAddress;
-(NSMutableArray*)fetchAllInterface;
-(NSMutableArray*)fetchAllNotes;
-(NSMutableArray*)fetchAllStaff;
-(NSMutableArray*)fetchAllDepart;
-(NSMutableArray*)fetchAllSysMsg:(NSString*)str_username;



-(void)DeleteNotesTable:(NSString*)str_index;


//获得单一数据
-(NSString*)fetchInterface:(NSString*)str_key;
//获得事务流程标题
-(NSString*)fetchShiWu:(NSString *)str_key;
//-(UserEntity*)fetchNotes:(NSString*)str_key;
//-(CarService*)fetchCarApplication:(NSString*)str_key;


@end

//
//  DataBase.m
//  unicomOA
//
//  Created by zr-mac on 16/5/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

-(void)dealloc {
    if ([_database open]) {
        [self close];
    }
}


-(void) open {
    if (![_database open]) {
        NSAssert(0, @"不能打开数据库");
    }
}

-(void)close {
    if (![_database close]) {
        NSAssert(0, @"关闭数据库失败");
    }
}

- (void)deallocDataBase
{
    _database = nil;
}
    
//单例
+(DataBase *)sharedinstanceDB {
    static DataBase *sharedInstanceDB=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstanceDB=[[DataBase alloc]init];
    });
    
    return sharedInstanceDB;
}

-(id)init {
    self=[super init];
    if (self) {
        NSString *dbname=@"Mydatabase.db";
        _database=[[FMDatabase alloc] initWithPath:[self databasePath:dbname]];
         NSLog(@"database init");
    }
    return self;
}

-(NSString *)databasePath:(NSString*)userName {
    NSString *dir = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Library",userName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return  [NSString stringWithFormat:@"%@/note.db",dir];
   
}

//初始化数据库所有的表
-(void)initTables {
    
    [_database open];
    //生成IP表
    NSString *sqlCreateTableIP=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",IP_TABLENAME,IP_ID,IP_NAME,IP_PORT,IP_MARK];
    BOOL resIP=[_database executeUpdate:sqlCreateTableIP];
    if (!resIP) {
        NSLog(@"error when creating IP table");
    } else {
        NSLog(@"success to creating IP table");
    }

    //生成接口表
    NSString *sqlCreateTableInterface=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT)",INTERFACE_TABLENAME,INTERFACE_ID,INTERFACE_NAME,INTERFACE_VALUE];
    BOOL resInterface = [_database executeUpdate:sqlCreateTableInterface];
    if (!resInterface) {
        NSLog(@"error when creating INTERFACE table");
    } else {
        NSLog(@"success to creating INTERFACE table");
    }

    //生成备忘录表
    NSString *sqlCreateTableNotes=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER , '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' REAL, '%@' REAL)",NOTES_TABLENAME,NOTES_ID,NOTES_INDEX,NOTES_FENLEI,NOTES_CONTENT,NOTES_MEETING_DATE,NOTES_DATE,NOTES_PIC_PATH,NOTES_COOR_X,NOTES_COOR_Y];
    BOOL resNotes = [_database executeUpdate:sqlCreateTableNotes];
    if (!resNotes) {
        NSLog(@"error when creating NOTES table");
    } else {
        NSLog(@"success to creating NOTES table");
    }

    //生成预约用车表
    NSString *sqlCreateTableCarApplication=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' BLOB, '%@' BLOB, '%@' BLOB)",CAR_TABLNAME,CAR_ID,CAR_USRNAME,CAR_DEPART,CAR_PHONNUM,CAR_CATEGROY,CAR_USRNUM,CAR_CARUSR,CAR_USINGTIME,CAR_RETURNTIME,CAR_DES,CAR_REASON,CAR_REMARK,CAR_APPLICATIONTIME,CAR_SHENPI1,CAR_SHENPI2,CAR_MODEL];
    BOOL resCarApp = [_database executeUpdate:sqlCreateTableCarApplication];
    if (!resCarApp) {
        NSLog(@"error when creating CAR table");
    } else {
        NSLog(@"success to creating CAR table");
    }


}



//初始化IP表
-(void)InsertIPTable:(NSString *)str_ipaddr port:(NSString *)str_port IP_Mark:(NSString *)str_mark {
    NSMutableArray *t_array=[self fetchIPAddress];
    if (t_array.count==0) {
        if ([_database open]) {
           NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@') VALUES ('%@', '%@', '%@')",IP_TABLENAME,IP_NAME,IP_PORT,IP_MARK,str_ipaddr,str_port,str_mark];
            BOOL res=[_database executeUpdate:insertSql1];
            if (res) {
                NSLog(@"成功添加至IP表!");
            } else {
                NSLog(@"添加数据至IP表出错！");
            }
        }
    }
}

//获取IP表数据
-(NSMutableArray*) fetchIPAddress {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", IP_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_ipaddress=[rs stringForColumn:IP_NAME];
        NSString *str_port=[rs stringForColumn:IP_PORT];
        NSArray *arr_ip=@[str_ipaddress,str_port];
        [array addObject:arr_ip];
    }
    
    [_database close];
    
    return array;
}


//更新IP地址
-(void)UpdateIPTable:(NSString *)str_ipaddr port:(NSString *)str_port IP_Mark:(NSString *)str_mark {
    if ([_database open]) {
        NSString *updateSql1=@"";
        updateSql1=[NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@', '%@' = '%@', '%@' = '%@' ",IP_TABLENAME,IP_NAME,str_ipaddr,IP_PORT,str_port,IP_MARK,str_mark];
        BOOL res=[_database executeUpdate:updateSql1];
        if (res) {
            NSLog(@"成功更新至IP表!");
        } else {
            NSLog(@"更新数据至IP表出错！");
        }
    }
}


                   



//初始化接口数据表
-(void)InsertInterFaceTable {
    NSMutableArray *t_array=[self fetchAllInterface];
    if (t_array.count==0) {
        if ([_database open]) {
            //登陆
            NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"Login",@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.login.biz.ext"];
            BOOL res1=[_database executeUpdate:insertSql1];
            
            //退出
            NSString *insertSql2=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"Logout",@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.logout.biz.ext"];
            BOOL res2=[_database executeUpdate:insertSql2];
            
            //修改密码
            NSString *insertSql3=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"ChangePassword",@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.updatePassword.biz.ext"];
            BOOL res3=[_database executeUpdate:insertSql3];
            
            //通讯录列表
            NSString *insertSql4=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"AddressList",@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.list.biz.ext"];
            BOOL res4=[_database executeUpdate:insertSql4];
            
            //通讯录姓名查询
            NSString *insertSql5=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"ListSearch",@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.search.biz.ext"];
            BOOL res5=[_database executeUpdate:insertSql5];
            
            //待办流程提醒
            NSString *insertSql6=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskRemind",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskManager.flowList.biz.ext"];
            BOOL res6=[_database executeUpdate:insertSql6];
            
            //未读消息列表
            NSString *insertSql7=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"UnreadMessage",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.msgList.biz.ext"];
            BOOL res7=[_database executeUpdate:insertSql7];
            
            //未读公文列表
            NSString *insertSql8=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"UnreadDoc",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.docList.biz.ext"];
            BOOL res8=[_database executeUpdate:insertSql8];
            
            //待办事项数量统计
            NSString *insertSql9=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskCount",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.count.biz.ext"];
            BOOL res9=[_database executeUpdate:insertSql9];
            
            //新闻数量统计
            NSString *insertSql10=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"NewsListCount",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.count.biz.ext"];
            BOOL res10=[_database executeUpdate:insertSql10];
            
            //新闻列表
            NSString *insertSql11=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"NewsList",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.list.biz.ext"];
            BOOL res11=[_database executeUpdate:insertSql11];
            
            //新闻详细内容
            NSString *insertSql12=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"NewsContent",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.list.biz.ext"];
            BOOL res12=[_database executeUpdate:insertSql12];
            
            //新闻评论列表
            NSString *insertSql13=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"NewsComment",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.commentList.biz.ext"];
            BOOL res13=[_database executeUpdate:insertSql13];
            
            //添加评论
            NSString *insertSql14=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"AddComment",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.addComment.biz.ext"];
            BOOL res14=[_database executeUpdate:insertSql14];
            
            //能发起的流程
            NSString *insertSql15=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskAudit",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.procdefList.biz.ext"];
            BOOL res15=[_database executeUpdate:insertSql15];
            
            //待办流程审批列表
            NSString *insertSql16=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"UnFinishTaskShenPiList",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.pendingList.biz.ext"];
            BOOL res16=[_database executeUpdate:insertSql16];
            
            //待办流程审批列表
            NSString *insertSql17=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"FinishTaskShenPiList",@"/default/mobile/oa/ com.hnsi.erp.mobile.oa.TaskAuditSearch.pendingList.biz.ext"];
            BOOL res17=[_database executeUpdate:insertSql17];
            
            //审批记录
            NSString *insertSql18=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskLog",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.queryDisposeLog.biz.ext"];
            BOOL res18=[_database executeUpdate:insertSql18];


            if (res1 && res2 && res3 && res4 && res5 && res6 && res7 && res8 && res9 && res10 && res11 && res12 && res13 && res14 && res15 && res16 && res17 && res18 ) {
                NSLog(@"成功添加数据至接口表");
            }
            else {
                NSLog(@"错误，无法添加数据至接口表");
            }
        }
    }
}

//获取接口数据表
-(NSMutableArray*)fetchAllInterface {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", INTERFACE_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_interface_key=[rs stringForColumn:INTERFACE_NAME];
        NSString *str_interface_value=[rs stringForColumn:INTERFACE_VALUE];
        NSArray *arr_interface=@[str_interface_key,str_interface_value];
        [array addObject:arr_interface];
    }
    
    [_database close];
    
    return array;

}

-(NSString*)fetchInterface:(NSString *)str_key {
    [_database open];
    NSString *str_interface_value=@"";
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ", INTERFACE_TABLENAME,INTERFACE_NAME,str_key];
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        str_interface_value=[rs stringForColumn:INTERFACE_VALUE];
    }
    [_database close];
    return str_interface_value;
}

//更新接口数据表
-(void)UpdateInterFaceTable:(NSMutableDictionary *)dic_inerface {
    if ([_database open]) {
        
    }
}

//NOTES_TABLENAME,NOTES_ID,NOTES_FENLEI,NOTES_CONTENT,NOTES_MEETING_DATE,NOTES_DATE,NOTES_PIC_PATH,NOTES_COOR_X,NOTES_COOR_Y

//添加数据至备忘录表
-(void)InsertNotesTable:(NSMutableDictionary *)dic_notes {
    if ([_database open]) {
        NSString *str_index=[dic_notes objectForKey:@"index"];
        NSString *str_fenlei=[dic_notes objectForKey:@"FenLei"];
        NSString *str_content=[dic_notes objectForKey:@"Content"];
        NSString *str_meeting_date=[dic_notes objectForKey:@"meeting_date"];
        if (str_meeting_date==nil) {
            str_meeting_date=@"";
        }
        NSString *str_notes_date=[dic_notes objectForKey:@"notes_date"];
        NSString *str_pic_path=[dic_notes objectForKey:@"pic_path"];
        NSString *str_coord_x=[dic_notes objectForKey:@"coord_x"];
        NSString *str_coord_y=[dic_notes objectForKey:@"coord_y"];
        
        //备忘录
        NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@' , '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@')",NOTES_TABLENAME,NOTES_INDEX,NOTES_FENLEI,NOTES_CONTENT,NOTES_MEETING_DATE,NOTES_DATE,NOTES_PIC_PATH,NOTES_COOR_X,NOTES_COOR_Y,str_index,str_fenlei,str_content,str_meeting_date,str_notes_date,str_pic_path,str_coord_x,str_coord_y];
        
        BOOL res=[_database executeUpdate:insertSql];
        if (res) {
            NSLog(@"数据成功添加至备忘录表");
        }
        else {
            NSLog(@"添加至备忘录表失败");
        }
        
    }
}


-(void)DeleteNotesTable:(NSString *)str_index {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM NOTES_TABLENAME WHERE NOTES_INDEX like '%%%@%%' ",str_index];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除该条备忘录");
        }
        else {
            NSLog(@"删除该条备忘录失败");
        }

    }
}

-(NSMutableArray*)fetchAllNotes {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", NOTES_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_index=[rs stringForColumn:NOTES_INDEX];
        NSString *str_notes_fenlei=[rs stringForColumn:NOTES_FENLEI];
        NSString *str_notes_content=[rs stringForColumn:NOTES_CONTENT];
        NSString *str_notes_meeting_date=[rs stringForColumn:NOTES_MEETING_DATE];
        NSString *str_notes_date=[rs stringForColumn:NOTES_DATE];
        NSString *str_notes_pic_path=[rs stringForColumn:NOTES_PIC_PATH];
        double d_coor_x=[rs doubleForColumn:NOTES_COOR_X];
        NSString *str_coord_x=[NSString stringWithFormat:@"%f",d_coor_x];
        double d_coor_y=[rs doubleForColumn:NOTES_COOR_Y];
         NSString *str_coord_y=[NSString stringWithFormat:@"%f",d_coor_y];
        CLLocationCoordinate2D coord;
        coord.longitude=d_coor_x;
        coord.latitude=d_coor_y;
        NSMutableDictionary *dic_interface=[NSMutableDictionary dictionaryWithCapacity:8];
        [dic_interface setValue:str_index forKey:@"index"];
        [dic_interface setValue:str_notes_fenlei forKey:@"fenlei"];
        [dic_interface setValue:str_notes_content forKey:@"content"];
        [dic_interface setValue:str_notes_meeting_date forKey:@"meeting_date"];
        [dic_interface setValue:str_notes_date forKey:@"notes_date"];
        [dic_interface setValue:str_notes_pic_path forKey:@"pic_path"];
        [dic_interface setValue:str_coord_x forKey:@"coord_x"];
        [dic_interface setValue:str_coord_y forKey:@"coord_y"];
        [array addObject:dic_interface];
    }
    
    [_database close];
    
    return array;
}

//根据条件查找某一条备忘录
//-(NSMutableDictionary*)fetchNotes:(


//更新备忘录表
//-(void)UpdateNotesTable:(NSMutableDictionary *)dic_notes {
    
//}


/*
-(NSMutableArray*)fetchAllCarApplication {
    //0508 暂时不实现
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", NOTES_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_notes_fenlei=[rs stringForColumn:NOTES_FENLEI];
        NSString *str_notes_content=[rs stringForColumn:NOTES_CONTENT];
        NSString *str_notes_meeting_date=[rs stringForColumn:NOTES_MEETING_DATE];
        NSString *str_notes_date=[rs stringForColumn:NOTES_DATE];
        NSString *str_notes_pic_path=[rs stringForColumn:NOTES_PIC_PATH];
        double d_coor_x=[rs doubleForColumn:NOTES_COOR_X];
        NSString *str_coord_x=[NSString stringWithFormat:@"%f",d_coor_x];
        double d_coor_y=[rs doubleForColumn:NOTES_COOR_Y];
        NSString *str_coord_y=[NSString stringWithFormat:@"%f",d_coor_y];
        CLLocationCoordinate2D coord;
        coord.longitude=d_coor_x;
        coord.latitude=d_coor_y;
        NSArray *arr_interface=@[str_notes_fenlei,str_notes_content,str_notes_meeting_date,str_notes_date,str_notes_pic_path,str_coord_x,str_coord_y];
        [array addObject:arr_interface];
    }
    
    [_database close];
    
    return array;

}
*/



@end

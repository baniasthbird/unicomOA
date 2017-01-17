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
        _base_func=[[BaseFunction alloc]init];
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
    //生成用户表
    NSString *sqlCreateTableUser=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",USER_TABLENAME,USER_ID,USER_NAME,USER_PASSWORD,USER_MARK];
    BOOL resUser=[_database executeUpdate:sqlCreateTableUser];
    if (!resUser) {
        NSLog(@"error when creating User table");
    } else {
        NSLog(@"success to creating User table");
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
    NSString *sqlCreateTableNotes=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER , '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",NOTES_TABLENAME,NOTES_ID,NOTES_INDEX,NOTES_FENLEI,NOTES_CONTENT,NOTES_MEETING_DATE,NOTES_DATE,NOTES_PIC_PATH,NOTES_COOR_X,NOTES_COOR_Y,NOTES_ADDR];
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
    
    //生成员工表
    NSString *sqlCreateTableStaff=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT , '%@' TEXT ,'%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT, '%@' TEXT )",STAFF_TABLENAME,STAFF_TABLE_ID,STAFF_ID,STAFF_USERNAME,STAFF_GENDER,STAFF_ORG_ID,STAFF_ORG_NAME,STAFF_EMAIL,STAFF_POSINAME,STAFF_MOBILE,STAFF_TEL,STAFF_IMG];
    BOOL resStaff=[_database executeUpdate:sqlCreateTableStaff];
    if (!resStaff) {
        NSLog(@"error when creating staff table");
    }
    else {
        NSLog(@"success to creating staff table");
    }

    
    //生成部门表
    NSString *sqlCreateTableDepartment=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( '%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT , '%@' TEXT , '%@' TEXT)",DEPART_TABLENAME,DEPART_ID,DEPART_ORGID,DEPART_ORGNAME,DEPART_PARENTID];
    BOOL resDepart=[_database executeUpdate:sqlCreateTableDepartment];
    if (!resDepart) {
        NSLog(@"error when creating depart table");
    }
    else {
        NSLog(@"success to creating depart table");
    }
    
    //生成已读系统消息表
    NSString *sqlCreateTableSysMsg=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( '%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT , '%@' TEXT)",SYSMSG_TABLENAME,SYSMSG_ID,SYSMSG_SYSID,SYSMSG_MSGTYPE,SYSMSG_SENDEMPNAME,SYSMSG_RECEIVENAME,SYSMSG_TITLE,SYSMSG_SENDTIME];
    BOOL resSysMsg=[_database executeUpdate:sqlCreateTableSysMsg];
    if (!resSysMsg) {
        NSLog(@"error when creating sysmsg table");
    }
    else {
        NSLog(@"success to creating sysmsg table");
    }

    //生成事务管理流程表
    NSString *sqlCreateTableShiWuProcess=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( '%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT , '%@' TEXT)",SHIWU_TABLENAME,SHIWU_ID,SHIWU_LABEL,SHIWU_TITLE];
    BOOL resShiWu=[_database executeUpdate:sqlCreateTableShiWuProcess];
    if (!resShiWu) {
        NSLog(@"error when creating shiwu table");
    }
    else {
         NSLog(@"success to creating shiwu table");
    }

}


-(void)DeleteIPTable {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM %@",IP_TABLENAME];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除IP表");
        }
        else {
            NSLog(@"删除IP表失败");
        }
    }

}

//初始化IP表
-(void)InsertIPTable:(NSString *)str_ipaddr port:(NSString *)str_port IP_Mark:(NSString *)str_mark {
    NSMutableArray *t_array=[[NSMutableArray alloc]init];
    if ([str_mark isEqualToString:@"Server"]) {
        t_array=[self fetchIPAddress];
    }
    else if ([str_mark isEqualToString:@"PushServer"]) {
        t_array=[self fetchPushIPAddress];
    }
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

//获取主服务器IP表数据
-(NSMutableArray*) fetchIPAddress {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@  = '%@' ", IP_TABLENAME,IP_MARK,@"Server"];
    
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

-(NSMutableArray*) fetchPushIPAddress {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@  = '%@' ", IP_TABLENAME,IP_MARK,@"PushServer"];
    
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
        updateSql1=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = '%@' ",IP_TABLENAME,IP_NAME,str_ipaddr,IP_PORT,str_port,IP_MARK,str_mark];
        BOOL res=[_database executeUpdate:updateSql1];
        if (res) {
            NSLog(@"成功更新至IP表!");
        } else {
            NSLog(@"更新数据至IP表出错！");
        }
    }
}

/*
//初始化用户表
-(void)InsertUserTable:(NSString *)str_username password:(NSString *)str_pwd Mark:(NSString *)str_mark {
    NSMutableArray *t_array=[self fetchIPAddress];
    if (t_array.count==0) {
        if ([_database open]) {
            NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@') VALUES ('%@', '%@', '%@')",USER_TABLENAME,USER_NAME,USER_PASSWORD,USER_MARK,str_username,str_pwd,str_mark];
            BOOL res=[_database executeUpdate:insertSql1];
            if (res) {
                NSLog(@"成功添加至用户表!");
            } else {
                NSLog(@"添加数据至用户表出错！");
            }
        }
    }

}

//获取IP表数据
-(NSMutableArray*) fetchUserInfo {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", USER_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_ipaddress=[rs stringForColumn:USER_NAME];
        NSString *str_port=[rs stringForColumn:USER_PASSWORD];
        NSArray *arr_ip=@[str_ipaddress,str_port];
        [array addObject:arr_ip];
    }
    
    [_database close];
    
    return array;
}

//更新用户信息
-(void)UpdateUserTable:(NSString *)str_username password:(NSString *)str_pwd Mark:(NSString *)str_mark {
    if ([_database open]) {
        NSString *updateSql1=@"";
        updateSql1=[NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@', '%@' = '%@', '%@' = '%@' ",USER_TABLENAME,USER_NAME,str_username,USER_PASSWORD,str_pwd,USER_MARK,str_mark];
        BOOL res=[_database executeUpdate:updateSql1];
        if (res) {
            NSLog(@"成功更新至用户表!");
        } else {
            NSLog(@"更新数据至用户表出错！");
        }
    }
}
*/

//初始化接口数据表
-(void)InsertInterFaceTable {
    NSMutableArray *t_array=[self fetchAllInterface];
    if (t_array.count == 0) {
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
            NSString *insertSql6=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskRemind",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.flowList.biz.ext"];
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
            NSString *insertSql12=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"NewsContent",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.getNews.biz.ext"];
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
            
            //已办流程审批列表
            NSString *insertSql17=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"FinishTaskShenPiList",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.finishedList.biz.ext"];
            BOOL res17=[_database executeUpdate:insertSql17];
            
            //审批记录
            NSString *insertSql18=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskLog",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.queryDisposeLog.biz.ext"];
            BOOL res18=[_database executeUpdate:insertSql18];
            
            //规章制度列表
            NSString *insertSql19=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"RulesSearch",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.list.biz.ext"];
            BOOL res19=[_database executeUpdate:insertSql19];
            
            //规章制度详细内容
            NSString *insertSql20=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"RulesDetail",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.detail.biz.ext"];
            BOOL res20=[_database executeUpdate:insertSql20];

            //待办流程数量统计
            NSString *insertSql21=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"TaskCountUnfinish",@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.count.biz.ext"];
            BOOL res21=[_database executeUpdate:insertSql21];
            
            //系统消息详细内容
            NSString *insertSql22=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"SysMsgDetail",@"/default/mobile/oa/com.hnsi.erp.mobile.common.MsgManager.getData.biz.ext"];
            BOOL res22=[_database executeUpdate:insertSql22];
            
            //头像上传
            NSString *insertSql23=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,@"UploadImg",@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.upload.biz.ext"];
            BOOL res23=[_database executeUpdate:insertSql23];


            if (res1 && res2 && res3 && res4 && res5 && res6 && res7 && res8 && res9 && res10 && res11 && res12 && res13 && res14 && res15 && res16 && res17 && res18 && res19 && res20 && res21 && res22 && res23 ) {
                NSLog(@"成功添加数据至接口表");
            }
            else {
                NSLog(@"错误，无法添加数据至接口表");
            }
        }
    }
    else if (t_array.count>0) {
        [self ModifyUrl:@"Login"];
        [self ModifyUrl:@"Logout"];
        [self ModifyUrl:@"ChangePassword"];
        [self ModifyUrl:@"AddressList"];
        [self ModifyUrl:@"ListSearch"];
        [self ModifyUrl:@"TaskRemind"];
        [self ModifyUrl:@"UnreadMessage"];
        [self ModifyUrl:@"UnreadDoc"];
        [self ModifyUrl:@"TaskCount"];
        [self ModifyUrl:@"NewsListCount"];
        [self ModifyUrl:@"NewsList"];
        [self ModifyUrl:@"NewsContent"];
        [self ModifyUrl:@"NewsComment"];
        [self ModifyUrl:@"AddComment"];
        [self ModifyUrl:@"TaskAudit"];
        [self ModifyUrl:@"UnFinishTaskShenPiList"];
        [self ModifyUrl:@"FinishTaskShenPiList"];
        [self ModifyUrl:@"TaskLog"];
        [self ModifyUrl:@"RulesSearch"];
        [self ModifyUrl:@"RulesDetail"];
        [self ModifyUrl:@"TaskCountUnfinish"];
        [self ModifyUrl:@"SysMsgDetail"];
        [self ModifyUrl:@"UploadImg"];
    }
}


-(void)ModifyUrl:(NSString*)str_keyword {
    NSString *str_url=[self fetchInterface:str_keyword];
    if ([str_url isEqualToString:@""]) {
        if ([str_keyword isEqualToString:@"Login"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.login.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"Logout"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.logout.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"ChangePassword"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.updatePassword.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"AddressList"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.list.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"ListSearch"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.search.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"TaskRemind"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.flowList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"UnreadMessage"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.msgList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"UnreadDoc"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.docList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"TaskCount"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskSearch.count.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"NewsListCount"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.count.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"NewsList"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.list.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"NewsContent"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.getNews.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"NewsComment"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.commentList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"AddComment"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.NewsSearch.addComment.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"TaskAudit"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.procdefList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"UnFinishTaskShenPiList"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.pendingList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"FinishTaskShenPiList"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.finishedList.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"TaskLog"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.queryDisposeLog.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"RulesSearch"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.list.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"RulesDetail"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.detail.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"TaskCountUnfinish"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.count.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"SysMsgDetail"]) {
            str_url=@"/default/mobile/oa/com.hnsi.erp.mobile.common.MsgManager.getData.biz.ext";
        }
        else if ([str_keyword isEqualToString:@"UploadImg"]) {
            str_url=@"/default/mobile/user/com.hnsi.erp.mobile.user.AddressListManager.upload.biz.ext";
        }
        
        NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",INTERFACE_TABLENAME,INTERFACE_NAME,INTERFACE_VALUE,str_keyword,str_url];
        if ([_database open]) {
            BOOL res=[_database executeUpdate:insertSql];
            if (res) {
                NSLog(@"%@成功添加至接口表",str_keyword);
            }
            else {
                NSLog(@"插入接口失败");
            }
            [_database close];
        }
    }
    else {
        NSString *updateSql=[NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@' ", INTERFACE_TABLENAME , INTERFACE_VALUE,str_url, INTERFACE_NAME, str_keyword];
        if ([_database open]) {
            BOOL res=[_database executeUpdate:updateSql];
            if (res) {
                NSLog(@"%@成功更新至接口表",str_keyword);
            }
            else {
                NSLog(@"更新接口失败");
            }
            [_database close];
        }
       

    }
}
/*
-(NSString*)GetValueFromDic:(NSDictionary*)dic_tmp key:(NSString*)str_key {
    NSObject *obj_tmp=[dic_tmp objectForKey:str_key];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    return str_tmp;
}
*/

-(void)InserStaffTable:(NSMutableArray*)arr_staff {
    NSMutableArray *t_array=[self fetchAllStaff];
    if ([t_array count]==0) {
        if ([_database open]) {
            if ([arr_staff count]>0) {
                for (int i=0;i<[arr_staff count];i++) {
                    NSDictionary *dic_tmp=[arr_staff objectAtIndex:i];
                    NSString *str_email=[_base_func GetValueFromDic:dic_tmp key:@"oemail"];
                    NSString *str_orgname=[_base_func GetValueFromDic:dic_tmp key:@"orgname"];
                    NSString *str_posiname=[_base_func GetValueFromDic:dic_tmp key:@"posiname"];
                    NSString *str_empname=[_base_func GetValueFromDic:dic_tmp key:@"empname"];
                    NSString *str_mobileno=[_base_func GetValueFromDic:dic_tmp key:@"mobileno"];
                    NSString *str_otel=[_base_func GetValueFromDic:dic_tmp key:@"otel"];
                    NSString *str_sex=[_base_func GetValueFromDic:dic_tmp key:@"sex"];
                    NSString *str_orgid=[_base_func GetValueFromDic:dic_tmp key:@"orgid"];
                    NSString *str_empid=[_base_func GetValueFromDic:dic_tmp key:@"empid"];
                    NSString *str_img=[_base_func GetValueFromDic:dic_tmp key:@"headimg"];
                    
                    NSString *instrSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",STAFF_TABLENAME,STAFF_ID,STAFF_USERNAME,STAFF_GENDER,STAFF_ORG_NAME,STAFF_POSINAME,STAFF_TEL,STAFF_MOBILE,STAFF_EMAIL,STAFF_ORG_ID,STAFF_IMG,str_empid,str_empname,str_sex,str_orgname,str_posiname,str_otel,str_mobileno,str_email,str_orgid,str_img];
                    BOOL res=[_database executeUpdate:instrSQL];
                    if (res) {
                        NSLog(@"更新员工成功!");
                    }
                    else {
                        NSLog(@"更新员工失败!");
                    }
                }
            }
        }
    }
}

-(void)InserDepartMentTable:(NSMutableArray *)arr_department {
    NSMutableArray *t_array=[self fetchAllDepart];
    if ([t_array count]==0) {
        if ([_database open]) {
            if ([arr_department count]>0) {
                for (int i=0;i<[arr_department count];i++) {
                    NSDictionary *dic_tmp=[arr_department objectAtIndex:i];
                    NSString *str_orgid=[_base_func GetValueFromDic:dic_tmp key:@"orgid"];
                    NSString *str_orgname=[_base_func GetValueFromDic:dic_tmp key:@"orgname"];
                    NSString *str_parentorgid=[_base_func GetValueFromDic:dic_tmp key:@"parentorgid"];
                    
                    NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' , '%@' ) VALUES ('%@' , '%@' , '%@')",DEPART_TABLENAME,DEPART_ORGID,DEPART_ORGNAME,DEPART_PARENTID,str_orgid,str_orgname,str_parentorgid];
                    BOOL res=[_database executeUpdate:insertSQL];
                    if (res) {
                        NSLog(@"更新部门成功!");
                    }
                    else {
                        NSLog(@"更新员工失败");
                    }
                }
            }
        }
    }
}

-(NSMutableArray*)fetchAllStaff {
     [_database open];
     NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", STAFF_TABLENAME];
     NSMutableArray *array=[@[] mutableCopy];
    
     FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_empid=[rs stringForColumn:STAFF_ID];
        NSString *str_empname=[rs stringForColumn:STAFF_USERNAME];
        NSString *str_sex=[rs stringForColumn:STAFF_GENDER];
        NSString *str_posi=[rs stringForColumn:STAFF_POSINAME];
        NSString *str_orgname=[rs stringForColumn:STAFF_ORG_NAME];
        NSString *str_orgid=[rs stringForColumn:STAFF_ORG_ID];
        NSString *str_mobile=[rs stringForColumn:STAFF_MOBILE];
        NSString *str_tel=[rs stringForColumn:STAFF_TEL];
        NSString *str_email=[rs stringForColumn:STAFF_EMAIL];
        NSString *str_img=[rs stringForColumn:STAFF_IMG];
        NSArray *arr_staff=@[str_empid,str_empname,str_sex,str_posi,str_orgname,str_orgid,str_mobile,str_tel,str_email,str_img];
        NSArray *arr_key=@[@"empid",@"empname",@"sex",@"posiname",@"orgname",@"orgid",@"mobileno",@"otel",@"oemail",@"img"];
        NSDictionary *dic_staff=[NSDictionary dictionaryWithObjects:arr_staff forKeys:arr_key];
        [array addObject:dic_staff];
    }
    
    [_database close];
    return  array;
    
}


-(NSMutableArray*)fetchAllDepart {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",DEPART_TABLENAME];
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_id=[rs stringForColumn:DEPART_ORGID];
        NSString *str_name=[rs stringForColumn:DEPART_ORGNAME];
        NSString *str_parentid=[rs stringForColumn:DEPART_PARENTID];
        NSArray *arr_depart=@[str_id,str_name,str_parentid];
        NSArray *arr_key=@[@"orgid",@"orgname",@"parentorgid"];
        NSDictionary *dic_depart=[NSDictionary dictionaryWithObjects:arr_depart forKeys:arr_key];
        [array addObject:dic_depart];
    }
    
    [_database close];
    return array;
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
        NSString *str_addr=[dic_notes objectForKey:@"addr"];
        
        //备忘录
        NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@' , '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@','%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@', '%@')",NOTES_TABLENAME,NOTES_INDEX,NOTES_FENLEI,NOTES_CONTENT,NOTES_MEETING_DATE,NOTES_DATE,NOTES_PIC_PATH,NOTES_COOR_X,NOTES_COOR_Y,NOTES_ADDR,str_index,str_fenlei,str_content,str_meeting_date,str_notes_date,str_pic_path,str_coord_x,str_coord_y,str_addr];
        
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

-(void)DeleteStaffTable {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM %@",STAFF_TABLENAME];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除员工表");
        }
        else {
            NSLog(@"删除员工表失败");
        }
        
    }

}

-(void)DeleteDepartmentTable {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM %@",DEPART_TABLENAME];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除部门表");
        }
        else {
            NSLog(@"删除部门表失败");
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
        NSString *str_address=[rs stringForColumn:NOTES_ADDR];
        NSMutableDictionary *dic_interface=[NSMutableDictionary dictionaryWithCapacity:8];
        [dic_interface setValue:str_index forKey:@"index"];
        [dic_interface setValue:str_notes_fenlei forKey:@"fenlei"];
        [dic_interface setValue:str_notes_content forKey:@"content"];
        [dic_interface setValue:str_notes_meeting_date forKey:@"meeting_date"];
        [dic_interface setValue:str_notes_date forKey:@"notes_date"];
        [dic_interface setValue:str_notes_pic_path forKey:@"pic_path"];
        [dic_interface setValue:str_coord_x forKey:@"coord_x"];
        [dic_interface setValue:str_coord_y forKey:@"coord_y"];
        [dic_interface setValue:str_address forKey:@"address"];
        [array addObject:dic_interface];
    }
    
    [_database close];
    
    return array;
}


-(void)UpdateNotesTable:(NSMutableDictionary *)dic_notes {
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
        NSString *str_addr=[dic_notes objectForKey:@"addr"];
        
       
        //备忘录
     //   NSString *updateSql=[NSString stringWithFormat:@"UPDATE NOTES_TABLENAME SET NOTES_ID = ? , NOTES_FENLEI = ? , NOTES_CONTENT = ? , NOTES_MEETING_DATE = ? , NOTES_DATE = ?, NOTES_PIC_PATH = ? , NOTES_COOR_X = ? , NOTES_COOR_Y = ? , NOTES_ADDRESS = ? WHERE NOTES_INDEX = ?",str_index,str_fenlei,str_content,str_meeting_date,str_notes_date,str_pic_path,str_coord_x,str_coord_y,str_addr,str_index];
        
        BOOL res=[_database executeUpdate:@"UPDATE NOTES_TABLENAME SET NOTES_ID = ? , NOTES_FENLEI = ? , NOTES_CONTENT = ? , NOTES_MEETING_DATE = ? , NOTES_DATE = ?, NOTES_PIC_PATH = ? , NOTES_COOR_X = ? , NOTES_COOR_Y = ? , NOTES_ADDRESS = ? WHERE NOTES_INDEX = ?",str_index,str_fenlei,str_content,str_meeting_date,str_notes_date,str_pic_path,str_coord_x,str_coord_y,str_addr,str_index];
        if (res) {
            NSLog(@"数据更新至备忘录表成功");
        }
        else {
            NSLog(@"更新数据至备忘录表失败");
        }

    }
}



-(void)UpdateStaffTable:(NSMutableArray *)arr_staff {
    if ([_database open]) {
        if ([arr_staff count]>0) {
            [self DeleteTable:STAFF_TABLENAME];
            
            for (int i=0;i<[arr_staff count];i++) {
                NSDictionary *dic_tmp=[arr_staff objectAtIndex:i];
                NSString *str_email=[_base_func GetValueFromDic:dic_tmp key:@"oemail"];
                NSString *str_orgname=[_base_func GetValueFromDic:dic_tmp key:@"orgname"];
                NSString *str_posiname=[_base_func GetValueFromDic:dic_tmp key:@"posiname"];
                NSString *str_empname=[_base_func GetValueFromDic:dic_tmp key:@"empname"];
                NSString *str_mobileno=[_base_func GetValueFromDic:dic_tmp key:@"mobileno"];
                NSString *str_otel=[_base_func GetValueFromDic:dic_tmp key:@"otel"];
                NSString *str_sex=[_base_func GetValueFromDic:dic_tmp key:@"sex"];
                NSString *str_orgid=[_base_func GetValueFromDic:dic_tmp key:@"orgid"];
                NSString *str_empid=[_base_func GetValueFromDic:dic_tmp key:@"empid"];
                NSString *str_img=[_base_func GetValueFromDic:dic_tmp key:@"headimg"];
                
               
                //插入
                    NSString *instrSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",STAFF_TABLENAME,STAFF_ID,STAFF_USERNAME,STAFF_GENDER,STAFF_ORG_NAME,STAFF_POSINAME,STAFF_TEL,STAFF_MOBILE,STAFF_EMAIL,STAFF_ORG_ID,STAFF_IMG,str_empid,str_empname,str_sex,str_orgname,str_posiname,str_otel,str_mobileno,str_email,str_orgid,str_img];
                    BOOL res=[_database executeUpdate:instrSQL];
                    if (res) {
                        NSLog(@"插入新员工成功!");
                    }
                    else {
                        NSLog(@"插入新员工失败!");
                    
                }
            }
        }
    }
}


-(void)UpdateDepartmentTable:(NSMutableArray *)arr_department {
    if ([_database open]) {
        if ([arr_department count]>0) {
            [self DeleteTable:DEPART_TABLENAME];
            for (int i=0;i<[arr_department count];i++) {
                NSDictionary *dic_tmp=[arr_department objectAtIndex:i];
                NSString *str_orgid=[_base_func GetValueFromDic:dic_tmp key:@"orgid"];
                NSString *str_orgname=[_base_func GetValueFromDic:dic_tmp key:@"orgname"];
                NSString *str_parentorgid=[_base_func GetValueFromDic:dic_tmp key:@"parentorgid"];
                
               
                    NSString *insertSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' , '%@' ) VALUES ('%@' , '%@' , '%@')",DEPART_TABLENAME,DEPART_ORGID,DEPART_ORGNAME,DEPART_PARENTID,str_orgid,str_orgname,str_parentorgid];
                    BOOL res=[_database executeUpdate:insertSQL];
                    if (res) {
                        NSLog(@"添加部门成功!");
                    }
                    else {
                        NSLog(@"添加员工失败");
                    }

                
            }
        }
    }
}


-(NSDictionary*)fetchSingleStaff:(NSString*)str_empid {
    [_database open];
    NSDictionary *dic_staff;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ ", STAFF_TABLENAME,STAFF_ID,str_empid];

    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_empid=[rs stringForColumn:STAFF_ID];
        NSString *str_empname=[rs stringForColumn:STAFF_USERNAME];
        NSString *str_sex=[rs stringForColumn:STAFF_GENDER];
        NSString *str_posi=[rs stringForColumn:STAFF_POSINAME];
        NSString *str_orgname=[rs stringForColumn:STAFF_ORG_NAME];
        NSString *str_orgid=[rs stringForColumn:STAFF_ORG_ID];
        NSString *str_mobile=[rs stringForColumn:STAFF_MOBILE];
        NSString *str_tel=[rs stringForColumn:STAFF_TEL];
        NSString *str_email=[rs stringForColumn:STAFF_EMAIL];
        NSString *str_img=[rs stringForColumn:STAFF_IMG];
        NSArray *arr_staff=@[str_empid,str_empname,str_sex,str_posi,str_orgname,str_orgid,str_mobile,str_tel,str_email,str_img];
        NSArray *arr_key=@[@"empid",@"empname",@"sex",@"posiname",@"orgname",@"orgid",@"mobileno",@"otel",@"oemail",@"img"];
        dic_staff=[NSDictionary dictionaryWithObjects:arr_staff forKeys:arr_key];
    }
    
    [_database close];
    return dic_staff;
}

-(NSDictionary*)fetchSingleDepartment:(NSString*)str_orgid {
    [_database open];
    NSDictionary *dic_depart;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",DEPART_TABLENAME,DEPART_ORGID,str_orgid];
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_id=[rs stringForColumn:DEPART_ORGID];
        NSString *str_name=[rs stringForColumn:DEPART_ORGNAME];
        NSString *str_parentid=[rs stringForColumn:DEPART_PARENTID];
        NSArray *arr_depart=@[str_id,str_name,str_parentid];
        NSArray *arr_key=@[@"orgid",@"orgname",@"parentorgid"];
        dic_depart=[NSDictionary dictionaryWithObjects:arr_depart forKeys:arr_key];
    }
    
    [_database close];
    return dic_depart;
    
}

-(NSMutableArray*)GetPeopleByName:(NSString*)str_condition keyword:(NSString *)str_key {
    [_database open];
    NSMutableArray *arr_people =[[NSMutableArray alloc]init];
    NSDictionary *dic_people;
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@%%' ",STAFF_TABLENAME,str_condition,str_key];
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_empid=[rs stringForColumn:STAFF_ID];
        NSString *str_empname=[rs stringForColumn:STAFF_USERNAME];
        NSString *str_sex=[rs stringForColumn:STAFF_GENDER];
        NSString *str_posi=[rs stringForColumn:STAFF_POSINAME];
        NSString *str_orgname=[rs stringForColumn:STAFF_ORG_NAME];
        NSString *str_orgid=[rs stringForColumn:STAFF_ORG_ID];
        NSString *str_mobile=[rs stringForColumn:STAFF_MOBILE];
        NSString *str_tel=[rs stringForColumn:STAFF_TEL];
        NSString *str_email=[rs stringForColumn:STAFF_EMAIL];
        NSString *str_img=[rs stringForColumn:STAFF_IMG];
        NSArray *arr_staff=@[str_empid,str_empname,str_sex,str_posi,str_orgname,str_orgid,str_mobile,str_tel,str_email,str_img];
        NSArray *arr_key=@[@"empid",@"empname",@"sex",@"posiname",@"orgname",@"orgid",@"mobileno",@"otel",@"oemail",@"img"];
        dic_people=[NSDictionary dictionaryWithObjects:arr_staff forKeys:arr_key];
        [arr_people addObject:dic_people];
    }
    return arr_people;

}

-(NSMutableArray*)GetPeopleByNum:(NSString *)str_condition con2:(NSString *)str_condition2 keyword:(NSString *)str_key {
    [_database open];
    NSMutableArray *arr_people=[[NSMutableArray alloc]init];
    NSDictionary *dic_people;
    //NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %@ OR  %@ LIKE %@",STAFF_TABLENAME,str_condition,str_key,str_condition2,str_key];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@%%' OR %@ LIKE '%%%@%%' ",STAFF_TABLENAME,str_condition,str_key,str_condition2,str_key];
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_empid=[rs stringForColumn:STAFF_ID];
        NSString *str_empname=[rs stringForColumn:STAFF_USERNAME];
        NSString *str_sex=[rs stringForColumn:STAFF_GENDER];
        NSString *str_posi=[rs stringForColumn:STAFF_POSINAME];
        NSString *str_orgname=[rs stringForColumn:STAFF_ORG_NAME];
        NSString *str_orgid=[rs stringForColumn:STAFF_ORG_ID];
        NSString *str_mobile=[rs stringForColumn:STAFF_MOBILE];
        NSString *str_tel=[rs stringForColumn:STAFF_TEL];
        NSString *str_email=[rs stringForColumn:STAFF_EMAIL];
        NSString *str_img=[rs stringForColumn:STAFF_IMG];
        NSArray *arr_staff=@[str_empid,str_empname,str_sex,str_posi,str_orgname,str_orgid,str_mobile,str_tel,str_email,str_img];
        NSArray *arr_key=@[@"empid",@"empname",@"sex",@"posiname",@"orgname",@"orgid",@"mobileno",@"otel",@"oemail",@"img"];
        dic_people=[NSDictionary dictionaryWithObjects:arr_staff forKeys:arr_key];
        [arr_people addObject:dic_people];
    }
    return arr_people;
}

//获取系统消息数据
-(NSMutableArray*)fetchAllSysMsg:(NSString*)str_username {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'", SYSMSG_TABLENAME,SYSMSG_RECEIVENAME,str_username];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_sysmsg_type=[rs stringForColumn:SYSMSG_MSGTYPE];
        NSString *str_sysmsg_name=[rs stringForColumn:SYSMSG_SENDEMPNAME];
        NSString *str_sysmsg_title=[rs stringForColumn:SYSMSG_TITLE];
        NSString *str_sysmsg_sendTime=[rs stringForColumn:SYSMSG_SENDTIME];
        NSString *str_sysmsg_receivename=[rs stringForColumn:SYSMSG_RECEIVENAME];
        NSString *str_sysmsg_id=[rs stringForColumn:SYSMSG_SYSID];
        NSDictionary *dic_sysmsg=[NSDictionary dictionaryWithObjectsAndKeys:str_sysmsg_id,@"id",str_sysmsg_type,@"msgType",str_sysmsg_name,@"sendEmpname",str_sysmsg_receivename,@"receiveName",str_sysmsg_title,@"title",str_sysmsg_sendTime,@"sendTime", nil];
        [array addObject:dic_sysmsg];
    }
    
    [_database close];
    
    return array;
}

//获取单个系统消息
-(NSMutableArray*)fetchSysMsg:(NSDictionary*)dic_sysmsg {
    [_database open];
    NSString *str_sendTime=[_base_func GetValueFromDic:dic_sysmsg key:@"sendTime"];
    NSString *str_title=[_base_func GetValueFromDic:dic_sysmsg key:@"title"];
    NSString *str_sendEmpname=[_base_func GetValueFromDic:dic_sysmsg key:@"sendEmpname"];
    NSString *str_receiveName=[_base_func GetValueFromDic:dic_sysmsg key:@"receiveName"];
    NSString *str_id=[_base_func GetValueFromDic:dic_sysmsg key:@"id"];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@' AND %@ = '%@' AND %@ = '%@' AND %@ = '%@'", SYSMSG_TABLENAME,SYSMSG_SENDTIME,str_sendTime,SYSMSG_TITLE,str_title,SYSMSG_SENDEMPNAME,str_sendEmpname,SYSMSG_RECEIVENAME,str_receiveName,SYSMSG_SYSID,str_id];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_sysmsg_type=[rs stringForColumn:SYSMSG_MSGTYPE];
        NSString *str_sysmsg_name=[rs stringForColumn:SYSMSG_SENDEMPNAME];
        NSString *str_sysmsg_title=[rs stringForColumn:SYSMSG_TITLE];
        NSString *str_sysmsg_sendTime=[rs stringForColumn:SYSMSG_SENDTIME];
        NSString *str_sysmsg_receivename=[rs stringForColumn:SYSMSG_RECEIVENAME];
        NSString *str_sysmsg_id=[rs stringForColumn:SYSMSG_SYSID];
        //NSArray *arr_interface=@[str_sysmsg_type,str_sysmsg_name,str_sysmsg_title,str_sysmsg_sendTime,str_sysmsg_isRead];
        NSDictionary *dic_sysmsg=[NSDictionary dictionaryWithObjectsAndKeys:str_sysmsg_id,@"id",str_sysmsg_type,@"msgType",str_sysmsg_name,@"sendEmpname",str_sysmsg_receivename,@"receiveName",str_sysmsg_title,@"title",str_sysmsg_sendTime,@"sendTime", nil];
        [array addObject:dic_sysmsg];
    }
    
    [_database close];
    
    return array;

}

-(void)InsertSysMsg:(NSMutableArray*)arr_sysmsg {
    if ([_database open]) {
        if ([arr_sysmsg count]>0) {
            for (int i=0;i<[arr_sysmsg count];i++) {
                NSDictionary *dic_sysmsg=(NSDictionary*)[arr_sysmsg objectAtIndex:i];
                NSMutableArray *arr_sysmsg = [self fetchSysMsg:dic_sysmsg];
                if ([arr_sysmsg count]==0) {
                    /*
                    NSString *str_msgtype=[_base_func GetValueFromDic:dic_sysmsg key:@"msgType"];
                    NSString *str_msgname=[_base_func GetValueFromDic:dic_sysmsg key:@"sendEmpname"];
                    NSString *str_msgtitle=[_base_func GetValueFromDic:dic_sysmsg key:@"title"];
                    NSString *str_sendTime=[_base_func GetValueFromDic:dic_sysmsg key:@"sendTime"];
                    NSString *str_isRead=@"0";
                    NSString *str_receiveName=[_base_func GetValueFromDic:dic_sysmsg key:@"receiveName"];
                    
                    NSString *inserSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@' , '%@' ,'%@', '%@') VALUES ('%@','%@' , '%@' , '%@' , '%@' , '%@')",SYSMSG_TABLENAME,SYSMSG_MSGTYPE,SYSMSG_SENDEMPNAME,SYSMSG_RECEIVENAME,SYSMSG_TITLE,SYSMSG_SENDTIME,SYSMSG_ISREAD,str_msgtype,str_msgname,str_receiveName,str_msgtitle,str_sendTime,str_isRead];
                    BOOL res=[_database executeUpdate:inserSQL];
                    if (res) {
                        NSLog(@"添加系统消息成功!");
                    }
                    else {
                        NSLog(@"添加系统消息失败!");
                    }
                     */
                    [self addSingleSysMsg:dic_sysmsg];
                }
                
                
            }
        }
    }
}

-(void)UpdateSysMsg:(NSMutableArray*)arr_sysmsg {
    if ([_database open]) {
        if ([arr_sysmsg count]>0) {
            for (int i=0; i<[arr_sysmsg count]; i++) {
                NSDictionary *dic_sysmsg=(NSDictionary*)[arr_sysmsg objectAtIndex:i];
                NSMutableArray *arr_sysmsg = [self fetchSysMsg:dic_sysmsg];
                if ([arr_sysmsg count]==0) {
                    [self addSingleSysMsg:dic_sysmsg];
                }
                else if ([arr_sysmsg count]==1) {
                    [self updateSingleSysMsg:dic_sysmsg];
                }
            }
        }
    }
}

//添加单独一条系统消息
-(void)addSingleSysMsg:(NSDictionary*)dic_sysmsg {
    if (dic_sysmsg!=nil) {
        NSMutableArray *arr_sysmsg = [self fetchSysMsg:dic_sysmsg];
        if ([arr_sysmsg count]==0) {
            if ([_database open]) {
                NSString *str_msgtype=[_base_func GetValueFromDic:dic_sysmsg key:@"msgType"];
                NSString *str_msgname=[_base_func GetValueFromDic:dic_sysmsg key:@"sendEmpname"];
                NSString *str_msgtitle=[_base_func GetValueFromDic:dic_sysmsg key:@"title"];
                NSString *str_sendTime=[_base_func GetValueFromDic:dic_sysmsg key:@"sendTime"];
                NSString *str_receiveName=[_base_func GetValueFromDic:dic_sysmsg key:@"receiveName"];
                NSString *str_id=[_base_func GetValueFromDic:dic_sysmsg key:@"id"];
                NSString *inserSQL=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@', '%@' ,'%@', '%@','%@') VALUES ('%@','%@' , '%@' , '%@' , '%@' , '%@')",SYSMSG_TABLENAME,SYSMSG_SYSID,SYSMSG_MSGTYPE,SYSMSG_SENDEMPNAME,SYSMSG_RECEIVENAME,SYSMSG_TITLE,SYSMSG_SENDTIME,str_id,str_msgtype,str_msgname,str_receiveName,str_msgtitle,str_sendTime];
                BOOL res=[_database executeUpdate:inserSQL];
                if (res) {
                    NSLog(@"添加系统消息成功!");
                }
                else {
                    NSLog(@"添加系统消息失败!");
                }

            }
        }
    }
}

-(void)updateSingleSysMsg:(NSDictionary*)dic_sysmsg {
    if (dic_sysmsg!=nil) {
        NSString *str_msgtype=[_base_func GetValueFromDic:dic_sysmsg key:@"msgType"];
        NSString *str_msgname=[_base_func GetValueFromDic:dic_sysmsg key:@"sendEmpname"];
        NSString *str_msgtitle=[_base_func GetValueFromDic:dic_sysmsg key:@"title"];
        NSString *str_sendTime=[_base_func GetValueFromDic:dic_sysmsg key:@"sendTime"];
        NSString *str_receiveName=[_base_func GetValueFromDic:dic_sysmsg key:@"receiveName"];
        NSString *str_id=[_base_func GetValueFromDic:dic_sysmsg key:@"id"];
        NSString *updateSQL=[NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@', '%@' = '%@', '%@' = '%@', '%@' = '%@' , '%@' = '%@' , '%@' = '%@'  ",SYSMSG_TABLENAME,SYSMSG_SYSID,str_id,SYSMSG_MSGTYPE,str_msgtype,SYSMSG_SENDEMPNAME,str_msgname,SYSMSG_RECEIVENAME,str_receiveName,SYSMSG_TITLE,str_msgtitle,SYSMSG_SENDTIME,str_sendTime];
        BOOL res=[_database executeUpdate:updateSQL];
        if (res) {
            NSLog(@"更新系统消息成功!");
        }
        else {
            NSLog(@"更新系统消息失败!");
        }
    }
}

-(void)DeleteSysMsgTable {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM %@",SYSMSG_TABLENAME];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除系统消息表");
        }
        else {
            NSLog(@"删除系统消息表失败");
        }
        
    }

}

-(void)DeleteTable:(NSString*)str_tablename {
    if ([_database open]) {
        NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM %@",str_tablename];
        
        BOOL res=[_database executeUpdate:deleteSql];
        if (res) {
            NSLog(@"成功删除表");
        }
        else {
            NSLog(@"删除表失败");
        }
    }
}

//获取接口数据表
-(NSMutableArray*)fetchAllShiWu {
    [_database open];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@", SHIWU_TABLENAME];
    
    NSMutableArray *array=[@[] mutableCopy];
    
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        NSString *str_shiwu_label=[rs stringForColumn:SHIWU_LABEL];
        NSString *str_shiwu_title=[rs stringForColumn:SHIWU_TITLE];
        NSArray *arr_interface=@[str_shiwu_label,str_shiwu_title];
        [array addObject:arr_interface];
    }
    
    [_database close];
    
    return array;
}



-(void)InsertShiwuTable {
     NSMutableArray *t_array=[self fetchAllShiWu];
     if (t_array.count == 0) {
         if ([_database open]) {
            
             NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"通用费用报销",@"com.hnsi.erp.xmyy.utilitycost.utilityBaoxiao"];
             BOOL res1=[_database executeUpdate:insertSql1];
             
             NSString *insertSql2=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"物品领用申请",@"com.hnsi.erp.xmyy.getGoods.getGoods"];
             BOOL res2=[_database executeUpdate:insertSql2];
             
             NSString *insertSql3=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"图书及资料购置费报销",@"com.hnsi.erp.xmyy.tswzgz.tszlgzworkflow"];
             BOOL res3=[_database executeUpdate:insertSql3];
             
             NSString *insertSql4=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"业务招待费申请",@"com.hnsi.erp.xmyy.businessettm.businessettm"];
             BOOL res4=[_database executeUpdate:insertSql4];
             
             NSString *insertSql5=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"业务招待费报销",@"com.hnsi.erp.xmyy.businessettm.businessBaoxiao"];
             BOOL res5=[_database executeUpdate:insertSql5];
             
             NSString *insertSql6=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"会议费申请",@"com.hnsi.erp.xmyy.hyfycost.hyfyApply"];
             BOOL res6=[_database executeUpdate:insertSql6];
             
             NSString *insertSql7=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"会议费报销",@"com.hnsi.erp.xmyy.hyfycost.hyfyBaoxiao"];
             BOOL res7=[_database executeUpdate:insertSql7];
             
             NSString *insertSql8=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"会议室申请",@"com.hnsi.erp.xmyy.hyssy.hyssyflow"];
             BOOL res8=[_database executeUpdate:insertSql8];
             
             NSString *insertSql9=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"中转过渡房申请",@"com.hnsi.erp.xmyy.gdzzf.gdzzfInfoflow"];
             BOOL res9=[_database executeUpdate:insertSql9];
             
             NSString *insertSql10=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"设备维修申请",@"com.hnsi.erp.xmyy.wangjunhui.equipmentServiceworkflow"];
             BOOL res10=[_database executeUpdate:insertSql10];
             
             NSString *insertSql11=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"综合服务申请",@"com.hnsi.erp.xmyy.zhService.zhService"];
             BOOL res11=[_database executeUpdate:insertSql11];
             
             NSString *insertSql12=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"预算外事项申请",@"com.hnsi.erp.xmyy.yswfp.yswsx"];
             BOOL res12=[_database executeUpdate:insertSql12];
             
             NSString *insertSql13=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"预算外事项报销",@"com.hnsi.erp.xmyy.yswfp.yswfp"];
             BOOL res13=[_database executeUpdate:insertSql13];
             
             NSString *insertSql14=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"部门自控费用报销",@"com.hnsi.erp.xmyy.depControlCost.apply"];
             BOOL res14=[_database executeUpdate:insertSql14];
             
             NSString *insertSql15=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"用印申请",@"com.hnsi.erp.xmyy.yysq.yysqflow"];
             BOOL res15=[_database executeUpdate:insertSql15];
             
             NSString *insertSql16=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"差旅费申请",@"com.hnsi.erp.xmyy.clfy.clfyApply"];
             BOOL res16=[_database executeUpdate:insertSql16];
             
             NSString *insertSql17=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"差旅费报销",@"com.hnsi.erp.xmyy.clfy.clfyBaoxiao"];
             BOOL res17=[_database executeUpdate:insertSql17];
             
             NSString *insertSql18=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"差旅费报销",@"com.hnsi.erp.xmyy.clfy.clfyBaoxiao"];
             BOOL res18=[_database executeUpdate:insertSql18];
             
             NSString *insertSql19=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"外部培训费报销",@"com.hnsi.erp.xmyy.wbpxfy.pxfyRei"];
             BOOL res19=[_database executeUpdate:insertSql19];
             
             NSString *insertSql20=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"驻地化费用报销",@"com.hnsi.erp.xmyy.zhudify.zhudifybaoxiao"];
             BOOL res20=[_database executeUpdate:insertSql20];
             
             NSString *insertSql21=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"通用业务付款单",@"com.hnsi.erp.xmyy.payment.payment"];
             BOOL res21=[_database executeUpdate:insertSql21];
             
             NSString *insertSql22=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"借款单",@"com.hnsi.erp.xmyy.loan.loan"];
             BOOL res22=[_database executeUpdate:insertSql22];
             
             NSString *insertSql23=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"坏账核销申请",@"com.hnsi.erp.xmyy.hzhx.hzhxflow"];
             BOOL res23=[_database executeUpdate:insertSql23];

             NSString *insertSql24=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"固定资产部门内部调拨申请",@"com.hnsi.erp.xmyy.gdzznb.gdzcnb"];
             BOOL res24=[_database executeUpdate:insertSql24];
             
             NSString *insertSql25=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"固定资产调拨申请",@"com.hnsi.erp.xmyy.gdzcdb.gdzcdb"];
             BOOL res25=[_database executeUpdate:insertSql25];
             
             NSString *insertSql26=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"分摊费用申请",@"com.hnsi.erp.xmyy.ftfy.ftfyApply"];
             BOOL res26=[_database executeUpdate:insertSql26];
             
             NSString *insertSql27=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"分摊费用报销",@"com.hnsi.erp.xmyy.ftfy.ftfyBaoxiao"];
             BOOL res27=[_database executeUpdate:insertSql27];
             
             NSString *insertSql28=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,@"固定资产报废",@"com.hnsi.erp.xmyy.gdzcbf.gdzcbfflow"];
             BOOL res28=[_database executeUpdate:insertSql28];


             if (res1 && res2 && res3 && res4 && res5 && res6 && res7 && res8 && res9 && res10 && res11 && res12 && res13 && res14 && res15 && res16 && res17 && res18 && res19 && res20 && res21 && res22 && res23 && res24 && res25 && res26 && res27 && res28) {
                 NSLog(@"成功添加数据至事务流程表");
             }
             else {
                 NSLog(@"添加数据至事务流程表失败");
             }
         }
     }
}

-(void)InsertSingleShiWU:(NSMutableDictionary*)dic_shiwu {
    if (dic_shiwu!=nil) {
        NSString *str_key=[dic_shiwu objectForKey:SHIWU_LABEL];
        NSString *str_value=[dic_shiwu objectForKey:SHIWU_TITLE];
        NSString *str_title= [self fetchShiWu:str_key];
        if ([str_title isEqualToString:@""]) {
            if ([_database open]) {
                NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,str_value,str_key];
                BOOL res=[_database executeUpdate:insertSql];
                if (res) {
                    NSLog(@"成功添加数据至事务流程表");
                }
                else {
                    NSLog(@"添加数据至事务流程表失败");
                }
            }
        }
    }
}

-(NSString*)fetchShiWu:(NSString *)str_key {
    [_database open];
    NSString *str_shiwu_title=@"";
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%%%@%%' ", SHIWU_TABLENAME,SHIWU_LABEL,str_key];
    FMResultSet *rs=[_database executeQuery:sql];
    while ([rs next]) {
        str_shiwu_title=[rs stringForColumn:SHIWU_TITLE];
    }
    [_database close];
    return str_shiwu_title;
}


-(void)UpdateShiWuTable:(NSMutableArray*)flowArray {
    if ([_database open]) {
        if (flowArray.count>0) {
            [self DeleteTable:SHIWU_TABLENAME];
            
            for (NSDictionary *dic_flowArray in flowArray) {
                NSString *str_title=[dic_flowArray objectForKey:@"lable"];
                NSString *str_key=[dic_flowArray objectForKey:@"title"];
                if (str_title!=nil && ![str_title isEqualToString:@""] && str_key!=nil && ![str_key isEqualToString:@""]) {
                    NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@' ) VALUES ('%@' , '%@')",SHIWU_TABLENAME,SHIWU_TITLE,SHIWU_LABEL,str_title,str_key];
                    BOOL res=[_database executeUpdate:insertSql];
                    if (res) {
                        NSLog(@"成功添加数据至事务流程表");
                    }
                    else {
                        NSLog(@"添加数据至事务流程表失败");
                    }

                }
                
            }
        }
    }
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

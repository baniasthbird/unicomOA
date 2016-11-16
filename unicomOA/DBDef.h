//
//  DBDef.h
//  unicomOA
//
//  Created by zr-mac on 16/5/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#ifndef DBDef_h
#define DBDef_h

//IP地址表
#define IP_TABLENAME @"IP_TABLE"
#define IP_ID @"IP_ID"
#define IP_NAME @"IP_ADDRESS"
#define IP_PORT @"IP_PORT"
#define IP_MARK @"IP_SERVERNAME"

//用户表
#define USER_TABLENAME @"USR_TABLE"
#define USER_ID @"USR_ID"
#define USER_NAME @"USR_NAME"
#define USER_PASSWORD @"USR_PWD"
#define USER_MARK @"USR_MARK"

//接口表
#define INTERFACE_TABLENAME @"INTERFACE_TABLE"
#define INTERFACE_ID        @"INTERFACE_ID"
#define INTERFACE_NAME      @"INTERFACE_NAME"
#define INTERFACE_VALUE     @"INTERFACE_VALUE"

//备忘录表
#define NOTES_TABLENAME @"NOTES_TABLENAME"
#define NOTES_ID        @"NOTES_ID"
#define NOTES_INDEX     @"NOTES_INDEX"
#define NOTES_FENLEI    @"NOTES_FENLEI"
#define NOTES_CONTENT   @"NOTES_CONTENT"
#define NOTES_MEETING_DATE @"NOTES_MEETING_DATE"
#define NOTES_DATE      @"NOTES_DATE"
#define NOTES_PIC_PATH  @"NOTES_PIC_PATH"
#define NOTES_COOR_X    @"NOTES_COOR_X"
#define NOTES_COOR_Y    @"NOTES_COOR_Y"
#define NOTES_ADDR      @"NOTES_ADDRESS"


//预约用车表
#define CAR_TABLNAME @"CAR_TABLE"
#define CAR_ID       @"CAR_ID"
#define CAR_USRNAME  @"CAR_NAME"
#define CAR_DEPART   @"CAR_DEPARTMENT"
#define CAR_PHONNUM  @"CAR_PHONNUM"
#define CAR_CATEGROY @"CAR_CATEGROY"
#define CAR_USRNUM   @"CAR_USRNUM"
#define CAR_CARUSR   @"CAR_CARUSR"
#define CAR_USINGTIME @"CAR_USINGTIME"
#define CAR_RETURNTIME @"CAR_RETURNTIME"
#define CAR_DES      @"CAR_DES"
#define CAR_REASON   @"CAR_REASON"
#define CAR_REMARK   @"CAR_REMARK"
#define CAR_APPLICATIONTIME @"CAR_APPTIME"
#define CAR_SHENPI1  @"CAR_SHENPI1"
#define CAR_SHENPI2  @"CAR_SHENPI2"
#define CAR_MODEL    @"CAR_MODEL"

//员工表
#define STAFF_TABLENAME @"STAFF_TABLE"
#define STAFF_ID        @"EMPID"
#define STAFF_USERNAME  @"EMPNAME"
#define STAFF_GENDER    @"SEX"
#define STAFF_ORG_ID    @"ORGID"
#define STAFF_ORG_NAME  @"ORGNAME"
#define STAFF_EMAIL     @"OEMAIL"
#define STAFF_POSINAME  @"POSINAME"
#define STAFF_MOBILE    @"MOBILENO"
#define STAFF_TEL       @"OTEL"
#define STAFF_IMG       @"IMG"
#define STAFF_TABLE_ID  @"STAFF_ID"

//部门表
#define DEPART_TABLENAME @"DEPART_TABLE"
#define DEPART_ID        @"DEPART_ID"
#define DEPART_ORGID     @"ORGID"
#define DEPART_ORGNAME   @"ORGNAME"
#define DEPART_PARENTID  @"PARENTORGID"

//系统消息表
#define SYSMSG_TABLENAME @"SYSMSG_TABLE"
#define SYSMSG_ID        @"SYSMSG_ID"
#define SYSMSG_SYSID     @"SYSMSG_SYSID"
#define SYSMSG_MSGTYPE   @"SYSMSG_TYPE"
#define SYSMSG_SENDEMPNAME @"SYSMSG_SENDEMPNAME"
#define SYSMSG_RECEIVENAME @"SYSMSG_RECEIVENAME"
#define SYSMSG_TITLE     @"SYSMSG_TITLE"
#define SYSMSG_SENDTIME  @"SYSMSG_SENDTIME"
#define SYSMSG_ISREAD    @"SYSMSG_ISREAD"

//#define DEPART_ID        @""

#endif /* DBDef_h */

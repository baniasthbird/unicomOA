//
//  Mpush.h
//  unicomOA
//
//  Created by hnsi-03 on 2017/1/11.
//  Copyright © 2017年 zr-mac. All rights reserved.
//

#ifndef Mpush_h
#define Mpush_h

#define appVersion @"9.2.1";

#define MPUserDefaults  [NSUserDefaults standardUserDefaults]
#define  MPIvData @"BCJIvData"
#define  MPClientKeyData @"BCJClientKeyData"
//#define PUSH_HOST_ADDRESS @"http://103.246.161.44:9999/push"
#define PUSH_HOST_ADDRESS @"http://192.168.111.12:9999/push"

#define  MPSessionKeyData @"BCJSessionKeyData"
#define  MPSessionId @"BCJSessionId"
#define  MPExpireTime @"BCJExpireTime"
#define MPDeviceId @"identifierForVendor"
#define MPDeviceToken @"ConnId"
#define MPMinHeartbeat 180
#define MPMaxHeartbeat 180
#define MPMaxConnectTimes 6
#define MPMainServerIP @"MainServerIP"


#endif /* Mpush_h */


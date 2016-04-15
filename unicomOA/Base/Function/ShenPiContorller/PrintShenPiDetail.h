//
//  PrintShenPiDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintApplicationDetail.h"
#import "UserInfo.h"

@class PrintShenPiDetail;
@protocol PrintShenPiDetailDelegate <NSObject>

-(void)PrintRefreshTableView;

@end

@interface PrintShenPiDetail : PrintApplicationDetail

@property (nonatomic,strong) UserInfo *user_Info;

@property (nonatomic,strong) id<PrintShenPiDetailDelegate> delegate;

@property  BOOL b_isEnabled;

@end

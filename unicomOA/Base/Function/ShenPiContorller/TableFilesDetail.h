//
//  TableFilesDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/11/28.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableFilesDetailDelegate <NSObject>

-(void)PassPartialData:(NSDictionary*)dic_data;

@end

@interface TableFilesDetail : UIViewController

@property (nonatomic,strong) NSArray *arr_data;

@property (nonatomic,strong) NSArray *arr_title;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSData *partialData;

@property  (nonatomic,strong) NSString *partialData_percent;

@property (nonatomic,strong) id<TableFilesDetailDelegate> delegate;


@property (nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

-(void)RefreshViewData;

@end

//
//  AddPrintFile.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintFiles.h"

@class AddPrintFile;

@protocol PrintFilePassValueDelegate <NSObject>

-(void)passValue:(NSString*)str_FileName pages:(int)i_pages copies:(int)i_copies pic_pages:(int)i_pic_pages cover:(BOOL)b_hascover colorcopies:(int)i_colorcopies simplecopies:(int)i_simplecopies;

@end

@interface AddPrintFile : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,unsafe_unretained) id<PrintFilePassValueDelegate> delegate;

@property (strong,nonatomic) PrintFiles *printFiles;


@end

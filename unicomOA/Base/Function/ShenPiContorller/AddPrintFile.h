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

-(void)passValue:(PrintFiles*)new_file ;

-(void)editValue:(PrintFiles*)origin_file editFile:(PrintFiles*)edit_file;

@end

@interface AddPrintFile : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,unsafe_unretained) id<PrintFilePassValueDelegate> delegate;

@property (strong,nonatomic) PrintFiles *printFiles;

@property BOOL b_isEdit;


@end

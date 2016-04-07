//
//  PrintFiles.h
//  unicomOA
//
//  Created by zr-mac on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//复印文件

@interface PrintFiles : NSObject

//文件名
@property (nonatomic,strong) NSString* str_filename;

//复印页数
@property int i_pages;

//复印份数
@property int i_copies;

//晒图张数
@property int i_pic_pages;

//正式封皮
@property BOOL b_hascover;

//精装册数
@property int i_colorcopies;

//简装册数
@property int i_simplecopies;

@end

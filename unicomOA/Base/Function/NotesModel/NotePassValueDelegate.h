//
//  NotePassValue.h
//  unicomOA
//
//  Created by zr-mac on 16/2/26.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#ifndef NotePassValue_h
#define NotePassValue_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol UINoteViewPassValueDelegate

-(void)passValue:(NSString*)str_FenLei Content:(NSString*)str_Content Time:(NSString*)str_curTime TimeNow:(NSString*)str_nowTime;

@end


#endif /* NotePassValue_h */

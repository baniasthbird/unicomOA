//
//  Soundselectvc.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/24.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Soundselectvc;

@protocol SoundselectvcDelegate <NSObject>

@required

-(void)PassSoundValue:(NSString*)str_sound_url;

@end


@interface Soundselectvc : UIViewController

@property (nonatomic,strong) NSString *str_sound;

@property (nonatomic,unsafe_unretained) id<SoundselectvcDelegate> delegate;

@end

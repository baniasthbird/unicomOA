//
//  GrayPageControl.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/3.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "GrayPageControl.h"

@implementation GrayPageControl

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    
    return self;
}

-(void) updateDots {
    for (int i=0; i<[self.subviews count]; i++) {
        UIView *dot=[self.subviews objectAtIndex:i];
        CGSize size;
        size.height= 7;
        size.width= 7;
        
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        
        if (i==self.currentPage) {
            dot.backgroundColor=[UIColor orangeColor];
          //  dot.image=activeImage;
        }
        else {
            dot.backgroundColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
          //  dot.image=inactiveImage;
        }
    }
}


-(void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end

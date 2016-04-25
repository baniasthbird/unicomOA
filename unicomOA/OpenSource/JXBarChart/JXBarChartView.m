//
//  JXBarChartView.m
//  JXBarChartViewExample
//
//  Created by jianpx on 7/18/13.
//  Copyright (c) 2013 PS. All rights reserved.
//

#import "JXBarChartView.h"

@interface JXBarChartView()
@property (nonatomic) CGContextRef context;
@property (nonatomic, strong) NSMutableArray *textIndicatorsLabels;
@property (nonatomic, strong) NSMutableArray *digitIndicatorsLabels;
@end

@implementation JXBarChartView


- (id)initWithFrame:(CGRect)frame
         startPoint:(CGPoint)startPoint
             values:(NSMutableArray *)values
           maxValue:(float)maxValue
     textIndicators:(NSMutableArray *)textIndicators
          textColor:(UIColor *)textColor
          barHeight:(float)barHeight
        barMaxWidth:(float)barMaxWidth
           gradient:(CGGradientRef)gradient
{
    self = [super initWithFrame:frame];
    if (self) {
        _values = values;
        _maxValue = maxValue;
        _textIndicatorsLabels = [[NSMutableArray alloc] initWithCapacity:[values count]];
        _digitIndicatorsLabels = [[NSMutableArray alloc] initWithCapacity:[values count]];
        _textIndicators = textIndicators;
        _startPoint = startPoint;
        _textColor = textColor ? textColor : [UIColor orangeColor];
        _barHeight = barHeight;
        _barMaxWidth = barMaxWidth;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //blue gradient
        CGFloat locations[] = {0.0, 0.5, 1.0};
        CGFloat colorComponents[] = {
            0.254, 0.599, 0.82, 1.0, //red, green, blue, alpha
            0.192, 0.525, 0.75, 1.0,
            0.096, 0.415, 0.686, 1.0
        };
        size_t count = 3;
        CGGradientRef defaultGradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, count);
        _gradient = gradient ?  gradient : defaultGradient;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setLabelDefaults:(UILabel *)label
{
    //label.textColor =[UIColor colorWithRed:182/255.0f green:182/255.0f blue:182/255.0f alpha:1];
    label.textColor=self.textColor;
    [label setTextAlignment:NSTextAlignmentLeft];
    //label.adjustsFontSizeToFitWidth = YES;
    label.font=[UIFont systemFontOfSize:14];
    //label.adjustsLetterSpacingToFitWidth = YES;
    label.backgroundColor = [UIColor clearColor];
}

-(CGGradientRef)makeGradient:(NSString*)str_color {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //blue gradient
    CGFloat locations[] = {0.0, 0.5, 1.0};
    CGFloat red_colorComponents[] = {
        238/255.0f, 110/255.0f, 88/255.0f, 1.0, //red, green, blue, alpha
        230/255.0f, 95/255.0f, 62/255.0f, 1.0,
        224/255.0f, 74/255.0f, 25/255.0f, 1.0
    };
    CGFloat orange_colorComponents[] = {
            224/255.0f, 167/255.0f, 79/255.0f, 1.0, //red, green, blue, alpha
            213/255.0f, 148/255.0f, 46/255.0f, 1.0,
            200/255.0f, 127/255.0f, 7/255.0f, 1.0
        };
    CGFloat blue_colorComponents[] = {
        0.254, 0.599, 0.82, 1.0, //red, green, blue, alpha
        0.192, 0.525, 0.75, 1.0,
        0.096, 0.415, 0.686, 1.0
    };
    CGFloat green_colorComponents[] = {
        61/255.0f, 189/255.0f, 143/255.0f, 1.0, //red, green, blue, alpha
        61/255.0f, 189/255.0f, 143/255.0f, 1.0,
        61/255.0f, 189/255.0f, 143/255.0f, 1.0
    };

    size_t count = 3;
    if ([str_color isEqualToString:@"red"])
    {
        CGGradientRef Gradient = CGGradientCreateWithColorComponents(colorSpace, red_colorComponents, locations, count);
        return Gradient;

    }
    else if ([str_color isEqualToString:@"orange"])
    {
         CGGradientRef Gradient = CGGradientCreateWithColorComponents(colorSpace, orange_colorComponents, locations, count);
        return Gradient;

    }
    else if ([str_color isEqualToString:@"green"]) {
        CGGradientRef Gradient = CGGradientCreateWithColorComponents(colorSpace, green_colorComponents, locations, count);
        return Gradient;
    }
    else {
        CGGradientRef Gradient = CGGradientCreateWithColorComponents(colorSpace, blue_colorComponents, locations, count);
        return Gradient;
    }
    
    
}

- (void)drawRectangle:(CGRect)rect context:(CGContextRef)context maxRect:(CGRect)max_rect atIndex:(int)i_index Grdient:(CGGradientRef)gradient
{
    CGContextSaveGState(self.context);
    CGContextStrokeRectWithWidth(context, max_rect, 1);
    CGContextAddRect(self.context, rect);
    CGContextClipToRect(self.context, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    if (i_index==0) {
        CGContextDrawLinearGradient(self.context, gradient, startPoint, endPoint, 0);
    }
    else if (i_index==1) {
        CGContextDrawLinearGradient(self.context, gradient, startPoint, endPoint, 0);
    }
    else if (i_index==2) {
        CGContextDrawLinearGradient(self.context, gradient, startPoint, endPoint, 0);
        
    }
    
    
    CGContextRestoreGState(self.context);
    //添加barmaxwidth
    
    
}

- (void)drawRect:(CGRect)rect
{
    self.context = UIGraphicsGetCurrentContext();
    int count =(int)[self.values count];
    float startx = self.startPoint.x;
    float starty = self.startPoint.y;
    float barMargin = 22;
    float digitWidth = rect.size.width;
    int total_value=0;
    for (int i=0; i<count; i++) {
        total_value+=[self.values[i] intValue];
    }
    for (int i = 0; i < count; i++) {
        
        //handle textlabel
        float textMargin_y = (i * (self.barHeight + barMargin*2)) + starty-self.barHeight*0.5;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(startx, textMargin_y, rect.size.width, self.barHeight*0.5)];
        textLabel.text = self.textIndicators[i];
        textLabel.textColor=[UIColor colorWithRed:182/255.0f green:182/255.0f blue:182/255.0f alpha:1];
        //[self setLabelDefaults:textLabel];
        @try {
            UILabel *originalTextLabel = self.textIndicatorsLabels[i];
            if (originalTextLabel) {
                [originalTextLabel removeFromSuperview];
            }
        }
        @catch (NSException *exception) {
            [self.textIndicatorsLabels insertObject:textLabel atIndex:i];
        }
        [self addSubview:textLabel];
        
        //handle bar
        float barMargin_y = (i * (self.barHeight + barMargin*2)) + starty+self.barHeight*0.5;
        float v = [self.values[i] floatValue] <= self.maxValue ? [self.values[i] floatValue]: self.maxValue;
        float rate = v / self.maxValue;
        float barWidth = rate * self.barMaxWidth;
        CGRect barFrame = CGRectMake(startx, barMargin_y, barWidth, self.barHeight);
        CGRect max_barFrame=CGRectMake(startx, barMargin_y, self.barMaxWidth, self.barHeight);
        CGGradientRef gradient=nil;
        /*
        if (i==1)
        {
           gradient =[self makeGradient:@"red"];
        }
        else if (i==2) {
            gradient =[self makeGradient:@"orange"];
        }
        */
        gradient=[self makeGradient:@"green"];
        [self drawRectangle:barFrame context:self.context maxRect:max_barFrame atIndex:i Grdient:gradient];
        //handle digitlabel
        UILabel *digitLabel = [[UILabel alloc] initWithFrame:CGRectMake(barFrame.origin.x +self.barMaxWidth*1.1, barFrame.origin.y, digitWidth, barFrame.size.height)];
        float d_percent=(float)[self.values[i] intValue]/(float)total_value;
        d_percent= d_percent*100;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"0.0"];
        NSString *str_percent= [numberFormatter stringFromNumber:[NSNumber numberWithFloat:d_percent]];
       // NSString *str_text=[NSString stringWithFormat:@"%@%%(%@)",str_percent,[self.values[i] stringValue]];
        digitLabel.text = [NSString stringWithFormat: @"%@%@",str_percent,@"%"];
        [self setLabelDefaults:digitLabel];
        @try {
            UILabel *originalDigitLabel = self.digitIndicatorsLabels[i];
            if (originalDigitLabel) {
                [originalDigitLabel removeFromSuperview];
            }
        }
        @catch (NSException *exception) {
            [self.digitIndicatorsLabels insertObject:digitLabel atIndex:i];
        }
        [self addSubview:digitLabel];
        
        UILabel *numLable=[[UILabel alloc] initWithFrame:CGRectMake(barFrame.origin.x+self.barMaxWidth*0.07, barFrame.origin.y, digitWidth, barFrame.size.height)];
        NSString *num=self.values[i];
        numLable.text=[NSString stringWithFormat:@"%@%@",num,@"票"];
        numLable.textColor=[UIColor whiteColor];
        numLable.font=[UIFont systemFontOfSize:14];
        [self addSubview:numLable];
        
    }
}

- (void)setValues:(NSMutableArray *)values
{
    for (int i = 0; i < [values count]; i++) {
        _values[i] = values[i];
    }
    [self setNeedsDisplay];
}

@end

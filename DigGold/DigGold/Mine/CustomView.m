//
//  CustomView.m
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGContextSetLineWidth(context, 2);
    
    CGContextMoveToPoint(context, 20, 180);
    
    CGContextAddLineToPoint(context, 20, 20);
    
    CGContextMoveToPoint(context, 20, 180);
    
    CGContextAddLineToPoint(context, ScreenWidth - 20, 180);
    
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 20, 180);
    
    CGFloat width = self.frame.size.width - 20;
    
    CGFloat height = self.frame.size.height - 20;
    
    CGContextAddLineToPoint(context, 10 * width, height * height);
    
    CGContextStrokePath(context);

}

@end

//
//  UIImage+Extension.m
//  WeiLv
//
//  Created by James on 16/5/30.
//  Copyright © 2016年 WeiLv Technology. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *) imageFromURLString: (NSString *) urlstring
{
    return [UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}

@end

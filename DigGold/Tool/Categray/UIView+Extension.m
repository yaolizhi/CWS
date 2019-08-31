//
//  UIView+Extension.m
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"
#import "UIColor+Hex.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
//    self.width = size.width;
//    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

-(CGFloat)maxX{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

-(CGFloat)maxY{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGRect)oneRightNextRect{
    return CGRectMake(self.maxX, self.y, Screen_Width-self.maxX, self.height);
}
-(void)widthToFit{
    float height = self.height;
    [self sizeToFit];
    self.height = height;
}

-(void)heightToFit{
    float width = self.width;
    [self sizeToFit];
    self.width = width;
}

-(CGRect)oneBottomNextRect{
    return CGRectMake(self.x, self.maxY, self.width, Screen_Height-self.maxY);
}

-(CGRect)rightNextRectWithWidth:(CGFloat)width andHeight:(CGFloat)height{
    return CGRectMake(self.maxX, self.y, width, height);
}

-(CGRect)bottomNextRectWithWidth:(CGFloat)width andHeight:(CGFloat)height{
    return CGRectMake(self.x, self.maxY, width, height);
}


-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

-(void)setBorderWithWidth:(CGFloat)width andColor:(UIColor *)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
-(void)label:(UILabel *)lable font:(float)font textColor:(UIColor *)color text:(NSString *)text
{
    lable.textColor = color;
    lable.font = [UIFont systemFontOfSize:font];
    lable.text = text;
    lable.adjustsFontSizeToFitWidth = YES;
    
}
-(void)btn:(UIButton *)btn font:(float)font textColor:(UIColor *)color text:(NSString *)text image:(UIImage*)imge
{
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    [btn setTitle:text forState:(UIControlStateNormal)];
    [btn setImage:imge forState:(UIControlStateNormal)];
    
}
-(void)btn:(UIButton *)btn font:(float)font textColor:(UIColor *)color text:(NSString *)text image:(UIImage*)imge sel:(SEL)sel taget:(id)taget
{
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    [btn setTitle:text forState:(UIControlStateNormal)];
    [btn setImage:imge forState:(UIControlStateNormal)];
    [btn addTarget:taget action:sel forControlEvents:(UIControlEventTouchUpInside)];
};
-(void)textField:(UITextField *)textField textFont:(CGFloat)textFont placeHolderFont:(CGFloat)placeHolderFont text:(NSString *)text placeText:(NSString *)placeText textColor:(UIColor *)textColor placeHolderTextColor:(UIColor *)placeHolderTextColor
{
    textField.text = text;
    textField.placeholder = placeText;
    [textField setValue:placeHolderTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
    textField.font = [UIFont systemFontOfSize:textFont];
    textField.textColor = textColor;
    
};

-(CGFloat)returnHeight:(NSString *)str font:(float)font width:(float)width
{
    return  [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;
};
-(CGFloat)returnWidth:(NSString *)str font:(float)font
{
    return  [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,20 ) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.width;
}


- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}
-(UILabel *)labelFrame:(CGRect)frame
{
    UILabel *l = [[UILabel alloc]init];
    l.frame = frame;
    return l;
};
-(UILabel *)labelNew
{
    return [[UILabel alloc]init];
};
-(UIColor *)color:(NSString *)color
{
    return [UIColor colorWithHexString:color];
    
}

-(void)localizedTextLabel:(UILabel *)textLabel
{
    textLabel.text = Localized(textLabel.text, nil);
    
}

-(void)localizedTextField:(UITextField *)textField
{
    textField.placeholder = Localized(textField.placeholder, nil);
    
}
-(void)localizedBtn:(UIButton *)btn
{
    [btn setTitle:Localized(btn.titleLabel.text, nil) forState:(UIControlStateNormal)];
    
}

-(void)locaLizedWithObjc:(id)Obj
{
    if ([Obj isKindOfClass:[UILabel class]]) {
        UILabel * textLabel = Obj;
        textLabel.text = Localized(textLabel.text, nil);
    }
    if ([Obj isKindOfClass:[UITextField class]]) {
        UITextField * textField = Obj;
        textField.placeholder = Localized(textField.placeholder, nil);
    }
    
    if ([Obj isKindOfClass:[UIButton class]]) {
        UIButton * btn = Obj;
          [btn setTitle:Localized(btn.titleLabel.text, nil) forState:(UIControlStateNormal)];
    }
};


@end

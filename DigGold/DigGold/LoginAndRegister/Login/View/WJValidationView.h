//
//
//  Created by James on 2019/1/1.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NNChangeValidationCodeBlock)();

@interface WJValidationView : UIView

@property (nonatomic, copy) NSArray *charArray;

@property (nonatomic, strong) NSMutableString *charString;

@property (nonatomic, copy) NNChangeValidationCodeBlock changeValidationCodeBlock;

- (instancetype)initWithFrame:(CGRect)frame andCharCount:(NSInteger)charCount andLineCount:(NSInteger)lineCount;

@end

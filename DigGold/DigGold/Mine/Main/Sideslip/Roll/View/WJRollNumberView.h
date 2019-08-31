//
//  WJRollNumberView.h
//  WJRollNumber
//
//  Created by James on 2019/1/2.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define WJRollNumberViewWidth 69
#define WJRollNumberViewHeight 107
@interface WJRollNumberView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                    rollBlock:(void (^)(NSInteger rollNumber))rollBlock;
- (void)startRollScrollWithRollNumber:(NSInteger)rollNumber
                           rollLength:(NSInteger)rollLength
                         intervalTime:(CGFloat)intervalTime;
@end

NS_ASSUME_NONNULL_END

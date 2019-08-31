//
//  WJRollClashView.h
//  WJRollNumber
//
//  Created by James on 2019/1/3.
//  Copyright © 2019年 JamesWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WJRollClashViewDelegate <NSObject>

- (void)rollHasFinished;

@end

@interface WJRollClashView : UIView
@property (nonatomic, weak) id<WJRollClashViewDelegate> delegate;

- (void)startRollWithLeftRollNumber:(NSInteger)leftRollNumber
                   middleRollNumber:(NSInteger)middleRollNumber
                    rightRollNumber:(NSInteger)rightRollNumber;
@end

NS_ASSUME_NONNULL_END

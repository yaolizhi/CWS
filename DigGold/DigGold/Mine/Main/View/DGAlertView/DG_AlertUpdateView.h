//
//  DG_AlertUpdateView.h
//  DigGold
//
//  Created by James on 2019/1/24.
//  Copyright © 2019年 MingShao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    DG_AlertUpdateStyle_Force,//强制
    DG_AlertUpdateStyle_Optional//非强制
} DG_AlertUpdateStyle;

@interface DG_AlertUpdateView : UIView


- (instancetype)initWithStyle:(DG_AlertUpdateStyle)style
                        title:(NSString *)title version:(NSString *)version
                      content:(NSString *)content
                   clickBlock:(void (^)(void))clickBlock;
- (void)showAlertUpdateView;
@end

NS_ASSUME_NONNULL_END

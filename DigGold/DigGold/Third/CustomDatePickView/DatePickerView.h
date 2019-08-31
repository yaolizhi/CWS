//
//  DatePickerView.h

//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd = 1,
    
}DateType;

@protocol DatePickerViewDelegate <NSObject>

- (void)getSelectDate:(NSString *)date type:(DateType)type;

@end

@interface DatePickerView : UIView

@property(nonatomic,assign)BOOL isDatePiker;
@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(DateType)type dataString:(NSString *)dataString;
- (void)showDataPickView;
- (void)dismissDataPickView;

@end

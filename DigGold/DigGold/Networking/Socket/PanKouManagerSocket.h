//
//  PanKouManagerSocket.h
//  SSKJ
//
//  Created by 赵亚明 on 2018/12/19.
//  Copyright © 2018 刘小雨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
typedef void(^DaBiManagerSocketDidConnectBlock)(void);

@protocol DaBiManagerSocketDelegate

-(void)managerSocketDidReciveData:(id)data;

@optional
@end
NS_ASSUME_NONNULL_BEGIN

@interface PanKouManagerSocket : NSObject

@property (nonatomic, weak) id<DaBiManagerSocketDelegate>delegate;

//超时重连时间，默认1秒
@property (nonatomic,assign)NSTimeInterval overtime;
//重连次数,默认5次
@property (nonatomic, assign)NSUInteger reconnectCount;
@property (nonatomic,copy)DaBiManagerSocketDidConnectBlock connect;
+ (instancetype)sharedManager;
//判断是否连接
- (BOOL)socketIsConnected;
//开启连接
- (void)openConnectSocketWithConnectSuccess:(DaBiManagerSocketDidConnectBlock)connectSuccess;
//关闭连接
- (void)closeConnectSocket;
//发送消息
- (void)socketSendMsg:(NSString*)str;

//单利存储数据

@property(nonatomic,strong)NSMutableDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END

//
//  PanKouManagerSocket.m
//  SSKJ
//
//  Created by 赵亚明 on 2018/12/19.
//  Copyright © 2018 刘小雨. All rights reserved.
//

#import "PanKouManagerSocket.h"

#import "SRWebSocket.h"

#define ksendHeartTimeInterval 30

@interface PanKouManagerSocket()<SRWebSocketDelegate> {
    NSInteger _reconnectCounter;
}
//主动断开：用于主动断开不需要自动重连YES主动  NO被动
@property (nonatomic,assign)BOOL isHandDisConnectSocket;
//重连socket定时器
@property(nonatomic, weak)NSTimer *reconnectSocketTimer;
//发送心跳定时器
@property(nonatomic, weak)NSTimer *sendHeartTimer;
@property(nonatomic, strong)SRWebSocket *webSocket;
@end

@implementation PanKouManagerSocket
@synthesize delegate = _delegate;
#pragma mark -- 初始化数据
+ (instancetype)sharedManager {
    static PanKouManagerSocket *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[PanKouManagerSocket alloc] init];
    });
    return _sharedManager;
}

-(id)init {
    self = [super init];
    if (self){
        _isHandDisConnectSocket = NO;
        _overtime = 1;
        _reconnectCount = 5;
    }
    return self;
}
#pragma mark -- 操作socket事件
//判断是否连接
- (BOOL)socketIsConnected {
    if (self.webSocket.readyState == SR_OPEN) {
        return YES;
    }
    return NO;
}
- (void)openConnectSocketWithConnectSuccess:(DaBiManagerSocketDidConnectBlock)connectSuccess {
    [PanKouManagerSocket sharedManager].connect = connectSuccess;
    [self openConnectSocket];
}
//开启连接
- (void)openConnectSocket {
    if (_webSocket)
    {
        [self clearSocket];
    }
    _isHandDisConnectSocket = NO;
    [self.webSocket open];
}
//关闭连接
- (void)closeConnectSocket {
    _reconnectCounter = 0;
    _isHandDisConnectSocket = YES;
    [self clearSocket];
    [self clearTimer];
}
//重新连接
- (void)reconnectSocket {
    
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        [self startReconnectSocketTimer];
    } else {
        [self closeConnectSocket];
        return;
    }
}
- (void)clearSocket {
    [_webSocket close];
    _webSocket.delegate = nil;
    _webSocket = nil;
}
#pragma mark -- 消息发送
//发送普通消息
- (void)socketSendMsg:(NSString*)str
{
    [self.webSocket send:str];
}
//发送心跳消息
- (void)sendHeartMsg{
    
}
#pragma mark -- 定时器管理
//开启重新连接定时器
- (void)startReconnectSocketTimer {
    if (!_reconnectSocketTimer) {
        _reconnectSocketTimer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(openConnectSocket) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_reconnectSocketTimer forMode:NSRunLoopCommonModes];
    }
}
//开启发送心跳定时器
- (void)startSendHeartTimer {
    if (!_sendHeartTimer) {
        _sendHeartTimer = [NSTimer scheduledTimerWithTimeInterval:ksendHeartTimeInterval target:self selector:@selector(sendHeartMsg) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_sendHeartTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)clearReconnectSocketTimer {
    if (_reconnectSocketTimer) {
        [_reconnectSocketTimer invalidate];
        _reconnectSocketTimer = nil;
    }
}
- (void)clearSendHeartTimer {
    if (self.sendHeartTimer) {
        [_sendHeartTimer invalidate];
        _sendHeartTimer = nil;
    }
    
}
- (void)clearTimer {
    [self clearSendHeartTimer];
    [self clearReconnectSocketTimer];
}

#pragma mark -- SRWebSocketDelegate
//socket连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [PanKouManagerSocket sharedManager].connect ? [PanKouManagerSocket sharedManager].connect() : nil;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
    [self clearReconnectSocketTimer];
    // 开启发送定时器数据
    [self sendHeartTimer];
}
//连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (!_isHandDisConnectSocket) {//被动断开
        //重新连接
        [self reconnectSocket];
    }
}
//接收服务端返回消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    [_delegate managerSocketDidReciveData:message];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KSocketLongDaBiNofication object:[self didWithData:message]];
}

-(NSDictionary *)didWithData:(id)data
{
    NSDictionary *singleGoodsDatas = nil;
    if ([data isKindOfClass:[NSString class]]) {
        singleGoodsDatas = [self dictionaryWithJsonString:data];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        singleGoodsDatas = data;
    }
    NSString *goodsCode = [WLTools stringTransformObject:[singleGoodsDatas objectForKey:@"code"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:singleGoodsDatas forKey:goodsCode];
    return dic;
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (_webSocket) {
        [self closeConnectSocket];
    }
}
//心跳
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}

-(SRWebSocket *)webSocket {
    if (!_webSocket) {
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:
                      [NSURLRequest requestWithURL:[NSURL URLWithString:kWllSocketURL]]];
        _webSocket.delegate = self;
    }
    return _webSocket;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end

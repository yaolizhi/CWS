//
//  WL_LoginUser_Tool.m
//  明
//
//  Created by mac for csh on 16/6/3.
//  Copyright © 2016年 WeiLv Technology. All rights reserved.
//

#import "SSKJ_User_Tool.h"

@interface SSKJ_User_Tool()

@end

@implementation SSKJ_User_Tool

+(void)clearUserInfo
{
//    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    SSKJUserDefaultsSET(@"", @"token");
    SSKJUserDefaultsSET(@"", @"account");
    SSKJUserDefaultsSET(@"", @"mobile");
    SSKJUserDefaultsSET(@"", @"uid");
    SSKJUserDefaultsSET(@"", @"userInfoModel");
    SSKJUserDefaultsSET(@"", @"has_tpwd");
}

+(SSKJ_User_Tool *)sharedUserTool
{
    
    static SSKJ_User_Tool *sharedSVC=nil;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,
        ^{
            sharedSVC = [[self alloc] init];
        });
  
    return sharedSVC;
}

#pragma mark -保存个人信息
-(void)saveUserInfoWithModel:(SSKJ_UserInfo_Model *)userModel
{

    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    if (![userModel isEqual:[NSNull null]]){
        [settings setObject:[userModel mj_keyValues] forKey:@"userInfoModel"];
        if (userModel.list.count > 0) {
            SSKJ_UserInfoItem_Model *model = userModel.list[0];
            [settings setObject:model.mobile forKey:@"mobile"];
        }
        if (![userModel.userid isEqual:[NSNull null]]) {
            [settings setObject:userModel.userid?:@"" forKey:@"uid"];
        }
        if (![userModel.has_tpwd isEqual:[NSNull null]]) {
            [settings setObject:userModel.has_tpwd?:@"" forKey:@"has_tpwd"];
        }
        
    }
    

}

-(SSKJ_UserInfo_Model *)getUserInfoModel
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [settings objectForKey:@"userInfoModel"];
    return [SSKJ_UserInfo_Model mj_objectWithKeyValues:dic];
}

#pragma mark -保存登录信息
-(void)saveLoginInfoWithLoginModel:(SSKJ_Login_Model *)loginModel
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    
    if (![loginModel.mobile isEqual:[NSNull null]]){
        [settings setObject:loginModel.mobile forKey:@"mobile"];
    }
    
    if (![loginModel.token isEqual:[NSNull null]]){
        [settings setObject:loginModel.token forKey:@"token"];
    }
    
    if (![loginModel.account isEqual:[NSNull null]]) {
        [settings setObject:loginModel.account forKey:@"account"];
    }
    
//    if (![loginModel.uid isEqual:[NSNull null]]) {
//        [settings setObject:loginModel.uid forKey:@"uid"];
//    }
    
}

- (BOOL)isLogingState {
    if ([self getToken].length>0 && [self getAccount].length>0) {
        return YES;
    }
    return NO;
}

-(void)saveLoginInfoWithMobile:(NSString *)mobile
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    if (![mobile isEqual:[NSNull null]]){
        [settings setObject:mobile forKey:@"mobile"];
    }
    
}

-(void)saveLoginInfoWithToken:(NSString *)token
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    if (![token isEqual:[NSNull null]]){
        [settings setObject:token forKey:@"token"];
    }
    
}
-(void)saveLoginInfoWithAccount:(NSString *)account
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    if (![account isEqual:[NSNull null]]){
        [settings setObject:account forKey:@"account"];
    }
    
}

//-(void)saveLoginInfoWithUid:(NSString *)uid
//{
//    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
//    if (![uid isEqual:[NSNull null]]){
//        [settings setObject:uid forKey:@"uid"];
//    }
//
//}


// 保存用户信息
-(void)saveUserInfoWithUserInfoModel:(SSKJ_UserInfo_Model *)userInfoModel
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];

//    if (![userInfoModel.uid isEqual:[NSNull null]]){
//        [settings setObject:userInfoModel.uid forKey:@"uid"];
//    }
    
}

#pragma mark - 获取手机号
-(NSString *)getMobile
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"mobile"];
    
}

#pragma mark - 获取token
-(NSString *)getToken
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"token"];
}


#pragma mark - 获取用户account
-(NSString *)getAccount
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"account"];
    
}

#pragma mark - 获取用户id
-(NSString *)getUID
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"uid"];
    
}

#pragma mark - 支付密码是否设置过
-(NSString *)getHas_tpwd
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"has_tpwd"];
    
}

- (void)saveCommonDataWithDic:(NSDictionary *)dic {
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSDictionary *data = [NSDictionary dictionaryWithDictionary:dic];
    [settings setObject:[data mj_JSONString] forKey:@"commonData_RG"];
    [settings synchronize];

}
- (NSDictionary *)getCommonData {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *dicString = [settings objectForKey:@"commonData_RG"];
    NSDictionary *dic = [dicString mj_JSONObject];
    if (dic && dic.allKeys.count > 0 && [dic isKindOfClass:[NSDictionary class]]) {
        return [dicString mj_JSONObject];
    }
    return @{};
}

- (void)fetchCommonData {
    NSDictionary *params = @{};
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_Common_data_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            [[SSKJ_User_Tool sharedUserTool]saveCommonDataWithDic:(NSDictionary *)netWorkModel.data];
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
        
    }];
}

- (void)fetchUserInfoData {
    NSDictionary *params = @{};
    WS(weakSelf);
    [[WLHttpManager shareManager]requestWithURL_HTTPCode:Port_UserInfo_URL RequestType:RequestTypePost Parameters:params Success:^(NSInteger statusCode, id responseObject) {
        WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
        if ([netWorkModel.status integerValue] == 200) {
            if ([netWorkModel.data isKindOfClass:[NSArray class]] &&
                ((NSArray *)netWorkModel.data).count == 0) {
//                [RCHUDPop popupTipText:responseObject[@"msg"] toView:nil];
                return;
            }
            
            WL_Network_Model *netWorkModel = [WL_Network_Model mj_objectWithKeyValues:responseObject];
            SSKJ_UserInfo_Model *model = [SSKJ_UserInfo_Model mj_objectWithKeyValues:netWorkModel.data];
            [[SSKJ_User_Tool sharedUserTool]saveUserInfoWithModel:model];
            
  
        }else{
            
        }
    } Failure:^(NSError *error, NSInteger statusCode, id responseObject) {
    }];
}

@end





























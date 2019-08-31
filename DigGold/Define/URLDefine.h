//
//  URLDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef URLDefine_h
#define URLDefine_h


#define ENVIRONMENT 1 //  0－开发/1－正式

#if ENVIRONMENT == 0
/* ************************  开发服务器接口地址  *********************************** */
//192.168.1.222:8080
#define ProductBaseServer  @"http://47.75.240.138:8080"// @"http://47.75.240.138:8080" //  @"http://192.168.1.222:8080"  //http://47.92.147.107

#define ProductBaseURLPath   "/app/"

#define ProductBaseURL       ProductBaseServer ProductBaseURLPath

#define SocketUrl @"ws://www.zijunkj.com/app/webSocketServer?account=account"

//买五卖五推送（盘口）
#define kWllSocketURL @"ws://b.keiex.com:7273"

/*******************************************************************************************/

#elif ENVIRONMENT ==1

/* ************************  发布正式服务器接口地址  *********************************** */


#define ProductBaseServer    @"http://b.keiex.com"

#define ProductBaseURLPath   "/app/"

#define ProductBaseURL       ProductBaseServer ProductBaseURLPath

#define SocketUrl @"ws://hrexpro.com/app/webSocketServer?account=account"

//买五卖五推送 盘口）
#define kWllSocketURL @"ws://b.keiex.com:7273"

/*******************************************************************************************/

#endif


/************************************ 登录、注册、忘记密码、获取验证码 ****************************/

/* 用户注册 */
#define Bull_Register_URL [NSString stringWithFormat:@"%@%@",ProductBaseURL,@"user/register"]
#define Bull_Login_URL [NSString stringWithFormat:@"%@%@",ProductBaseURL,@"user/login"]
/*******************************************************************************************/


/* 我的 */
//公告列表接口
#define NoticeListURL [NSString stringWithFormat:@"%@/Home/Qbw/zixun",ProductBaseServer]
// 公告详情接口
#define NoticeDetailURL [NSString stringWithFormat:@"%@/Home/Qbw/zixun_detail",ProductBaseServer]
// 交易挖矿 url
#define Mytrans_wk [NSString stringWithFormat:@"%@/home/qbw/trans_wk",ProductBaseServer]
//版本更新
#define BFEX_System_Version_Update_URL  [NSString stringWithFormat:@"%@/home/Version/check_version",ProductBaseServer]

#endif /* URLDefine_h */

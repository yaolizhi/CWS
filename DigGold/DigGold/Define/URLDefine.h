//
//  URLDefine.h
//  DigGold
//
//  Created by 赵亚明 on 2018/12/25.
//  Copyright © 2018 MingShao. All rights reserved.
//

#ifndef URLDefine_h
#define URLDefine_h


#define ENVIRONMENT 0 //  0－开发/1－正式

#if ENVIRONMENT == 0
/* ************************  开发服务器接口地址  *********************************** */
//192.168.1.222:8080
#define ProductBaseServer  @"http://www.0068cws.com"

#define ProductBaseURLPath   ""

#define ProductBaseURL       ProductBaseServer ProductBaseURLPath

//#define SocketUrl @"ws://47.244.107.142:7273"
#define SocketUrl @"ws://7273.qklxmbd.com"
//#define SocketUrl @"ws://192.168.1.119:7273"

//买五卖五推送（盘口）
#define kWllSocketURL @"ws://b.keiex.com:7273"

/*******************************************************************************************/

#elif ENVIRONMENT ==1

/* ************************  发布正式服务器接口地址  *********************************** */


#define ProductBaseServer  @"http://www.qklxmbd.com"

#define ProductBaseURLPath   ""

#define ProductBaseURL       ProductBaseServer ProductBaseURLPath

//7273.qklxmbd.com   47.91.166.216:7273
#define SocketUrl @"ws://7273.qklxmbd.com"

//#define SocketUrl @"ws://192.168.1.119:7273"

//买五卖五推送 盘口）
#define kWllSocketURL @"ws://b.keiex.com:7273"

/*******************************************************************************************/

#endif



//*********************************** 登录、注册、忘记密码、获取验证码 ***************************
#define PortUrl(port) [NSString stringWithFormat:@"%@%@",ProductBaseURL,port]
/* 用户注册 */
#define Port_Register_URL PortUrl(@"/Home/Users/register")
/* 用户登录 */
#define Port_Login_URL PortUrl(@"/Home/Users/user_login")
/* 发送短信 */
#define Port_SendSMS_URL PortUrl(@"/Home/Users/send_sms")
/* 重置资金密码 */
#define Port_ResetTPWD_URL PortUrl(@"/Home/Users/reset_tpwd")
/* 修改密码 */
#define Port_Edit_Pwd_URL PortUrl(@"/Home/Users/edit_pwd")
/* 上传头像 */
#define Port_Save_Upic_URL PortUrl(@"/Home/Users/save_upic")
/* 庄家奖池--主页 */
#define Port_Banker_Pool_URL PortUrl(@"/Home/Users/Banker_pool")
/* 账单流水 */
#define Port_BillList_URL PortUrl(@"/Home/Users/bill")
/* 用户信息 */
#define Port_UserInfo_URL PortUrl(@"/Home/Users/userinfo")
/* 排行榜 */
#define Port_Leaderboard_URL PortUrl(@"/Home/Users/leaderboard")
/* 删除钱包地址 */
#define Port_Del_Address_URL PortUrl(@"/Home/Users/del_address")
/* 修改资金密码 */
#define Port_Edit_Tpwd_URL PortUrl(@"/Home/Users/edit_tpwd")
/* 更新新手机号 */
#define Port_UpdateMyMobilePost_URL PortUrl(@"/Home/Users/update_my_mobile_post")
/* 历史查询 */
#define Port_Vcerify_URL PortUrl(@"/Home/Users/vcerify")
/* 开奖历史 */
#define Port_Lottery_URL PortUrl(@"/Home/Users/lottery")
/* 我的竞猜 */
#define Port_Myquiz_URL PortUrl(@"/Home/Users/myquiz")
/* 添加钱包地址 */
#define Port_Wallet_Address_URL PortUrl(@"/Home/Users/wallet_address")
/* 展示钱包地址 */
#define Port_Show_Address_URL PortUrl(@"/Home/Users/show_address")
/* 公告列表 */
#define Port_Notice_list_Post_URL PortUrl(@"/Home/Users/notice_list_post")
/* 公告详情 */
#define Port_Notice_one_Post_URL PortUrl(@"/Home/Users/notice_one_post")
/* 庄家奖池--历史 */
#define Port_Banker_History_URL PortUrl(@"/Home/Users/Banker_history")
/* 公共数据 */
#define Port_Common_data_URL PortUrl(@"/Home/Users/common_data")
/* 重置登录密码 */
#define Port_Reset_Opwd_URL PortUrl(@"/Home/Users/reset_opwd")
/* 修改昵称 */
#define Port_Edit_Realname_URL PortUrl(@"/Home/Users/edit_realname")
/* 支付方式 */
#define Port_Set_Pay_URL PortUrl(@"/Home/Users/set_pay")
/* 展示支付方式 */
#define Port_Show_Pay_URL PortUrl(@"/Home/Users/show_pay")
/* 上传图片 */
#define Port_CommonFileUpImg_URL PortUrl(@"/Home/Users/pic_up")
/* 推广二维码 */
#define Port_Link_URL PortUrl(@"/Home/Users/link")
/* 充值记录 */
#define Port_ChongzhiList_URL PortUrl(@"/Home/Users/chongzhi_list_post")
/* 提现记录 */
#define Port_TixianList_URL PortUrl(@"/Home/Users/tixian_list_post")
/* 提币请求 */
#define Port_Tixian_post_URL PortUrl(@"/Home/Users/tixian_post")
/* 普通用户下注 */
#define Port_Order_add_post_post_URL PortUrl(@"/Home/Order/order_add_post")
/* 普通用户逃跑 */
#define Port_Order_escape_post_post_URL PortUrl(@"/Home/Order/order_escape_post")
/* 庄家注入和提取 */
#define Port_Bank_op_post_URL PortUrl(@"/Home/Order/bank_op_post")
/* 充值二维码 */
#define Port_Bpay_URL PortUrl(@"/Home/Users/bpay")
/* 公共数据 */
#define Port_Common_data_URL PortUrl(@"/Home/Users/common_data")
/* roll点页面信息 */
#define Port_Roll_page_URL PortUrl(@"/Home/Roll/roll_page")
/* roll */
#define Port_Get_roll_num_URL PortUrl(@"/Home/Roll/get_roll_num")
/* ctData */
#define Port_Ct_Data_URL PortUrl(@"/Home/Users/ct_data")
/* versionUpdate */
#define Port_CheckVersion_URL PortUrl(@"/Home/Version/check_version")
/* 支付方式 */
#define Port_SetPay_URL PortUrl(@"/Home/Users/set_pay")
/* 银行类型 */
#define Port_BankList_URL PortUrl(@"/home/users/bank_list")
/* 充值 */
#define Port_OceanChongZhi_URL PortUrl(@"/Home/Ocean/chongzhi_buy")
/* 吾彩充值 */
#define Port_WuCaiChongZhi_URL PortUrl(@"/Home/Wu/pay")
/* 吾彩提币 */
#define Port_WuCaiOffer_URL PortUrl(@"/Home/Wu/offer")
/* 申请代理商 */
#define Port_Deiliapply_URL PortUrl(@"/Home/Users/daili_apply_post")
/* 获取usdt比率 */
#define Port_USDTRate_URL PortUrl(@"/Home/Users/get_tx_data")
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

#define AppDownUrl @"https://admin.xjqgsp.com/upload/?id=ab3185186230"


#endif /* URLDefine_h */

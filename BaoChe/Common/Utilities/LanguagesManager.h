//
//  LanguagesManager.h
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedStr(key) [LanguagesManager getStr:key]

static NSString * const LanguageTypeDidChangedNotificationKey = @"LanguageTypeDidChangedNotificationKey";

@interface LanguagesManager : NSObject

+ (void)initialize;
+ (NSArray *)getAppLanguagesTypeArray;
+ (void)setLanguage:(NSString *)languageType;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate;

@end

// 所有模块
static NSString * const All_DataSourceNotFoundKey              = @"All_DataSourceNotFound";
static NSString * const All_Confirm                            = @"All_Confirm";
static NSString * const All_Cancel                             = @"All_Cancel";
static NSString * const All_Delete                             = @"All_Delete";
static NSString * const All_Edit                               = @"All_Edit";
static NSString * const All_Save                               = @"All_Save";
static NSString * const All_PickFromCamera                     = @"All_PickFromCamera";
static NSString * const All_PickFromAlbum                      = @"All_PickFromAlbum";
static NSString * const All_AreYouWantToGiveUpInputContent     = @"All_AreYouWantToGiveUpInputContent";

// 积分商城
static NSString * const IntegralStore_integralRequired         = @"IntegralStore_integralRequired";
static NSString * const IntegralStore_exchangeCount            = @"IntegralStore_exchangeCount";

// 积分商城->详情
static NSString * const DeatilIntegralStore_MyIntegral         = @"DeatilIntegralStore_MyIntegral";
static NSString * const DeatilIntegralStore_ExchangeNow        = @"DeatilIntegralStore_ExchangeNow";

// 意见反馈
static NSString * const Feedback_FeedbackType                   = @"Feedback_FeedbackType";
static NSString * const Feedback_PleaseSelectFeedbackType       = @"Feedback_PleaseSelectFeedbackType";
static NSString * const Feedback_FeedbackContent                = @"Feedback_FeedbackContent";
static NSString * const Feedback_PleaseInputFeedbackContent     = @"Feedback_PleaseInputFeedbackContent";
static NSString * const Feedback_Contact                        = @"Feedback_Contact";
static NSString * const Feedback_PleaseInputYourName            = @"Feedback_PleaseInputYourName";
static NSString * const Feedback_PleaseInputMobilePhoneOrEmail  = @"Feedback_PleaseInputMobilePhoneOrEmail";
static NSString * const Feedback_SubmitFeedback                 = @"Feedback_SubmitFeedback";

// 我的余额
static NSString * const MyBalance_BalancePaymentDetails        = @"MyBalance_BalancePaymentDetails";

// 购物车
static NSString * const ShoppingCart_TotalOf                   = @"ShoppingCart_TotalOf";
static NSString * const ShoppingCart_Settlement                = @"ShoppingCart_Settlement";
static NSString * const ShoppingCart_DeleteProductItemKey      = @"ShoppingCart_DeleteProductItem";
static NSString * const ShoppingCart_NoSelectedProductItemKey  = @"ShoppingCart_NoSelectedProductItem";

// 购物车->优惠劵领取
static NSString * const ShoppingCart_Receive                   = @"ShoppingCart_Receive";
static NSString * const ShoppingCart_AlreadyReceive            = @"ShoppingCart_AlreadyReceive";

// 用户资料修改
static NSString * const ModifyUserInfo_Nickname                = @"ModifyUserInfo_Nickname";
static NSString * const ModifyUserInfo_Email                   = @"ModifyUserInfo_Email";
static NSString * const ModifyUserInfo_QQ                      = @"ModifyUserInfo_QQ";
static NSString * const ModifyUserInfo_MobilePhoneNumber       = @"ModifyUserInfo_MobilePhoneNumber";
static NSString * const ModifyUserInfo_Modify                  = @"ModifyUserInfo_Modify";

// 修改密码
static NSString * const ModifyPassword_OldPassword                    = @"ModifyPassword_OldPassword";
static NSString * const ModifyPassword_OldPasswordErrorRemind         = @"ModifyPassword_OldPasswordErrorRemind";

static NSString * const ModifyPassword_NewPassword                    = @"ModifyPassword_NewPassword";
static NSString * const ModifyPassword_NewPasswordErrorRemind         = @"ModifyPassword_NewPasswordErrorRemind";

static NSString * const ModifyPassword_NewPasswordConfirm             = @"ModifyPassword_NewPasswordConfirm";
static NSString * const ModifyPassword_NewPasswordConfirmErrorRemind  = @"ModifyPassword_NewPasswordConfirmErrorRemind";

static NSString * const ModifyPassword_ModifyPassword                 = @"ModifyPassword_ModifyPassword";
static NSString * const ModifyPassword_PasswordModifyFail             = @"ModifyPassword_PasswordModifyFail";

// 地址管理
static NSString * const AddressManager_AddNewAddress           = @"AddressManager_AddNewAddress";
static NSString * const AddressManager_ToDoOfTheAddress        = @"AddressManager_ToDoOfTheAddress";

// 地址管理->地址编辑或添加
static NSString * const AddressManager_PleaseChooseProvinceAndCity    = @"AddressManager_PleaseChooseProvinceAndCity";
static NSString * const AddressManager_PleaseInputDetailAddress       = @"AddressManager_PleaseInputDetailAddress";
static NSString * const AddressManager_PleaseInputZipCode             = @"AddressManager_PleaseInputZipCode";
static NSString * const AddressManager_PleaseInputConsigneeName       = @"AddressManager_PleaseInputConsigneeName";
static NSString * const AddressManager_PleaseInputConsigneeMobile     = @"AddressManager_PleaseInputConsigneeMobile";

// 类目
static NSString * const Catalog_TabType_ClassificationKey      = @"Catalog_TabType_Classification";
static NSString * const Catalog_TabType_BrandKey               = @"Catalog_TabType_Brand";
static NSString * const Catalog_TabType_EfficacyKey            = @"Catalog_TabType_Efficacy";

// 注册&登陆
static NSString * const Login_Login                            = @"Login_Login";
static NSString * const Login_UserName                         = @"Login_UserName";
static NSString * const Login_Password                         = @"Login_Password";
static NSString * const Login_AutoLogin                        = @"Login_AutoLogin";
static NSString * const Login_ForgetPassword                   = @"Login_ForgetPassword";
static NSString * const Login_LoginNow                         = @"Login_LoginNow";

static NSString * const Register_Register                      = @"Register_Register";
static NSString * const Register_MobileNumber                  = @"Register_MobileNumber";
static NSString * const Register_Email                         = @"Register_Email";
static NSString * const Register_PleaseInputPassword           = @"Register_PleaseInputPassword";
static NSString * const Register_PleaseInputPasswordAgain      = @"Register_PleaseInputPasswordAgain";
static NSString * const Register_VerificationCode              = @"Register_VerificationCode";
static NSString * const Register_GetVerificationCode           = @"Register_GetVerificationCode";
static NSString * const Register_RegisterNow                   = @"Register_RegisterNow";
static NSString * const Register_UseMobileNumberToRegister     = @"Register_UseMobileNumberToRegister";
static NSString * const Register_UseEmailToRegister            = @"Register_UseEmailToRegister";

// 注册&登陆预留
static NSString * const Login_NoUserShowInfoKey                = @"Login_NoUserShowInfo";
static NSString * const Login_NoPasswordShowInfoKey            = @"Login_NoPasswordShowInfo";
static NSString * const Login_NoPasswordConfirmShowInfoKey     = @"Login_NoPasswordConfirmShowInfo";
static NSString * const Login_PasswordNotEqualShowInfoKey      = @"Login_PasswordNotEqualShowInfo";
static NSString * const Login_NoAgreeProtocolShowInfoKey       = @"Login_NoAgreeProtocolShowInfo";
static NSString * const Login_LoadingShowInfoKey               = @"Login_LoadingShowInfo";
static NSString * const Login_LoginFailShowInfoKey             = @"Login_LoginFailShowInfo";

// 个人
static NSString * const Mine_VIPLevel                          = @"Mine_VIPLevel";
static NSString * const Mine_Order                             = @"Mine_Order";
static NSString * const Mine_Integral                          = @"Mine_Integral";
static NSString * const Mine_Balance                           = @"Mine_Balance";
static NSString * const Mine_RedEnvelope                       = @"Mine_RedEnvelope";

static NSString * const Mine_Coupon                            = @"Mine_Coupon";
static NSString * const Mine_RefundOrafterSales                = @"Mine_RefundOrafterSales";
static NSString * const Mine_ShippingAddress                   = @"Mine_ShippingAddress";

static NSString * const Mine_MyCollect                         = @"Mine_MyCollect";
static NSString * const Mine_Feedback                          = @"Mine_Feedback";
static NSString * const Mine_MyRecommend                       = @"Mine_MyRecommend";
static NSString * const Mine_MyComments                        = @"Mine_MyComments";
static NSString * const Mine_MyConsulting                      = @"Mine_MyConsulting";

static NSString * const Mine_ModifyPassword                    = @"Mine_ModifyPassword";

// 个人预留
static NSString * const Mine_DeleteThisAddressKey              = @"Mine_DeleteThisAddress";
static NSString * const Mine_PhoneNumberErrorKey               = @"Mine_PhoneNumberError";
static NSString * const Mine_EmailErrorKey                     = @"Mine_EmailError";

//版本检测
static NSString * const Version_NowNewVersionKey               = @"Version_NowNewVersion";
static NSString * const Version_LoadingShowKey                 = @"Version_LoadingShowKey";

// 产品
static NSString * const Product_List_BrandKey                  = @"Product_List_Brand";
static NSString * const Product_List_SortKey                   = @"Product_List_Sort";
static NSString * const Product_List_EffectKey                 = @"Product_List_Effect";
static NSString * const Product_List_PriceKey                  = @"Product_List_Price";

static NSString * const Product_Detail_AddCartKey              = @"Product_Detail_AddCart";
static NSString * const Product_Detail_GoPayKey                = @"Product_Detail_GoPay";

static NSString * const Product_AddCartSucceedShowInfoKey      = @"Product_AddCartSucceedShowInfo";
static NSString * const Product_AddCartFailShowInfoKey         = @"Product_AddCartFailShowInfo";
static NSString * const Product_AddFavoriteSucceedShowInfoKey  = @"Product_AddFavoriteSucceedShowInfo";
static NSString * const Product_AddFavoriteFailShowInfoKey     = @"Product_AddFavoriteFailShowInfo";
static NSString * const Product_NoSearchHistoryShowInfoKey     = @"Product_NoSearchHistoryShowInfo";
static NSString * const Product_ClearSearchHistoryShowInfoKey  = @"Product_ClearSearchHistoryShowInfo";

// 订单
static NSString * const Order_List_AllOrdersKey                = @"Order_List_AllOrders";
static NSString * const Order_List_WaitShipmentsOrdersKey      = @"Order_List_WaitShipmentsOrders";
static NSString * const Order_List_WaitPayOrdersKey            = @"Order_List_WaitPayOrders";

static NSString * const Order_List_OrderNumberKey              = @"Order_List_OrderNumber";
static NSString * const Order_List_OrderStateKey               = @"Order_List_OrderState";
static NSString * const Order_List_OrderMoneyKey               = @"Order_List_OrderMoney";
static NSString * const Order_List_OrderTimeKey                = @"Order_List_OrderTime";
static NSString * const Order_List_OrderAmountKey              = @"Order_List_OrderAmount";

static NSString * const Order_List_ProductAmountKey            = @"Order_List_ProductAmount";
static NSString * const Order_List_ProductTotalPriceKey        = @"Order_List_ProductTotalPrice";
static NSString * const Order_List_SelectAllProductKey         = @"Order_List_SelectAllProduct";

static NSString * const Order_Detail_RefundKey                 = @"Order_Detail_Refund";//退款/退货
static NSString * const Order_Detail_CommentKey                = @"Order_Detail_Comment";//评论
static NSString * const Order_Detail_LogisticsInfoKey          = @"Order_Detail_LogisticsInfo";
static NSString * const Order_Detail_ReceiveInfoKey            = @"Order_Detail_ReceiveInfo";

static NSString * const Order_Detail_FreightMoneyKey           = @"Order_Detail_FreightMoney";
static NSString * const Order_Detail_PayMoneyKey               = @"Order_Detail_PayMoney";

static NSString * const Order_Detail_UserNameKey               = @"Order_Detail_UserName";
static NSString * const Order_Detail_TelephoneKey              = @"Order_Detail_Telephone";
static NSString * const Order_Detail_AddressKey                = @"Order_Detail_Address";
static NSString * const Order_Detail_BestTimeKey               = @"Order_Detail_BestTime";

static NSString * const Order_Write_TotalProductKey            = @"Order_Write_TotalProduct";

static NSString * const Order_Write_ProductPacketKey           = @"Order_Write_ProductPacket";
static NSString * const Order_Write_GreetingCardKey            = @"Order_Write_GreetingCard";
static NSString * const Order_Write_LeaveMessageKey            = @"Order_Write_LeaveMessage";
static NSString * const Order_Write_InputMessageKey            = @"Order_Write_InputMessage";

static NSString * const Order_Write_Pay_AlipayKey              = @"Order_Write_Pay_Alipay";
static NSString * const Order_Write_Pay_WeChatKey              = @"Order_Write_Pay_WeChat";
static NSString * const Order_Write_Pay_PaypalKey              = @"Order_Write_Pay_Paypal";
static NSString * const Order_Write_Pay_BalanceKey             = @"Order_Write_Pay_Balance";

static NSString * const Order_Write_UseRedPacketKey            = @"Order_Write_UseRedPacketKey";
static NSString * const Order_Write_UseCouponKey               = @"Order_Write_UseCouponKey";
static NSString * const Order_Write_UseBalanceKey              = @"Order_Write_UseBalanceKey";
static NSString * const Order_Write_UseIntegralKey             = @"Order_Write_UseIntegralKey";

static NSString * const Order_Write_UnitPointKey               = @"Order_Write_UnitPointKey";
static NSString * const Order_Write_UnitMoneyKey               = @"Order_Write_UnitMoneyKey";

static NSString * const Order_Write_GoPayKey                   = @"Order_Write_GoPayKey";


//评论
static NSString * const Comment_List_LookMoreKey               = @"Comment_List_LookMore";
static NSString * const Comment_Detail_PublishKey              = @"Comment_Detail_Publish";

//收藏夹
static NSString * const Favorites_Product_PersonNumKey         = @"Favorites_Product_PersonNum";

//退款、退货
static NSString * const Refund_Money_Step_FirstInfoKey         = @"Refund_Money_Step_FirstInfo";
static NSString * const Refund_Money_Step_SecondInfoKey        = @"Refund_Money_Step_SecondInfo";
static NSString * const Refund_Money_Step_ThirdInfoKey         = @"Refund_Money_Step_ThirdInfo";

static NSString * const Refund_Product_Step_FirstInfoKey       = @"Refund_Product_Step_FirstInfo";
static NSString * const Refund_Product_Step_SecondInfoKey      = @"Refund_Product_Step_SecondInfo";
static NSString * const Refund_Product_Step_ThirdInfoKey       = @"Refund_Product_Step_ThirdInfo";
static NSString * const Refund_Product_Step_FourthInfoKey      = @"Refund_Product_Step_FourthInfo";

static NSString * const Refund_TypeKey                         = @"Refund_Type";
static NSString * const Refund_ReasonKey                       = @"Refund_Reason";
static NSString * const Refund_MoneyKey                        = @"Refund_Money";
static NSString * const Refund_NumberKey                       = @"Refund_Number";
static NSString * const Refund_ExplainKey                      = @"Refund_Explain";

static NSString * const Refund_Choose_MoneyKey                 = @"Refund_Choose_Money";
static NSString * const Refund_Choose_ProductKey               = @"Refund_Choose_Product";

static NSString * const Refund_RemindText_ChooseKey            = @"Refund_RemindText_Choose";
static NSString * const Refund_RemindText_MoneyKey             = @"Refund_RemindText_Money";
static NSString * const Refund_RemindText_NumberKey            = @"Refund_RemindText_Number";
static NSString * const Refund_RemindText_MaxKey               = @"Refund_RemindText_Max";

static NSString * const Refund_Reason_DescriptionDifferentKey  = @"Refund_Reason_DescriptionDifferent";
static NSString * const Refund_Reason_FakeKey                  = @"Refund_Reason_FakeKey";
static NSString * const Refund_Reason_BreakageKey              = @"Refund_Reason_Breakage";
static NSString * const Refund_Reason_DefectKey                = @"Refund_Reason_Defect";
static NSString * const Refund_Reason_SizeDifferentKey         = @"Refund_Reason_SizeDifferent";
static NSString * const Refund_Reason_FaultBuyKey              = @"Refund_Reason_FaultBuy";
static NSString * const Refund_Reason_DonotLikeKey             = @"Refund_Reason_DonotLike";
static NSString * const Refund_Reason_EffectIsBadKey           = @"Refund_Reason_EffectIsBad";

static NSString * const Refund_LogisticsCompanyKey             = @"Refund_LogisticsCompany";
static NSString * const Refund_LogisticsNumberKey              = @"Refund_LogisticsNumber";
static NSString * const Refund_RemindText_LogisticsNumberKey   = @"Refund_RemindText_LogisticsNumber";

// 各控制器导航栏标题
static NSString * const NavTitle_Feedback                      = @"NavTitle_Feedback";
static NSString * const NavTitle_IntegralStore                 = @"NavTitle_IntegralStore";
static NSString * const NavTitle_DetailIntegralStore           = @"NavTitle_DetailIntegralStore";
static NSString * const NavTitle_MyBalance                     = @"NavTitle_MyBalance";
static NSString * const NavTitle_ModifyUserInfo                = @"NavTitle_ModifyUserInfo";
static NSString * const NavTitle_ModifyPassword                = @"NavTitle_ModifyPassword";
static NSString * const NavTitle_ShoppingCarKey                = @"NavTitle_ShoppingCar";
static NSString * const NavTitle_MineKey                       = @"NavTitle_Mine";
static NSString * const NavTitle_AddressManagerKey             = @"NavTitle_AddressManager";
static NSString * const NavTitle_AddAddressKey                 = @"NavTitle_AddAddress";
static NSString * const NavTitle_ModifyAddress                 = @"NavTitle_ModifyAddress";
static NSString * const NavTitle_PreferentialKey               = @"NavTitle_Preferential";
static NSString * const NavTitle_FAQKey                        = @"NavTitle_FAQ";

static NSString * const NavTitle_OrderListKey                  = @"NavTitle_OrderList";
static NSString * const NavTitle_OrderDetailKey                = @"NavTitle_OrderDetail";
static NSString * const NavTitle_OrderWriteKey                 = @"NavTitle_OrderWrite";
static NSString * const NavTitle_OrderProductListKey           = @"NavTitle_OrderProductListKey";
static NSString * const NavTitle_FavoritesKey                  = @"NavTitle_Favorites";
static NSString * const NavTitle_MyCommentKey                  = @"NavTitle_MyComment";
static NSString * const NavTitle_CommentDetialKey              = @"NavTitle_CommentDetial";

#import "RNTencentIM.h"
#import <React/RCTConvert.h>

#define TUIKit_DB_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_tencent_imsdk_data/"]
#define TUIKit_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/image/"]
#define TUIKit_Video_Path [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/video/"]
#define TUIKit_Voice_Path [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/voice/"]
#define TUIKit_File_Path [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/file/"]

NSString* TLSPwdLoginFailed = @"TLSPwdLoginFailed"; //TLS登录失败
NSString* TLSPwdLoginTimeout = @"TLSPwdLoginTimeout";//TLS登录超时
NSString* OnRefreshUserSigFail = @"OnRefreshUserSigFail";//刷新SIG失败
NSString* OnRefreshUserSigTimeout = @"OnRefreshUserSigTimeout";//刷新SIG超时
NSString* GetFriendListFailed = @"GetFriendListFailed";//获取好友列表失败
NSString* GetUsersProfile = @"GetUsersProfile";//获取用户资料失败
NSString* AddFriendFailed = @"AddFriendFailed";//添加好友失败
NSString* AddFriendSuccess = @"AddFriendSuccess";//添加好友成功
NSString* AddFriendUnknow = @"AddFriendUnknow";//添加好友状态未知
NSString* AddFriendPENDING = @"AddFriendPENDING";//添加好友等待好友审核通过
NSString* AddFriendNOT_FRIEND = @"AddFriendNOT_FRIEND";//添加好友查无此人
NSString* AddFriendALREADY_FRIEND = @"AddFriendALREADY_FRIEND";//添加好友已经是好友
NSString* DelFriend = @"DelFriend";//删除好友
NSString* GetConversionList = @"GetConversionList";//获取所有会话
NSString* NewMessage = @"NewMessage";
NSString* NewPreMessage = @"NewPreMessage";
NSString* ReceiptMessage = @"ReceiptMessage"; //消息已读回执
NSString* GetLocalMessage = @"GetLocalMessage";
NSString* GetAllLocalMessage = @"GetAllLocalMessage";
NSString* soundFilePathEvent = @"soundFilePathEvent";

NSString* onForceOffline = @"onForceOffline";//被其他终端踢下线
NSString* onUserSigExpired = @"onUserSigExpired";//用户签名过期了，需要刷新 userSig 重新登录 SDK
NSString* onConnected = @"onConnected";
NSString* onConnecting = @"onConnecting";
NSString* onSelfInfoUpdated = @"onSelfInfoUpdated";
NSString* onWifiNeedAuth = @"onWifiNeedAuth";
NSString* onGroupTipsEvent = @"onGroupTipsEvent";
NSString* onRefresh = @"onRefresh";
NSString* onRefreshConversation = @"onRefreshConversation";
NSString* OnAddFriends = @"OnAddFriends";
NSString* OnDelFriends = @"OnDelFriends";
NSString* OnFriendProfileUpdate = @"OnFriendProfileUpdate";
NSString* OnAddFriendReqs = @"OnAddFriendReqs";
NSString* onMemberJoin = @"onMemberJoin";
NSString* onMemberQuit = @"onMemberQuit";
NSString* onMemberUpdate = @"onMemberUpdate";
NSString* onGroupAdd = @"onGroupAdd";
NSString* onGroupDelete = @"onGroupDelete";
NSString* onGroupUpdate = @"onGroupUpdate";
NSString* TImLoginFailed = @"tenImLoginFailed";//登录失败
NSString* TImLoginSuccess = @"tenImLoginSuccess";//登录失败
NSString* TImLogout = @"TImLogout";//登出


NSString* OPEN_CONVERSATION = @"OPEN_CONVERSATION";//打开会话
NSString* ClOSE_CONVERSATION = @"ClOSE_CONVERSATION";//关闭会话
NSString* LABEL_SEARCH = @"LABEL_SEARCH";//标签搜索
NSString* RESPOND_BROADCAST = @"RESPOND_BROADCAST";//响应广播
NSString* LOCK_CONVERSATION = @"LOCK_CONVERSATION";//超时锁定会话
NSString* ADD_TO_BLACKLIST = @"ADD_TO_BLACKLIST";//添加到黑名单
NSString* DELETE_FROM_BLACKLIST = @"DELETE_FROM_BLACKLIST";//从黑名单移除

NSMutableArray* msgList;

NSString* currentConversationId = @"";
NSString* currentConversationType = @"";


@implementation RNTencentIM


RCT_EXPORT_MODULE();

+(id)allocWithZone:(struct _NSZone *)zone{
  static RNTencentIM *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}
//.m文件
//+(id)allocWithZone:(NSZone *)zone {
//  static RNBridge *sharedInstance = nil;
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    sharedInstance = [super allocWithZone:zone];
//  });
//  return sharedInstance;
//}

RCT_EXPORT_METHOD(init:(NSDictionary *)params resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    //    TIMManager * manager = [TIMManager sharedInstance];
    //    [manager setEnv:0];
    //    TIMSdkConfig* config = [[TIMSdkConfig alloc] init];
    //    config.accountType = @"36862";
    //    config.disableCrashReport = YES;
    //    config.disableLogPrint = YES;
    //    //    config.logLevel = TIM_LOG_NONE;
    //    config.sdkAppId = 1400186212;
    //    [manager initSdk:config];
    ////    [[QalSDKProxy sharedInstance] setEnv:0];
    //    [[QalSDKProxy sharedInstance] initQal:1400186212];
    //    [[TLSHelper getInstance] init:1400186212 andAppVer:@"v1.0"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:TUIKit_Image_Path]){
      [fileManager createDirectoryAtPath:TUIKit_Image_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Video_Path]){
      [fileManager createDirectoryAtPath:TUIKit_Video_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_Voice_Path]){
      [fileManager createDirectoryAtPath:TUIKit_Voice_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_File_Path]){
      [fileManager createDirectoryAtPath:TUIKit_File_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:TUIKit_DB_Path]){
      [fileManager createDirectoryAtPath:TUIKit_DB_Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSNumber* sdkAppId = [RCTConvert NSNumber:params[@"sdkAppId"]];
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    config.logLevel = V2TIM_LOG_INFO;
    [[V2TIMManager sharedInstance]initSDK:sdkAppId != nil?[sdkAppId intValue]:1400324754 config:config listener:self];
    resolve(@{});
  });
}


RCT_EXPORT_METHOD(TLSPwdLogin:(NSString*)identifiers:(NSString*)passWord){

//  if ([[TLSHelper getInstance] needLogin:identifiers]) {
//    [[TLSHelper getInstance] TLSPwdLogin:identifiers andPassword:passWord andTLSPwdLoginListener:self];
//  }else {
//    [[TLSHelper getInstance] TLSRefreshTicket:identifiers andTLSRefreshTicketListener:self];
//  }
}

RCT_EXPORT_METHOD(tenImLogon:(NSString*)identifier:(NSString*)userSig:
 (RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
//  TIMLoginParam *login_param = [[TIMLoginParam alloc] init];
//  // identifier 为用户名，userSig 为用户登录凭证
//  // appidAt3rd 在私有帐号情况下，填写与 sdkAppId 一样
//  login_param.identifier = identifier;
//  login_param.userSig = userSig;
//  login_param.appidAt3rd = @"1400324754";
    [[V2TIMManager sharedInstance] login:identifier userSig:userSig succ:^{
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"loginStatus"] = @"tenImLoginSuccess";
        dic[@"tenName"] = identifier;
        dic[@"tenPsw"] = userSig;
        successCallback(dic);
    } fail:^(int code, NSString *desc) {
        //错误码 code 和错误描述 desc，可用于定位请求失败原因
        //错误码 code 列表请参见错误码表
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"loginStatus"] = [NSString stringWithFormat:@"tenImLoginFailed,code: %d  errmsg: %@",code, desc];
        NSLog(@"TenImLogon Failed:%d->%@", code, desc);
        errorCallback([NSString stringWithFormat:@"%d",code], desc,nil);
    }];
}


RCT_EXPORT_METHOD(getLoginStatus:
 (RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  V2TIMLoginStatus* loginStatus = [[V2TIMManager sharedInstance] getLoginStatus];
  NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
  dic[@"status"] = [NSNumber numberWithInt:loginStatus];
  successCallback(dic);
}


- (void)onRecvNewMessage:(V2TIMMessage*)message{
    NSString* conversationType = @"";
    if([[message userID] isEqualToString: currentConversationId]){
      if([message groupID] == nil) {
        conversationType = @"C2C";
      } else {
        conversationType = @"Group";
      }
      if([conversationType isEqualToString: currentConversationType]){
        [msgList insertObject:message atIndex:0];
      }
      //Todo: 需要添加conversionId
    }
    NSMutableArray* array = [self handleMessage:[NSArray arrayWithObject:message]];
  [self sendEventWithName:NewMessage body:array];
}

/**
 *  踢下线通知
 */
- (void)onKickedOffline{
  [self sendEventWithName:onForceOffline body:nil];
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err{

}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired{
    [self sendEventWithName:onUserSigExpired body:nil];
}

/**
 *  网络连接成功
 */
- (void)onConnectSuccess{
  [self sendEventWithName:onConnected body:nil];
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnectFailed:(int)code err:(NSString*)err{

}

/**
 * 当前用户的资料发生了更新
 */
- (void)onSelfInfoUpdated:(V2TIMUserFullInfo *)info{

}


/**
 *  连接中
 */
- (void)onConnecting{
    [self sendEventWithName:onConnecting body:nil];
}

/**
 *  刷新会话
 */
- (void)onRefresh{

}

/**
 *  刷新部分会话（包括多终端已读上报同步）
 *
 *  @param conversations 会话（TIMConversation*）列表
 */
- (void)onRefreshConversations:(NSArray*)conversations{

}

/**
 *  密码登陆要求验证图片验证码
 *
 *  @param picData 图片验证码
 *  @param errInfo 错误信息
 */
//-(void)  OnPwdLoginNeedImgcode:(NSData *)picData andErrInfo:(TLSErrInfo *)errInfo{
//
//}

/**
 *  密码登陆请求图片验证成功
 *
 *  @param picData 图片验证码
 */
-(void)  OnPwdLoginReaskImgcodeSuccess:(NSData *)picData{

}

/**
 *  密码登陆成功
 *
 *  @param userInfo 用户信息
 */
//-(void)  OnPwdLoginSuccess:(TLSUserInfo *)userInfo{
//  NSString* userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
//}

/**
 *  密码登陆失败
 *
 *  @param errInfo 错误信息
 */
//-(void)  OnPwdLoginFail:(TLSErrInfo *)errInfo{
//  [self sendEventWithName:TLSPwdLoginFailed body:nil];
//}

/**
 *  秘密登陆超时
 *
 *  @param errInfo 错误信息
 */
//-(void)  OnPwdLoginTimeout:(TLSErrInfo *)errInfo{
//  [self sendEventWithName:TLSPwdLoginTimeout body:nil];
//}

/**
 *  刷新票据成功
 *
 *  @param userInfo 用户信息
 */
//-(void)  OnRefreshTicketSuccess:(TLSUserInfo *)userInfo{
//  NSString* userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
//}

/**
 *  刷新票据失败
 *
 *  @param errInfo 错误信息
 */
//-(void)  OnRefreshTicketFail:(TLSErrInfo *)errInfo{
//  [self sendEventWithName:OnRefreshUserSigFail body:nil];
//}

/**
 *  刷新票据超时
 *
 *  @param errInfo 错误信息
 */
//-(void)  OnRefreshTicketTimeout:(TLSErrInfo *)errInfo{
//  [self sendEventWithName:OnRefreshUserSigTimeout body:nil];
//}

/**
 *  添加好友通知
 *
 *  @param users 好友列表（TIMUserProfile*）
 */
- (void)onFriendListAdded:(NSArray< V2TIMFriendInfo * > *)users{
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for(V2TIMFriendInfo* result in users){
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[@"identifier"] = result.userID;
    dic[@"getFaceUrl"] = [[result userFullInfo] faceURL];
    if ([[result userFullInfo] gender] == 1) {
      dic[@"getGender"] = @"Male";
    }else if([[result userFullInfo] gender] == 2){
      dic[@"getGender"] = @"Female";
    }else{
      dic[@"getGender"] = @"Unknow";
    }
    dic[@"getNickName"] = [[result userFullInfo] nickName];
    dic[@"getRemark"] = [result friendRemark];
    [array addObject:dic];
  }
  [self sendEventWithName:OnAddFriends body:array];
}

/**
 *  删除好友通知
 *
 *  @param identifiers 用户id列表（NSString*）
 */
- (void)onDelFriends:(NSArray*)identifiers{
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for(NSString* result in identifiers){
    [array addObject:result];
  }
  [self sendEventWithName:OnDelFriends body:array];
}

/**
 *  好友资料更新通知
 *
 *  @param profiles 资料列表（TIMUserProfile*）
 */
- (void)onFriendProfileChanged:(NSArray< V2TIMFriendInfo * > *)users{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(V2TIMFriendInfo* result in users){
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      dic[@"identifier"] = result.userID;
      dic[@"getFaceUrl"] = [[result userFullInfo] faceURL];
      if ([[result userFullInfo] gender] == 1) {
        dic[@"getGender"] = @"Male";
      }else if([[result userFullInfo] gender] == 2){
        dic[@"getGender"] = @"Female";
      }else{
        dic[@"getGender"] = @"Unknow";
      }
      dic[@"getNickName"] = [[result userFullInfo] nickName];
      dic[@"getRemark"] = [result friendRemark];
      [array addObject:dic];
    }
    [self sendEventWithName:OnFriendProfileUpdate body:array];
}

/**
 *  好友申请通知
 *
 *  @param reqs 好友申请者id列表（TIMSNSChangeInfo*）
 */
- (void)onFriendApplicationListAdded:(NSArray< V2TIMFriendApplication * > *)reqs{

  NSMutableArray* array = [[NSMutableArray alloc] init];
  for(V2TIMFriendApplication* result in reqs){
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[@"getIdentifier"] = result.userID;
    dic[@"getNickName"] = result.nickName;
    dic[@"faceUrl"] = result.faceUrl;
    dic[@"addTime"] = [NSNumber numberWithDouble:result.addTime];
    dic[@"getRemark"] = @"";
    dic[@"getWording"] = result.addWording;
    dic[@"getSource"] = result.addSource;
    [array addObject:dic];
  }
  [self sendEventWithName:OnAddFriendReqs body:array];
}

/**
 *  收到了已读回执
 *
 *  @param receipts 已读回执（TIMMessageReceipt*）列表
 */
- (void) onRecvC2CReadReceipt:(NSArray< V2TIMMessageReceipt * > *)receipts{
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for(V2TIMMessageReceipt* result in receipts){
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[@"peer"] = [result userID];
    dic[@"timestamp"] = [NSNumber numberWithDouble:result.timestamp];
    [array addObject:dic];
  }
  [self sendEventWithName:ReceiptMessage body:array];
}


/**
 *  收到了消息回撤
 *
 *  @param msgID 消息回撤 消息id
 */
- (void) onRecvMessageRevoked:(NSString *)msgID{
  NSMutableArray* array = [[NSMutableArray alloc] init];
  NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
  dic[@"msgID"] = msgID;
  [self sendEventWithName:ReceiptMessage body:dic];
}


/**
 *  上传进度回调
 *
 *  @param msg      正在上传的消息
 *  @param elemidx  正在上传的elem的索引
 *  @param taskid   任务id
 *  @param progress 上传进度
 */
- (void)onUploadProgressCallback:(V2TIMMessage*)msg elemidx:(uint32_t)elemidx taskid:(uint32_t)taskid progress:(uint32_t)progress{

}

/**
 *  有新用户加入群时的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 加群用户的群资料（TIMGroupMemberInfo*）列表
 */
- (void)onMemberJoin:(NSString*)groupId membersInfo:(NSArray*)membersInfo{

}

/**
 *  有群成员退群时的通知回调
 *
 *  @param groupId 群ID
 *  @param members 退群成员的identifier（NSString*）列表
 */
- (void)onMemberQuit:(NSString*)groupId members:(NSArray*)members{

}

/**
 *  群成员信息更新的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 更新后的群成员资料（TIMGroupMemberInfo*）列表
 */
- (void)onMemberUpdate:(NSString*)groupId membersInfo:(NSArray*)membersInfo{

}

/**
 *  加入群的通知回调
 *
 *  @param groupInfo 加入群的群组资料
 */
- (void)onGroupAdd:(V2TIMGroupInfo*)groupInfo{

}

/**
 *  解散群的通知回调
 *
 *  @param groupId 解散群的群ID
 */
- (void)onGroupDelete:(NSString*)groupId{

}

/**
 *  群资料更新的通知回调
 *
 *  @param groupInfo 更新后的群资料信息
 */
- (void)onGroupUpdate:(V2TIMGroupInfo*)groupInfo{

}


RCT_EXPORT_METHOD(setUserConfig){
//  TIMUserConfig* config = [[TIMUserConfig alloc] init];
//
//  config.userStatusListener = self;
//  config.groupEventListener = self;
//  config.refreshListener = self;
//  config.friendshipListener = self;
//  config.receiptListener = self;
//  config.messageUpdateListener = self;
//  //  config.messgeRevokeListener = self;
//  config.uploadProgressListener = self;
//  config.groupListener = self;
//
//  config.disableRecnetContact = NO;
//  config.disableStorage = NO;
//  //开启消息已读回执
//  config.enableReadReceipt = YES;
//  config.enableFriendshipProxy = YES;
//  config.enableGroupAssistant = YES;
//
//  [[TIMManager sharedInstance] setUserConfig:config];
//
//  TIMSdkConfig* sdkConfig = [[TIMManager sharedInstance] getGlobalConfig];
//  sdkConfig.connListener = self;

}

/**
 * 添加消息监听器
 */
RCT_EXPORT_METHOD(addMessageListener){
  //  [[TIMManager shareInstance] setUserConfig];
  //  [TIMManager sharedInstance].getUserConfig.messageUpdateListener = self;
  [[V2TIMManager sharedInstance] addAdvancedMsgListener:self];
}

/**
 * 移除消息监听器
 */
RCT_EXPORT_METHOD(removeMessageListener){
  //  [TIMManager sharedInstance].getUserConfig.messageUpdateListener = nil;
  [[V2TIMManager sharedInstance] removeAdvancedMsgListener:self];
}


/**
 * 发送文字消息
 */
RCT_EXPORT_METHOD(sendTIMTextMessage:(NSString*)toUser:(NSString*)conversationType:(NSString*)content:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
    V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
    if(type == V2TIM_C2C) {
        NSString* msgId = [[V2TIMManager sharedInstance] sendC2CTextMessage:toUser to:content succ:^{
            //发送消息成功
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"success"] = @true;
            successCallback(dic);
        } fail:^(int code, NSString *desc) {
            NSLog(@"SendMsg Failed:%d->%@", code, desc);
            errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\",\"getMsgId\":\"%@\",\"peer\":\"%@\"}",code, desc, msgId, toUser],nil);
        }];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"peer"] = toUser;
        dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
        dic[@"getMsgId"] = msgId;
        dic[@"messageType"] = @"TEXT";
        dic[@"conversationType"] = conversationType;
        dic[@"content"] = content;
        [self sendEventWithName:NewPreMessage body:dic];
    } else if(type == V2TIM_GROUP) {
        //待完善
    }
}

/**
 * 发送图片消息
 * @param toUser
 * @param conversationType
 */
RCT_EXPORT_METHOD(sendTIMImageMessage:(NSString*)toUser:(NSString*)conversationType:(NSString*)path:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
    V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
    V2TIMMessage* msg = [[V2TIMMessage alloc] init];
    V2TIMMessage* elem = [[V2TIMManager sharedInstance] createImageMessage:path];
    NSString* msgId = @"";
    if(type == V2TIM_C2C) {
        msgId = [[V2TIMManager sharedInstance] sendMessage:elem receiver:toUser groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:false offlinePushInfo:nil progress:^(uint32_t progress) {

        } succ:^{
            //发送消息成功
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"success"] = @true;
            successCallback(dic);
        } fail:^(int code, NSString *desc) {
            NSLog(@"SendMsg Failed:%d->%@", code, desc);
            errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\",\"getMsgId\":\"%@\",\"peer\":\"%@\"}",code, desc, msgId, toUser],nil);
        }];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"peer"] = toUser;
        dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
        dic[@"getMsgId"] = msgId;
        dic[@"messageType"] = @"TEXT";
        dic[@"conversationType"] = conversationType;
        dic[@"content"] = @"";
        [self sendEventWithName:NewPreMessage body:dic];
    } else if(type == V2TIM_GROUP) {
        //待完善
    }
  NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
  dic[@"peer"] = toUser;
  dic[@"timestamp"] = [NSNumber numberWithDouble:msg.timestamp.timeIntervalSince1970];
  dic[@"getMsgId"] = msgId;
  dic[@"messageType"] = @"IMAGE";
  dic[@"conversationType"] = conversationType;
  dic[@"imagePath"] = path;
  [self sendEventWithName:NewPreMessage body:dic];
}
/**
 * 发送语音
 */
#pragma mark - sendSound
RCT_EXPORT_METHOD(sendTimSoundMessage:(NSString*)toUser:(NSString*)conversationType:(NSString*)path:(NSInteger)duration:(RCTPromiseResolveBlock)successCallback rejecter:(RCTPromiseRejectBlock)errorCallback){
        V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
        V2TIMMessage* elem = [[V2TIMManager sharedInstance] createSoundMessage:path duration:duration];
        NSString* msgId = @"";
        if(type == V2TIM_C2C) {
            msgId = [[V2TIMManager sharedInstance] sendMessage:elem receiver:toUser groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:false offlinePushInfo:nil progress:^(uint32_t progress) {

            } succ:^{
                //发送消息成功
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                dic[@"success"] = @true;
                successCallback(dic);
            } fail:^(int code, NSString *desc) {
                NSLog(@"SendMsg Failed:%d->%@", code, desc);
                errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\",\"getMsgId\":\"%@\",\"peer\":\"%@\"}",code, desc, msgId, toUser],nil);
            }];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"peer"] = toUser;
            dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
            dic[@"getMsgId"] = msgId;
            dic[@"messageType"] = @"TEXT";
            dic[@"conversationType"] = conversationType;
            dic[@"content"] = @"";
            [self sendEventWithName:NewPreMessage body:dic];
        } else if(type == V2TIM_GROUP) {
            //待完善
        }
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      dic[@"peer"] = toUser;
      dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
      dic[@"getMsgId"] = msgId;
      dic[@"messageType"] = @"IMAGE";
      dic[@"conversationType"] = conversationType;
      dic[@"soundPath"] = path;
      dic[@"duration"] = [NSString stringWithFormat: @"%ld", (long)duration];
      [self sendEventWithName:NewPreMessage body:dic];
}

//发送自定义消息
RCT_EXPORT_METHOD(sendTimCustomMessage:(NSString*)toUser:(NSString*)conversationType:(NSString*)content:(NSString*)description:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
    V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
    V2TIMMessage* elem = [[V2TIMManager sharedInstance] createCustomMessage:content desc:description extension:nil];
    NSString* msgId = @"";
    if(type == V2TIM_C2C) {
        msgId = [[V2TIMManager sharedInstance] sendMessage:elem receiver:toUser groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:false offlinePushInfo:nil progress:^(uint32_t progress) {

        } succ:^{
            //发送消息成功
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"success"] = @true;
            successCallback(dic);
        } fail:^(int code, NSString *desc) {
            NSLog(@"SendMsg Failed:%d->%@", code, desc);
            errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\",\"getMsgId\":\"%@\",\"peer\":\"%@\"}",code, desc, msgId, toUser],nil);
        }];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        dic[@"peer"] = toUser;
        dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
        dic[@"getMsgId"] = msgId;
        dic[@"messageType"] = @"TEXT";
        dic[@"conversationType"] = conversationType;
        dic[@"content"] = @"";
        [self sendEventWithName:NewPreMessage body:dic];
    } else if(type == V2TIM_GROUP) {
        //待完善
    }
  NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
  dic[@"peer"] = toUser;
  dic[@"timestamp"] = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
  dic[@"getMsgId"] = msgId;
  dic[@"messageType"] = @"IMAGE";
  dic[@"conversationType"] = conversationType;
  dic[@"content"] = content;
  dic[@"description"] = description;
  [self sendEventWithName:NewPreMessage body:dic];
}

RCT_EXPORT_METHOD(tenImLogout:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  [[V2TIMManager sharedInstance] logout:^{
    //登出成功
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[@"logoutStatus"] = [NSNumber numberWithBool:YES];
    successCallback(dic);
    [self sendEventWithName:TImLogout body:dic];
  } fail:^(int code, NSString *msg) {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    dic[@"logoutStatus"] = [NSNumber numberWithBool:NO];
    dic[@"logoutFailedCode"] = [NSNumber numberWithInt:code];
    dic[@"logoutFailedMessage"] = msg;
    [self sendEventWithName:TImLogout body:dic];
    errorCallback([NSString stringWithFormat:@"%d",code],msg,nil);
  }];
}

RCT_EXPORT_METHOD(getConversationList:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [[V2TIMManager sharedInstance] getConversationList:^(NSArray<V2TIMConversation *> *list) {
        for (int i = 0; i<[list count]; i++) {
          V2TIMConversation* conversation = list[i];
          if ([conversation type] == V2TIM_GROUP) {
            continue;
          }
          V2TIMMessage *msg = [conversation lastMessage];
          if (msg == nil) {
            continue;
          }
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"identifier"] = [msg userID];
            dic[@"timestamp"] = [NSNumber numberWithDouble:msg.timestamp.timeIntervalSince1970];
            dic[@"messageType"] = [[self getMessageType:msg] uppercaseString];
            dic[@"conversionType"] = [self getConversationType:[conversation type]];


            dic[@"getFaceUrl"] = [msg faceURL];
            dic[@"getNickName"] = [msg nickName];
            dic[@"getRemark"] =[msg friendRemark];
            dic[@"sender"] =[msg sender];
            dic[@"peer"] =[msg userID];
            dic[@"isSelf"] = [NSNumber numberWithBool: [msg isSelf]];
            BOOL isBlack = false;
            BOOL isLock = false;

            V2TIMElemType elem = [msg elemType];
            if(elem  == V2TIM_ELEM_TYPE_TEXT){
              V2TIMTextElem* textElem = [msg textElem];
              dic[@"messageContent"] = textElem.text;
            }else if(elem  == V2TIM_ELEM_TYPE_IMAGE){
              dic[@"messageContent"] = @"[图片]";
            }else if(elem  == V2TIM_ELEM_TYPE_SOUND){
              dic[@"messageContent"] = @"[音频]";
            }else if(elem  == V2TIM_ELEM_TYPE_VIDEO){
              dic[@"messageContent"] = @"[视频]";
            }else if(elem  == V2TIM_ELEM_TYPE_CUSTOM){
              V2TIMCustomElem* customElem = [msg customElem];
              NSString* desc = customElem.desc;
              if([desc isEqualToString: ADD_TO_BLACKLIST]){
                isBlack = true;
                isLock = true;
              } else if([desc isEqualToString: OPEN_CONVERSATION]){
                isLock = false;
              } else if([desc isEqualToString: ClOSE_CONVERSATION]){
                isLock = true;
              } else if([desc isEqualToString: LABEL_SEARCH]){
                isLock = true;
              } else if([desc isEqualToString: RESPOND_BROADCAST]){
                isLock = false;
              } else if([desc isEqualToString: LOCK_CONVERSATION]){
                isLock = true;
              } else if([desc isEqualToString: DELETE_FROM_BLACKLIST]){
                isBlack = false;
                isLock = true;
              }

              if([desc isEqualToString: @""]){
                dic[@"messageContent"] = @"[自定义消息]";
              } else{
                dic[@"messageContent"] = desc;
              }

            }
            dic[@"unread"] =[NSNumber numberWithInt:[conversation unreadCount]];
            dic[@"isLock"] = [NSNumber numberWithBool: isLock];
            dic[@"isBlack"] = [NSNumber numberWithBool: isBlack];
            [array addObject:dic];
        }
        successCallback(array);
    } fail:^(int code, NSString *desc) {
        errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\"}",code, desc], nil);
    }];
}


//删除会话
RCT_EXPORT_METHOD(deleteConversation:(NSString*)conversationType:(NSString*)identifier:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
    V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
    [[V2TIMManager sharedInstance] deleteConversation:identifier succ:^{
        successCallback([NSNumber numberWithBool:TRUE]);
    } fail:^(int code, NSString *desc) {
        errorCallback([NSString stringWithFormat:@"%d",code],[NSString stringWithFormat:@"{\"code\":\"%d\",\"msg\":\"%@\"}",code, desc], nil);
    }];
}


RCT_EXPORT_METHOD(clearMsgList){
  if(msgList.count > 0){
    [msgList removeAllObjects];
  }
  currentConversationId = @"";
  currentConversationType = @"";
}



-(NSString*)getConversationType:(V2TIMConversationType)type{
  NSString* typeString = @"C2C";
  if (type == V2TIM_GROUP) {
    typeString = @"Group";
  }
  return typeString;
}
-(NSString*)getMessageType:(V2TIMMessage*)msg{
    NSString* messageType = @"Text";
    V2TIMElemType type = msg.elemType;
    if(type  == V2TIM_ELEM_TYPE_TEXT){
        messageType = @"Text";
    }else if(type  == V2TIM_ELEM_TYPE_IMAGE){
        messageType = @"Image";
    }else if(type  == V2TIM_ELEM_TYPE_SOUND){
        messageType = @"Sound";
    }else if(type  == V2TIM_ELEM_TYPE_VIDEO){
        messageType = @"Video";
    }else if(type  == V2TIM_ELEM_TYPE_CUSTOM){
        messageType = @"Custom";
    }else if(type  == V2TIM_ELEM_TYPE_FILE){
        messageType = @"File";
    }else if(type  == V2TIM_ELEM_TYPE_LOCATION){
        messageType = @"Location";
    }else if(type  == V2TIM_ELEM_TYPE_FACE){
        messageType = @"Face";
    }
  return messageType;
}


/**
 * 分页获取会话本地消息
 */
RCT_EXPORT_METHOD(getLocalMessage:(NSString*)conversionId:(NSString*)conversationType:
                  (NSString*)loadMore:
(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  V2TIMConversationType type = [@"chat" isEqualToString:conversationType]?V2TIM_C2C:V2TIM_GROUP;
    currentConversationType = [@"chat" isEqualToString:conversationType] ? @"C2C" : @"Group";
    [[V2TIMManager sharedInstance] getConversation:conversionId succ:^(V2TIMConversation *conv) {
        currentConversationId = conversionId;
        V2TIMMessage* last = nil;
        if([loadMore isEqualToString:@"initLoad"]){
          msgList = [[NSMutableArray alloc] init];
        }else{
          last = [msgList lastObject];
        }
//        [conv getMes]
    } fail:^(int code, NSString *desc) {

    }];



  [conversation getMessage:10 last:last succ:^(NSArray *msgs) {
    NSMutableArray* array = [self handleMessage:msgs];
    [msgList addObjectsFromArray:msgs];
    successCallback(array);
  } fail:^(int code, NSString *msg) {
    NSLog(@"error : %d %@",code,msg);
    errorCallback(@"getLocalMessage Failed",msg,nil);
  }];

}


/**
 * 获取会话本地消息
 */
RCT_EXPORT_METHOD(getAllLocalMessage:(NSString*)conversionId:
                  (NSString*)conversationType:
(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  TIMConversationType type = [@"chat" isEqualToString:conversationType]?TIM_C2C:TIM_GROUP;
  TIMConversation* conversation = [[TIMManager sharedInstance] getConversation:type receiver:conversionId];
  [conversation getMessage:10000 last:nil succ:^(NSArray *msgs) {
    NSMutableArray* array = [self handleMessage:msgs];
    successCallback(array);
  } fail:^(int code, NSString *msg) {
    NSLog(@"error : %d %@",code,msg);
    errorCallback(@"getAllLocalMessage",msg,nil);
  }];
}

/**
 * 获取好友列表
 * @param promise
 */
RCT_EXPORT_METHOD(getFriendList:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  [[TIMFriendshipManager sharedInstance] getFriendList:^(NSArray *friends) {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSLog(@"error : %lu ",(unsigned long)[array count]);
    for (TIMUserProfile * profile in friends) {
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      dic[@"identifier"] = profile.identifier;
      dic[@"getNickName"] = profile.nickname;
      dic[@"getRemark"] = profile.remark;
      dic[@"getFaceUrl"] = profile.faceURL;
      [array addObject:dic];
    }
    NSLog(@"error : %s","ssssssss!!!!!!!!");
    successCallback(array);
  } fail:^(int code, NSString *msg) {
    errorCallback(GetFriendListFailed,msg,nil);
  }];
}


/**
 * 获取用户资料
 * @param userName
 * @param promise
 */
RCT_EXPORT_METHOD(getUsersProfile:(NSArray*)userNames:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  [[TIMFriendshipManager sharedInstance] getUsersProfile:userNames  succ:^(NSArray *friends) {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (TIMUserProfile* profile in friends) {
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      dic[@"identifier"] = profile.identifier;
      dic[@"getNickName"] = profile.nickname;
      dic[@"getRemark"] = profile.remark;
      dic[@"faceUrl"] = profile.faceURL;
      if (profile.gender == TIM_GENDER_MALE) {
        dic[@"getGender"] = @"Male";
      }else if(profile.gender == TIM_GENDER_FEMALE){
        dic[@"getGender"] = @"Female";
      }else{
        dic[@"getGender"] = @"Unknow";
      }
      dic[@"getLocation"] = profile.location;
      dic[@"getSelfSignature"] = profile.selfSignature;
      dic[@"getBirthday"] = [NSNumber numberWithDouble:[profile birthday]];
      dic[@"getLanguage"] = [NSNumber numberWithDouble:[profile language]];
      dic[@"getLevel"] = [NSNumber numberWithDouble:[profile level]];
      dic[@"getRole"] = [NSNumber numberWithDouble:[profile role]];
      if (profile.gender == TIM_GENDER_MALE) {
        dic[@"getGender"] = @"Male";
      }else if(profile.gender == TIM_GENDER_FEMALE){
        dic[@"getGender"] = @"Female";
      }else{
        dic[@"getGender"] = @"Unknow";
      }
      [array addObject:dic];
    }
    successCallback(array);
  } fail:^(int code, NSString *msg) {
    errorCallback(GetUsersProfile,msg,nil);
  }];
}


//修改个人信息
RCT_EXPORT_METHOD(modifyProfile:
                  (NSDictionary*) params: (RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){

  TIMUserProfile * profile = [[TIMUserProfile alloc] init];

  if([[params allKeys] containsObject:@"nickName"]){
    profile.nickname = [params valueForKey: @"nickName"];
  }

  if([[params allKeys] containsObject:@"faceUrl"]){
    profile.faceURL = [params valueForKey: @"faceUrl"];
  }

  if([[params allKeys] containsObject:@"selfSignature"]){
    NSString *signature = [params valueForKey: @"selfSignature"];
    profile.selfSignature = [signature dataUsingEncoding:NSUTF8StringEncoding];
  }
  if([[params allKeys] containsObject:@"birthday"]){
    profile.birthday = [[params valueForKey: @"birthday"] integerValue];
  }
  if([[params allKeys] containsObject:@"language"]){
    profile.language = [[params valueForKey: @"language"] integerValue];
  }

  if([[params allKeys] containsObject:@"gender"]){
    if([[params valueForKey: @"gender"] isEqualToString:@"Male"]){
      profile.gender = TIM_GENDER_MALE;
    }else{
      profile.gender = TIM_GENDER_FEMALE;
    }
  }
  TIMFriendProfileOption *option = [TIMFriendProfileOption new];
  [[TIMFriendshipManager sharedInstance] modifySelfProfile: option profile:profile succ:^{
    NSLog(@"modifyProfile: %s","success");
    successCallback([NSNumber numberWithBool:true]);
  } fail:^(int code, NSString *msg) {
    errorCallback(@"modifyProfile failed",msg,nil);
  }];

}


RCT_EXPORT_METHOD(addFriend:(NSString*)userName:(NSString*)remark:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){
  NSMutableArray* array = [[NSMutableArray alloc] init];
  TIMAddFriendRequest* request = [[TIMAddFriendRequest alloc] init];
  request.remark = remark;
  request.addWording = userName;
  [array addObject:request];
  [[TIMFriendshipManager sharedInstance] addFriend:array succ:^(NSArray *friends) {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for (TIMFriendResult* res in friends) {
      switch (res.status) {
        case TIM_FRIEND_STATUS_SUCC:
          dic[@"identifer"] = res.identifier;
          successCallback(dic);
          break;
        case TIM_ADD_FRIEND_STATUS_PENDING:
          errorCallback(AddFriendPENDING,@"",nil);
        case TIM_ADD_FRIEND_GROUP_STATUS_NOT_FRIEND:
          errorCallback(AddFriendNOT_FRIEND,@"",nil);
          break;
        case TIM_ADD_FRIEND_STATUS_ALREADY_FRIEND:
          errorCallback(AddFriendALREADY_FRIEND,@"",nil);
          break;
      }
    }
  } fail:^(int code, NSString *msg) {
    errorCallback(AddFriendFailed,msg,nil);
  }];
}


//设置会话消息已读
RCT_EXPORT_METHOD(setReadMessage:
                  (NSString*)conversationType:
                  (NSString*)identifier:
(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){

  TIMConversationType type = [@"C2C" isEqualToString:conversationType]?TIM_C2C:TIM_GROUP;

  TIMConversation* conversation = [[TIMManager sharedInstance] getConversation:type receiver:identifier];

  [conversation setReadMessage:nil succ:^{
    NSLog(@"setReadMessage: %s","success");
    successCallback([NSNumber numberWithBool:true]);
  } fail:^(int code, NSString *msg) {
    NSLog(@"error : %d %@",code,msg);
    errorCallback(@"setReadMessage failed",msg,nil);
  }];
}


RCT_EXPORT_METHOD(delFriend:(NSString*)identifer:(RCTPromiseResolveBlock)successCallback:(RCTPromiseRejectBlock)errorCallback){

  [[TIMFriendshipManager sharedInstance] delFriend:TIM_FRIEND_DEL_SINGLE users:[NSArray arrayWithObjects:identifer, nil] succ:^(NSArray *friends) {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(TIMFriendResult* result in friends){
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      dic[@"delFriendStatus"] = [NSNumber numberWithBool:YES];
      dic[@"delFriendIdentifer"] = result.identifier;
      [array addObject:dic];
    }
    successCallback(array);
  } fail:^(int code, NSString *msg) {
    errorCallback(DelFriend,msg,nil);
  }];
}

/**
 * 同意/拒绝好友申请
 */
RCT_EXPORT_METHOD(addFriendResponse:(NSString*)identifer:(int)actionType){

  [[TIMFriendshipManager sharedInstance] doResponse:[NSArray arrayWithObjects:identifer, nil] succ:^(NSArray *friends) {

  } fail:^(int code, NSString *msg) {

  }];
}
/**
 * 设置自己的好友验证方式为需要验证
 * @param allowType
 */
RCT_EXPORT_METHOD(setAllowType:(int)allowType){
  TIMFriendProfileOption* option = [[TIMFriendProfileOption alloc] init];
  TIMUserProfile* profile = [[TIMUserProfile alloc] init];
  profile.allowType = allowType == 1?TIM_FRIEND_ALLOW_ANY:TIM_FRIEND_NEED_CONFIRM;

  [[TIMFriendshipManager sharedInstance] modifySelfProfile:option profile:profile succ:^{

  } fail:^(int code, NSString *msg) {

  }];
}

-(NSMutableArray*)handleMessage:(NSArray*)msgs{
  NSMutableArray* array = [[NSMutableArray alloc] init];
  for (int i = 0; i<[msgs count]; i++) {
    if([[msgs[i] getConversation] getType] == TIM_SYSTEM){
      continue;
    }

    for (int j = 0; j<[msgs[i] elemCount]; j++) {
      V2TIMMessage* msg = msgs[i];
      NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
      TIMElem* elem = [msg getElem:j];
      TIMUserProfile* profile = [msg getSenderProfile];
      dic[@"getFaceUrl"] = profile == nil?@"":profile.faceURL;
      dic[@"getIdentifier"] = profile == nil?@"":profile.identifier;
      dic[@"getNickName"] = profile == nil?@"":profile.nickname;
      dic[@"getRemark"] = profile == nil?@"":profile.remark;
      dic[@"isSelf"] = [NSNumber numberWithBool: [msg isSelf]];
      dic[@"getMsgId"] = msg.msgId;
      dic[@"peer"] = [[msg getConversation] getReceiver];
      dic[@"timestamp"] = [NSNumber numberWithDouble:msg.timestamp.timeIntervalSince1970];
      dic[@"conversionType"] = [self getConversationType:[msg getConversation].getType];
      dic[@"messageStatus"] = [NSNumber numberWithInteger: [msg status]];
      BOOL isBlack = false;
      BOOL isLock = false;

      if ([elem isKindOfClass:[TIMTextElem class]]) {
        TIMTextElem* textElem = (TIMTextElem*)elem;
        dic[@"messageType"] = @"TEXT";
        dic[@"messageContent"] = textElem.text;
      }else if([elem isKindOfClass:[TIMImageElem class]]){
        TIMImageElem* imageElem = (TIMImageElem*)elem;
        dic[@"messageType"] = @"IMAGE";
        dic[@"messageContent"] = @"[图片]";
        NSMutableArray* imageArray =[[NSMutableArray alloc] init];
        for (TIMImage *image in [imageElem imageList]) {
          NSMutableDictionary* imageDic =[[NSMutableDictionary alloc] init];
          if([image type] == TIM_IMAGE_TYPE_LARGE){
            imageDic[@"imgType"] = @"Large";
          } else if([image type] == TIM_IMAGE_TYPE_THUMB){
            imageDic[@"imgType"] = @"Thumb";
          } else if([image type] == TIM_IMAGE_TYPE_ORIGIN){
            imageDic[@"imgType"] = @"Original";
          }

          NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
          NSString *cachePath = [cacPath objectAtIndex:0];
          NSString *filePath = [NSString stringWithFormat:@"%@%@%@%@",cachePath,@"/images/",image.uuid,@".jpg"];
          imageDic[@"imgLocalPath"] = filePath;
          imageDic[@"imgOriginUrl"] = image.url;
          imageDic[@"imgUuid"] = image.uuid;
          imageDic[@"imgWidth"] = [[NSNumber  numberWithInteger:image.width] stringValue];
          imageDic[@"imgHeight"] = [[NSNumber  numberWithInteger:image.height] stringValue];
          imageDic[@"imgSize"] = [NSNumber numberWithDouble:image.size];
          [imageArray addObject:imageDic];
        }
        dic[@"imgList"] = imageArray;

      }else if([elem isKindOfClass:[TIMCustomElem class]]){
        dic[@"messageType"] = @"CUSTOM";
        TIMCustomElem* customElem = (TIMCustomElem*)elem;
        NSString* desc = customElem.description;
        NSData* data = customElem.data;
        if([desc isEqualToString: ADD_TO_BLACKLIST]){
          isBlack = true;
          isLock = true;
        } else if([desc isEqualToString: OPEN_CONVERSATION]){
          isLock = false;
        } else if([desc isEqualToString: ClOSE_CONVERSATION]){
          isLock = true;
        } else if([desc isEqualToString: LABEL_SEARCH]){
          isLock = true;
        } else if([desc isEqualToString: RESPOND_BROADCAST]){
          isLock = false;
        } else if([desc isEqualToString: LOCK_CONVERSATION]){
          isLock = true;
        } else if([desc isEqualToString: DELETE_FROM_BLACKLIST]){
          isBlack = false;
          isLock = true;
        }
        if([desc isEqualToString: @""]){
          dic[@"messageContent"] = @"[自定义消息]";
        } else{
          dic[@"messageContent"] = desc;
        }
        dic[@"desc"] = desc;
        dic[@"data"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      }else if([elem isKindOfClass:[TIMSoundElem class]]){
        TIMSoundElem* soundElem = (TIMSoundElem*)elem;
        dic[@"messageType"] = @"SOUND";
        dic[@"messageContent"] = @"[音频]";
        dic[@"soundDuration"] = [NSNumber numberWithDouble:soundElem.second];
        dic[@"soundDataSize"] = [NSNumber numberWithDouble:soundElem.dataSize];
        //Library/Caches/voice/
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",path,@"/Caches/voice/"];
        //将语音存储到本地documents
        if (![fileManager fileExistsAtPath:directoryPath]) {
          NSError* error;
          [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
          if(error){
            NSLog(@"create soundFile directory failed  %@",error);
          }
        };
        NSString *targetFilePath = [[directoryPath stringByAppendingPathComponent:[soundElem uuid]] stringByAppendingString:@".aac"];
        if([fileManager fileExistsAtPath:targetFilePath]){
          dic[@"soundPath"] = targetFilePath;
        }else{
          [soundElem getSound:(targetFilePath) succ:^{
            NSLog(@"下载音频文件成功,路径是:  %@",targetFilePath);
            NSLog(@"下载音频文件的MsgId是:  %@",msg.msgId);
            NSLog(@"是否属于自己发送的语音: %@",msg.isSelf?@"属于自己":@"不属于自己");
            NSMutableDictionary* diccSound = [[NSMutableDictionary alloc] init];
            diccSound[@"getIdentifier"] = profile == nil?@"":profile.identifier;
            diccSound[@"soundDuration"] = [NSNumber numberWithDouble:[soundElem second]];
            diccSound[@"soundDataSize"] = [NSNumber numberWithDouble:[soundElem dataSize]];
            diccSound[@"messageContent"] = @"[音频]";
            diccSound[@"messageType"] = @"SOUND";
            diccSound[@"getMsgId"] = msg.msgId;
            diccSound[@"soundPath"] = targetFilePath;
            [self sendEventWithName:soundFilePathEvent body:diccSound];
          } fail:^(int code, NSString *msg) {
            NSLog(@"下载音频文件失败");
            NSLog(@"getSoundFailed : %d %@",code,msg);
          }];
        }
      }
      dic[@"isLock"] = [NSNumber numberWithBool: isLock];
      dic[@"isBlack"] = [NSNumber numberWithBool: isBlack];
      [array addObject:dic];
    }
  }
  return array;
}

-(NSString*)getFriendsProfile:(NSString*)tenName{
  NSArray* users = [NSArray arrayWithObjects:tenName, nil];
  [[TIMFriendshipManager sharedInstance] getFriendsProfile:users succ:^(NSArray *friends) {

  } fail:^(int code, NSString *msg) {

  }];
  return nil;
}

-(NSArray<NSString *> *)supportedEvents{
  return @[TLSPwdLoginFailed,TLSPwdLoginTimeout,OnRefreshUserSigFail,OnRefreshUserSigTimeout,GetFriendListFailed,GetUsersProfile,AddFriendFailed,AddFriendSuccess,AddFriendUnknow,AddFriendPENDING,AddFriendNOT_FRIEND,AddFriendALREADY_FRIEND,DelFriend,NewMessage, NewPreMessage, ReceiptMessage, onForceOffline,onUserSigExpired,onConnected,onSelfInfoUpdated,onWifiNeedAuth,onGroupTipsEvent,onRefresh,onRefreshConversation,OnAddFriends,OnDelFriends,OnFriendProfileUpdate,OnAddFriendReqs,onMemberJoin,onMemberQuit,onMemberUpdate,onGroupAdd,onGroupDelete,TImLoginFailed,TImLoginSuccess,TImLogout,soundFilePathEvent];
}
@end



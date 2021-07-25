//
//  XCXinChatTools.swift
//  
//
//  Created by FangLin on 2019/12/27.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import UIKit
import NIMSDK
import CoreData

/* ============================== UserDefaults ============================== */
fileprivate let kWechatAccount = "SmartTileGpsAccount"
fileprivate let kWechatPassword = "SmartTileGpsPassword"
fileprivate let kWechatUserId = "SmartTileGpsUserId"

class XCXinChatTools: NSObject {
    // 当前聊天的userId
    var currentChatUserId: String?
    
    // MARK:- 代理
    // MARK: 音频代理
    weak var mediaDelegate: XCXinChatToolsMediaDelegate?
    // weak var chatDelegate:
    
    static let shared: XCXinChatTools = {
        let tools = XCXinChatTools()
        return tools
    }()
    
    func registerNIMManager() {
        NIMSDKConfig.shared().delegate = XCXinChatTools.shared as? NIMSDKConfigDelegate
        NIMSDKConfig.shared().shouldSyncUnreadCount = true
        NIMSDKConfig.shared().maxAutoLoginRetryTimes = 10
        NIMSDK.shared().register(withAppID: NIM_AppKey, cerName: nil)
        NIMCustomObject.registerCustomDecoder(XCNIMMsgDecoder.init())   //解码自定义消息
        NIMSDK.shared().chatManager.add(XCXinChatTools.shared as NIMChatManagerDelegate)
        NIMSDK.shared().mediaManager.add(XCXinChatTools.shared as NIMMediaManagerDelegate)
//        NIMSDK.shared().apnsManager.add(XCXinChatTools.shared as NIMApnsManagerDelegate)
        NIMSDK.shared().loginManager.add(XCXinChatTools.shared as NIMLoginManagerDelegate)
        NIMSDK.shared().userManager.add(XCXinChatTools.shared as NIMUserManagerDelegate)
        NIMSDK.shared().conversationManager.add(XCXinChatTools.shared as NIMConversationManagerDelegate)
        NIMSDK.shared().systemNotificationManager.add(XCXinChatTools.shared as NIMSystemNotificationManagerDelegate)
    }
}

// MARK:- 登录相关
extension XCXinChatTools {
    // MARK: 手动登录
    func login(with account: String, pwd: String, errorBlock:@escaping (Error?) -> ()) {
        // 如果pwd MD5加密 => pwd.MD5String()
        NIMSDK.shared().loginManager.login(account, token: pwd, completion: {[unowned self] (error) in
            if error == nil {
                Dprint("登录成功")
                // 存储账号和密码
                self.storeCurrentUser(account, pwd)
                
                errorBlock(nil)
            } else {
                errorBlock(error)
                Dprint((error! as NSError).code)
            }
        })
    }
    // MARK: 自动登录
    func autoLogin() -> (Bool) {
        // 取出账号和密码
        var account: String?
        var pwd: String?
        self.readCurrentUser { (myAccount, myPwd) in
            account = myAccount
            pwd = myPwd
        }
        if account == nil || pwd == nil { // 没有保存账号或密码
            Dprint("没有保存账号或密码")
            return false
        } else {    // 自动登录
            Dprint("启用自动登录")
            NIMSDK.shared().loginManager.autoLogin(account!, token: pwd!)
            return true
        }
    }
    
    // MARK: 登出
    func loginOut() {
        NIMSDK.shared().loginManager.logout { (error) in
            if error == nil {
                guard let userInfo = UserInfo.mr_findFirst() else {
                    return
                }
                userInfo.mr_deleteEntity()
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                self.clearCurrentUser()
                self.trans2UserVC() // 跳转到用户界面
            }
        }
    }
}

// MARK:- 信息操作
extension XCXinChatTools {
    // MARK: 获取当前用户的userId
    func getCurrentUserId() -> String {
        let userId = NIMSDK.shared().loginManager.currentAccount()
        return userId
    }
    
    // MARK: 获取当前用户的资料
    func getMineInfo() -> NIMUser? {
        return NIMSDK.shared().userManager.userInfo(self.getCurrentUserId())
    }
    
    // MARK:- 从本地获取好友信息
    func getFriendInfo(userId: String) -> NIMUser? {
        return NIMSDK.shared().userManager.userInfo(userId)
    }
    
    // MARK:- 从服务器获取好友信息
    func refreshFriends() {
        guard let users = self.getMyFriends() else {return}
        var userIds: [String] = []
        for user in users {
            userIds.append(user.userId ?? "")
        }
        NIMSDK.shared().userManager.fetchUserInfos(userIds) { (users, error) in
            if error != nil {
                Dprint(error)
            } else {
                Dprint("获取成功，下次启动程序会自动更新好友信息")
                // 发送更新好友列表的通知
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteUserInfoUpdateFriends), object: self, userInfo: nil)
            }
        }
    }
    
    //MARK: - 搜索用户信息
    func searchUserInfo(_ userId:String,completion:@escaping (String?,NIMUser?)->()) {
        NIMSDK.shared().userManager.fetchUserInfos([userId]) { (users, error) in
            if error != nil {
                completion("500",nil)
            }else {
                if users?.count == 0 {
                    completion("200",nil)
                }else {
                    completion("200",users?.first)
                }
            }
        }
    }
}

// MARK:- 好友操作
extension XCXinChatTools {
    // MARK: 获取我的好友
    func getMyFriends() -> [NIMUser]? {
        return NIMSDK.shared().userManager.myFriends()
    }
    // MARK: 添加好友
    //直接添加好友
    func addFriend(_ userID: String, message: String, completion:@escaping (Error?)->()) {
        let request = NIMUserRequest()
        request.userId = userID
        request.operation = .add
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            completion(error)
        }
    }
    //请求添加好友
    func requstAddFriend(_ userID: String, message: String, completion:@escaping (Error?)->()) {
        let request = NIMUserRequest()
        request.userId = userID
        request.operation = .request
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            completion(error)
        }
    }
    //通过好友请求
    func verifyAddFriend(_ userID: String, message: String, completion:@escaping (Error?)->()) {
        let request = NIMUserRequest()
        request.userId = userID
        request.operation = .verify
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            completion(error)
        }
    }
    //拒绝好友请求
    func rejectAddFriend(_ userID: String, message: String, completion:@escaping (Error?)->()) {
        let request = NIMUserRequest()
        request.userId = userID
        request.operation = .reject
        request.message = message
        NIMSDK.shared().userManager.requestFriend(request) { (error) in
            completion(error)
        }
    }
    
    // MARK: 删除好友
    func deleteFriend(_ userID: String, completion:@escaping (Error?)->()) {
        NIMSDK.shared().userManager.deleteFriend(userID) { (error) in
            completion(error)
        }
    }
    
    //MARK: 判断是否是我的好友
    func isMyFriend(_ userId: String) -> Bool {
        return NIMSDK.shared().userManager.isMyFriend (userId)
    }
}


// MARK:- 代理
// MARK: 登录相关代理
extension XCXinChatTools: NIMLoginManagerDelegate {
    // MARK: 自动登录失败的回调
    func onAutoLoginFailed(_ error: Error) {
        
        let errorCode = (error as NSError).code
//        if errorCode == 302 {
//            // 用户名密码错误导致自动登录失败
//            trans2UserVC() // 跳转到用户界面
//            XCProgressHUD.XC_showError(withStatus: "用户名或密码错误")
//        } else if errorCode == 417 {
//            // 已有一端登录导致自动登录失败
//            trans2UserVC() // 跳转到用户界面
//            XCProgressHUD.XC_showWarning(withStatus: "您的账号已在其它设备上登录")
//        } else if errorCode == 422 {
//            XCProgressHUD.XC_showError(withStatus: "您的账号已被禁用")
//        }else {
//            // 这个情况不用关心
//            XCProgressHUD.XC_showError(withStatus: "这个情况不用关心")
//        }
        Dprint(errorCode)
    }
    
    //MARK: 被踢下线
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        if code == .byClient {
            clearCurrentUser()
            trans2UserVC() // 跳转到用户界面
            XCProgressHUD.XC_showWarning(withStatus: "您的账号已在其它设备上登录")
        }
    }
}
// MARK: 好友管理相关代理
extension XCXinChatTools: NIMUserManagerDelegate {
    // MARK: 好友添加成功的回调
    func onFriendChanged(_ user: NIMUser) {
        // 该回调在成功 添加/删除 好友后都会调用
        // 好友添加成功后，会触发回调
        // 解除成功后，会同时修改本地的缓存数据，并触发回调
//        Dprint("好友列表更新：\(String(describing: user.alias))")
        // 刷新用户/好友信息
        self.refreshFriends()
    }
    // MARK: 修改用户资料成功的回调
    func onUserInfoChanged(_ user: NIMUser) {
        Dprint("修改资料")
        // 刷新用户/好友信息
        self.refreshFriends()
    }
}

// MARK:- 一些处理
extension XCXinChatTools {
    // MARK: 存储用户信息
    func storeCurrentUser(_ account: String, _ password: String) {
        // 存储账号和密码
        UserDefaults.standard.set(account, forKey: kWechatAccount)
        UserDefaults.standard.set(password, forKey: kWechatPassword)
    }
    // MARK: 读取用户信息
    func readCurrentUser(info:@escaping (String?, String?)->Void) {
        // 取出账号和密码
        let account = UserDefaults.standard.string(forKey: kWechatAccount)
        let pwd = UserDefaults.standard.string(forKey: kWechatPassword)
        info(account, pwd)
    }
    // MARK: 清除用户信息
    func clearCurrentUser() {
        UserDefaults.standard.removeObject(forKey: kWechatAccount)
        UserDefaults.standard.removeObject(forKey: kWechatPassword)
    }
    
    // MARK: 跳转到用户界面
    func trans2UserVC() {
        MQTTHelper.destroy()
        AMapLocationHelper.shared().stopUpdatingLocation()
        AMapLocationHelper.destroy()
        let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.rootViewController = nav
    }
}

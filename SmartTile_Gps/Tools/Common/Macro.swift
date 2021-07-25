//
//  Macro.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/18.
//  Copyright © 2020 fanglin. All rights reserved.
//

import Foundation

//MARK: - 云信SDK
let NIM_AppKey = "b37412d68da4b48c4a80b8c740df4318"

// MARK:- 通知常量
// 通讯录好友发生变化
let kNoteUserInfoUpdateFriends  = "noteUserInfoUpdateFriends"
// 添加消息
let kNoteChatMsgInsertMsg    = "noteChatMsgInsertMsg"
// 更新消息状态
let kNoteChatMsgUpdateMsg = "noteChatMsgUpdateMsg"
// 重发消息状态
let kNoteChatMsgResendMsg = "noteChatMsgResendMsg"
// 添加好友请求通知
let kNoteAddFriendRequestMsg = "noteAddFriendRequestMsg"
// 点击消息中的图片
let kNoteChatMsgTapImg = "noteChatMsgTapImg"
// 点击添加好友请求消息
let kNoteChatMsgAddFriendRequest = "noteChatMsgAddFriendRequest"
// 音频播放完毕
let kNoteChatMsgAudioPlayEnd = "noteChatMsgAudioPlayEnd"
// 视频开始播放
let kNoteChatMsgVideoPlayStart = "noteChatMsgVideoPlayStart"
/* ============================== 录音按钮长按事件 ============================== */
let kNoteChatBarRecordBtnLongTapBegan = "noteChatBarRecordBtnLongTapBegan"
let kNoteChatBarRecordBtnLongTapChanged = "noteChatBarRecordBtnLongTapChanged"
let kNoteChatBarRecordBtnLongTapEnded = "noteChatBarRecordBtnLongTapEnded"
/* ============================== 与网络交互后返回 ============================== */
let kNoteWeChatGoBack = "noteWeChatGoBack"

//SOS
let kNoteCallingSOS = "noteCallingSOS"

// 导航栏背景颜色
let kNavBarBgColor = RGBCOLOR(r: 237, g: 237, b: 237, alpha: 1)
// MARK:- 常用按钮颜色
let kBtnWhite = RGBA(r: 0.97, g: 0.97, b: 0.97, a: 1.00)
let kBtnDisabledWhite = RGBA(r: 0.97, g: 0.97, b: 0.97, a: 0.30)
let kBtnGreen = RGBA(r: 0.15, g: 0.67, b: 0.16, a: 1.00)
let kBtnDisabledGreen = RGBA(r: 0.65, g: 0.87, b: 0.65, a: 1.00)
let kBtnRed = RGBA(r: 0.89, g: 0.27, b: 0.27, a: 1.00)
// 分割线颜色
let kSplitLineColor = RGBA(r: 0.78, g: 0.78, b: 0.80, a: 1.00)
// 常规背景颜色
let kCommonBgColor = RGBA(r: 0.92, g: 0.92, b: 0.92, a: 1.00)
let kSectionColor = RGBA(r: 0.94, g: 0.94, b: 0.96, a: 1.00)
// 表情键盘颜色大全
let kChatBoxColor = RGBCOLOR(r: 244.0, g: 244.0, b: 246.0, alpha: 1.0)
let kLineGrayColor = RGBCOLOR(r: 188.0, g: 188.0, b: 188.0, alpha: 0.6)

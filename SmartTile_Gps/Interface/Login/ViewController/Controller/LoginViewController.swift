//
//  LoginViewController.swift
//  Sheng
//
//  Created by FL on 2017/7/24.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
    登录界面
 */

import UIKit
import SwiftyJSON
import CoreData
import CryptoSwift
import Toast_Swift
import SnapKit

class LoginViewController: SBaseController,UIGestureRecognizerDelegate {
   
    @IBOutlet var phoneBGView: UIView!
    @IBOutlet weak var iphoneTF: UITextField!
    
    
    @IBOutlet var passwordBGView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet var shengJianIcon: UIImageView!
 
    @IBOutlet weak var bigRemView: UIView!
    @IBOutlet weak var smallRemView: UIView!
    @IBOutlet weak var rememberLabel: UILabel!
    
    @IBOutlet weak var forgetPwdBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var registerBtn: UIButton!
    
    var isRememberSelect:Bool = UserDefaults.standard.string(forKey: "isRemember") == nil ? true:FLUserDefaultsBoolGet(key: "isRemember")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        self.configInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserNameAndPwd()
    }
    
    func setUserNameAndPwd() {
        if UserDefaults.standard.string(forKey: "userName") != nil {
            iphoneTF.text = FLUserDefaultsStringGet(key: "userName")
        }
        if UserDefaults.standard.string(forKey: "userName") != nil {
            if isRememberSelect {
                passwordTF.text = FLUserDefaultsStringGet(key: "password")
            }
        }
    }
    
    //MARK: - 配置界面
    func configInterface() {
        
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat(20*IPONE_SCALE) + STATUSBAR_HEIGHT)
            make.right.equalTo(-10*IPONE_SCALE)
            make.width.equalTo(100*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
       
     
        shengJianIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(CGFloat(70*IPONE_SCALE) + STATUSBAR_HEIGHT)
            make.width.equalTo(150*IPONE_SCALE)
            make.height.equalTo(46*IPONE_SCALE)
        }
        
        
        //手机号背景
        phoneBGView.backgroundColor = HEXCOLOR(h: 0xf2f2f2, alpha: 1.0)
        phoneBGView.layer.cornerRadius = 3
        phoneBGView.snp.makeConstraints { (maker) in
            maker.top.equalTo(shengJianIcon.snp.bottom).offset(ISIPHONE5 ? 25 : 35)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(47)
        }
        //手机号输入框
        iphoneTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        iphoneTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        iphoneTF.delegate = self
        iphoneTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.centerY.equalToSuperview()
        }
        
        
        //密码背景
        passwordBGView.backgroundColor = HEXCOLOR(h: 0xf2f2f2, alpha: 1.0)
        passwordBGView.layer.cornerRadius = 3
        passwordBGView.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneBGView.snp.bottom).offset(15)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(47)
        }
        
        //密码输入框
        passwordTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        passwordTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        passwordTF.delegate = self
        passwordTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.centerY.equalToSuperview()
        }
        
        //大环 -记住密码
        bigRemView.layer.borderColor = HEXCOLOR(h: 0x37D8C4, alpha: 1.0).cgColor
        bigRemView.layer.borderWidth = 0.5
        bigRemView.layer.cornerRadius = ISIPHONE6p ? 13/2 : 11/2
        bigRemView.layer.masksToBounds = true
        bigRemView.backgroundColor = UIColor.white
        bigRemView.snp.makeConstraints { (maker) in
            maker.left.equalTo(passwordBGView)
            maker.top.equalTo(passwordBGView.snp.bottom).offset(ISIPHONE6p ? 26 : 22)
            maker.width.height.equalTo(ISIPHONE6p ? 13 : 11)
        }
        
        //小view -记住密码
        if isRememberSelect {
            smallRemView.isHidden = false
        }else {
            smallRemView.isHidden = true
        }
        smallRemView.layer.cornerRadius = ISIPHONE6p ? 7/2 : 6/2
        smallRemView.layer.masksToBounds = true
        smallRemView.backgroundColor = HEXCOLOR(h: 0x37D8C4, alpha: 1.0)
        smallRemView.snp.makeConstraints { (maker) in
            maker.center.equalTo(bigRemView)
            maker.width.height.equalTo(ISIPHONE6p ? 7 : 6)
        }
        
        //记住密码
        rememberLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 12 : 11)
        rememberLabel.textColor = HEXCOLOR(h: 0x67677a, alpha: 1.0)
        rememberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(bigRemView.snp.right).offset(ISIPHONE6p ? 7 : 5)
            maker.height.equalTo(11)
            maker.centerY.equalTo(bigRemView)
        }
        let remenberBtn = UIButton.init(type: .custom)
        remenberBtn.addTarget(self, action: #selector(rememberAction), for: .touchUpInside)
        self.view.addSubview(remenberBtn)
        remenberBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bigRemView)
            make.right.equalTo(rememberLabel.snp.right)
            make.centerY.equalTo(bigRemView)
            make.height.equalTo(20)
        }
        
        //忘记密码
        forgetPwdBtn.titleLabel?.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 12 : 11)
        forgetPwdBtn.setTitleColor(HEXCOLOR(h: 0x67677a, alpha: 1.0), for: .normal)
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.top.equalTo(passwordBGView.snp.bottom).offset(ISIPHONE6p ? 26 : 22)
            maker.height.equalTo(11)
        }
        
        //登录按钮
        loginBtn.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1.0), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        loginBtn.layer.borderWidth = 0.5
        loginBtn.layer.borderColor = Main_Color.cgColor
        loginBtn.layer.cornerRadius = 3.0
        loginBtn.layer.masksToBounds = true
        loginBtn.backgroundColor = Main_Color
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(forgetPwdBtn.snp.bottom).offset(ISIPHONE6p ? 50 : 40)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(ISIPHONE6p ? 48 : 45)
        }
    }
    
    //MARK: - 记住密码
    @objc func rememberAction() {
        isRememberSelect = !isRememberSelect
        if isRememberSelect {
            smallRemView.isHidden = false
        }else {
            smallRemView.isHidden = true
        }
        FLUserDefaultsBoolSet(key: "isRemember", obj: isRememberSelect)
    }
    
    //MARK: - 忘记密码
    @IBAction func forgetAction(_ sender: Any) {
        
    }
    
    
    //MARK: - 手机号登录
    @IBAction func LoginAction(_ sender: Any) {
        if (iphoneTF.text?.isEmpty)! {
            self.view.makeToast("Phone number is empty", duration: 1.0, position: .center)
            Dprint("手机号为空")
            return
        }else if (passwordTF.text?.isEmpty)! {
            self.view.makeToast("Password is empty", duration: 1.0, position: .center)
            Dprint("密码为空")
            return
        }
        //加载动画
        self.view.makeToastActivity(.center)
        
        let params = ["password":passwordTF.text!,"phone":iphoneTF.text!] as [String : Any]
        SURLRequest.sharedInstance.requestPostWithUrl(Login_Url, param: params, suc: { [weak self](data) in
            if let weekself = self{
                Dprint("LOGIN_URL:\(data)")
                let jsonDict = JSON(data)
                if jsonDict["result"].stringValue == "true" {  //后台登录成功
                    let content = jsonDict["data"]
                    let model = UserInfoModel.getFromModel(json: content)
                    //登录网易云信
                    XCXinChatTools.shared.login(with: "\(model.idaccount)", pwd: model.token) { (error) in
                        if (error == nil) {
                            //隐藏加载动画
                            weekself.view.hideToastActivity()
                            SMainBoardObject.shared().idAccount = model.idaccount
                            UserInfoModel.userData(content: content)
                            FLUserDefaultsStringSet(key: "pwd", obj: weekself.passwordTF.text!)
                            
                            FLUserDefaultsStringSet(key: "userName", obj: weekself.iphoneTF.text!)
                            if weekself.isRememberSelect {
                                FLUserDefaultsStringSet(key: "password", obj: weekself.passwordTF.text!)
                            }else {
                                FLUserDefaultsStringSet(key: "password", obj: "")
                            }
                            weekself.loginSucceeAction()
                        }else{
                            UserInfo.mr_findFirst()?.mr_deleteEntity()
                            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                            UIViewController.bottomToast(message: "登录失败,请尝试重试")
                            //隐藏加载动画
                            weekself.view.hideToastActivity()
                        }
                    }
                }else {
                    //隐藏加载动画
                    weekself.view.hideToastActivity()
//                    let content:JSON = jsonDict["content"]
                    let message = jsonDict["message"].stringValue
                    weekself.view.makeToast(message, duration: 1.0, position: .center)
//                    if message == "4000000" {
//                        weekself.view.makeToast("用户名为空", duration: 1.0, position: .center)
//                    }else if message == "4000001" {
//                        weekself.view.makeToast("密码为空", duration: 1.0, position: .center)
//                    }else if message == "4000002" {
//                        weekself.view.makeToast("此账号不存在", duration: 1.0, position: .center)
//                    }else if message == "4000003" {
//                        weekself.view.makeToast("密码错误", duration: 1.0, position: .center)
//                    }else if message == "4000004" {
//                        weekself.view.makeToast("您的设备或账号已被禁封", duration: 2.0, position: .center)
//                    }
                }
            }
        }) { [weak self](error) in
            if let weakSelf = self{
                //隐藏加载动画
                weakSelf.view.hideToastActivity()
                Dprint("LOGIN_URLError:\(error)")
            }
        }
    }
    
    func loginSucceeAction() {
        let tabbarVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = tabbarVC
    }

    //MARK: - 注册
    @IBAction func RegisterAction(_ sender: Any) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - self.view点击事件，结束编辑
    @objc func viewAction() {
        self.view.endEditing(true)
    }
}


extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == iphoneTF {
            passwordTF.text = ""
        }
        return true
    }
}

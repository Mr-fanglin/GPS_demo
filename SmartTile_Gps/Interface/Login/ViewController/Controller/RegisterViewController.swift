//
//  RegisterViewController.swift
//  Sheng
//
//  Created by FL on 2017/7/25.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
    注册界面
 */

import UIKit
import SwiftyJSON
import CoreData

class RegisterViewController: SBaseController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iphoneLabel: UILabel!
    @IBOutlet weak var iphoneTF: UITextField!
    
    @IBOutlet weak var oneLineLabel: UILabel!
    @IBOutlet weak var twoLineLabel: UILabel!
    @IBOutlet weak var threeLineLabel: UILabel!
    
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyTF: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        self.configInterface()
        
    }
    
    //MARK: - 配置界面
    func configInterface() {
        
        //返回按钮
        backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(STATUSBAR_HEIGHT)
            maker.width.equalTo(ISIPHONE6p ? 62 : 53)
            maker.height.equalTo(ISIPHONE6p ? 52 : 46)
        }
        
        //标题
        titleLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 17 : 15)
        titleLabel.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(ISIPHONE6p ? 16 : 14)
            maker.centerY.equalTo(backBtn)
            maker.centerX.equalTo(self.view)
        }
        
        //手机号下的分割线
        oneLineLabel.backgroundColor = HEXCOLOR(h: 0xdadada, alpha: 1.0)
        oneLineLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(ISIPHONE6p ? 184 : 160)
            maker.left.equalTo(ISIPHONE6p ? 35 : 30)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.height.equalTo(0.5)
        }
        
        //手机号
        iphoneLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        iphoneLabel.textColor = HEXCOLOR(h: 0x676779, alpha: 1.0)
        iphoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(oneLineLabel)
            maker.bottom.equalTo(oneLineLabel.snp.top).offset(ISIPHONE6p ? -11 : -10)
            maker.height.equalTo(ISIPHONE6p ? 14 : 12)
        }
        
        //手机号输入框
        iphoneTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        iphoneTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        iphoneTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(ISIPHONE6p ? 115 : 100)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.centerY.equalTo(iphoneLabel)
        }
        
        //验证码下的分割线
        twoLineLabel.backgroundColor = HEXCOLOR(h: 0xdadada, alpha: 1.0)
        twoLineLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(oneLineLabel.snp.bottom).offset(ISIPHONE6p ? 89 : 77)
            maker.left.equalTo(ISIPHONE6p ? 35 : 30)
            maker.right.equalTo(ISIPHONE6p ? -167 : -145)
            maker.height.equalTo(0.5)
        }
        
        //验证码Label
        verifyLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        verifyLabel.textColor = HEXCOLOR(h: 0x676779, alpha: 1.0)
        verifyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(twoLineLabel)
            maker.bottom.equalTo(twoLineLabel.snp.top).offset(ISIPHONE6p ? -11 : -10)
            maker.height.equalTo(ISIPHONE6p ? 14 : 12)
        }
        
        //验证码输入框
        verifyTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        verifyTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        verifyTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(ISIPHONE6p ? 115 : 100)
            maker.right.equalTo(ISIPHONE6p ? -167 : -145)
            maker.centerY.equalTo(verifyLabel)
        }
       
        //密码设置下的分割线
        threeLineLabel.backgroundColor = HEXCOLOR(h: 0xdadada, alpha: 1.0)
        threeLineLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(twoLineLabel.snp.bottom).offset(ISIPHONE6p ? 89 : 77)
            maker.left.equalTo(ISIPHONE6p ? 35 : 30)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.height.equalTo(0.5)
        }
        
        //密码设置
        passwordLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        passwordLabel.textColor = HEXCOLOR(h: 0x676779, alpha: 1.0)
        passwordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(threeLineLabel)
            maker.bottom.equalTo(threeLineLabel.snp.top).offset(ISIPHONE6p ? -11 : -10)
            maker.height.equalTo(ISIPHONE6p ? 14 : 12)
        }
        
        //密码设置输入框
        passwordTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        passwordTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        passwordTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(ISIPHONE6p ? 115 : 100)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.centerY.equalTo(passwordLabel)
        }
        
        //下一步按钮
        nextBtn.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1.0), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        nextBtn.layer.borderWidth = 0.5
        nextBtn.layer.borderColor = Main_Color.cgColor
        nextBtn.layer.cornerRadius = 3.0
        nextBtn.layer.masksToBounds = true
        nextBtn.backgroundColor = Main_Color
        nextBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(threeLineLabel.snp.bottom).offset(40*IPONE_SCALE)
            maker.width.equalTo(ISIPHONE6p ? 269 : 234)
            maker.height.equalTo(ISIPHONE6p ? 45 : 40)
            maker.centerX.equalTo(self.view)
        }
    }
    
    //MARK: - self.view点击事件，结束编辑
    @objc func viewAction() {
        self.view.endEditing(true)
    }
    
    
    //MARK: - 返回按钮
    @IBAction func backAction(_ sender: Any) {
        
        self.navBackAction()
    }
    
    //MARK: - 下一步按钮
    @IBAction func nextAction(_ sender: Any) {
        if (iphoneTF.text?.isEmpty)! {
            self.view.makeToast("Phone number is empty", duration: 1.0, position: .center)
            Dprint("手机号为空")
            return
        }else if (verifyTF.text?.isEmpty)! {
            self.view.makeToast("Account is empty", duration: 1.0, position: .center)
            Dprint("账号为空")
            return
        }else if (passwordTF.text?.isEmpty)! {
            self.view.makeToast("Password is empty", duration: 1.0, position: .center)
            Dprint("密码为空")
            return
        }
        
        //加载动画
        self.view.makeToastActivity(.center)
        
        let mobile = self.iphoneTF.text!
        let pwd = passwordTF.text!
        let nickname = self.verifyTF.text!
        let params = ["code":"123456","nickname":nickname,"password":pwd,"phone":mobile] as [String: Any]
        SURLRequest.sharedInstance.requestPostWithUrl(Register_Url, param: params, suc: { [weak self](data) in
            if let weekself = self{
                //隐藏加载动画
                weekself.view.hideToastActivity()
                let jsonDict = JSON(data)
                Dprint("REGISTER_URL:\(jsonDict)")
                if jsonDict["result"].stringValue == "true" {
                    weekself.view.makeToast("注册成功", duration: 1.0, position: .center)
                    weekself.navigationController?.popViewController(animated: true)
                }else{
                    let content:JSON = jsonDict["content"]
                    let message = content["message"].stringValue
                    if message == "4000000" {
                        weekself.view.makeToast("用户名为空", duration: 1.0, position: .center)
                    }else if message == "4000001" {
                        weekself.view.makeToast("密码为空", duration: 1.0, position: .center)
                    }else if message == "4000004" {
                        weekself.view.makeToast("您的设备或账号已被禁封", duration: 1.0, position: .center)
                    }else if message == "4000120" {
                        weekself.view.makeToast("手机号已注册", duration: 1.0, position: .center)
                    }else if message == "4000122" {
                        weekself.view.makeToast("验证码错误", duration: 1.0, position: .center)
                    }else if message == "4000123" {
                        weekself.view.makeToast("当前设备可注册的账号数已达上限，如有疑问请咨询QQ：755583740", duration: 1.0, position: .center)
                    }
                }
            }
        }) { [weak self](error) in
            if let weakself = self{
               //隐藏加载动画
               weakself.view.hideToastActivity()
               //self.view.makeToast("请求出错", duration: 1.0, position: .center)
               Dprint("REGISTER_URLError:\(error)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        Dprint("dealloc")
    }
}

extension RegisterViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

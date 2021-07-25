//
//  SettingAliasController.swift
//  XinChat
//
//  Created by FangLin on 2019/11/19.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

fileprivate let SettingAliasTitleCellID = "SettingAliasTitleCellID"
fileprivate let SettingAliasInputCellID = "SettingAliasInputCellID"

///设置备注控制器
class SettingAliasController: UIViewController {
    
    var userInfo: XCContactCellModel?
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        tbView.backgroundColor = .clear
        tbView.delegate = self
        tbView.dataSource = self
        tbView.separatorStyle = .none
        tbView.register(SettingAliasTitleCell.classForCoder(), forCellReuseIdentifier: SettingAliasTitleCellID)
        tbView.register(SettingAliasInputCell.classForCoder(), forCellReuseIdentifier: SettingAliasInputCellID)
        return tbView
    }()
    
    let saveBtn = UIButton.init(type: .custom)
    
    init(userInfo: XCContactCellModel?) {
        super.init(nibName: nil, bundle: nil)
        self.userInfo = userInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveBtn.isEnabled = false
    }
    
    fileprivate func setInterface() {
        self.view.backgroundColor = kNavBarBgColor
        
        let navbarBgV = UIView.init()
        navbarBgV.backgroundColor = .clear
        self.view.addSubview(navbarBgV)
        navbarBgV.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(NEWNAVHEIGHT)
        }
        
        let titleL = UILabel.init()
        titleL.text = NSLocalizedString("Set_notes", comment: "")
        titleL.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        navbarBgV.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(NavbarHeight)
            make.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        backBtn.setTitleColor(HEXCOLOR(h: 0x666666, alpha: 1), for: .normal)
        backBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        backBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        navbarBgV.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_HEIGHT)
            make.left.equalTo(15*IPONE_SCALE)
            make.width.equalTo(50*IPONE_SCALE)
            make.height.equalTo(NavbarHeight)
        }
        
        saveBtn.setTitle(NSLocalizedString("Finish", comment: ""), for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        saveBtn.backgroundColor = HEXCOLOR(h: 0x07C160, alpha: 1)
        saveBtn.layer.cornerRadius = 5
        saveBtn.layer.masksToBounds = true
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.isEnabled = false
        navbarBgV.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15*IPONE_SCALE)
            make.centerY.equalTo(backBtn)
            make.width.equalTo(60*IPONE_SCALE)
            make.height.equalTo(35*IPONE_SCALE)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
        }
    }
}

extension SettingAliasController {
    @objc func saveBtnClick(sender:UIButton) {
        let user = XCXinChatTools.shared.getFriendInfo(userId: userInfo?.userId ?? "")
        let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? SettingAliasInputCell
        guard let inputStr = cell?.inputTF.text else {
            return
        }
        guard let userInfo = user else {
            return
        }
//        XCXinChatTools.shared.updateUserInfo(userInfo, inputStr) { (error) in
//            Dprint("error:\(error)")
//        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func cancelBtnClick(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingAliasController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingAliasTitleCellID) as? SettingAliasTitleCell
            cell?.titleLabel.text = NSLocalizedString("Remark_name", comment: "")
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingAliasInputCellID) as? SettingAliasInputCell
            cell?.inputTF.placeholder = NSLocalizedString("Set_notes", comment: "")
            cell?.inputTF.text = userInfo?.title
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(35*IPONE_SCALE)
        }else {
            return CGFloat(50*IPONE_SCALE)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension SettingAliasController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.saveBtn.isEnabled = true
        return true
    }
}

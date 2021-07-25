//
//  MineController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/17.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class MineController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- 懒加载
    // MARK: 功能
    lazy var funcArr: [XCContactCellModel] = {
        return XCUIDataHelper.getMineVCData()
    }()
    
    var topView:MineTopView = MineTopView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(290*IPONE_SCALE)+STATUSBAR_HEIGHT))
    var bottomView:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(270*IPONE_SCALE)-STATUSBAR_HEIGHT))
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init(frame: .zero)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setInterface()
    }
    
    func setInterface() {
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(CGFloat(290*IPONE_SCALE)+STATUSBAR_HEIGHT)
        }
        
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = .white
        bottomView.setUpShadowView(shadowColor: HEXCOLOR(h: 0x7E97A8, alpha: 1), size: CGSize.init(width: 0, height: 5), opacity: 1, radius: 10)
        bottomView.layer.cornerRadius = CGFloat(18*IPONE_SCALE)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(-20*IPONE_SCALE)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 添加tableView
        bottomView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(10*IPONE_SCALE)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 注册cellID
        tableView.register(MineCell.self, forCellReuseIdentifier: "MineCell")
        
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funcArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell") as? MineCell
        let model = funcArr[indexPath.row]
        cell?.model = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 { //退出登录
            let alertVC = UIAlertController.initAlertView(message: NSLocalizedString("Confirm_Logout", comment: ""), sureTitle: NSLocalizedString("Determine", comment: ""), sureAction: { (alert) in
                XCXinChatTools.shared.loginOut()
            }, cancleTitle: NSLocalizedString("Cancel", comment: "")) { (cancel) in
                
            }
            self.present(alertVC, animated: true, completion: nil)
        }else if indexPath.row == 1 {
            let qrCodeVC = MyQRCodeController.init()
            self.navigationController?.pushViewController(qrCodeVC, animated: true)
        }else if indexPath.row == 0 {
            let deviceListVC = DeviceListController()
            self.navigationController?.pushViewController(deviceListVC, animated: true)
        }else if indexPath.row == 3 {
            let settingVC = SettingController()
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50*IPONE_SCALE)
    }
}

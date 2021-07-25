//
//  QRScanController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/10/14.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit


class QRScanController: SBaseController {
    
    var scanView:LFQRCodeScanner = LFQRCodeScanner.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: "scan", leftImage: nil, rightStr: nil, ringhtAction: nil)
        self.setInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scanView.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanView.stop()
    }
    
    func setInterface() {
        //扫描有效区（即框内透明区域）
        let interestRect = CGRect.init(x: 50, y: (self.view.frame.size.height - (self.view.frame.size.width - 100))/2.0, width: self.view.frame.size.width - 100, height: self.view.frame.size.width - 100)
        
        //扫描控件
        scanView = LFQRCodeScanner.init(frame: self.view.bounds, rectOfInterest: interestRect)
        scanView.imgLine.image = UIImage.init(named: "line")
        scanView.scanFilishBlock = { (result) in
            guard let resultStr = result?.stringValue else {
                return
            }
            if resultStr.contains("user:") {
                var userInfoVC:UserInfoController!
                if XCXinChatTools.shared.isMyFriend(resultStr.replacingOccurrences(of: "user:", with: "")) {
                    userInfoVC = UserInfoController.init(funcType: .SendMessage)
                }else {
                    userInfoVC = UserInfoController.init(funcType: .AddBook)
                }
                userInfoVC.userId = resultStr.replacingOccurrences(of: "user:", with: "")
                self.navigationController?.pushViewController(userInfoVC, animated: true)
            }else if resultStr.contains("device:") {
                let bindVC = BindSeviceController()
                bindVC.deviceId = resultStr.replacingOccurrences(of: "device:", with: "")
                self.navigationController?.pushViewController(bindVC, animated: true)
            }
        }
        self.view.insertSubview(scanView, at: 0)
    }

}

//
//  MyQRCodeController.swift
//  SmartTile_Gps
//
//  Created by FangLin on 2020/9/29.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class MyQRCodeController: SBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: "My QR Code", leftImage: nil, rightStr: nil, ringhtAction: nil)
        self.setInterface()
    }
    
    func setInterface() {
        let imageV = UIImageView.init()
        self.view.addSubview(imageV)
        imageV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(SCREEN_WIDTH/2)
        }
        guard let userId = UserInfo.mr_findFirst()?.idaccount else {
            return
        }
        let imageCode = LFQRCodeUtil.createQRimageString("user:\(userId)", sizeWidth: SCREEN_WIDTH/2, fill: .black, logo: UIImage.init(named: ""))
        imageV.image = imageCode
    }

}

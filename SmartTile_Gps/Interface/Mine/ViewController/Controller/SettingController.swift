//
//  SettingController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2021/3/12.
//  Copyright © 2021 fanglin. All rights reserved.
//

import UIKit

class SettingController: SBaseController {
    
    var slider:UISlider = UISlider.init()
    var numLabel:UILabel = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: NSLocalizedString("Setting", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
        self.setInterface()
    }
    
    func setInterface() {
        let titleLabel = UILabel.init()
        titleLabel.text = NSLocalizedString("Time_interval", comment: "")
        titleLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(18*IPONE_SCALE))
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+20)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(18*IPONE_SCALE)
        }
        
        self.view.addSubview(slider)
        slider.minimumValue = 0
        slider.maximumValue = 120
        slider.value = 15
        slider.setValue(15, animated: true)
        slider.addTarget(self, action: #selector(sliderDidChange(_:)), for: .valueChanged)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(50*IPONE_SCALE)
            make.top.equalTo(titleLabel.snp.bottom).offset(20*IPONE_SCALE)
        }
        
        numLabel.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        numLabel.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        numLabel.text = "15s"
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-40*IPONE_SCALE)
            make.top.equalTo(slider.snp.bottom).offset(20*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
        }
    }

    @objc func sliderDidChange(_ slider:UISlider) {
        let disCreatValue = roundf(slider.value)
        numLabel.text = String.init(format: "%.fs", disCreatValue)
    }
}

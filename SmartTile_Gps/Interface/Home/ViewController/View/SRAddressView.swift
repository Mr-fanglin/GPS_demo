//
//  SRAddressView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/1.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class SRAddressView: UIView {
    
    var startAddressStr:String = "" {
        didSet{
            startTF.text = startAddressStr
        }
    }
    
    var stopAddressStr:String = "" {
        didSet{
            stopTF.text = stopAddressStr
            twoLineV.isHidden = false
            cancelBtn.isHidden = false
            confirmBtn.isHidden = false
            stopClickBtn.isEnabled = false
        }
    }

    var startImg:UIImageView = UIImageView.init()
    var stopImg:UIImageView = UIImageView.init()
    var startTF:UITextField = UITextField.init()
    var stopTF:UITextField = UITextField.init()
    var lineV:UIView = UIView.init()
    
    let stopClickBtn = UIButton.init(type: .custom)
    
    var twoLineV = UIView.init()
    var cancelBtn = UIButton.init(type: .custom)
    var confirmBtn = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setUp()
    }
    
    var stopLabelActionBlock:(()->())?
    @objc func stopTapAction() {
        if let block = stopLabelActionBlock {
            block()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        startImg.image = UIImage.init(named: "home_journey_ic_start")
        self.addSubview(startImg)
        startImg.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.top.equalTo(15*IPONE_SCALE)
            make.width.height.equalTo(32*IPONE_SCALE)
        }
        
        startTF.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        startTF.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        startTF.placeholder = "起点位置"
        startTF.isEnabled = false
        self.addSubview(startTF)
        startTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(startImg)
            make.left.equalTo(startImg.snp.right).offset(15*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(startImg.snp.right)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(1)
            make.top.equalTo(62*IPONE_SCALE)
        }
        
        stopImg.image = UIImage.init(named: "home_journey_ic_end")
        self.addSubview(stopImg)
        stopImg.snp.makeConstraints { (make) in
            make.left.equalTo(startImg)
            make.top.equalTo(lineV.snp.bottom).offset(15*IPONE_SCALE)
            make.width.height.equalTo(32*IPONE_SCALE)
        }
        
        stopTF.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        stopTF.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        stopTF.placeholder = "送达位置"
        stopTF.isEnabled = false
        self.addSubview(stopTF)
        stopTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopImg)
            make.left.equalTo(stopImg.snp.right).offset(15*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        
        stopClickBtn.backgroundColor = .clear
        stopClickBtn.addTarget(self, action: #selector(stopTapAction), for: .touchUpInside)
        self.addSubview(stopClickBtn)
        stopClickBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineV.snp.bottom)
            make.left.equalTo(stopImg.snp.right).offset(15*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(50*IPONE_SCALE)
        }
        
        twoLineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        twoLineV.isHidden = true
        self.addSubview(twoLineV)
        twoLineV.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(124*IPONE_SCALE)
        }
        
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(HEXCOLOR(h: 0x666666, alpha: 1), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        cancelBtn.isHidden = true
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(twoLineV.snp.bottom)
            make.height.equalTo(50*IPONE_SCALE)
            make.right.equalTo(self.snp.centerX)
        }
        
        confirmBtn.setTitle("发出请求", for: .normal)
        confirmBtn.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1), for: .normal)
        confirmBtn.backgroundColor = Main_Color
        confirmBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        confirmBtn.isHidden = true
        self.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX)
            make.top.equalTo(twoLineV.snp.bottom)
            make.height.equalTo(50*IPONE_SCALE)
            make.right.equalToSuperview()
        }
    }
    
    var cancelBtnActionBlock:(()->())?
    @objc func cancelBtnAction() {
        twoLineV.isHidden = true
        cancelBtn.isHidden = true
        confirmBtn.isHidden = true
        stopClickBtn.isEnabled = true
        if let block = cancelBtnActionBlock {
            block()
        }
    }
    
    var confirmBtnActionBlock:(()->())?
    @objc func confirmBtnAction() {
        if let block = confirmBtnActionBlock {
            block()
        }
    }
}

//
//  HomeOrderView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/16.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class HomeOrderView: UIView {
    
    var model:OrderModel = OrderModel() {
        didSet{
            if model.orderStatus == 1 {
                detailLabel.text = String.init(format: NSLocalizedString("Home_hasOrdrMessage", comment: ""), model.guardianName)
                lookDetailButton.isHidden = false
                bgView.isUserInteractionEnabled = true
            }else if model.orderStatus == 2 {
                detailLabel.text = NSLocalizedString("Home_NoOrderMessage", comment: "")
                lookDetailButton.isHidden = false
                bgView.isUserInteractionEnabled = true
            }else if model.orderStatus == 6 {
                detailLabel.text = NSLocalizedString("Home_NoOrderMessage", comment: "")
                lookDetailButton.isHidden = true
                bgView.isUserInteractionEnabled = false
            }else if model.orderStatus == 8 {
                detailLabel.text = NSLocalizedString("Home_NoOrderMessage", comment: "")
                lookDetailButton.isHidden = true
                bgView.isUserInteractionEnabled = false
            }
        }
    }
    
    lazy var headImg:UIImageView = {
        let headImgV = UIImageView.init(frame: .zero)
        headImgV.image = UIImage.init(named: "MoreMyBankCard")
        return headImgV
    }()
    
    lazy var bgView:UIView = {
        let bgV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(45*IPONE_SCALE), height: CGFloat(50*IPONE_SCALE)))
        bgV.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 0.4)
        bgV.layer.cornerRadius = 8
        bgV.layer.masksToBounds = true
        return bgV
    }()
    
    lazy var detailLabel:UILabel = {
        let detailL = UILabel.init(frame: .zero)
        detailL.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        detailL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        detailL.text = NSLocalizedString("Home_NoOrderMessage", comment: "")
        return detailL
    }()
    
    lazy var lookDetailButton:UIButton = {
        let lookDetailBtn = UIButton.init(type: .custom)
        lookDetailBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        lookDetailBtn.setTitleColor(Main_Color, for: .normal)
        lookDetailBtn.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 0.6)
        lookDetailBtn.setTitle(NSLocalizedString("Home_Detail", comment: ""), for: .normal)
        lookDetailBtn.isHidden = true
        return lookDetailBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.backgroundColor = .clear
        self.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25*IPONE_SCALE)
        }
        
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(headImg.snp.right).offset(5*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH-CGFloat(45*IPONE_SCALE))
            make.height.equalTo(50*IPONE_SCALE)
        }
        
        bgView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(17*IPONE_SCALE)
            make.right.equalTo(-80*IPONE_SCALE)
        }
        
        lookDetailButton.layer.cornerRadius = 5
        lookDetailButton.layer.masksToBounds = true
        lookDetailButton.addTarget(self, action: #selector(bgVTapClick), for: .touchUpInside)
        lookDetailButton.setTitleColor(UIColor.red, for: .normal)
        bgView.addSubview(lookDetailButton)
        lookDetailButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(50*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        let bgVTap = UITapGestureRecognizer.init(target: self, action: #selector(bgVTapClick))
        bgView.isUserInteractionEnabled = false
        bgView.addGestureRecognizer(bgVTap)
        
    }
    
    @objc func bgVTapClick() {
        let orderVC = DriverOrderController.init()
        orderVC.model = model
        UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(orderVC, animated: true)
    }
}

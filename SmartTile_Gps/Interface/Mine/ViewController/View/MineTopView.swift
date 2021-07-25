//
//  MineTopView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class MineTopView: UIView {

    lazy var bgImg:UIImageView = {
        let bgImageV = UIImageView.init(frame: .zero)
        bgImageV.image = UIImage.init(named: "boot page_bg")
        return bgImageV
    }()
    
    lazy var nameLabel:UILabel = {
        let nameL = UILabel.init(frame: .zero)
        nameL.font = UIFont.boldSystemFont(ofSize: CGFloat(21*IPONE_SCALE))
        nameL.textColor = HEXCOLOR(h: 0x000000, alpha: 1)
        return nameL
    }()
    
    lazy var sexImgV:UIImageView = {
        let sexImg = UIImageView.init(frame: .zero)
        return sexImg
    }()
    
    lazy var headImg:UIImageView = {
        let head = UIImageView.init(frame: .zero)
        head.image = UIImage.init(named: "DefaultProfileHead_phone")
        head.layer.cornerRadius = 5
        head.layer.masksToBounds = true
        return head
    }()
    
    lazy var integralImg:UIImageView = {
        let integralImgV = UIImageView.init(frame: .zero)
        integralImgV.image = UIImage.init(named: "contacts_credit_score")
        return integralImgV
    }()
    lazy var integralLabel:UILabel = {
        let integralL = UILabel.init(frame: .zero)
        integralL.text = "Credit score：9966"
        integralL.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        integralL.textColor = HEXCOLOR(h: 0xF37374, alpha: 1)
        return integralL
    }()
    lazy var gradeImg:UIImageView = {
        let gradeImgV = UIImageView.init(frame: .zero)
        gradeImgV.image = UIImage.init(named: "contacts_credit_scorecontacts_credit_ranking")
        return gradeImgV
    }()
    lazy var gradeLabel:UILabel = {
        let gradeL = UILabel.init(frame: .zero)
        gradeL.text = "Top 10"
        gradeL.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        gradeL.textColor = HEXCOLOR(h: 0xF37374, alpha: 1)
        return gradeL
    }()
    lazy var askNumL:UILabel = {
        let askNumLabel = UILabel.init(frame: .zero)
        askNumLabel.text = "0"
        askNumLabel.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        askNumLabel.textColor = HEXCOLOR(h: 0x3a3a3a, alpha: 1)
        return askNumLabel
    }()
    lazy var askLabel:UILabel = {
        let askL = UILabel.init(frame: .zero)
        askL.text = "Ask for help"
        askL.font = UIFont.systemFont(ofSize: CGFloat(11*IPONE_SCALE))
        askL.textColor = HEXCOLOR(h: 0xB3B3B3, alpha: 1)
        return askL
    }()
    lazy var getNumL:UILabel = {
        let getNumLabel = UILabel.init(frame: .zero)
        getNumLabel.text = "0"
        getNumLabel.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        getNumLabel.textColor = HEXCOLOR(h: 0x3a3a3a, alpha: 1)
        return getNumLabel
    }()
    lazy var getLabel:UILabel = {
        let getL = UILabel.init(frame: .zero)
        getL.text = "Get help"
        getL.font = UIFont.systemFont(ofSize: CGFloat(11*IPONE_SCALE))
        getL.textColor = HEXCOLOR(h: 0xB3B3B3, alpha: 1)
        return getL
    }()
    lazy var likeNumL:UILabel = {
        let likeNumLabel = UILabel.init(frame: .zero)
        likeNumLabel.text = "0"
        likeNumLabel.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        likeNumLabel.textColor = HEXCOLOR(h: 0x3a3a3a, alpha: 1)
        return likeNumLabel
    }()
    lazy var likeLabel:UILabel = {
        let likeL = UILabel.init(frame: .zero)
        likeL.text = "My likes"
        likeL.font = UIFont.systemFont(ofSize: CGFloat(11*IPONE_SCALE))
        likeL.textColor = HEXCOLOR(h: 0xB3B3B3, alpha: 1)
        return likeL
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HEXCOLOR(h: 0xFAFAFA, alpha: 1)
        self.setUp()
        self.setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData() {
        if let userInfo = UserInfo.mr_findFirst() {
            nameLabel.text = userInfo.name
            if userInfo.sex == 0 {
                sexImgV.image = UIImage.init(named: "contacts_gender_boy")
            }else {
                sexImgV.image = UIImage.init(named: "contacts_gender_girl")
            }
        }
    }
    
    func setUp() {
        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(28*IPONE_SCALE)
            make.top.equalTo(CGFloat(58*IPONE_SCALE) + STATUSBAR_HEIGHT)
            make.height.equalTo(21*IPONE_SCALE)
        }
        
        self.addSubview(sexImgV)
        sexImgV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(15*IPONE_SCALE)
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(15*IPONE_SCALE)
        }
        self.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.right.equalTo(-26*IPONE_SCALE)
            make.top.equalTo(CGFloat(59*IPONE_SCALE)+STATUSBAR_HEIGHT)
            make.width.height.equalTo(57*IPONE_SCALE)
        }
        self.addSubview(integralImg)
        integralImg.snp.makeConstraints { (make) in
            make.left.equalTo(27*IPONE_SCALE)
            make.top.equalTo(nameLabel.snp.bottom).offset(17*IPONE_SCALE)
            make.width.equalTo(19*IPONE_SCALE)
            make.height.equalTo(19*IPONE_SCALE)
        }
        self.addSubview(integralLabel)
        integralLabel.snp.makeConstraints { (make) in
            make.left.equalTo(integralImg.snp.right).offset(8*IPONE_SCALE)
            make.centerY.equalTo(integralImg)
            make.height.equalTo(11*IPONE_SCALE)
        }
        self.addSubview(gradeImg)
        gradeImg.snp.makeConstraints { (make) in
            make.left.equalTo(27*IPONE_SCALE)
            make.top.equalTo(integralImg.snp.bottom).offset(10*IPONE_SCALE)
            make.width.equalTo(19*IPONE_SCALE)
            make.height.equalTo(19*IPONE_SCALE)
        }
        self.addSubview(gradeLabel)
        gradeLabel.layer.cornerRadius = CGFloat(15*IPONE_SCALE)/2
        gradeLabel.layer.masksToBounds = true
        gradeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gradeImg.snp.right).offset(7*IPONE_SCALE)
            make.centerY.equalTo(gradeImg)
            make.width.equalTo(52*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        self.addSubview(askNumL)
        askNumL.snp.makeConstraints { (make) in
            make.left.equalTo(48*IPONE_SCALE)
            make.top.equalTo(gradeLabel.snp.bottom).offset(50*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        self.addSubview(askLabel)
        askLabel.snp.makeConstraints { (make) in
            make.left.equalTo(askNumL)
            make.top.equalTo(askNumL.snp.bottom).offset(12*IPONE_SCALE)
            make.height.equalTo(11*IPONE_SCALE)
        }
        self.addSubview(getNumL)
        getNumL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(askNumL)
            make.height.equalTo(15*IPONE_SCALE)
        }
        self.addSubview(getLabel)
        getLabel.snp.makeConstraints { (make) in
            make.left.equalTo(getNumL)
            make.top.equalTo(getNumL.snp.bottom).offset(12*IPONE_SCALE)
            make.height.equalTo(11*IPONE_SCALE)
        }
        self.addSubview(likeNumL)
        likeNumL.snp.makeConstraints { (make) in
            make.right.equalTo(-48*IPONE_SCALE)
            make.centerY.equalTo(askNumL)
            make.height.equalTo(15*IPONE_SCALE)
        }
        self.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeNumL)
            make.top.equalTo(likeNumL.snp.bottom).offset(12*IPONE_SCALE)
            make.height.equalTo(11*IPONE_SCALE)
        }
    }
    
    
}

//
//  GsensorValueView.swift
//  SmartTile_Gps
//
//  Created by FangLin on 2021/6/6.
//  Copyright © 2021 fanglin. All rights reserved.
//

import UIKit
import SnapKit

class GsensorValueView: UIView {
    
    var g1Value:Float = 0.0 {
        didSet{
            g1MaxLabel.text = String.init(format: "G1:%.2f", g1Value)
            if (g1Value<=3.0) {
                g1MaxLabel.textColor = UIColor.green;
            }else if (g1Value>3 && g1Value<=5) {
                g1MaxLabel.textColor = UIColor.yellow;
            }else if (g1Value>5) {
                g1MaxLabel.textColor = UIColor.red;
            }
        }
    }
    
    var g2Value:Float = 0.0 {
        didSet{
            g2Label.text = String.init(format: "G2:%.2f", g2Value)
            if (g2Value<=3.0) {
                g2Label.textColor = UIColor.green;
            }else if (g2Value>3 && g2Value<=5) {
                g2Label.textColor = UIColor.yellow;
            }else if (g2Value>5) {
                g2Label.textColor = UIColor.red;
            }
        }
    }
    
    
    var g1MaxLabel:UILabel = UILabel.init()
    var g2Label:UILabel = UILabel.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        g1MaxLabel.textColor = UIColor.green
        g1MaxLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        g1MaxLabel.text = "G1:0.0"
        self.addSubview(g1MaxLabel)
        g1MaxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5*IPONE_SCALE)
            make.top.equalTo(5*IPONE_SCALE)
            make.height.equalTo(16*IPONE_SCALE)
        }
        
        g2Label.textColor = UIColor.green
        g2Label.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        g2Label.text = "G2:0.0"
        self.addSubview(g2Label)
        g2Label.snp.makeConstraints { (make) in
            make.left.equalTo(5*IPONE_SCALE)
            make.top.equalTo(g1MaxLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(16*IPONE_SCALE)
        }
    }

}

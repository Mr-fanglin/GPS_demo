//
//  OrderStatusCell.swift
//  SmartTile_Gps
//
//  Created by FangLin on 2020/9/29.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {
    
    var progressModel:OrderProgressModel = OrderProgressModel() {
        didSet{
            if progressModel.myChild {
                if progressModel.orderStatus == 1 {
                    detailLabel.text = "Pick up request"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Sent"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 3 {
                    detailLabel.text = "Agree to pick up"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Agreed"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 4 {
                    detailLabel.text = "Driver is on the way"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Coming"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 5 {
                    detailLabel.text = "Picking the child"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Picked"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 6 {
                    detailLabel.text = "Arrived at destination"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Arrived"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 8 {
                    detailLabel.text = "Order finish"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "finish"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 20 {
                    detailLabel.text = "Waiting the driver come"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "waiting"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 30 {
                    detailLabel.text = "Waiting the driver picked"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "waiting"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 40 {
                    detailLabel.text = "Waiting arrive at destination"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "waiting"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 50 {
                    detailLabel.text = "Order finish"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "Success"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }
            }else {
                if progressModel.orderStatus == 1 {
                    detailLabel.text = "Call the driver"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Sent"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 3 {
                    detailLabel.text = "You get the order"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Agreed"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 4 {
                    detailLabel.text = "Go to the child"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Started"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 5 {
                    detailLabel.text = "Sure get the child"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Got"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 6 {
                    detailLabel.text = "Sure arrive at destination"
                    detailLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    timeLabel.text = progressModel.createDate
                    statusLabel.text = "Arrived"
                    statusLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 7 {
                    detailLabel.text = "Order finish"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "finish"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }else if progressModel.orderStatus == 20 {
                    detailLabel.text = "Go to the child"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = ""
                    operatBtn.isHidden = false
                    operatBtn.setTitle("Start", for: .normal)
                    operatBtn.tag = 200
                }else if progressModel.orderStatus == 30 {
                    detailLabel.text = "Sure get the child"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = ""
                    operatBtn.isHidden = false
                    operatBtn.setTitle("Sure", for: .normal)
                    operatBtn.tag = 201
                }else if progressModel.orderStatus == 40 {
                    detailLabel.text = "Sure arrive at destination"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = ""
                    operatBtn.isHidden = false
                    operatBtn.setTitle("Sure", for: .normal)
                    operatBtn.tag = 202
                }else if progressModel.orderStatus == 50 {
                    detailLabel.text = "Order finish"
                    detailLabel.textColor = Main_Color
                    timeLabel.text = ""
                    statusLabel.text = "Success"
                    statusLabel.textColor = Main_Color
                    operatBtn.isHidden = true
                }
            }
            
            
        }
    }

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var operatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        detailLabel.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.top.equalTo(5*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        timeLabel.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.top.equalTo(detailLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(13*IPONE_SCALE)
        }
        
        statusLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-30*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        operatBtn.isHidden = true
        operatBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        operatBtn.layer.cornerRadius = CGFloat(15*IPONE_SCALE)
        operatBtn.layer.masksToBounds = true
        operatBtn.addTarget(self, action: #selector(operatBtnAction(sender:)), for: .touchUpInside)
        operatBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-30*IPONE_SCALE)
            make.width.equalTo(70*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
    }
    
    var operatBtnActionBlock:((_ tag:Int)->())?
    @objc func operatBtnAction(sender:UIButton) {
        if let block = operatBtnActionBlock {
            block(sender.tag)
        }
    }
}

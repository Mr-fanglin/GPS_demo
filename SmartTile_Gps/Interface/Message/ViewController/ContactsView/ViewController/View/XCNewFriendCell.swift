//
//  XCNewFriendCell.swift
//  XinChat
//
//  Created by FangLin on 2019/12/4.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCNewFriendCell: UITableViewCell {
    
    var model:XCNewFriendMsgModel = XCNewFriendMsgModel() {
        didSet {
            avatarView.image = UIImage.init(named: model.avatarPath ?? "DefaultProfileHead_phone")
            nicknameLabel.text = model.title
            subMsgLabel.text = model.subTitle
            if model.isAdd {
                operateBtn.setTitle("已添加", for: .normal)
                operateBtn.setTitleColor(HEXCOLOR(h: 0x666666, alpha: 1), for: .normal)
            }else {
                operateBtn.setTitle("等待验证", for: .normal)
                operateBtn.setTitleColor(Main_Color, for: .normal)
            }
        }
    }

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var subMsgLabel: UILabel!
    @IBOutlet weak var operateBtn: UIButton!
    @IBOutlet weak var lineV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setUp()
    }
    
    fileprivate func setUp() {
        avatarView.layer.cornerRadius = 5
        avatarView.layer.masksToBounds = true
        avatarView.snp.makeConstraints { (make) in
            make.left.equalTo(18*IPONE_SCALE)
            make.width.height.equalTo(40*IPONE_SCALE)
            make.centerY.equalToSuperview()
        }
        
        operateBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        operateBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-25*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(16*IPONE_SCALE)
            make.width.equalTo(80*IPONE_SCALE)
        }
        
        nicknameLabel.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12*IPONE_SCALE)
            make.top.equalTo(avatarView.snp.top).offset(2*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.right.equalTo(operateBtn.snp.left).offset(-10*IPONE_SCALE)
        }
        
        subMsgLabel.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        subMsgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameLabel.snp.left)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
            make.right.equalTo(operateBtn.snp.left).offset(-10*IPONE_SCALE)
        }
        
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.left)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

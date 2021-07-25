//
//  XCContactCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/11.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import SDWebImage
import BadgeSwift

class XCContactCell: UITableViewCell {
    
    // MARK:- 属性
    // MARK: 模型
    var model: XCContactCellModel? {
        didSet {
            nicknameL.text = model?.title ?? ""
            avatarView.image = UIImage.init(named: model?.image ?? "DefaultProfileHead_phone")
        }
    }

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nicknameL: UILabel!
    @IBOutlet weak var lineV: UIView!
    
    lazy var tipBadge: BadgeSwift = {
        let badge = BadgeSwift()
        badge.font = UIFont.systemFont(ofSize: 13.0)
        badge.textColor = UIColor.white
        badge.cornerRadius = 9
        badge.badgeColor = UIColor.red
        return badge
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .gray
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
        
        nicknameL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        nicknameL.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(17*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        self.addSubview(tipBadge)
        tipBadge.snp.makeConstraints { (make) in
            make.right.equalTo(-30*IPONE_SCALE)
            make.centerY.equalToSuperview()
        }
        
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(nicknameL.snp.left)
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

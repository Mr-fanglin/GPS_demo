//
//  SNavBarView.swift
//  Sheng
//
//  Created by DS on 2017/7/18.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/**
 * @brief: 自定义导航栏(废弃)
 */

import UIKit
import SwiftyJSON

class SNavBarView: UIView {
    
    //MARK: - public property
    /// 点击标题按钮回调点击的序号
    var clickTitleBlock:((_ index:Int) -> ())?
    
    var addBtnActionBlock:(()->())?

    /// 选中序号
    var curIndex = 0{
        didSet{
            if oldValue == curIndex {
                return
            }
            switch curIndex {
            case 0:  //按钮一
                orderBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
                findBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                messageBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                orderBtn.setTitleColor(Main_Color, for: .normal)
                findBtn.setTitleColor(paleBlackColor, for: .normal)
                messageBtn.setTitleColor(paleBlackColor, for: .normal)
                lineView.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(orderBtn)
                    make.bottom.equalTo(-10.5)
                    make.width.equalTo(orderBtn.titleLabel!.snp.width)
                    make.height.equalTo(2)
                })
            case 1: //按钮二
                orderBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                findBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
                messageBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                orderBtn.setTitleColor(paleBlackColor, for: .normal)
                findBtn.setTitleColor(Main_Color, for: .normal)
                messageBtn.setTitleColor(paleBlackColor, for: .normal)
                lineView.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(findBtn)
                    make.bottom.equalTo(-10.5)
                    make.width.equalTo(findBtn.titleLabel!.snp.width)
                    make.height.equalTo(2)
                }
                
            case 2: //按钮三
                orderBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                findBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
                messageBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
                orderBtn.setTitleColor(paleBlackColor, for: .normal)
                findBtn.setTitleColor(paleBlackColor, for: .normal)
                messageBtn.setTitleColor(Main_Color, for: .normal)
                lineView.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(messageBtn)
                    make.bottom.equalTo(-10.5)
                    make.width.equalTo(messageBtn.titleLabel!.snp.width)
                    make.height.equalTo(2)
                }
                
            default:
                print("navigation error")
            }
        }
    }
    
    //MARK: - private property
    var orderBtn = UIButton.init(type: .custom)     //按钮一
    var findBtn = UIButton.init(type: .custom)      //按钮二
    var messageBtn = UIButton.init(type: .custom)   //按钮三
    var addBtn = UIButton.init(type: .custom)  //添加
    private let paleBlackColor = HEXCOLOR(h: 0x8f9094, alpha: 1)  //字体浅黑色
    private let selColor = Main_Color        //选中状态颜色
    private let selFont = UIFont.systemFont(ofSize: ISIPHONE6p ? 17:16)
    private var lineView = UIView.init()    //线
    
    //MARK: - SYSTEM
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        backgroundColor = UIColor.clear
        
        orderBtn.tag = 100
        orderBtn.setTitle(NSLocalizedString("Message_message", comment: ""), for: .normal)
        orderBtn.setTitleColor(HEXCOLOR(h: 0x000000, alpha: 1), for: .normal)
        orderBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
        orderBtn.addTarget(self, action: #selector(titleBtnAction(sender:)), for: .touchUpInside)
        self.addSubview(orderBtn)
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(55*IPONE_SCALE)
            make.bottom.equalTo(0)
            make.width.equalTo(90*IPONE_SCALE)
        }
        
        findBtn.tag = 101
        findBtn.setTitle(NSLocalizedString("Message_Contact", comment: ""), for: .normal)
        findBtn.setTitleColor(paleBlackColor, for: .normal)
        findBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
        findBtn.addTarget(self, action: #selector(titleBtnAction(sender:)), for: .touchUpInside)
        self.addSubview(findBtn)
        findBtn.snp.makeConstraints { (make) in
            make.left.equalTo(orderBtn.snp.right).offset(5*IPONE_SCALE)
            make.bottom.equalTo(0)
            make.height.equalTo(55*IPONE_SCALE)
            make.width.equalTo(90*IPONE_SCALE)
        }

        messageBtn.tag = 102
        messageBtn.setTitle(NSLocalizedString("Message_TrustGroup", comment: ""), for: .normal)
        messageBtn.setTitleColor(paleBlackColor, for: .normal)
        messageBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16*IPONE_SCALE))
        messageBtn.addTarget(self, action: #selector(titleBtnAction(sender:)), for: .touchUpInside)
        self.addSubview(messageBtn)
        messageBtn.snp.makeConstraints { (make) in
            make.left.equalTo(findBtn.snp.right).offset(5*IPONE_SCALE)
            make.height.equalTo(55*IPONE_SCALE)
            make.bottom.equalToSuperview()
            make.width.equalTo(90*IPONE_SCALE)
        }
        
        addBtn.setImage(UIImage.init(named: "contacts_add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        self.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15*IPONE_SCALE)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(55*IPONE_SCALE)
        }
        
        lineView.backgroundColor = Main_Color
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(orderBtn)
            make.bottom.equalTo(-10)
            make.width.equalTo(orderBtn.titleLabel!.snp.width)
            make.height.equalTo(4)
        }
    }

    
    // MARK: - 按钮点击
    @objc func titleBtnAction(sender:UIButton) {
        switch sender.tag {
        case 100:
            curIndex = 0
        case 101:
            curIndex = 1
        case 102:
            curIndex = 2
        default:
            print("navigation error")
            return
        }
        if let clickTitleBlock = clickTitleBlock {
            clickTitleBlock(curIndex)
        } 
    }
    
    @objc func addBtnAction() {
        if let block = addBtnActionBlock {
            block()
        }
    }
}

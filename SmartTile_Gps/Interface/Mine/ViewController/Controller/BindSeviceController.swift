//
//  BindSeviceController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/16.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class BindSeviceController: SBaseController {
    
    var deviceModel:ChildModel = ChildModel() {
        didSet{
            deviceTF.text = deviceModel.iddevice
            nameTF.text = deviceModel.name
            childContactTF.text = deviceModel.phone
            contactOneTF.text = deviceModel.phone1
            contactTwoTF.text = deviceModel.phone2
            self.rightBtn.isHidden = false
        }
    }
    
    var deviceId:String = "" {
        didSet{
            deviceTF.text = deviceId
            self.rightBtn.isHidden = true
        }
    }
    
    var deviceTF = UITextField.init()
    var nameTF = UITextField.init()
    var childContactTF = UITextField.init()
    var contactOneTF = UITextField.init()
    var contactTwoTF = UITextField.init()
    
    var operationBtn = UIButton.init(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setInterface()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setInterface() {
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: NSLocalizedString("Bind_sevice", comment: ""), leftImage: nil, rightStr: NSLocalizedString("delete", comment: ""), ringhtAction: #selector(deleteAction))
        
        let headImg = UIImageView.init()
        self.view.addSubview(headImg)
        headImg.image = UIImage.init(named: "DefaultProfileHead_phone")
        headImg.layer.cornerRadius = CGFloat(25*IPONE_SCALE)
        headImg.layer.masksToBounds = true
        headImg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(20*IPONE_SCALE))
            make.width.height.equalTo(50*IPONE_SCALE)
        }
        
        let deviceNameLabel = UILabel.init()
        deviceNameLabel.text = NSLocalizedString("DeviceId_Name", comment: "")
        deviceNameLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        self.view.addSubview(deviceNameLabel)
        deviceNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headImg.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        deviceTF.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        deviceTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        deviceTF.placeholder = NSLocalizedString("DeviceId_Name", comment: "")
        deviceTF.borderStyle = .roundedRect
        self.view.addSubview(deviceTF)
        deviceTF.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-100*IPONE_SCALE)
            make.top.equalTo(deviceNameLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(28*IPONE_SCALE)
        }
        
        let nameLabel = UILabel.init()
        nameLabel.text = NSLocalizedString("Name", comment: "")
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(deviceTF.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
       
        nameTF.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        nameTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        nameTF.borderStyle = .roundedRect
        self.view.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-100*IPONE_SCALE)
            make.top.equalTo(nameLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(28*IPONE_SCALE)
        }
    
        let contactNameLabel = UILabel.init()
        contactNameLabel.text = NSLocalizedString("Contact_information", comment: "")
        contactNameLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        self.view.addSubview(contactNameLabel)
        contactNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameTF.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        childContactTF.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        childContactTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        childContactTF.placeholder = NSLocalizedString("child_contact", comment: "")
        childContactTF.borderStyle = .roundedRect
        self.view.addSubview(childContactTF)
        childContactTF.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-100*IPONE_SCALE)
            make.top.equalTo(contactNameLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(28*IPONE_SCALE)
        }
        
        contactOneTF.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        contactOneTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        contactOneTF.placeholder = NSLocalizedString("One_Contact", comment: "")
        contactOneTF.borderStyle = .roundedRect
        self.view.addSubview(contactOneTF)
        contactOneTF.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-100*IPONE_SCALE)
            make.top.equalTo(childContactTF.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(28*IPONE_SCALE)
        }
        
        contactTwoTF.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        contactTwoTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        contactTwoTF.placeholder = NSLocalizedString("Two_Contact", comment: "")
        contactTwoTF.borderStyle = .roundedRect
        self.view.addSubview(contactTwoTF)
        contactTwoTF.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-100*IPONE_SCALE)
            make.top.equalTo(contactOneTF.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(28*IPONE_SCALE)
        }
        
        operationBtn.backgroundColor = Main_Color
        operationBtn.layer.cornerRadius = 5
        operationBtn.layer.masksToBounds = true
        operationBtn.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        operationBtn.setTitleColor(.white, for: .normal)
        operationBtn.addTarget(self, action: #selector(operationBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(operationBtn)
        operationBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-50*IPONE_SCALE)
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH-100)
            make.height.equalTo(40*IPONE_SCALE)
        }
    }
    
    @objc func deleteAction() {
        MineRequestObject.shared.requestDeleteChild(idChild: deviceModel.id) { [weak self](code) in
            if let weakself = self {
                if code == "0" {
                    weakself.view.makeToast(NSLocalizedString("delete_suc", comment: ""))
                    weakself.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    @objc func operationBtnAction(sender:UIButton) {
        guard let deviceID = deviceTF.text else {
            return
        }
        guard let name = nameTF.text else {
            return
        }
        guard let childContact = childContactTF.text else {
            return
        }
        guard let contactOne = contactOneTF.text else {
            return
        }
        guard let contactTwo = contactTwoTF.text else {
            return
        }
        MineRequestObject.shared.requestAddChild(id: deviceModel.id, iddevice: deviceID, name: name, phone: childContact, phone1: contactOne, phone2: contactTwo) { [weak self](code,message) in
            if let weakself = self {
                if code == "0" {
                    weakself.navigationController?.popViewController(animated: true)
                }else {
                    weakself.view.makeToast(message)
                }
            }
        }
    }
}

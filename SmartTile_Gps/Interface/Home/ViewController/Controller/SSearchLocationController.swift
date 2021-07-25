//
//  SSearchLocationController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/2.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

protocol SSearchLocationControllerDelegate:NSObjectProtocol {
    func didSelectLocationFinish(model:AMapPOI)
}

fileprivate let SSearchLocationCellID = "XCLocationSearchListCellID"

class SSearchLocationController: SBaseController {
    
    weak var delegate: SSearchLocationControllerDelegate?
    
    var dataList:[AMapPOI] = []{
        didSet{
            self.tableView.reloadData()
        }
    }  //数据源
    
    let endLocationTF:UITextField = UITextField.init()
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NEWNAVHEIGHT-CGFloat(50*IPONE_SCALE)), style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.separatorStyle = .none
        tbView.register(SSearchLocationCell.classForCoder(), forCellReuseIdentifier: SSearchLocationCellID)
        return tbView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setInterface()
        AMapLocationHelper.shared().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        endLocationTF.becomeFirstResponder()
    }
    
    private func setInterface() {
        self.createNavbar(navTitle: NSLocalizedString("Delivery_location", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
        
        let topLineV = UIView.init()
        topLineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.view.addSubview(topLineV)
        topLineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(NEWNAVHEIGHT)
        }
        
        endLocationTF.placeholder = NSLocalizedString("Delivery_location", comment: "")
        endLocationTF.backgroundColor = .white
        endLocationTF.delegate = self
        endLocationTF.returnKeyType = .search
        endLocationTF.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        endLocationTF.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        self.view.addSubview(endLocationTF)
        endLocationTF.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-60*IPONE_SCALE)
            make.top.equalTo(topLineV.snp.bottom)
            make.height.equalTo(50*IPONE_SCALE)
        }
        
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        cancelBtn.setTitleColor(HEXCOLOR(h: 0x999999, alpha: 1), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-5*IPONE_SCALE)
            make.centerY.equalTo(endLocationTF)
            make.width.equalTo(50*IPONE_SCALE)
            make.height.equalTo(50*IPONE_SCALE)
        }
        
        let bottomLineV = UIView.init()
        bottomLineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.view.addSubview(bottomLineV)
        bottomLineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(endLocationTF.snp.bottom)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(bottomLineV.snp.bottom)
        }
    }
    
    @objc func cancelBtnAction() {
        if self.endLocationTF.isEditing == true {
            self.endLocationTF.endEditing(true)
        }
    }

}
extension SSearchLocationController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SSearchLocationCellID) as! SSearchLocationCell
        let model = dataList[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        delegate?.didSelectLocationFinish(model: model)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70*IPONE_SCALE)
    }
}

extension SSearchLocationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let content = textField.text else {
            return true
        }
        AMapLocationHelper.shared().setMapPOIKeywordsSearchRequest(keyword: content)
        
        self.view.endEditing(true)
        return true
    }
}

extension SSearchLocationController: AMapReGeocodeSearchDelegate {
    func onPOISearchFinish(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        self.dataList = response.pois
        self.tableView.reloadData()
    }
}

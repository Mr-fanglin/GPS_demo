//
//  XCLocationSearchListView.swift
//  XinChat
//
//  Created by FangLin on 2019/11/19.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

protocol XCLocationSearchListViewDelegate:NSObjectProtocol {
    func didSelectLocationFinish(latitude:Double, longitude:Double,title:String)
}

fileprivate let XCLocationSearchListCellID = "XCLocationSearchListCellID"
///定位搜索周边位置视图
class XCLocationSearchListView: UIView {
    
    weak var delegate: XCLocationSearchListViewDelegate?
    
    var dataList:[AMapPOI] = []{
        didSet{
            self.tableView.reloadData()
            if dataList.count > 0 {
                selectedIndexPath = IndexPath.init(row: 0, section: 0)
            }
        }
    }  //数据源
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: CGRect.init(x: 0, y: CGFloat(10*IPONE_SCALE), width: SCREEN_WIDTH, height: self.height), style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.separatorStyle = .none
        tbView.register(XCLocationSearchListCell.classForCoder(), forCellReuseIdentifier: XCLocationSearchListCellID)
        return tbView
    }()
    
    var selectedIndexPath:IndexPath = IndexPath.init(row: -1, section: -1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.clipRectCorner(direction: [.topLeft,.topRight], cornerRadius: CGFloat(15*IPONE_SCALE))
        
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(10*IPONE_SCALE)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XCLocationSearchListView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XCLocationSearchListCellID) as! XCLocationSearchListCell
        let model = dataList[indexPath.row]
        cell.model = model
        if dataList.count > 0 {
            if indexPath.row == selectedIndexPath.row {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.reloadData()
        let model = dataList[indexPath.row]
        let subAddressStr:String = model.name ?? model.address
        let addressStr = model.province + model.city + model.district + model.address
        let title = addressStr + "," + subAddressStr
        delegate?.didSelectLocationFinish(latitude: Double(model.location.latitude), longitude: Double(model.location.longitude), title: title)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80*IPONE_SCALE)
    }
}

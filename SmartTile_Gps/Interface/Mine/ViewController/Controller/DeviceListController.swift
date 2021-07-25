//
//  DeviceListController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/16.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class DeviceListController: SBaseController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr:[ChildModel] = []
    
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init(frame: .zero)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: NSLocalizedString("Equipment management", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 注册cellID
        tableView.register(MineCell.self, forCellReuseIdentifier: "MineCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        HomeRequestObject.shared.requestChildList { [weak self](dataList) in
            if let weakself = self {
                weakself.dataArr = dataList
                weakself.tableView.reloadData()
            }
        }
    }

    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineCell") as? MineCell
        let model = self.dataArr[indexPath.row]
        cell?.deviceModel = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bindSVC = BindSeviceController()
        bindSVC.deviceModel = self.dataArr[indexPath.row]
        self.navigationController?.pushViewController(bindSVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60*IPONE_SCALE)
    }
}

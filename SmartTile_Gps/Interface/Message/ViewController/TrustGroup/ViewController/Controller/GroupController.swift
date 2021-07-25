//
//  GroupController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/26.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class GroupController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    
    var dataArr:[GroupListModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }
    
    func setInterface() {
        // 添加tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        // 注册cellID
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    func requestData() {
        MessageRequestObject.shared.requestGroupGetList { [weak self](list) in
            if let weakself = self {
                weakself.dataArr = list
            }
        }
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell
        let model = dataArr[indexPath.row]
        cell?.model = model
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70*IPONE_SCALE)
    }
}



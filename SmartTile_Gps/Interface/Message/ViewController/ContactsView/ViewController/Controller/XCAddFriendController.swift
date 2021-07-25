//
//  XCAddFriendController.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

fileprivate let XCSettingMiddleCellID = "XCSettingMiddleCellID"
fileprivate let XCSettingNormalCellID = "XCSettingNormalCellID"

class XCAddFriendController: SBaseController {
    
    // MARK:- 懒加载
    // 搜索控制器
    var searchController: UISearchController?
    var searchVC = XCAddFriendSearchController()
    
    // tableView
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68.0
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = kNavBarBgColor
        return tableView
    }()
    
    // models
    lazy var models: [XCSettingCellModel] = {
        return XCUIDataHelper.getAddFriendFunc()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    fileprivate func setUp() {
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: NSLocalizedString("Contact_AddFriend", comment: ""), leftImage: nil, rightStr: nil, ringhtAction: nil)
        
        // 添加tableView
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(XCSettingMiddleCell.classForCoder(), forCellReuseIdentifier: XCSettingMiddleCellID)
        tableView.register(XCSettingNormalCell.classForCoder(), forCellReuseIdentifier: XCSettingNormalCellID)
        
        //初始化search
        searchController = UISearchController.init(searchResultsController: self.searchVC)
        searchController?.searchResultsUpdater = self.searchVC
        searchController?.delegate = self
        searchController?.searchBar.delegate = self.searchVC
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = NSLocalizedString("Search_EnterID", comment: "")
        searchController?.searchBar.tintColor = RGBCOLOR(r: 83, g: 91, b: 136, alpha: 1)
        searchController?.searchBar.setValue(NSLocalizedString("Cancel", comment: ""), forKey:"cancelButtonText")
        // 去除上下两条横线
//        searchController?.searchBar.setBackgroundImage(kNavBarBgColor.trans2Image(), for: .any, barMetrics: .default)
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        
        let searchView:UIView = UIView(frame: searchController?.searchBar.bounds ?? .zero)
        searchView.addSubview(searchController!.searchBar)
        tableView.tableHeaderView = searchView

        self.definesPresentationContext = true
        self.searchVC.nav = self.navigationController
    }
}

extension XCAddFriendController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        var cell: XCSettingBaseCell?
        var cellID: String!
        if model.type == .middle {
            cellID = XCSettingMiddleCellID
        } else {
            cellID = XCSettingNormalCellID
        }
        cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? XCSettingBaseCell
        cell?.model = model
        return cell!
    }
}

extension XCAddFriendController: UISearchControllerDelegate {
    //MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        self.edgesForExtendedLayout = .all
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.edgesForExtendedLayout = .all
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        
    }
    
}



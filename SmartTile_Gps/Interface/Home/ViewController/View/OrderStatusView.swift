//
//  OrderStatusView.swift
//  SmartTile_Gps
//
//  Created by FangLin on 2020/9/29.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OrderStatusView: UIView {
    
    var driverOperatBlock:((_ tag:Int)->())?
    
    var progressList:[OrderProgressModel] = [] {
        didSet{
            for progressModel in progressList {
                progressModel.myChild = statusModel.myChild
            }
            let firstProgressModel = progressList[0]
            if firstProgressModel.orderStatus == 8 || firstProgressModel.orderStatus == 7 {
                
            }else {
                let model = OrderProgressModel()
                model.orderStatus = Int8(progressList.count)*10
                model.myChild = statusModel.myChild
                progressList.insert(model, at: 0)
            }
            self.tableView.reloadData()
        }
    }
    
    var statusModel:ChildStatusModel = ChildStatusModel() {
        didSet{
            callBtn.isHidden = false
            if statusModel.myChild {
                nameLabel.text = "Driver:"+statusModel.accountInfo.name
            }else {
                nameLabel.text = statusModel.child.name
            }
            AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: statusModel.order.fromLatitude, longitude: statusModel.order.fromLongitude)
            AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: statusModel.order.toLatitude, longitude: statusModel.order.toLongitude)
        }
    }

    var topView:UIView = UIView.init()
    var headImg:UIImageView = UIImageView.init()
    var nameLabel:UILabel = UILabel.init()
    var callBtn:UIButton = UIButton.init()
    var mapViewBtn:UIButton = UIButton.init()
    var bottomView:UIView = UIView.init()
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.backgroundColor = .white
        tbView.delegate = self
        tbView.dataSource = self
        return tbView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 0.1)
        self.setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Action
    @objc func callBtnAction() {
        let phone = "telprompt://" + (statusModel.myChild ? statusModel.accountInfo.phone:statusModel.child.phone)
        guard let url = URL.init(string: phone) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                Dprint("success")
            }
        }else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func mapViewBtnAction() {
//        let appName = "高德地图"
//        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=&dlat=\(statusModel.myChild ? statusModel.order.carLatitude:statusModel.order.fromLatitude)&dlon=\(statusModel.myChild ? statusModel.order.carLongitude:statusModel.order.fromLongitude)&t=\(0)"
//            if self.openMap(urlString) == false {
//                print("您还没有安装高德地图")
//
//            }
        let gpsLocation = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: statusModel.myChild ? statusModel.order.carLatitude:statusModel.order.fromLatitude, longitude: statusModel.myChild ? statusModel.order.carLongitude:statusModel.order.fromLongitude), AMapCoordinateType.GPS)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: gpsLocation, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)])
    }
    private func openMap(_ urlString: String) -> Bool {
        guard let url = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return false
        }
        if UIApplication.shared.canOpenURL(url) == true {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    Dprint("success")
                }
            }else {
                UIApplication.shared.openURL(url)
            }
            return true
        } else {
            return false
        }
    }
        
    //MARK: - UI
    func setInterface() {
        topView.backgroundColor = .white
        topView.layer.cornerRadius = CGFloat(55*IPONE_SCALE)/2
        topView.layer.masksToBounds = true
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(11*IPONE_SCALE)
            make.right.equalTo(-11*IPONE_SCALE)
            make.top.equalToSuperview()
            make.height.equalTo(55*IPONE_SCALE)
        }
        
        headImg.image = UIImage.init(named: "home_journey_trust_normal_50%")
        headImg.layer.cornerRadius = CGFloat(40*IPONE_SCALE)/2
        headImg.layer.masksToBounds = true
        topView.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15*IPONE_SCALE)
            make.width.height.equalTo(40*IPONE_SCALE)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        nameLabel.textColor = HEXCOLOR(h: 0x3A3A3A, alpha: 1)
        topView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImg.snp.right).offset(19*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(20*IPONE_SCALE)
        }
        
        callBtn.setImage(UIImage.init(named: "home_journey_phone"), for: .normal)
        callBtn.addTarget(self, action: #selector(callBtnAction), for: .touchUpInside)
        topView.addSubview(callBtn)
        callBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40*IPONE_SCALE)
            make.right.equalTo(-80*IPONE_SCALE)
        }
        
        mapViewBtn.setImage(UIImage.init(named: "home_journey_location"), for: .normal)
        mapViewBtn.addTarget(self, action: #selector(mapViewBtnAction), for: .touchUpInside)
        topView.addSubview(mapViewBtn)
        mapViewBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        bottomView.backgroundColor = .white
        bottomView.corner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radii: CGFloat(15*IPONE_SCALE), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(160*IPONE_SCALE)))
        self.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-10*IPONE_SCALE)
            make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(160*IPONE_SCALE)
        }
        
        bottomView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10*IPONE_SCALE)
            make.bottom.equalTo(-10*IPONE_SCALE)
        }
        tableView.register(UINib.init(nibName: "OrderStatusCell", bundle: nil), forCellReuseIdentifier: "OrderStatusCell")
    }
    
    var helpBtnActionBlock:((_ model:ChildStatusModel)->())?
    var cancelBtnActionBlock:((_ model:OrderModel)->())?
    var finishBtnActionBlock:((_ model:OrderModel)->())?
    @objc func operatBtn(sender:UIButton){
        
    }
}

extension OrderStatusView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell", for: indexPath) as! OrderStatusCell
        let model = progressList[indexPath.row]
        cell.progressModel = model
        cell.operatBtnActionBlock = {[weak self](tag) in
            if let weakself = self {
                if let block = weakself.driverOperatBlock {
                    block(tag)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50*IPONE_SCALE)
    }
}

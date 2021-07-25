//
//  XCPhotoBrowserController.swift
//  XinChat
//
//  Created by FangLin on 2019/11/5.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

fileprivate let XCPhotoBrowserViewCellID = "XCPhotoBrowserViewCellID"

/// 聊天图片放大控制器
class XCPhotoBrowserController: UIViewController {

    // MARK:- 定义属性
    var indexPath: IndexPath!
    var picsBlock: (()->())?
    
    // MARK:- 懒加载
    lazy var msgModels: [XCChatMsgModel] = [XCChatMsgModel]()
    lazy var checkButton: UIButton = {
        let checkBtn = UIButton()
        checkBtn.setTitle("查看原图", for: .normal)
        checkBtn.backgroundColor = UIColor.black
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        checkBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        checkBtn.layer.borderWidth = 0.3
        checkBtn.layer.cornerRadius = 2
        checkBtn.layer.masksToBounds = true
        checkBtn.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
        return checkBtn
    }()
    lazy var picsButton: UIButton = {
        let picsBtn = UIButton()
        picsBtn.setImage(#imageLiteral(resourceName: "player_mode_video_wall"), for: .normal)
        picsBtn.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        picsBtn.layer.borderWidth = 0.3
        picsBtn.layer.cornerRadius = 2
        picsBtn.layer.masksToBounds = true
        picsBtn.addTarget(self, action: #selector(picsButtonClick), for: .touchUpInside)
        return picsBtn
    }()
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: XCPhotoBrowserCollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
        
        // 滚到对应的图片位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK:- init
    init(indexPath: IndexPath, msgModels: [XCChatMsgModel]) {
        super.init(nibName: nil, bundle: nil)
        
        self.indexPath = indexPath
        self.msgModels = msgModels
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        Dprint("LXFPhotoBrowserController 被销毁了")
        self.removeFromParent()
    }
}

// MARK:- 初始化
extension XCPhotoBrowserController {
    fileprivate func setup() {
        automaticallyAdjustsScrollViewInsets = false
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(checkButton)
        view.addSubview(picsButton)
        
        // 设置frame
        collectionView.frame = view.bounds
        setCheckBtnConstraints(modelNum: indexPath.item)
        picsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(30)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.width.equalTo(38)
            make.height.equalTo(24)
        }
        
        // 设置collectiionView属性
        collectionView.register(XCPhotoBrowserCell.self, forCellWithReuseIdentifier: XCPhotoBrowserViewCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    fileprivate func setCheckBtnConstraints(modelNum: Int) {
        let size = XCSpaceSizeTools.shared.getSizeString(size: Int(msgModels[Int(modelNum)].fileLength!))
        checkButton.setTitle("查看原图\(size)", for: .normal)
        checkButton.titleLabel?.sizeToFit()
        let titleL = checkButton.titleLabel!
        checkButton.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.width.equalTo(titleL.width + 8)
            make.height.equalTo(titleL.height + 5)
        }
    }
}

// MARK:- 事件处理
extension XCPhotoBrowserController {
    @objc func checkButtonClick() {
        Dprint("查看原图")
    }
    @objc func picsButtonClick() {
        Dprint("查看附件")
    }
}

// MARK:- UICollectionViewDataSource
extension XCPhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = msgModels[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XCPhotoBrowserViewCellID, for: indexPath) as! XCPhotoBrowserCell
        
        cell.msgModel = model
        cell.delegate = self
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        checkButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkButton.isHidden = false
        let num =  scrollView.contentOffset.x / (UIScreen.main.bounds.width + 20)
        setCheckBtnConstraints(modelNum: Int(round(num)))
    }
}

extension XCPhotoBrowserController: XCPhotoBrowserViewCellDelegate {
    func imageViewClick() {
        self.dismiss(animated: true, completion: nil)
    }
}


/* ============================================================ */

// MARK:- 自定义布局
class XCPhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0                          // 设置最小行间距
        minimumInteritemSpacing = 0                     // 设置最小item间距
        scrollDirection = .horizontal                   // 设置滚动方向
        
        // 2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}


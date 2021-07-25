//
//  XCChatMoreView.swift
//  
//
//  Created by FangLin on 2017/1/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

enum XCChatMoreType: Int {
    case pic        // 照片
    case camera     // 相机
    case sight      // 小视频
    case video      // 视频聊天
    case wallet     // 红包
    case location   // 位置
    case myfav      // 收藏
    case friendCard // 个人名片
}

fileprivate let kMoreCellNumberOfOneRow = 4
fileprivate let kMoreCellRow = 2
fileprivate let kMoreCellNumberOfOnePage = kMoreCellRow * kMoreCellNumberOfOneRow
fileprivate let kMoreCellID = "moreCellID"

protocol XCChatMoreViewDelegate : NSObjectProtocol {
    func chatMoreView(moreView: XCChatMoreView, didSeletedType type: XCChatMoreType)
}

class XCChatMoreView: UIView {
    // MARK:- 代理
    weak var delegate: XCChatMoreViewDelegate?
    
    // MARK:- 懒加载
    lazy var moreView: UICollectionView = { [unowned self] in
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: XCChatHorizontalLayout(column: kMoreCellNumberOfOneRow, row: kMoreCellRow))
        collectionV.backgroundColor = kChatKeyboardBgColor
        collectionV.dataSource = self
        collectionV.delegate = self
        return collectionV
    }()

    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.moreDataSouce.count / kMoreCellNumberOfOnePage + (self.moreDataSouce.count % kMoreCellNumberOfOnePage == 0 ? 0 : 1)
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        return pageC
    }()
    
    lazy var moreDataSouce: [(name: String, icon: UIImage, type: XCChatMoreType)] = {
        return [
            ("照片", #imageLiteral(resourceName: "sharemore_pic"), XCChatMoreType.pic),
            ("相机", #imageLiteral(resourceName: "sharemore_video"), XCChatMoreType.camera),
            ("小视频", #imageLiteral(resourceName: "sharemore_sight"), XCChatMoreType.sight),
            ("视频聊天", #imageLiteral(resourceName: "sharemore_videovoip"), XCChatMoreType.video),
            ("红包", #imageLiteral(resourceName: "sharemore_wallet"), XCChatMoreType.wallet),
            ("位置", #imageLiteral(resourceName: "sharemore_location"), XCChatMoreType.location),
            ("收藏", #imageLiteral(resourceName: "sharemore_myfav"), XCChatMoreType.myfav),
            ("个人名片", #imageLiteral(resourceName: "sharemore_friendcard"), XCChatMoreType.friendCard)
        ]
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(moreView)
        self.addSubview(pageControl)
        
        moreView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(197)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(35)
            make.top.equalTo(moreView.snp.bottom).offset(-16)
        }
        self.backgroundColor = kChatKeyboardBgColor
        moreView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: moreView.height)
        // 注册itemID
        moreView.register(XCChatMoreCell.self, forCellWithReuseIdentifier: kMoreCellID)
        
    }
}

extension XCChatMoreView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataSouce.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let moreModel = moreDataSouce[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreCellID, for: indexPath) as? XCChatMoreCell
        
        cell?.model = moreModel
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreModel = moreDataSouce[indexPath.item]
        delegate?.chatMoreView(moreView: self, didSeletedType: moreModel.type)
    }
    
}
extension XCChatMoreView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
    }
}

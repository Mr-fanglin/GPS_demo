//
//  XCChatEmotionCell.swift
//  
//
//  Created by FangLin on 2017/1/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class XCChatEmotionCell: UICollectionViewCell {
    // MARK:- 定义属性
    var emotion: XCChatEmotion? {
        didSet {
            guard let emo = emotion else { return }
            if emo.isRemove {
                emotionImageView.image = UIImage(named: "DeleteEmoticonBtn")
            } else if emo.isEmpty {
                emotionImageView.image = UIImage()
            } else {
                guard let imgPath = emo.imgPath else {
                    return
                }
                emotionImageView.image = UIImage(contentsOfFile: imgPath)
            }
        }
    }
    
    // MARK:- 懒加载
    lazy var emotionImageView: UIImageView = {
        return UIImageView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(emotionImageView)
        emotionImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(32)
        }
    }
}

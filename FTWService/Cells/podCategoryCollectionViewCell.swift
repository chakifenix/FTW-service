//
//  podCategoryCollectionViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class podCategoryCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 0
        return label
    }()
    let imageview:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "category")
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        addSubview(imageview)
        addSubview(label)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageview.snp.bottom).offset(8)
            make.left.equalTo(imageview.snp.left).offset(2)
            make.right.equalTo(imageview.snp.right)
        }
        imageview.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(100)
        }
    }
    
}

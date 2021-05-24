//
//  TasksCollectionViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        return label
    }()
    let allCat: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        addSubview(allCat)
        addSubview(label)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        allCat.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.width.equalToSuperview()
        }
    }
}

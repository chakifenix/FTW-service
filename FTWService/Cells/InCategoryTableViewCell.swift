//
//  InCategoryTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class InCategoryTableViewCell: UITableViewCell {
    
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(label)
        configureViews()
    }
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

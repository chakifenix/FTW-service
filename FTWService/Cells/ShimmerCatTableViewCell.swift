//
//  ShimmerCatTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class ShimmerCatTableViewCell: UITableViewCell {
    let labelView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(labelView)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        labelView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-24)
        }
        
    }
}

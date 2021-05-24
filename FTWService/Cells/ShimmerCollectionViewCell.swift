//
//  ShimmerCollectionViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class ShimmerCollectionViewCell: UICollectionViewCell {
    let labelView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    let imageView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 16
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        addSubview(labelView)
        addSubview(imageView)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        labelView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(24)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.right.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
        }
    }
}

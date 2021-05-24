//
//  LevelBonusCell.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/19/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class LevelBonusCell: UITableViewCell {
    let Inview:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    let percent:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 15.0)
        label.textColor = .gray
        return label
    }()
    
    let Title:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        return label
    }()
    let discription:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Inview.layer.cornerRadius = 10
        Inview.layer.shadowColor = UIColor.black.cgColor
        Inview.layer.shadowRadius = 5
        Inview.layer.shadowOpacity = 0.1
        Inview.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundColor = .clear
        setupConstraint()
    }
    func setupConstraint() {
        addSubview(Inview)
        self.Inview.addSubview(Title)
        self.Inview.addSubview(percent)
        self.Inview.addSubview(discription)
        Inview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-8)
        }
        Title.snp.makeConstraints { (make) in
            make.top.equalTo(Inview.snp.top).offset(10)
            make.left.equalTo(Inview.snp.left).offset(16)
        }
        percent.snp.makeConstraints { (make) in
            make.top.equalTo(Inview.snp.top).offset(10)
            make.right.equalTo(Inview.snp.right).offset(-16)
        }
        discription.snp.makeConstraints { (make) in
            make.top.equalTo(Title.snp.bottom).offset(16)
            make.left.equalTo(Title.snp.left)
            make.right.equalTo(percent.snp.right)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

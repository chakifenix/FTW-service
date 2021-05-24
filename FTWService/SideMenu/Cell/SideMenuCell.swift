//
//  SideMenuCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 2/3/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    let vcImage:UIImageView = {
       let image = UIImageView()
        
       return image
    }()
    let vcTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(vcImage)
        addSubview(vcTitle)
        vcImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.width.height.equalTo(25)
        }
        vcTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(vcImage.snp.centerY)
            make.left.equalTo(vcImage.snp.right).offset(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class sideMenuHeaderCell: UITableViewCell {
    let imageview:WebImage = {
        let image = WebImage()
        image.layer.cornerRadius = UIScreen.main.bounds.height * 0.23 * 0.6/2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        return label
    }()
    let bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(bgView)
        bgView.addSubview(imageview)
        bgView.addSubview(title)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        }
        imageview.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(UIViewController().getStatusBarFrame().height + 16)
            make.left.equalToSuperview().offset(32)
            make.height.equalTo(bgView.snp.height).multipliedBy(0.6)
            make.width.equalTo(imageview.snp.height)
        }
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageview.snp.centerY)
            make.left.equalTo(imageview.snp.right).offset(24)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


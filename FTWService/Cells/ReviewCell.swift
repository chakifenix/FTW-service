//
//  ReviewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    let image1: WebImage = {
        let image = WebImage()
        image.clipsToBounds = true
        image.layer.cornerRadius = 18
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "profileWhite")
        return image
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "icon-small-1")
        return image
    }()
    let aboutMe:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        label.text = "Имя Фамилья"
        return label
    }()
    let dateRev:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "26 августа 2019"
        return label
    }()
    let descrMe: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Безопасная оплата картой и гарантия возврата денег.Компенсация в случае морального ущерба"
        label.numberOfLines = 2
        return label
    }()
    
    let sumLike:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image1)
        addSubview(iconLike)
        addSubview(sumLike)
        
        addSubview(descrMe)
        addSubview(aboutMe)
        addSubview(dateRev)
        configureViews()
    }
    func configureViews() {
        image1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        aboutMe.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.left.equalTo(image1.snp.right).offset(12)
        }
        dateRev.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.bottom).offset(4)
            make.left.equalTo(image1.snp.right).offset(12)
        }
        descrMe.snp.makeConstraints { (make) in
            make.top.equalTo(dateRev.snp.bottom).offset(8)
            make.left.equalTo(dateRev.snp.left)
            make.right.equalToSuperview()
        }
        
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        sumLike.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconLike.snp.centerY)
            make.right.equalTo(iconLike.snp.left).offset(-3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

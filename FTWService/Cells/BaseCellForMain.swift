//
//  BaseCellForMain.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 5/2/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class BaseCellForMain:UICollectionViewCell{
    
    var favouriteBool = false
    var favouriteId: String = ""
    var favouriteTarget: (() -> ())?
    
    let cardView:UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.image = #imageLiteral(resourceName: "Green")
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Починить холодильник,не охлаждается"
        label.font = UIFont(name: "proximanova-medium", size: 15)
        label.textColor = #colorLiteral(red: 0.2117647059, green: 0.8117647059, blue: 0.6352941176, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel:UILabel = {
        let label = UILabel()
        label.text = "5000 тг"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Холодильники и морозильные камеры"
        label.textColor = #colorLiteral(red: 0.2, green: 0.247, blue: 0.322, alpha: 1)
        label.numberOfLines = 2
        label.font = UIFont(name: "proximanova-medium", size: 8)
        return label
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.text = "Cегодня в 16:00"
        label.textColor = #colorLiteral(red: 0.2591280043, green: 0.3168036342, blue: 0.3958082199, alpha: 1)
        label.font = UIFont(name: "proximanova-medium", size: 3)
        return label
    }()
   
    let cityLabel:UILabel = {
        let label = UILabel()
        label.text = "г.Алматы"
        label.textColor = #colorLiteral(red: 0.2, green: 0.247, blue: 0.322, alpha: 1)
        label.font = UIFont(name: "proximanova-medium", size: 8)
        return label
    }()
    
    
    let dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-12)
        }
        
        cardView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
           make.top.equalTo(8)
           make.left.equalTo(16)
        }
        
        cardView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
        }
        
        cardView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalTo(imageView.snp.height).multipliedBy(1.1)
        }
        

        cardView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).offset(4)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(-6)
        }
        
        cardView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        
        cardView.addSubview(dividerLine)
        dividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.right.equalTo(-32)
            make.height.equalTo(1)
        }
        
        cardView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
        }

    }
}

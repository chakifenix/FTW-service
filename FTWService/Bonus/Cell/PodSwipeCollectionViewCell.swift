//
//  PodSwipeCollectionViewCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/18/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class PodSwipeCollectionViewCell: UICollectionViewCell {
  
    let partnersName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "f", size: 12)
//        label.numberOfLines = 0
        label.minimumScaleFactor = 0.8
        return label
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "Программа", size: 12)
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.8
        return label
    }()
    let registButton:UIButton = {
       let button = UIButton()
        return button
    }()
    
    let imageview:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "category")
//        image.backgroundColor = .red
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowRadius = 5
        image.layer.shadowOpacity = 0.1
        image.layer.shadowOffset = CGSize(width: 0, height: 0)
        return image
    }()
    var index:Int?{
        didSet{
            self.partnersName.text = labelNameArray[index!].label
            self.imageview.image = labelNameArray[index!].image
            self.titleLabel.text = "Программа"
        }
    }
    
    
    var labelNameArray = [CardPartners(label: "БОНУСНАЯ", image: #imageLiteral(resourceName: "forBouns")),CardPartners(label: "ПАРТНЕРСКАЯ", image: #imageLiteral(resourceName: "forPartners")),CardPartners(label: "ЕЩЕ", image: #imageLiteral(resourceName: "forBouns")),CardPartners(label: "ЕЩЕ", image: #imageLiteral(resourceName: "forPartners"))]
    
//        ["БОНУСНАЯ","ПАРТНЕРСКАЯ"]
    override init(frame: CGRect) {
        super.init(frame: frame)
    
//        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.gray.cgColor
////        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = .zero
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
        addSubview(imageview)
        self.imageview.addSubview(partnersName)
        self.imageview.addSubview(titleLabel)
        addSubViewsAndlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageview.snp.centerY).offset(-10)
            make.left.equalTo(imageview.snp.left).offset(8)
            make.width.equalTo(imageview.snp.width).multipliedBy(0.8)
            make.height.equalTo(imageview.snp.height).multipliedBy(0.2)
            //            make.bottom.equalTo(partnersName.snp.top)
            //            make.left.equalTo(partnersName.snp.left)
            //            make.height.equalTo(imageview.snp.height).multipliedBy(0.25)
            //            make.width.equalTo(imageview.snp.width).multipliedBy(0.5)
        }
        partnersName.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(imageview.snp.left).offset(8)
            make.width.equalTo(imageview.snp.width).multipliedBy(0.8)
            make.height.equalTo(imageview.snp.height).multipliedBy(0.2)
        }

        imageview.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

struct CardPartners {
    var label:String?
    var image:UIImage?
}

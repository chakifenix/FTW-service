//
//  DetailHeaderViewCell.swift
//  NewTestingProject
//
//  Created by Zhanibek Santay on 12/12/19.
//  Copyright © 2019 Zhanibek Santay. All rights reserved.
//

import UIKit
import MaterialComponents

class DetailHeaderViewCell: UITableViewCell {
    
    let headerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
//                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        return view
    }()
    
    let qrImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "STAR")
//        image.layer.cornerRadius = (UIScreen.main.bounds.height - 36)*0.65/2
//        image.clipsToBounds = true
        return image
    }()
    
    
    let Title:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        label.text = "Starbucks"
        return label
    }()
    
    let imagePencil:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "sign"), for: .normal)
        return button
    }()
    
    let discriptionInHeader:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Скидка от партнеров"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupConstraint(){
        self.addSubview(headerView)
        headerView.addSubview(qrImage)
        headerView.addSubview(Title)
        headerView.addSubview(discriptionInHeader)
        headerView.addSubview(imagePencil)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(36)
            make.left.equalTo(self.snp.left).offset(12)
            make.right.equalTo(self.snp.right).offset(-12)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        qrImage.snp.makeConstraints { (make) in
            //            make.top.equalTo(self.headerView.snp.top).offset(24)
            make.centerY.equalTo(headerView.snp.centerY)
            make.left.equalTo(headerView.snp.left).offset(24)
            //            make.size.equalTo(CGSize(width:100, height: 100))
            make.height.equalTo(headerView.snp.height).multipliedBy(0.65)
            make.width.equalTo(qrImage.snp.height)
        }
        
        Title.snp.makeConstraints { (make) in
            make.left.equalTo(qrImage.snp.right).offset(24)
            make.centerY.equalTo(qrImage.snp.centerY).offset(-8)
            make.width.equalTo(self.headerView.snp.width).multipliedBy(0.50)
            make.height.equalTo(self.qrImage.snp.height).multipliedBy(0.25)
            //            make.size.equalTo(CGSize(width: 200, height: 30))
        }
        
        discriptionInHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.Title.snp.bottom)
            make.left.equalTo(qrImage.snp.right).offset(24)
            //            make.bottom.equalTo(dateLabel.snp.top).offset(8)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
            make.right.equalToSuperview()
        }
        
        imagePencil.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 20, height: 20))
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupConstraint()
        self.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        // Configure the view for the selected state
    }
    
}

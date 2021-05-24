
//
//  TabBarCell.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 2/5/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class MenuCell: BaseCell{
    
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Data_Colors.mainColor
        //        iv.tintColor = UIColor(red: 91/255.0, green: 14/255.0, blue: 13/255.0, alpha: 1)
        return iv
    }()
    let label:UILabel = {
        let label = UILabel()
        label.text = "Все уведомления"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Data_Colors.mainColor
        return label
    }()
    
    override var isHighlighted: Bool{
        didSet{
            self.backgroundColor = isHighlighted ? #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1) : .white//            imageView.tintColor = UIColor(red: 91/255.0, green: 14/255.0, blue: 13/255.0, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            self.backgroundColor = isSelected ? #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1) : .white
            //            self.backgroundColor = .gray
            //            imageView.tintColor =  UIColor(red: 91/255.0, green: 14/255.0, blue: 13/255.0, alpha: 1)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(label)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

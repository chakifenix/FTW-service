//
//  AnketaImageCollectionViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class AnketaImageCollectionViewCell: UICollectionViewCell {
    
    let imageview:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "category")
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFit
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowRadius = 5
        image.layer.shadowOpacity = 0.1
        image.layer.shadowOffset = CGSize(width: 0, height: 0)
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        addSubview(imageview)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        imageview.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
}

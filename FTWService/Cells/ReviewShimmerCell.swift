//
//  ReviewShimmerCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import SnapKit
class ReviewShimmerCell: UITableViewCell {
    let image1: UIImageView = {
        let image = UIImageView()
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
    let nameView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    let descrView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(image1)
        addSubview(iconLike)
        addSubview(nameView)
        addSubview(descrView)
        addSubview(dateView)
        addConst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func addConst() {
        image1.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(dateView.snp.top)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(15)
        }
        dateView.snp.makeConstraints { (make) in
            make.top.equalTo(image1.snp.top).offset(8)
            make.left.equalTo(image1.snp.right).offset(16)
            make.right.equalTo(iconLike.snp.left).offset(-8)
            make.height.equalTo(20)
        }
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(dateView.snp.bottom).offset(12)
            make.left.equalTo(image1.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        descrView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom).offset(12)
            make.left.equalTo(image1.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
    }
    
}

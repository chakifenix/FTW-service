//
//  ShimmerReviewTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class ShimmerReviewTableViewCell: UITableViewCell {
    let image1: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileWhite")
        return image
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "icon-small-1")
        return image
    }()
    let shimView1:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    let shimView2:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    let shimView3:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image1)
        addSubview(iconLike)
        configureViews()
    }
    func configureViews() {
        image1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        shimView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.equalTo(image1.snp.right).offset(16)
            make.right.equalTo(iconLike.snp.left).offset(8)
        }
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(shimView1.snp.top)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
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
    
}

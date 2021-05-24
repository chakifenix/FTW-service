//
//  TextPartnersVipTableViewCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/19/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class TextPartnersVipTableViewCell: UITableViewCell {

    let categoryLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 15.0)
        label.text = "Категория"
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setupConstraint()
    }
    
    func setupConstraint(){
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }

}

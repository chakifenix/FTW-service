//
//  DetailDescriptionViewCell.swift
//  NewTestingProject
//
//  Created by Zhanibek Santay on 12/12/19.
//  Copyright © 2019 Zhanibek Santay. All rights reserved.
//

import UIKit

class DetailDescriptionViewCell: UITableViewCell {
    
    let discriptionTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Описание :"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    let bonusTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Описание доступных скидок:"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    let discription:UILabel = {
        let label = UILabel()
        label.text = "Безопасная Описание доступных скидок Описание доступных скидок Описание доступных скидок"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addSubview(discription)
        self.addSubview(discriptionTitleLabel)
        self.addSubview(bonusTitleLabel)
        discriptionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(8)
            make.left.equalTo(self.snp.left).offset(16)
        }
        discription.snp.makeConstraints { (make) in
            make.top.equalTo(discriptionTitleLabel.snp.bottom).offset(4).priority(.high)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            //            make.bottom.equalTo(bonusTitleLabel.snp.top).offset(-2)
        }
        bonusTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.discription.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
        }
        // Configure the view for the selected state
    }
    
}

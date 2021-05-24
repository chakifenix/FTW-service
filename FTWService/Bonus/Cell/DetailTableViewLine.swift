//
//  DetailTableViewLine.swift
//  NewTestingProject
//
//  Created by Zhanibek Santay on 12/12/19.
//  Copyright © 2019 Zhanibek Santay. All rights reserved.
//

import UIKit

class DetailTableViewLine: UITableViewCell {
    
    let title:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Капучино"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
        label.numberOfLines = 0
        return label
    }()
    let seperatorView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        return view
    }()
    let pracent:UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.text = "20%"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addSubview(title)
        self.addSubview(pracent)
        self.addSubview(seperatorView)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        pracent.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp.right).offset(-8)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        seperatorView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.right.equalTo(self.pracent.snp.right)
            make.left.equalTo(self.title.snp.left)
            make.height.equalTo(1)
        }
        // Configure the view for the selected state
    }
    
}

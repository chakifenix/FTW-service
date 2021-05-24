//
//  CityTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
class CityTableViewCell: UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    let finishlabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(label)
        addSubview(finishlabel)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        finishlabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

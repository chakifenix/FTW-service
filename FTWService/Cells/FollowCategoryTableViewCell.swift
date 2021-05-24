//
//  FollowCategoryTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class FollowCategoryTableViewCell: UITableViewCell {
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //    let button:KGRadioButton = {
    //        let radio = KGRadioButton()
    //        radio.innerCircleCircleColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
    //        radio.outerCircleColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
    //        return radio
    //    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        //        addSubview(button)
        //        button.addTarget(self, action: #selector(RadioAction(sender:)), for: .touchUpInside)
        configureViews()
    }
    //    @objc func RadioAction(sender: KGRadioButton) {
    //        sender.isSelected = !sender.isSelected
    //    }
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
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

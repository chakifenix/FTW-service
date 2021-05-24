//
//  ChargeBonusTableViewCell.swift
//  NewTestingProject
//
//  Created by Zhanibek Santay on 12/8/19.
//  Copyright © 2019 Zhanibek Santay. All rights reserved.
//

import UIKit
import SnapKit

class ChargeBonusTableViewCell: UITableViewCell {
    
    let lineview1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    let lineview2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    let bonusTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    let label:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint(){
        addSubview(bonusTitleLabel)
        addSubview(lineview1)
        addSubview(lineview2)
        addSubview(label)
        lineview1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        lineview2.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        bonusTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            
        }
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func buttonClicked() {
        //        let vc = OurPartnersViewController()
        //        self.show(vc, sender: self)
    }
    
}


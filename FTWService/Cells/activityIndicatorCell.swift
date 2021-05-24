//
//  activityIndicatorCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import JTMaterialSpinner
class activityIndicatorCell: UITableViewCell {
    let refresh:JTMaterialSpinner = {
        let spinner = JTMaterialSpinner()
        spinner.circleLayer.lineWidth = 2.0
        spinner.circleLayer.strokeColor = Constans().blue.cgColor
        spinner.animationDuration = 1.5
        return spinner
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(refresh)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        refresh.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}

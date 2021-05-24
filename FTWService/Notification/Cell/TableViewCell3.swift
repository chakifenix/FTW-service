//
//  TableViewCell3.swift
//  resources
//
//  Created by MacOs User on 9/27/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit

class TableViewCell3: UITableViewCell {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configurationOfProperties()
    }
    
    func configurationOfProperties(){
        headerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        headerView.layer.cornerRadius = 10
        bodyView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        bodyView.layer.cornerRadius = 10
    }
    
}

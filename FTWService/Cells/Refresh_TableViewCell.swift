//
//  Refresh_TableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import JTMaterialSpinner

class Refresh_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var Refresh: JTMaterialSpinner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        Refresh.circleLayer.lineWidth = 2.0
        Refresh.circleLayer.strokeColor = Constans().blue.cgColor
        Refresh.animationDuration = 1.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  TableViewCell2.swift
//  resources
//
//  Created by MacOs User on 9/27/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var city: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configurationOfProperties()
        
    }
    
    func configureOfData(cellModel:CellModel){
        self.title.text = cellModel.secondCellModel?.label
    }
    
    func configurationOfProperties(){
    
        headerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        headerView.layer.cornerRadius = 18
        bodyView.layer.cornerRadius = 35
    }
    

}

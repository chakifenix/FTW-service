//
//  TableViewCell1.swift
//  resources
//
//  Created by MacOs User on 9/27/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var labelCell: UILabel!
    
    @IBOutlet weak var subtitile: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        configurationOfProperties()
        
    }
    
    
    func configurationOfProperties(){
        headerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        headerView.layer.cornerRadius = 18
        bodyView.layer.cornerRadius = 35
    }
    
    func configureCell(cellModel:CellModel){
        self.labelCell.text = cellModel.firstCellModel?.label
        self.time.text = cellModel.firstCellModel?.time
        self.city.text = cellModel.firstCellModel?.city
        self.subtitile.text = cellModel.firstCellModel?.title
    }
}

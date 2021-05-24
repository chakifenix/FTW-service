//
//  SwitchFilter_TableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class SwitchFilter_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var Main_Image: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Ditail: UILabel!
    @IBOutlet weak var Switch_main: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

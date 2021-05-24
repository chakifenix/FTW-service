//
//  TaskCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var InView: UIView!
    @IBOutlet weak var Сategory: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    @IBOutlet weak var shimmer: UIView!
    @IBOutlet weak var LabelPrice: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.frame = CGRect(x: 0, y: 0, width: 264, height: 228)
        return imageview
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        InView.layer.cornerRadius = 25
        
        
        InView.layer.shadowColor = UIColor.black.cgColor
        InView.layer.shadowRadius = 5
        InView.layer.shadowOpacity = 0.05
        InView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


//
//  Category.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import Foundation
struct Category {
    var id:Int
    var name: String
    var parent_id: Int
    var isSelected = false
    
    init(id:Int,name:String,parent_id:Int) {
        self.id = id
        self.name = name
        self.parent_id = parent_id
    }
    
    init(id:Int,name:String,parent_id:Int,isSelected:Bool) {
        self.id = id
        self.name = name
        self.parent_id = parent_id
        self.isSelected = isSelected
    }
    
}

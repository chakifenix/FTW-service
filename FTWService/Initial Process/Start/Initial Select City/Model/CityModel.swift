//
//  CityModel.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import Foundation

struct CityModel {
    var id:Int
    var name: String
    var lang: String
    var contry_id: Int
    var param: String
    
    init(id:Int,name:String,lang:String,contry_id:Int,param:String) {
        self.id = id
        self.name = name
        self.lang = lang
        self.contry_id = contry_id
        self.param = param
    }
    
}

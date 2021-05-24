//
//  TaskRequest.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import Foundation
class TaskReguest {
    var user_id : Int
    var username : String?
    var avatar: String?
    var userphone : String?
    var userstars_sad : Int
    var userstars_neutral : Int
    var userstars_happy : Int
    var id : Int
    var narrative : String
    var amount : Int
    var selected : Int
    var current: String
    init(user_id : Int, username : String?,avatar:String?,userphone : String?, userstars_sad : Int,userstars_neutral : Int, userstars_happy : Int, id : Int,narrative : String,amount : Int,selected : Int,current:String) {
        self.user_id = user_id
        self.username = username
        self.avatar = avatar
        self.userphone = userphone
        self.userstars_sad = userstars_sad
        self.userstars_neutral = userstars_neutral
        self.userstars_happy = userstars_happy
        self.id = id
        self.narrative = narrative
        self.amount = amount
        self.selected = selected
        self.current = current
    }
}

//
//  AuthModel.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import Foundation
struct LoginModel {
    let id: Int
    let auth_status: String
    let _token: String
    init(json: [String:Any]) {
        id = json["id"] as! Int
        auth_status = json["auth_status"] as! String
        _token = json["_token"] as! String
    }
}
struct IDModel {
    let id: Int?
    let name: String?
    init(id:Int?,name:String?) {
        self.id = id
        self.name = name
    }
}

struct RegisterModel {
    let id: String
    let auth_status: String
    let _token: String
    init(json: [String:Any]) {
        id = json["id"] as! String
        auth_status = json["auth_status"] as! String
        _token = json["_token"] as! String
    }
}
struct SMSModel {
    let check: String
    init(json: [String:Any]) {
        check = json["check"] as! String
    }
}


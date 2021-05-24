//
//  Recources_Data.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class CheckID: Decodable {
    var id: Int?
    var name: String?
    var fname: String?
    var email: String?
    var phone: String?
    
    init(id : Int? , name : String? , fname : String?,email: String?,phone: String?) {
        self.id = id
        self.name = name
        self.fname = fname
        self.email = email
        self.phone = phone
    }
}
struct Task_Data {
    let task: [Task_Resource]
    let param: [Param]
}
struct Task_Resource:Decodable {
    var Id: Int?
    var task: String?
    var cat_id: Int?
    var narrative: String?
    var created_at: String?
    var user_id: Int?
    
    
    init(Id : Int? , task : String? ,cat_id: Int?,narrative: String?,created_at: String?,user_id: Int?) {
        self.Id = Id
        self.task = task
        self.cat_id = cat_id
        self.narrative = narrative
        self.created_at = created_at
        self.user_id = user_id
    }
    
}
struct ParamUser: Decodable{
    var meta_param: String?
    var meta_value: String?
    init(meta_param: String?,meta_value:String?) {
        self.meta_param = meta_param
        self.meta_value = meta_value
    }
}
struct Param: Decodable{
    var param: String?
    var value: String?
    init(param: String?,value:String?) {
        self.param = param
        self.value = value
    }
}
struct UserInfo:Decodable {
    var Id: Int?
    var name: String?
    var fname: String?
    var email: String?
    var phone: String?
    var wallet: Int?
    var avatar: String?
    var status: Bool?
    var sad: Int?
    var neutral: Int?
    var happy: Int?
    var sex: String?
    var city: String?
    var current: String?
    var task_requests: Int?
    var tasks: Int?
    var about: String?
    var birthday: String?
    
    init(json: [String:Any]) {
        Id = json["id"] as? Int
        name = json["name"] as? String
        fname = json["fname"] as? String
        email = json["email"] as? String
        phone = json["phone"] as? String
        wallet = json["wallet"] as? Int
        avatar = json["avatar"] as? String
        status = json["status"] as? Bool
        sad = json["sad"] as? Int
        neutral = json["neutral"] as? Int
        happy = json["happy"] as? Int
        sex = json["sex"] as? String
        city = json["city"] as? String
        current = json["current"] as? String
        task_requests = json["task_requests"] as? Int
        tasks = json["tasks"] as? Int
        about = json["about"] as? String
        birthday = json["birthday"] as? String
    }
    
}
struct UserDetail {
      var title: String?
      var detail:String?
  }
struct UserReviews:Decodable {
    var user_id: Int
    var username: String?
    var avatar: String?
    var like: Int
    var datein: String
    var narrative: String?
    
    
    init(user_id : Int , username : String? ,avatar:String?,like: Int,datein: String,narrative: String?) {
        self.user_id = user_id
        self.username = username
        self.avatar = avatar
        self.like = like
        self.datein = datein
        self.narrative = narrative
    }
    
}
class MainTask {
    var id: Int?
    var task: String?
    var sub_cat_id: Int?
    var sub_cat_name: String?
    var cat_id: String?
    var amount: String?
    var current: String?
    var cdate: String?
    var edate: String?
    var cdate_l: String?
    var level_l: String?
    var work_with: String?
    var city: String?
    var narrative: String?
    init(id : Int? , task : String? , sub_cat_id : Int?,sub_cat_name: String?,cat_id: String?,amount: String?,current: String?,cdate: String?, edate: String?, cdate_l: String?, level_l: String?,work_with: String?,city: String?,narrative: String?) {
        self.id = id
        self.task = task
        self.sub_cat_id = sub_cat_id
        self.sub_cat_name = sub_cat_name
        self.cat_id = cat_id
        self.amount = amount
        self.current = current
        self.cdate = cdate
        self.edate = edate
        self.cdate_l = cdate_l
        self.level_l = level_l
        self.work_with = work_with
        self.city = city
        self.narrative = narrative
    }
}

class BonusActivity {
    var idUser:Int?
    var date:String?
    var value:Int?
    var reason:String?
    var pl_mn: String?
    init(json: [String:Any]) {
        idUser = json["idUser"] as? Int
        date = json["date"] as? String
        value = json["value"] as? Int
        reason = json["reason"] as? String
        pl_mn = json["pl_mn"] as? String
    }
    
    
    
}

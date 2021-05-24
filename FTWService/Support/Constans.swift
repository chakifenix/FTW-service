//
//  Constans.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class Constans {
    static let shared = Constans()
    let Background_Color = UIColor(displayP3Red: 233/255.0, green: 236/255.0, blue: 239/255.0, alpha: 1.0)
    let blue = UIColor(displayP3Red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255, alpha: 1)
    let red = UIColor(displayP3Red: 244/255.0, green: 67/255.0, blue: 54.0/255, alpha: 1)
    let green = UIColor(displayP3Red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255, alpha: 1)
    let grey = UIColor(displayP3Red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255, alpha: 1)
    let userid = UserDefaults.standard.integer(forKey: "ID")
    let userName = UserDefaults.standard.string(forKey: "name")
    let token = UserDefaults.standard.string(forKey: "token")
    let userCountry = UserDefaults.standard.string(forKey: "country")
    let userCity = UserDefaults.standard.string(forKey: "city")
    let API_KEY = "$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS"
    let id_Data = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_task&tasks=all"
    let Get_Data = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_task&tasks=all&status=open"
    let taskUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_task&tasks="
    let Nativ_Key = "ccbf622e-14ed-4808-9f3d-dc25c3d4634a"
    let searchUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_task&tasks=all&search="
    let category = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    let filter_Cat_Id = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_task&tasks=all"
    let cityUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_task&tasks=all&city="
    let createPartner = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=create_partner&"
    let createSale = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=create_partners_sale&"
    let uploadImage = "https://orzu.org/api/avatar"
    let sortPartners = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=partners_list_sort&"
    let partnerList = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=partners_list_all"
    let bonusActivity = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=bonus_list&userid="
    let addBonus = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&"
    let userInfo = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_user&user="

}

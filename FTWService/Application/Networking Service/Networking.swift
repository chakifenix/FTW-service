//
//  Networking.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import Foundation
import Alamofire
class Networking {
    static func getCategory(url: String,id: Int,completion: @escaping (_ category: [Category],_ _ids: [Int]) -> ()) {
        guard let url = URL(string: "\(url)&cat_id=only_subcat&id=\(id)") else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                guard let allCategory = value as? Array<[String: Any]> else {return}
                var category = [Category]()
                var id = Int()
                var ids = [Int]()
                for item in allCategory {
                    let categories = Category(id: (item["id"] as? Int)!,
                                              name: (item["name"] as? String)!,
                                              parent_id: (item["parent_id"] as? Int)!)
                    category.append(categories)
                    id = categories.id
                    ids.append(id)
                    
                }
                completion(category, ids)
            case .failure(let error):
                print(error)
            }
        }
    }
   

    static func deleteRequest(url:String){
        guard let url = URL(string: url) else { return }
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func getCity(url:String,completion: @escaping (_ city: [CityModel]) -> ()) {
        //        id: Int,name: String,lang: String,country_id: Int,param: String
        guard let url = URL(string:url) else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                guard let allCities = value as? Array<[String: Any]> else {return}
                var allCity = [CityModel]()
                
                for item in allCities {
                    let categories = CityModel(id: (item["id"] as? Int)!,
                                               name: (item["name"] as? String)!,
                                               lang: (item["lang"] as? String)!,
                                               contry_id: (item["contry_id"] as? Int)!,
                                               param: (item["param"] as? String)!)
                    
                    allCity.append(categories)
                }
                completion(allCity)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    static func uploadImage(fileUrl: URL,url:String,userId:String,token:String,apikey: String,completion: @escaping (_ result: Any?) -> () ){
        let param = ["userid":userId,"utoken":token,"appid":apikey]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileUrl, withName: "file")
            for (key, value) in param {// this will loop the 'parameters' value, you can comment this if not needed
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:url) { (encodingCompletion) in
            switch encodingCompletion {
            case .success(request: let uploadRequest,
                          streamingFromDisk: _,
                          streamFileURL: _):
                uploadRequest.responseJSON { response in
                    //                    print(response.result.value)
                    completion(response.result.value)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    
    static func uploadCreateTaskImage(fileUrl: URL,url:String,taskId:String){
        let param = ["task_id":taskId]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileUrl, withName: "file")
            for (key, value) in param {// this will loop the 'parameters' value, you can comment this if not needed
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:url) { (encodingCompletion) in
            switch encodingCompletion {
            case .success(request: let uploadRequest,
                          streamingFromDisk: _,
                          streamFileURL: _):
                uploadRequest.responseJSON { response in
                    print(response.result.value)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func getMainTasks(url: String,continueUrl: String,completion: @escaping (_ category: [MainTask]?,_ error: Any?) -> ()) {
        guard let url = URL(string: "\(url)\(continueUrl)") else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                guard let allCategory = value as? Array<[String: Any]> else {
                    completion(nil,value)
                    return
                }
                var allTask = [MainTask]()
                for task in allCategory {
                    let tasks = MainTask(id: task["id"] as? Int,
                                         task:  task["task"] as? String,
                                         sub_cat_id:  task["sub_cat_id"] as? Int,
                                         sub_cat_name:  task["sub_cat_name"] as? String,
                                         cat_id:  task["cat_id"] as? String,
                                         amount:  task["amount"] as? String,
                                         current:  task["current"] as? String,
                                         cdate:  task["cdate"] as? String,
                                         edate:  task["edate"] as? String,
                                         cdate_l:  task["cdate_l"] as? String,
                                         level_l:  task["level_l"] as? String,
                                         work_with:  task["work_with"] as? String,
                                         city:  task["city"] as? String,
                                         narrative:  task["narrative"] as? String)
                    allTask.append(tasks)
                }
                completion(allTask, nil)
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }
    }
    static func getFilterTask(url: String,continueUrl: String,completion: @escaping (_ category: [MainTask]?,_ error: Error?) -> ()) {
        guard let url = URL(string: "\(url)\(continueUrl)") else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                guard let allCategory = value as? [Array<[String: Any]>] else {return}
                var task = [MainTask]()
                for x in allCategory {
                    for i in x {
                        let tasks = MainTask(id: i["id"] as? Int,
                                             task:  i["task"] as? String,
                                             sub_cat_id:  i["sub_cat_id"] as? Int,
                                             sub_cat_name:  i["sub_cat_name"] as? String,
                                             cat_id:  i["cat_id"] as? String,
                                             amount:  i["amount"] as? String,
                                             current:  i["current"] as? String,
                                             cdate:  i["cdate"] as? String,
                                             edate:  i["edate"] as? String,
                                             cdate_l:  i["cdate_l"] as? String,
                                             level_l:  i["level_l"] as? String,
                                             work_with:  i["work_with"] as? String,
                                             city:  i["city"] as? String,
                                             narrative:  i["narrative"] as? String)
                        task.append(tasks)
                    }
                }
                completion(task,nil)
                
            case .failure(let error):
                print(error)
                completion(nil,error)
            }
        }
        
    }
    
    
    static func getPartners(url:String,completion: @escaping (_ category: [Partners]?) -> ()) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                guard let allPartners = value as? Array<[String: Any]> else {
                    completion(nil)
                    return
                }
                var partnerArray = [Partners]()
                for item in allPartners {
                    let partners = Partners(id: (item["id"] as? Int)!
                        , userid: (item["userid"] as? Int)!
                        , name: (item["name"] as? String), discription: (item["discription"] as? String), images: (item["images"] as? String), logo: (item["logo"] as? String), city: (item["city"] as? String), catid: (item["catid"] as? String), percent: (item["percent"] as? String))
                    partnerArray.append(partners)
                }
                completion(partnerArray)
            case .failure(let error):
                print(error)
            }
        }
    }
    static func partnerUrl(url:String,param:[String:String],completion:@escaping (_ result:Any?,_ error:Error?) ->()) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let val):
                print(val)
                completion(val,nil)
            case .failure(let err):
                completion(nil,err)
            }
        }
    }
    static func uploadImages(fileUrl: URL,url:String,param:[String:String],completion: @escaping (_ result: Any?) -> ()){
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileUrl, withName: "file")
            for (key, value) in param {// this will loop the 'parameters' value, you can comment this if not needed
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:url) { (encodingCompletion) in
            switch encodingCompletion {
            case .success(request: let uploadRequest,
                          streamingFromDisk: _,
                          streamFileURL: _):
                uploadRequest.responseJSON { response in
                    completion(response.result.value)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    static func getUserBonusActivity(url:URL,completion:@escaping(_ bonusActivity:[BonusActivity]?) -> ()){
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let result = value as? Array<[String:Any]> else {
                    completion(nil)
                    return
                }
                var bonus = [BonusActivity]()
                for item in result {
                    let array = BonusActivity(json: item)
                    bonus.append(array)
                }
                completion(bonus)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    static func getSaleName(id:Int,completion: @escaping (_ category: [SaleName]) -> ()) {
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=sales_list_my&id=\(id)") else {return}
        Alamofire.request(url,method: .get).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                guard let allPartners = value as? Array<[String: Any]> else {return}
                var saleNameArray = [SaleName]()
                for item in allPartners {
                    let saleName = SaleName(id: item["id"] as? Int, idPartner: item["idPartner"] as? Int, namePartner: item["namePartner"] as? String, sale_name: item["sale_name"] as! String , description: item["description"] as? String, image: item["image"] as? String, partner_city: item["partner_city"] as? String, partners_cat: item["partners_cat"] as? String, partners_subcat: item["partners_subcat"] as? String, sale_percent: item["sale_percent"] as? Int, create_date: item["create_date"] as? String)
                    saleNameArray.append(saleName)
                }
                completion(saleNameArray)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    static func getUserInfo(url:String,id:Int,completion: @escaping (_ result:Any?,_ error:Error?) -> ()) {
        guard let url = URL(string: url + String(id)) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                completion(value,nil)
            case .failure(let error):
                completion(nil,error)
                print(error.localizedDescription)
            }
        }
    }
    



static func getTask(id:Int,completion: @escaping (_ taskcategory: [Task_Resource],_ paramcategory: [Param]) -> ()) {
    guard let urls = URL(string: "\(Constans().taskUrl)\(id)") else {return}
    
    Alamofire.request(urls).validate().responseJSON { (response) in
        switch response.result {
        case .success(let value):
            let tasksArray = value as? [Array<[String:Any]>]
            var taskarray = [Task_Resource]()
            var paramArray = [Param]()
            for item1 in tasksArray![0] {
                let task = Task_Resource(Id: item1["id"] as? Int,
                                         task: item1["task"] as? String,
                                         cat_id: item1["cat_id"] as? Int,
                                         narrative: item1["narrative"] as? String,
                                         created_at: item1["created_at"] as? String,
                                         user_id: item1["user_id"] as? Int)
                taskarray.append(task)
            }
            for item2 in tasksArray![1] {
                let param = Param(param: item2["param"] as? String, value: item2["value"] as? String)
                paramArray.append(param)
                print(paramArray)
            }
            completion(taskarray,paramArray)
        case .failure(let error):
            print(error.localizedDescription)
        }
        
    }
}


}

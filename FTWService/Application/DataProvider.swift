//
//  DataProvider.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
class DataProvider  {
    static var imageCache = NSCache<NSString,UIImage>()
    static var categoryCashe = NSCache<NSString,AnyObject>()
    static func downloadImage(url:URL,completion: @escaping (_ image: UIImage?) -> ()) {
        if let cashedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cashedImage)
        } else {
            if let data =  try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                self.imageCache.setObject(image!, forKey:url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }
        
    }
    static func getCategoryArray(url:String,id:Int,completion: @escaping (_ array: [Category]?) -> ()) {
        if let cashedArray = categoryCashe.object(forKey: (url + "\(id)") as NSString) {
            completion((cashedArray as! [Category]))
        } else {
            Networking.getCategory(url: url, id: id) { (category, id) in
                self.categoryCashe.setObject(category as AnyObject, forKey: (url + "\(id)") as NSString)
                completion(category)
            }
        }
    }
    static func getCasheTask(url:String,continueUrl:String,completion: @escaping (_ array: [MainTask]?,_ error: Error?) -> ()) {
        if let cashedArray = categoryCashe.object(forKey: (url + continueUrl) as NSString) {
            completion(cashedArray as? [MainTask],nil)
        } else {
            Networking.getMainTasks(url: url, continueUrl: continueUrl){ (task, err) in
                if task != nil {
                    self.categoryCashe.setObject(task as AnyObject, forKey: (url + continueUrl) as NSString)
                    completion(task, nil)
                }
                
            }
        }
    }
}

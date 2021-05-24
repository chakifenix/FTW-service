//
//  Notifications.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 2/8/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit
import UserNotifications


class Natifications: NSObject, UNUserNotificationCenterDelegate {
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization(){
        notificationCenter.requestAuthorization(options: [.alert,.sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else {return}
            self.getNotificationSettings()
        }
    }
    
    
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else {return}
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}

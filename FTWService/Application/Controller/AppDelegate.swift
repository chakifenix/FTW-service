//
//  AppDelegate.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 11/22/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import Intercom
import UserNotifications
import YandexMapKit
import Firebase
import FirebaseMessaging
import FirebaseAuth
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var All_Resources: [MainTask]?
    let defaults = UserDefaults.standard
    let notifications = Natifications()
    var boolCheck = true
    var globalID:String?
    let notificationsCenter = UNUserNotificationCenter.current()
    var gradientLayer:CAGradientLayer!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if (launchOptions?[.remoteNotification] as?  [AnyHashable : Any]) != nil {
            
        }
        settingView()
        configureSDK()
        registerForRemoteNotification(application: application)
        return true
    }
    fileprivate func configureSDK() {
        YMKMapKit.setApiKey("38c4c9bc-766a-4574-8088-18a4e7583a90")
        Intercom.setApiKey("ios_sdk-f73bc2a09ced39836ddf3d16349198d5a08edc96", forAppId:"p479kps8")
        Intercom.unreadConversationCount()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        FirebaseApp.configure()
        let Islogin = defaults.bool(forKey: "login")
        let loginId = defaults.integer(forKey: "ID")
        
        if Islogin {
            Intercom.registerUser(withUserId: "\(loginId)")
        } else {
            Intercom.registerUnidentifiedUser()
        }
        if let name = defaults.string(forKey: "name") {
            let userAttributes = ICMUserAttributes()
            userAttributes.name = name
            userAttributes.userId = String(loginId)
            Intercom.updateUser(userAttributes)
        }
        //        // Recommend moving the below line to prompt for push after informing the user about
        //        //   how your app will use them.
        //        notifications.requestAutorization()
        //        notifications.notificationCenter.delegate = notifications
        Messaging.messaging().delegate = self
    }
    
    func registerForRemoteNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    //1316e30fc6ba1a2946da7873e07556b7f6b8bb022f07ed76da7dc12fab2a1879
    //1316e30fc6ba1a2946da7873e07556b7f6b8bb022f07ed76da7dc12fab2a1879
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let firebaseAuth = Auth.auth()
//        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
  

        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        let tokenParts = deviceToken.map { (data) -> String in
            return String(format: "%02.2hhx", data)
        }
              let token = tokenParts.joined()
                print("Device  token: \(token)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Messaging.messaging().shouldEstablishDirectChannel = false
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        Messaging.messaging().shouldEstablishDirectChannel = false
        
    }
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
        // URL not auth related, developer should handle it.
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
        print(userInfo)
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification support is unavailable due to error: \(error)")
    }
   
}




extension AppDelegate {
    func settingView() {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UISearchBar.appearance().backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 0.8470588235)
        UISearchBar.appearance().barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 0.8470588235)
        UISearchBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UIApplication.shared.statusBarStyle = .lightContent
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
    }
}





extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NotifyData.shared.arrays = UserDefaults.standard.object(forKey: "SaveData") as? [String:String] ?? [String:String]()
        var checkForSave = true
        var id:String?
        var badge:String?
        var title:String?
        var city:String?
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary{
                badge = alert["body"] as? String
                title = alert["title"] as? String
            }
        }
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        if let ID = userInfo["ID"] as? String{
            id = ID
            NotifyData.shared.idOffTask = ID
        }
        if let parseCity = userInfo["city"] as? String{
            city = parseCity
        }
         print("ios10 willPresent notification: ", userInfo)


//        if id![0..<3] != "my."{
//        print(id![3...])
//        var new = title?.components(separatedBy: ":")

//        }
        if title! == "Подписка"{
            boolCheck = false
            checkForSave = true
        }else{
            boolCheck = true
            checkForSave = true
            let badgeSplit =  badge!.split(separator: " ")
            if badgeSplit[0] != "Вас"{
            let endOfSentence = id!.firstIndex(of: ".")!
            let firstSentence = id![...endOfSentence]
            if firstSentence == "my."{
                let endOfSentence = id!.split(separator: ".")
                id = String(endOfSentence[1])
                guard let item = id else {return}
                self.globalID = item
                }
            }else{
                checkForSave = false
            }
        }
        if checkForSave{
            NotifyData.shared.arrays.updateValue("\(title!), \(badge!)", forKey: "\(id!), \(city!), \(dateString)")
            NotifyData.shared.saveToTheUserDefaults()
        }
         completionHandler([.alert, .badge, .sound])
        print("ios10 willPresent notification: ", userInfo)
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let notifyInfo = response.notification.request.content.userInfo
        print(notifyInfo)
        print("sadgkfjdsklgjdlkfjglkdjgdklsgjfkldsjgl")
//        handlePushNotification()
    }
    
    fileprivate func handlePushNotification() {
        var array = [MainTask]()
        let queue = DispatchQueue.init(label: "labels",attributes: .concurrent)
        queue.async {
            Networking.getMainTasks(url: Constans().Get_Data, continueUrl: "&page=1") { (task,err)  in
                guard let resource = task else {return}
                array =  resource
                let idtask = IDTaskViewController()
                let index = array[0].id!
                idtask.hidesBottomBarWhenPushed = true
                idtask.index = index
                idtask.navigationItem.largeTitleDisplayMode = .never
                idtask.title = "Задания №\(array[0].id!)"
                if array[0].cdate == nil && array[0].work_with == nil{
                    idtask.dateT = array[0].cdate_l! ?? "нет данных"
                } else if array[0].cdate == nil  && array[0].cdate_l == nil {
                    idtask.dateT = "Дата по договоренности"}
                else if array[0].cdate_l == nil && array[0].work_with == nil && array[0].edate != nil {
                    idtask.dateT = "с \(array[0].cdate!) - до \(array[0].edate!)"}
                else if array[0].cdate == nil  && array[0].cdate_l == nil && array[0].edate == nil {
                    idtask.dateT = "c \(array[0].cdate!)"}
                if array[0].amount == "Предложите цену" {
                    idtask.amount = array[0].amount! ?? "нет данных"
                } else {
                    guard let current = array[0].current else {return}
                    idtask.amount = "\(array[0].amount!) \(current)" ?? "нет данных"}
                idtask.Title = array[0].task ?? "нет данных"
                idtask.taskIndex = array[0].id!
                idtask.taskId = String(array[0].id!)
                if self.boolCheck {
                    let listOffer = ListOfferViewController()
                    listOffer.taskId = self.globalID! ?? String(index)
                    let vc = TabBarViewController()
                    self.window?.rootViewController = vc
                    let nav = vc.viewControllers?.first as? UINavigationController
                    nav?.navigationController?.pushViewController(idtask, animated: true)
                    nav?.visibleViewController?.navigationController?.show(listOffer, sender: self)
                    print("doesn't this")
                }else{
                    let vc = TabBarViewController()
                    self.window?.rootViewController = vc
                    let nav = vc.viewControllers?.first as? UINavigationController
                    nav?.pushViewController(idtask, animated: true)
                    //                print(resource[0])
                }
            }
        }
    }
    
    
    
}

extension AppDelegate : MessagingDelegate{
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}




class NotifyData{
     static let shared = NotifyData()
    var arrays = [String:String]()
    var idOffTask:String?
    func saveToTheUserDefaults(){
        var userDefaults = UserDefaults.standard
       userDefaults.set(NotifyData.shared.arrays, forKey: "SaveData")
    }

}


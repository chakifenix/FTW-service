//
//  TabBarController.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 5/1/20.
//  Copyright © 2020 Orzu. All rights reserved.
//


import UIKit

class TabBarViewController: UITabBarController {
    
    //    MARK: - Properties
    let addTabbarController = UIViewController().inNavigation()
    
    lazy var menuButton: UIButton = {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.backgroundColor = Data_Colors.mainColor
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.setImage(UIImage(named: "plusko"), for: .normal)
//           menuButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return menuButton
    }()
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNav()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        menuButton.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tabBarController?.view.bringSubviewToFront(menuButton)
    }
    
    //MARK: - setupviews
    func setupViews() -> Void {
        let mainController = MainViewController().inNavigation()
        mainController.tabBarItem = UITabBarItem.init(title: "Найти задание", image: #imageLiteral(resourceName: "interface").changeSize(scaledTo: CGSize(width: 24, height: 24)), tag: 0)
        
        let myTaskController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTableTask") as! UINavigationController
        myTaskController.tabBarItem = UITabBarItem.init(title: "Мои задания", image: #imageLiteral(resourceName: "interface (1)").changeSize(scaledTo: CGSize(width: 24, height: 24)), tag: 1)
        
        addTabbarController.tabBarItem.image = nil
        let createTaskController = InCategoryViewController().inNavigation()
        createTaskController.tabBarItem = UITabBarItem.init(title: "Создать задание", image: #imageLiteral(resourceName: "plusko").changeSize(scaledTo: CGSize(width: 24, height: 24)), tag: 0)
        let notificationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "green") as! UINavigationController
        notificationController.tabBarItem = UITabBarItem.init(title: "Уведомления", image: #imageLiteral(resourceName: "bell"), tag: 3)
        
        
        let profileController = UserProfileViewController().inNavigation()
        profileController.tabBarItem = UITabBarItem.init(title: "Профиль", image: #imageLiteral(resourceName: "profileWhite").changeSize(scaledTo: CGSize(width: 24, height: 24)), tag: 4)
        
        viewControllers = [mainController, myTaskController,createTaskController,notificationController, profileController]
//        setupMiddleButton()
    }
    
    func setupNav() -> Void {
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.384, green: 0.384, blue: 0.384, alpha: 1)
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor =  #colorLiteral(red: 0.2124414444, green: 0.8114148974, blue: 0.6365436912, alpha: 1)
        
    }
    func setupMiddleButton() {
         view.addSubview(menuButton)
         view.layoutIfNeeded()
     }
    
    
    //    MARK: - Tabbar delegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        if viewController == addTabbarController {
//            return false
//        }
        
        return true
    }
    
    //MARK: - actions
//    @objc func buttonAction() -> Void {
//        selectedIndex = 2
//    }
}



////
////  BounsViewController.swift
////  OrzuServiceProject
////
////  Created by MacOs User on 12/5/19.
////  Copyright © 2019 Orzu. All rights reserved.
////
//
import UIKit
import Alamofire
class BonusViewController: UIViewController {
    
    let firstChildVC = FirstViewContainerVC()
    let secondChildVC = SecondContainerVC()

    var changer = true
    var subChanger = true
    var charbool = true
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blueFon")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    private let triangle1: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tran")
        image.isHidden = false
        return image
    }()
    
    
    private let triangle2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tran")
        image.isHidden = true
        return image
    }()
    
    private let chooseBtn1: UIButton = {
        let button = UIButton()
        button.setTitle("Стать участником", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(choosePlaceAction), for: .touchUpInside)
        //        button.addTarget(self, action: #selector(remoteButtonAction), for: .touchUpInside)
        //        button.alpha = 0
        return button
    }()
    
    private let chooseBtn2: UIButton = {
        let button = UIButton()
        button.setTitle("Указать период", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        button.addTarget(self, action: #selector(remoteButtonAction), for: .touchUpInside)
        //        button.alpha = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func viewSettings() {
        navigationItem.title = "Бонусы"
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setSecondChildVCConstraints(vc: firstChildVC.view)
        viewSettings()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
//    func sideMenuConfigure(_ viewcontroller:UIViewController) {
//        SideMenuManager.default.menuPresentMode = .menuSlideIn
//        let rightMenuNavigationController = UISideMenuNavigationController(rootViewController: viewcontroller)
//        rightMenuNavigationController.menuWidth = 275
//        SideMenuManager.default.menuRightNavigationController = rightMenuNavigationController
//        SideMenuManager.default.menuAnimationFadeStrength = 0.6
//        SideMenuManager.default.menuShadowOpacity = 0.1
//        SideMenuManager.defaultManager.menuFadeStatusBar = false
//        self.present(SideMenuManager.default.menuRightNavigationController!, animated: true)
//    }
  
    func addSecondChildVC(vc:UIViewController){
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        setSecondChildVCConstraints(vc: vc.view)
    }
    func deleteFunc(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    
    @objc func choosePlaceAction() {
        chooseBtn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        triangle1.isHidden = false
        triangle2.isHidden = true
        changer = true
        deleteFunc(vc: secondChildVC)
        addSecondChildVC(vc: firstChildVC)
    }
    
    
    @objc func remoteButtonAction() {
        chooseBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        triangle1.isHidden = true
        triangle2.isHidden = false
        changer = false
        deleteFunc(vc: firstChildVC)
        addSecondChildVC(vc: secondChildVC)
        print("22")

    }
    func setSecondChildVCConstraints(vc:UIView){
        cardView.addSubview(vc)
        vc.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardView.snp.top).offset(10)
            make.left.equalTo(self.cardView.snp.left).offset(10)
            make.right.equalTo(self.cardView.snp.right).offset(-10)
            make.bottom.equalTo(self.cardView.snp.bottom).offset(-10)
        }
    }
    func setupConstraint(){
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(firstChildVC.view)
        bgView.addSubview(chooseBtn1)
        bgView.addSubview(chooseBtn2)
        bgView.addSubview(triangle1)
        bgView.addSubview(triangle2)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        chooseBtn1.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(32)
            make.height.equalTo(20)
        }
        chooseBtn2.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(chooseBtn1.snp.right).offset(32)
            make.height.equalTo(20)
        }
        
        triangle1.snp.makeConstraints { (make) in
            make.top.equalTo(chooseBtn1.snp.bottom).offset(1)
            make.centerX.equalTo(chooseBtn1.snp.centerX)
            make.size.equalTo(CGSize(width: 25, height: 16))
        }
        triangle2.snp.makeConstraints { (make) in
            make.top.equalTo(chooseBtn2.snp.bottom).offset(1)
            make.centerX.equalTo(chooseBtn2.snp.centerX)
            make.size.equalTo(CGSize(width: 25, height: 16))
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}

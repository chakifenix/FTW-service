//
//  AnketaViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire
class AnketaViewController: UIViewController {
    let uploadImageUrl = "https://orzu.org/api/avatar"
    let bonusUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=edit_bonus_minus&"
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let cardView: AnimateView = {
        let view = AnimateView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    private let views: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let lineview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    private let lineview2: UIView = {
        let view = UIView()
        view.backgroundColor = Data_Colors.gradientColor
        return view
    }()
    private let gobutton: UIButton = {
        let button = UIButton()
        button.setTitle("Опубликовать", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    private let taskName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "5000"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "| За услугу"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let locationText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Алматы"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let dateText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "27.05.1998"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let amountText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Напрямую исполнителю"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let narrativeText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "красава"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize.height = 700
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = true
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    let userImage:UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 32
        return view
    }()
    let userName:UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    let createrTaskLabel:UILabel = {
        let label = UILabel()
        label.text = "Заказчик"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let Userviews: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Data_Colors.gradientColor.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = imageArray!.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return pc
    }()
    let GoodiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "greenGood")
        return image
    }()
    let NormaliconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "brownNormal")
        image.isUserInteractionEnabled = true
        return image
    }()
    let BadiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "redBad")
        image.isUserInteractionEnabled = true
        return image
    }()
    let SumGoodIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "1"
        return label
    }()
    let SumNormalIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "1"
        return label
    }()
    let SumBadIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "0"
        return label
    }()
    let scrollViewImage: UIView = {
        let v = UIView()
        v.backgroundColor = Data_Colors.mainColor
        return v
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        return collectionView
    }()
    
    var heightLabel:CGFloat = 0
    var imageArray:[UIImage]?
    var pathArray:[PickerArrayModel]?{
        didSet{
            print(pathArray)
        }
    }
    var cashText = ""
    var location = ""
    var nameText = ""
    var tasknameText = ""
    var textDate = ""
    var narrative = ""
    var wallet:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIDURL()
        let name = UserDefaults.standard.string(forKey: "name")
        userName.text = name
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AnketaImageCollectionViewCell.self, forCellWithReuseIdentifier: "anketaImages")
        heightLabel = narrativeText.heightForLabel(text: narrative, font: UIFont.systemFont(ofSize: 15), width: UIScreen.main.bounds.width - 32)
        print("Height\(heightLabel)")
        scrollView.contentSize.height = 700 + heightLabel
        createViews()
        taskName.text = tasknameText
        cashLabel.text = cashText
        dateText.text = textDate
        narrativeText.text = narrative
        locationText.text = location
        userImage.image = PassData.cachImage
        bonusItem(bonus: PassData.wallet)
        print(scrollView.contentSize.height)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gobutton.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    private func createViews() {
        let locationstackView = UIStackView()
        locationstackView.axis = .vertical
        locationstackView.distribution = .fill
        locationstackView.alignment = .fill
        locationstackView.spacing = 6
        
        let amountstackView = UIStackView()
        amountstackView.axis = .vertical
        amountstackView.distribution = .fill
        amountstackView.alignment = .fill
        amountstackView.spacing = 6
        
        let datestackView = UIStackView()
        datestackView.axis = .vertical
        datestackView.distribution = .fill
        datestackView.alignment = .fill
        datestackView.spacing = 6
        
        let narrativestackView = UIStackView()
        narrativestackView.axis = .vertical
        narrativestackView.distribution = .fill
        narrativestackView.alignment = .fill
        narrativestackView.spacing = 6
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.alignment = .fill
        mainStackView.spacing = 20
        
        let labelLocation = UILabel()
        labelLocation.text = "Адрес"
        labelLocation.textColor = .lightGray
        labelLocation.font = UIFont.systemFont(ofSize: 15)
        
        let labelDate = UILabel()
        labelDate.text = "Начать"
        labelDate.textColor = .lightGray
        labelDate.font = UIFont.systemFont(ofSize: 15)
        
        let labelAmount = UILabel()
        labelAmount.text = "Оплата"
        labelAmount.textColor = .lightGray
        labelAmount.font = UIFont.systemFont(ofSize: 15)
        
        let labelNarrative = UILabel()
        labelNarrative.text = "Нужно"
        labelNarrative.textColor = .lightGray
        labelNarrative.font = UIFont.systemFont(ofSize: 15)
        
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(scrollView)
        
        scrollView.addSubview(views)
        views.addSubview(lineview)
        views.addSubview(gobutton)
        views.addSubview(mainStackView)
        views.addSubview(taskName)
        views.addSubview(collectionView)
        views.addSubview(cashLabel)
        views.addSubview(serviceLabel)
        views.addSubview(lineview2)
        views.addSubview(Userviews)
        views.addSubview(pageControl)
        views.addSubview(createrTaskLabel)
        Userviews.addSubview(userImage)
        Userviews.addSubview(userName)
        Userviews.addSubview(BadiconLike)
        Userviews.addSubview(NormaliconLike)
        Userviews.addSubview(GoodiconLike)
        Userviews.addSubview(SumBadIcon)
        Userviews.addSubview(SumGoodIcon)
        Userviews.addSubview(SumNormalIcon)
        mainStackView.addArrangedSubview(locationstackView)
        mainStackView.addArrangedSubview(datestackView)
        mainStackView.addArrangedSubview(amountstackView)
        mainStackView.addArrangedSubview(narrativestackView)
        
        locationstackView.addArrangedSubview(labelLocation)
        locationstackView.addArrangedSubview(locationText)
        amountstackView.addArrangedSubview(labelAmount)
        amountstackView.addArrangedSubview(amountText)
        datestackView.addArrangedSubview(labelDate)
        datestackView.addArrangedSubview(dateText)
        narrativestackView.addArrangedSubview(labelNarrative)
        narrativestackView.addArrangedSubview(narrativeText)
        print("Nar\(narrativestackView.frame.height)")
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.8)
        }
        
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.leading.equalTo(cardView.snp.leading)
            make.trailing.equalTo(cardView.snp.trailing)
            make.bottom.equalTo(cardView.snp.bottom)
        }
        views.snp.makeConstraints { (make) in
            let width = Double(scrollView.contentSize.width)
            let height = Double(scrollView.contentSize.height)
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        taskName.snp.makeConstraints { (make) in
            make.top.equalTo(views.snp.top).offset(24)
            make.left.equalTo(views.snp.left).offset(24)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        cashLabel.snp.makeConstraints { (make) in
            make.top.equalTo(taskName.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        serviceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cashLabel.snp.top)
            make.left.equalTo(cashLabel.snp.right).offset(6)
        }
        
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(serviceLabel.snp.bottom).offset(12)
            make.left.equalTo(views.snp.left).offset(24)
            make.right.equalTo(views.snp.right).offset(-24)
            make.height.equalTo(1)
        }
        
        if (imageArray!.count>0){
            collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(lineview.snp.bottom).offset(4)
                make.left.equalTo(views.snp.left).offset(24)
                make.right.equalTo(views.snp.right).offset(-24)
                make.height.equalTo(160)
            }
            pageControl.snp.makeConstraints { (make) in
                make.left.equalTo(views.snp.left).offset(24)
                make.right.equalTo(views.snp.right).offset(-24)
                make.bottom.equalTo(collectionView.snp.bottom).offset(-5)
                make.height.equalTo(10)
            }
            mainStackView.snp.makeConstraints { (make) in
                make.top.equalTo(collectionView.snp.bottom).offset(16)
                make.left.equalTo(views.snp.left).offset(24)
                make.right.equalTo(views.snp.right).offset(-24)
            }
        }else{
            mainStackView.snp.makeConstraints { (make) in
                make.top.equalTo(lineview.snp.bottom).offset(16)
                make.left.equalTo(views.snp.left).offset(24)
                make.right.equalTo(views.snp.right).offset(-24)
            }
        }
        
        lineview2.snp.makeConstraints { (make) in
            make.top.equalTo(mainStackView.snp.bottom).offset(12)
            make.left.equalTo(views.snp.left).offset(24)
            make.right.equalTo(views.snp.right).offset(-24)
            make.height.equalTo(1)
        }
        createrTaskLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview2.snp.bottom).offset(12)
            make.left.equalTo(lineview2.snp.left)
        }
        Userviews.snp.makeConstraints { (make) in
            make.top.equalTo(createrTaskLabel.snp.bottom).offset(12)
            make.left.equalTo(lineview2.snp.left)
            make.right.equalTo(lineview2.snp.right)
            make.height.equalTo(80)
        }
        userImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(Userviews.snp.centerY)
            make.left.equalTo(Userviews.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        userName.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.top).offset(4)
            make.left.equalTo(userImage.snp.right).offset(16)
            make.right.equalTo(Userviews.snp.right).offset(-16)
        }
        gobutton.snp.makeConstraints { (make) in
            make.top.equalTo(Userviews.snp.bottom).offset(32)
            make.left.equalTo(views.snp.left).offset(24)
            make.right.equalTo(views.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        BadiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(userName.snp.bottom).offset(8)
            make.left.equalTo(userName.snp.left)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumBadIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(BadiconLike.snp.centerY)
            make.left.equalTo(BadiconLike.snp.right).offset(4)
        }
        NormaliconLike.snp.makeConstraints { (make) in
            make.top.equalTo(BadiconLike.snp.top)
            make.left.equalTo(SumBadIcon.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumNormalIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(NormaliconLike.snp.centerY)
            make.left.equalTo(NormaliconLike.snp.right).offset(4)
        }
        GoodiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(NormaliconLike.snp.top)
            make.left.equalTo(SumNormalIcon.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumGoodIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(GoodiconLike.snp.centerY)
            make.left.equalTo(GoodiconLike.snp.right).offset(4)
        }
        
    }
    func bonusItem(bonus:String) {
        let bonus = UIBarButtonItem(title: bonus, style: .plain, target: self, action: #selector(bonusAction))
        navigationItem.rightBarButtonItem = bonus
    }
    @objc func bonusAction() {
        
    }
    @objc func buttonPressed() {
        self.showLoader()
        self.view.isUserInteractionEnabled = false
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=input_task&") else {return}
        var param = [String:String]()
        _ = PassData.category
        _ = PassData.podCategory
        let idCat =  PassData.podCategorID
        let task = PassData.createTask
        let location = PassData.location
        let startDay = PassData.startdayTask
        let finishDay = PassData.finishdayTask
        let cash = PassData.cashTask
        let remote = PassData.wtasker
        let exactTime = PassData.selectedIndexDay
        let exactDay = PassData.exactDay
        let loginId = UserDefaults.standard.integer(forKey: "ID")
        let token = UserDefaults.standard.string(forKey: "token")
        if remote != "wtasker" && exactDay == "" && exactTime == "" {
            if location == "Удаленно" {
                if cash == "wtasker" {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"period","periodA":startDay,"periodB":finishDay,"location":"remote","price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"period","periodA":startDay,"periodB":finishDay,"location":"remote","price":"indicate","priceVal":cash,"utoken":token!]
                }
            } else {
                if cash == "wtasker"{
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"period","periodA":startDay,"periodB":finishDay,"location":"indicate","locationVal":location,"price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"period","periodA":startDay,"periodB":finishDay,"location":"indicate","locationVal":location,"price":"indicate","priceVal":cash,"utoken":token!]
                }
            }
        }
        else if exactDay != "" && exactTime != "" {
            if location == "Удаленно" {
                if cash == "wtasker"{
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"exact","exactD":exactDay,"exactT":exactTime,"location":"remote","price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"exact","exactD":exactDay,"exactT":exactTime,"location":"remote","price":"indicate","priceVal":cash,"utoken":token!]
                }
                print("OKKK")
            }
            else {
                if cash == "wtasker"{
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"exact","exactD":exactDay,"exactT":exactTime,"location":"indicate","locationVal":location,"price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":"exact","exactD":exactDay,"exactT":exactTime,"location":"indicate","locationVal":location,"price":"indicate","priceVal":cash,"utoken":token!]
                }
            }
        }
        else if remote == "wtasker" {
            if location == "Удаленно" {
                if cash == "wtasker"{
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":remote,"location":"remote","price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":remote,"location":"remote","price":"indicate","priceVal":cash,"utoken":token!]
                }
            } else {
                if cash == "wtasker"{
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":remote,"location":"indicate","locationVal":location,"price":"wtasker","utoken":token!]
                } else {
                    param = ["task": task, "catid": "\(idCat)", "narrative": narrative,"userid":"\(loginId)","date":remote,"location":"indicate","locationVal":location,"price":"indicate","priceVal":cash,"utoken":token!]
                }
            }
        }
  
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                if self.pathArray!.count>0{
                    let id = value as? String
                    let array = id?.split(separator: ":")
                    guard let taskId = array?[1] else {return}
                    for i in self.pathArray!{
                        let fileUrl = i.pathImage
                        let queue = DispatchQueue.init(label: "UploadImage",attributes: .concurrent)
//                        DispatchQueue.concurrentPerform(iterations: self.pathArray!.count, execute: { (index) in
//                            print(Thread.current)
//                            Networking.uploadCreateTaskImage(fileUrl: fileUrl, url: self.uploadImageUrl, taskId: String(taskId))
//                        })
                        queue.async {
                            print(Thread.current)
                            Networking.uploadCreateTaskImage(fileUrl: fileUrl, url: self.uploadImageUrl, taskId: String(taskId))
                        }
                    }
                }
                    self.showLoader()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "natification")
                self.present(controller, animated: true, completion: {
                    self.hideLoader()
                })
                //                if (value as? String) == "User token error"{
                //                    print("toast")
                //                }else{
                //
                //
                //
            //                }
            case .failure(let error):
                print(error)
            }
        }
    
    }
    func minusBonus(id:Int,token:String) {
        guard let url = URL(string: bonusUrl) else {return}
        let param = ["userid":String(id),"utoken":token]
        Alamofire.request(url,method: .get,parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func checkIDURL() {
        let id = UserDefaults.standard.integer(forKey: "ID")
        guard let chechIdUrl = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_user&user=\(id)&param=more") else {return}
        Alamofire.request(chechIdUrl).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let item1 =  value as! [String:Any]
                let user = UserInfo(json: item1)
                self.SumBadIcon.text = String(user.sad!)
                self.SumNormalIcon.text = String(user.neutral!)
                self.SumGoodIcon.text = String(user.happy!)
                let urlString = "https://orzu.org\(user.avatar!)"
                self.wallet = user.wallet!
                guard let url = URL(string: urlString) else{return}
                DataProvider.downloadImage(url: url, completion: { (image) in
                    self.userImage.image = image
                })
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x/collectionView.frame.width)
    }
    
    
}


extension AnketaViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "anketaImages", for: indexPath) as! AnketaImageCollectionViewCell
        cell.imageview.image = imageArray![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        performZoomInForStartingImageView(startingImageView: imageArray![indexPath.row])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUpZoom") as! ZoomPhotoViewController
        //        self.addChild(popUpVC) // 2
        ////        popUpVC.view.frame = self.view.frame  // 3
        //        self.view.addSubview(popUpVC.view) // 4
        popUpVC.zoomImage = imageArray![indexPath.row]
        self.show(popUpVC, sender: self)
    }
    
    
}


extension AnketaViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
}

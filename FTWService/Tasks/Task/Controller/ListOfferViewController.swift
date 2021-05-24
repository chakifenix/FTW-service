//
//  ListOfferViewController.swift
//  resources
//
//  Created by MacOs User on 8/29/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Alamofire
class ListOfferViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,buttonAction {
    
    let taskUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=task_requests&act=view&task_id="
    let chooseUserUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=task_requests&act=selected&"
    let reviewsView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    let cardView:UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .white
                view.clipsToBounds = true
                view.layer.cornerRadius = 40
                view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    let bluewView:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Green")
        return image
    }()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    var taskId = ""
    var isChoosen = false
    var taskArray = [TaskReguest]()
    var selected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Мои отклики"
        reviewsView.delegate = self
        reviewsView.dataSource = self
        reviewsView.isScrollEnabled = true
        reviewsView.separatorInset = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 0)
        reviewsView.tableFooterView = UIView()
        parseJson()
        configureSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        //        navigationController?.navigationBar.barTintColor = .clear
        
    }
    func configureSettings() {
        self.view.addSubview(bluewView)
        self.view.addSubview(cardView)
        cardView.addSubview(reviewsView)
        reviewsView.register(AllOffer.self, forCellReuseIdentifier: "offers")
        bluewView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        reviewsView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.height.equalTo(cardView.snp.height)
        }
        
        
    }
    func action(at indexPath: IndexPath) {
        guard let url = URL(string: "\(chooseUserUrl)") else {return}
        print(taskArray[indexPath.row].id)
        let token = UserDefaults.standard.string(forKey: "token")
        print(token!)
        let param = ["req_id":String(taskArray[indexPath.row].id),"utoken":Constans().token!,"userid":String(Constans().userid)]
        Alamofire.request(url,method: .get,parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.showSuccess("Вы выбрали исполнителя!")
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "Response status code was unacceptable: 500." {
                    self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                }
            }
        }
        isChoosen = true
        reviewsView.reloadData()
    }
    
    func callphoneAction(at indexPath: IndexPath) {
        guard let phone = taskArray[indexPath.row].userphone else {return}
        dialNumber(number: phone)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if taskArray.count == 0{
            tableView.setEmptyView(name: "noResultColor", message: "У вас нету отклика")
        }else{
            tableView.restoreView()
        }
        return taskArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offers", for: indexPath) as! AllOffer
        cell.aboutMe.text = taskArray[indexPath.row].username!
        cell.descrMe.text = taskArray[indexPath.row].narrative
        cell.SumBadIcon.text = String(taskArray[indexPath.row].userstars_sad)
        cell.SumNormalIcon.text = String(taskArray[indexPath.row].userstars_neutral)
        cell.SumGoodIcon.text = String(taskArray[indexPath.row].userstars_happy)
        cell.cash.text = String(taskArray[indexPath.row].amount) + " " + taskArray[indexPath.row].current
        cell.image1.set(imageUrl: "https://orzu.org\(taskArray[indexPath.row].avatar!)")
        cell.delegate = self
        cell.indexPath = indexPath
        if isChoosen {
            cell.selectButton.isHidden = true
        }
        if selected == true {
            if taskArray[indexPath.row].selected == 1 {
                cell.selectButton.isHidden = true
                cell.callButton.isHidden = false
            }
            else{
                cell.selectButton.isHidden = true
                cell.callButton.isHidden = true
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if heightarray[indexPath.row] < 20 {
            return 120
        } else {
            return 120 + (heightarray[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userVC = UserIDProfileViewController()
        userVC.userID = taskArray[indexPath.row].user_id
        userVC.UsernameString = taskArray[indexPath.row].username ?? "User"
        self.show(userVC, sender: self)
    }
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    //TODO: Error
    var heightarray = [CGFloat]()
    func parseJson() {
        guard let url = URL(string: "\(taskUrl)\(taskId)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let json = (value as? Array<[String:Any]>) else {
                    return
                }
                for item in json {
                    let array = TaskReguest(user_id: item["user_id"] as! Int,
                                            username: item["username"] as? String,
                                            avatar: item["avatar"] as? String,
                                            userphone: item["userphone"] as? String,
                                            userstars_sad: item["userstars_sad"] as! Int,
                                            userstars_neutral: item["userstars_neutral"] as! Int,
                                            userstars_happy: item["userstars_happy"] as! Int,
                                            id: item["id"] as! Int,
                                            narrative: item["narrative"] as! String,
                                            amount: item["amount"] as! Int,
                                            selected: item["selected"] as! Int,
                                            current: item["current"] as? String ?? "")
                    if array.username != nil {
                        self.taskArray.append(array)
                    }
                    DispatchQueue.main.async {
                        self.reviewsView.reloadData()
                    }
                }
                for item in self.taskArray {
                    if item.selected == 1 {
                        self.selected = true
                    }
                    let size = UILabel().heightForLabel(text: item.narrative, font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 84)
                    print(size)
                    self.heightarray.append(size)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
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
protocol buttonAction {
    func action(at indexPath:IndexPath)
    func callphoneAction(at indexPath:IndexPath)
}
class AllOffer: UITableViewCell {
    let image1: WebImage = {
        let image = WebImage()
        image.image = UIImage(named: "profileWhite")
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        return image
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "coolSmile")
        return image
    }()
    let NormaliconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "normalSmile")
        image.isUserInteractionEnabled = true
        return image
    }()
    let BadiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "badSmile")
        image.isUserInteractionEnabled = true
        return image
    }()
    let aboutMe:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Имя Фамилья"
        return label
    }()
    //    let dateRev:UILabel = {
    //        let label = UILabel()
    //        label.textColor = .lightGray
    //        label.font = UIFont(name: "Roboto-Regular", size: 11)
    //        label.text = "25 августа 2019"
    //        return label
    //    }()
    let descrMe: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "Безопасная оплата картой и гарантия возврата денег.Компенсация в случае морального ущерба"
        label.numberOfLines = 0
        return label
    }()
    //    let categor:UILabel = {
    //        let label = UILabel()
    //        label.textColor = .lightGray
    //        label.font = UIFont(name: "Roboto-Regular", size: 10)
    //        label.text = "Категория:"
    //        return label
    //    }()
    //    let Namecategor:UILabel = {
    //        let label = UILabel()
    //        label.textColor = .lightGray
    //        label.font = UIFont(name: "Roboto-Regular", size: 10)
    //        label.text = "Maстер на час"
    //        return label
    //    }()
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
    let selectButton:UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать исполнителя", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1), for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12.5
        return button
    }()
    let callButton:UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 12.5
        return button
    }()
    let cash:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "5000"
        return label
    }()
    var delegate: buttonAction?
    var indexPath:IndexPath?
    var isChoosen = false
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image1)
        addSubview(iconLike)
        addSubview(SumGoodIcon)
        //        addSubview(Namecategor)
        //        addSubview(categor)
        addSubview(descrMe)
        addSubview(aboutMe)
        //        addSubview(dateRev)
        addSubview(NormaliconLike)
        addSubview(BadiconLike)
        addSubview(SumBadIcon)
        addSubview(SumNormalIcon)
        addSubview(selectButton)
        addSubview(cash)
//        addSubview(usluga)
        addSubview(callButton)
        configureViews()
        callButton.isHidden = true
        selectButton.isHidden = false
        selectButton.addTarget(self, action: #selector(chooseUser), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        
    }
    @objc func chooseUser(_ sender:UIButton) {
        guard let index = indexPath else {
            return
        }
        isChoosen = true
        selectButton.isHidden = true
        callButton.isHidden = false
        self.delegate?.action(at: index)
    }
    @objc func callPhone(_ sender:UIButton) {
        guard let index = indexPath else {
            return
        }
        self.delegate?.callphoneAction(at: index)
    }
    func configureViews() {
        image1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        aboutMe.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(image1.snp.right).offset(12)
        }
        descrMe.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.bottom).offset(10)
            make.left.equalTo(aboutMe.snp.left)
            make.right.equalToSuperview().offset(-16)
        }
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumGoodIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconLike.snp.centerY)
            make.right.equalTo(iconLike.snp.left).offset(-6)
        }
        NormaliconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalTo(SumGoodIcon.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumNormalIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(NormaliconLike.snp.centerY)
            make.right.equalTo(NormaliconLike.snp.left).offset(-6)
        }
        BadiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalTo(SumNormalIcon.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumBadIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(BadiconLike.snp.centerY)
            make.right.equalTo(BadiconLike.snp.left).offset(-6)
        }
        cash.snp.makeConstraints { (make) in
            make.top.equalTo(descrMe.snp.bottom).offset(8)
            make.left.equalTo(aboutMe.snp.left)
        }
//        usluga.snp.makeConstraints { (make) in
//            make.top.equalTo(cash.snp.top)
//            make.left.equalTo(cash.snp.right).offset(4)
//        }
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cash.snp.centerY)
            make.right.equalTo(iconLike.snp.right)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(30)
        }
        callButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(cash.snp.centerY)
            make.right.equalTo(iconLike.snp.right)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(30)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//  FollowCategoryViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import SnapKit
import Alamofire
//Pod
class SubFollowCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let tableview: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blueFon")
        return view
    }()
    let label: UILabel = {
        let label = UILabel()
        label.text = "Категории"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Cохранить", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return button
    }()
    var podCategory = [Category](){
        didSet{
            isCheceked = [Bool](repeatElement(false, count: podCategory.count))
            
        }
    }
    var saveSomeIDArray = [Int:String]()
    var newBoolArray = [Bool]()
    var parentId:String = ""
    var catMassive = [String:String]()
    var titleText = ""
    var subscriptionUrl = ""
    var isCheceked:[Bool]?
    
    var catJsonArray = [String:String]()
    var newCategoryForTheCheck = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.register(FollowCategoryTableViewCell.self, forCellReuseIdentifier: "follows")
        createViews()
        
        saveButton.addTarget(self, action: #selector(saveButtonAction), for:.touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors:[#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
        
    }
    
    func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(tableview)
        cardView.addSubview(saveButton)
        bgView.addSubview(label)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(cardView.snp.bottom)
        }
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(24)
        }
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.height.equalTo(45)
        }
        
        //
    }
    
    @objc func saveButtonAction(){
        let token = UserDefaults.standard.string(forKey: "token")
        let userId = UserDefaults.standard.string(forKey: "ID")
        for (key,value) in SaveDateFromFollows.shared.saveAllSomeIDArray{
            subscriptionUrl = subscriptionUrl + "&cat[]=\(value)"
        }
        requestJSON(continueUrl: subscriptionUrl, userId: userId!, token: token!)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "follows", for: indexPath) as! FollowCategoryTableViewCell
        //        overWrite()
        cell.label.text = podCategory[indexPath.row].name
        cell.accessoryType = self.newCategoryForTheCheck[indexPath.row].isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        newCategoryForTheCheck[indexPath.row].isSelected = !newCategoryForTheCheck[indexPath.row].isSelected
        if newCategoryForTheCheck[indexPath.row].isSelected {
            SaveDateFromFollows.shared.saveAllSomeIDArray.updateValue("\(parentId);\(podCategory[indexPath.row].id)", forKey:podCategory[indexPath.row].id)
            self.newCategoryForTheCheck[indexPath.row].isSelected = true
            //            print(saveSomeIDArray)
        }else{
            SaveDateFromFollows.shared.saveAllSomeIDArray.removeValue(forKey: podCategory[indexPath.row].id)
            self.newCategoryForTheCheck[indexPath.row].isSelected = false
            //            print(saveSomeIDArray)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 65
    }
    
    func requestJSON(continueUrl:String,userId:String,token:String){
        //        subscriptionUrl = subscriptionUrl + "&cat[]=\(parentId);\(podCategory[IndexPath.row].id)"
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=user_param&userid=\(userId)&utoken=\(token)&act=subscribe" + continueUrl) else {return}
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.showToast(message: "Настройка сохранено!")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 64, y: self.view.frame.size.height-80, width: self.view.frame.size.width - 128, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Roboto-Regular", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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


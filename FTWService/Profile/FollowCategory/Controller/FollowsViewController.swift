//
//  FollowsViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Alamofire
import FirebaseMessaging
import Shimmer

class SaveDateFromFollows{
    static var shared = SaveDateFromFollows()
    var saveAllSomeIDArray = [Int:String]()
}
struct ExpandedNames {
    var isExpanded:Bool
    var name:String
    var id:Int
    var names:[SomeCategory]
    var isSelectedAll = false
}

struct SomeCategory {
    var name:String
    var id:Int
    var hasFavourite:Bool
}

class FollowsViewController: UIViewController{
    let tableview: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.isHidden = true
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
        button.addTarget(self, action: #selector(saveButtonAction), for:.touchUpInside)
        return button
    }()
    lazy var shimmerTableview: UITableView = {
        let tableview = UITableView()
        tableview.isUserInteractionEnabled = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ShimmerCatTableViewCell.self, forCellReuseIdentifier: "FollowsShimmerView")
        tableview.isHidden = false
        tableview.separatorColor = UIColor.groupTableViewBackground
        tableview.layer.cornerRadius = 45
        tableview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return tableview
    }()
    var shimmer:FBShimmeringView!

    private var subscriptionUrl = ""
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    let subscribeUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_user&user_cat="
    var category = [Category]()
    var expandedArray = [ExpandedNames]()
    var podCategory = [Category]()
    var podCatString = [SomeCategory]()
    var categoryIds = [Int]()
    var catJsonArray = [String:String]()
    var followsCell:Follows?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Подписка на задания"
        view.backgroundColor = .white
        jsonData()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.register(Follows.self, forCellReuseIdentifier: "followCat")
        shimmerAction()
        createViews()
        //        updateSections()
        //        subscriptionCategory(id: id)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Подписка на задания"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors:[#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
        
    }
    private func shimmerAction() {
        shimmer = FBShimmeringView(frame: shimmerTableview.frame)
        cardView.addSubview(shimmerTableview)
        cardView.addSubview(shimmer)
        shimmer.contentView = shimmerTableview
        shimmerTableview.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(cardView.snp.bottom).offset(-54.5)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerTableview)
        }
        shimmer.isShimmering = true
    }
    
    @objc func saveButtonAction(){
        print(SaveDateFromFollows.shared.saveAllSomeIDArray)
        let token = UserDefaults.standard.string(forKey: "token")
        let userId = UserDefaults.standard.string(forKey: "ID")
        var checkFirebaseArray = [String]()
        for (key,value) in SaveDateFromFollows.shared.saveAllSomeIDArray{
            subscriptionUrl = subscriptionUrl + "&cat[]=\(value)"
//            checkFirebaseArray.append("cat_\(key)")
            Messaging.messaging().subscribe(toTopic: "cat_\(key)") { error in
                print("Subscribed to weather topic")
            }
        }
        
        requestJSON(continueUrl: subscriptionUrl, userId: userId!, token: token!)
    }
    
    
    func jsonData() {
        let id = UserDefaults.standard.integer(forKey: "ID")
        DataProvider.getCategoryArray(url: url, id: 0) { (result) in
            guard let category = result else {return}
            self.category = category
            for cat in category{
                DataProvider.getCategoryArray(url: self.url, id: cat.id) { (result)
                    in
                    guard let category = result else {return}
                    self.podCategory = category
                    for podCat in self.podCategory{
                        self.podCatString.append(SomeCategory(name: podCat.name, id: podCat.id, hasFavourite: false))
                    }
                    self.expandedArray.append(ExpandedNames(isExpanded: false, name: cat.name, id: cat.id, names: self.podCatString, isSelectedAll: false))
                    self.podCatString.removeAll()
                    if self.expandedArray.count == 16 {
                        self.expandedArray.sort { $0.id < $1.id }
                        self.subscriptionCategory(id:id)
                        self.shimmer.isShimmering = false
                        self.shimmerTableview.isHidden = true
                        self.tableview.isHidden = false
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                }
            }
        }
        
        
    }
    
    func subscriptionCategory(id:Int) {
        guard let url = URL(string: "\(subscribeUrl)\(id)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                guard let newValue = value as? [String: String] else {return}
                self.catJsonArray = newValue
                for (section,ex) in self.expandedArray.enumerated(){
                    for var (index,i) in ex.names.enumerated(){
                        for j in newValue{
                            if i.id == Int(j.key)!{
                                self.expandedArray[section].names[index].hasFavourite = true
                            }
                        }
                    }
                }
                SaveDateFromFollows.shared.saveAllSomeIDArray.removeAll()
                for i in self.catJsonArray{
                    SaveDateFromFollows.shared.saveAllSomeIDArray.updateValue("\(i.key);\(i.key)", forKey: Int(i.key)!)
                }
                self.tableview.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "Response status code was unacceptable: 500." {
                    self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                }
            }
        }
        
        
        self.tableview.reloadData()
        
        
    }
    func updateSections(){
        var indexPaths = [IndexPath]()
        for index in expandedArray.indices{
            for row in expandedArray[index].names.indices{
                let indexPath = IndexPath(row: row, section: index)
                indexPaths.append(indexPath)
            }
            tableview.deleteRows(at: indexPaths, with: .fade)
            
        }
    }
    @objc func handleExpandClose(buttonTag:UIButton){
        let section = buttonTag.tag
        var indexPaths = [IndexPath]()
        for row in expandedArray[section].names.indices{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpended = expandedArray[section].isExpanded
        
        expandedArray[section].isExpanded = !isExpended
        if isExpended{
            tableview.deleteRows(at: indexPaths, with: .fade)
            tableview.reloadData()
        }else{
            let indexPath = IndexPath(item: 0, section: section)
            tableview.insertRows(at: indexPaths, with: .fade)
            tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    @objc func handleCheckBox(_ sender: CheckBox) {
        let section = sender.tag
        print(section,"Sender")
        print(sender.isChecked)
        expandedArray[section].isSelectedAll = !expandedArray[section].isSelectedAll
        selectedAllRow(section: section, isSelected: sender.isChecked)
    }
    func selectedRow(indexPath:IndexPath,tableView:UITableView) {
        expandedArray[indexPath.section].names[indexPath.row].hasFavourite = !expandedArray[indexPath.section].names[indexPath.row].hasFavourite
        if expandedArray[indexPath.section].names[indexPath.row].hasFavourite {
            SaveDateFromFollows.shared.saveAllSomeIDArray.updateValue("\(expandedArray[indexPath.section].names[indexPath.row].id);\(expandedArray[indexPath.section].names[indexPath.row].id)", forKey:expandedArray[indexPath.section].names[indexPath.row].id)
            expandedArray[indexPath.section].names[indexPath.row].hasFavourite = true
            //            print(saveSomeIDArray)
        }else{
            SaveDateFromFollows.shared.saveAllSomeIDArray.removeValue(forKey: expandedArray[indexPath.section].names[indexPath.row].id)
            expandedArray[indexPath.section].names[indexPath.row].hasFavourite = false
            //            print(saveSomeIDArray)
        }
        tableView.reloadData()
    }
    func selectedAllRow(section:Int,isSelected:Bool) {
        let somecat = expandedArray[section].names
        let dispathWork = DispatchGroup()
        let queue = DispatchQueue.init(label: "Queue",qos: .userInteractive)
        queue.async(group: dispathWork, execute: {
            for i in 0..<somecat.count{
                self.expandedArray[section].names[i].hasFavourite = isSelected
                if self.expandedArray[section].names[i].hasFavourite {
                    SaveDateFromFollows.shared.saveAllSomeIDArray.updateValue("\(self.expandedArray[section].names[i].id);\(self.expandedArray[section].names[i].id)", forKey:self.expandedArray[section].names[i].id)
                    self.expandedArray[section].names[i].hasFavourite = true
                    //            print(saveSomeIDArray)
                }else{
                    SaveDateFromFollows.shared.saveAllSomeIDArray.removeValue(forKey: self.expandedArray[section].names[i].id)
                    self.expandedArray[section].names[i].hasFavourite = false
                    //            print(saveSomeIDArray)
                }
            }
        })
        dispathWork.notify(queue: .main) {
            self.tableview.reloadData()
            
        }
        
    }
}

extension FollowsViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableview {
            return expandedArray.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            if !expandedArray[section].isExpanded{
                return 0
            }
            return expandedArray[section].names.count
        } else {
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            
            followsCell = tableView.dequeueReusableCell(withIdentifier: "followCat", for: indexPath) as? Follows
            followsCell?.callbackAction = {
                self.selectedRow(indexPath: indexPath, tableView: tableView)
            }
            let someCat = expandedArray[indexPath.section].names[indexPath.row]
            print(someCat.hasFavourite,"HH")
            followsCell?.label.text = someCat.name
            followsCell?.checkBox.isChecked = someCat.hasFavourite ?  true : false
            return followsCell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowsShimmerView", for: indexPath) as! ShimmerCatTableViewCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableview {
            for x in 0..<expandedArray[section].names.count {
                if self.expandedArray[section].names[x].hasFavourite == false {
                    self.expandedArray[section].isSelectedAll = false
                    break
                }else {
                    self.expandedArray[section].isSelectedAll = true
                }
            }
            let contentView = UIView()
            contentView.backgroundColor = .white
            contentView.isUserInteractionEnabled = true
            
            let label = UILabel()
            label.text = self.expandedArray[section].name
            label.textColor = .black
            
            let button = UIButton()
            button.tag = section
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            let lineview = UIView()
            lineview.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            
            let checkBox = CheckBox()
            checkBox.tag = section
            checkBox.style = .tick
            checkBox.borderStyle = .square
            checkBox.isChecked = expandedArray[section].isSelectedAll ? true : false
            checkBox.addTarget(self, action: #selector(handleCheckBox(_:)), for: .valueChanged)
            contentView.addSubview(label)
            contentView.addSubview(lineview)
            contentView.addSubview(button)
            contentView.addSubview(checkBox)
            
            label.snp.makeConstraints { (make) in
                make.centerY.equalTo(contentView.snp.centerY)
                make.left.equalTo(contentView.snp.left).offset(24)
            }
            lineview.snp.makeConstraints { (make) in
                make.top.equalTo(contentView.snp.bottom).offset(-1)
                make.left.equalTo(contentView).offset(20)
                make.right.equalTo(contentView).offset(-20)
                make.height.equalTo(1)
            }
            button.snp.makeConstraints { (make) in
                make.top.left.bottom.equalToSuperview()
                make.right.equalTo(checkBox.snp.right).offset(-8)
            }
            checkBox.snp.makeConstraints { (make) in
                make.centerY.equalTo(contentView.snp.centerY)
                make.right.equalTo(contentView.snp.right).offset(-24)
                make.width.height.equalTo(24)
            }
            return contentView
        } else {
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedRow(indexPath: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableview {
            return 70
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 65
    }
    
}

class Follows: UITableViewCell {
    var callbackAction: (()->())?
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    lazy var checkBox:CheckBox = {
        let checkBox = CheckBox()
        checkBox.style = .tick
        checkBox.borderStyle = .square
        checkBox.addTarget(self, action: #selector(handleCheckBox(_:)), for: .valueChanged)
        return checkBox
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(checkBox)
        configureViews()
    }
    
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        checkBox.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-16)
        }
    }
    @objc func handleCheckBox(_ sender: CheckBox) {
        print(sender.isChecked)
        callbackAction?()
        
        //        sender.isChecked = !sender.isChecked
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





extension FollowsViewController{
    
    func requestJSON(continueUrl:String,userId:String,token:String){
        //        subscriptionUrl = subscriptionUrl + "&cat[]=\(parentId);\(podCategory[IndexPath.row].id)"
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=user_param&userid=\(userId)&utoken=\(token)&act=subscribe" + continueUrl) else {return}
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success( _):
                self.showAlert(text: "Сохранено!", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(tableview)
        cardView.addSubview(saveButton)
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
            make.bottom.equalTo(saveButton.snp.centerY)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.height.equalTo(45)
        }
        
    }
    
}

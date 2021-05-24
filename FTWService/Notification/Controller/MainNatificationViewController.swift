//
//  MainNatificationViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import Alamofire
class MainNatificationViewController: UIViewController {
    
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Все Уведомления"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
  
    lazy var tableView:UITableView = {
       let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        tv.separatorStyle = .none
       return tv
    }()
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        return view
    }()
    lazy var tabBar:TabBarNatification = {
        let tb = TabBarNatification()
        tb.mainNatificationViewController = self
        return tb
    }()
    
//    @IBOutlet weak var tabBarNatificationView: TabBarNatification!
    var array:[CellModel] = []
    var myIndex = 0
    let reviewUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=reviews&act=view&userid="
    
    var arrayRev = [UserReviews]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        notificationSetup()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    
        getReviews(url: "\(reviewUrl)344&sort=all&page=1")
//        tabBarNatificationView.mainNatificationViewController = self
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 35
        
        tableView.layer.cornerRadius = 35
        tableView.layer.masksToBounds = true
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Do any additional setup after loading the view.
        setUpMenuButton()
        setupConstraint()
       
    }
    func notificationSetup(){
        NotifyData.shared.arrays = UserDefaults.standard.object(forKey: "SaveData") as? [String:String] ?? [String:String]()
        for (key,value) in NotifyData.shared.arrays{
            var city:String?
            var title:String?
            var badge:String?
            var id:String?
            var time = "не определено"
            let splitValue = key.components(separatedBy: ",")
            let splitKey = value.components(separatedBy: ",")
            for (index,value) in splitValue.enumerated(){
                if index == 0{
                    id = value
                }else if index == 1{
                    city = value
                }else{
                    time = value
                }
            }
            for (index,value) in splitKey.enumerated(){
                if index == 0{
                    title = value
                }else{
                    badge = value
                }
            }
            Networking.getMainTasks(url: Constans().Get_Data, continueUrl: "&page=1") { (task,err)  in
                guard let resource = task else {return}
                 let main = resource.filter({$0.id == Int(id!)!})
                if main.count != 0 {
                if title!.contains("Подписка") {
                    self.array.append(CellModel(firstCell: FirstCellModel(label: main.first!.task!, time: time, city: city!, title: title!), cell: 1))
                }else{
                    self.array.append(CellModel(secondCell: SecondCellModel(label: main.first!.task!, time: time, city: city!), cell: 2))
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()

                    }
            }
                
            }
            
        }
        
    }
    func setupConstraint(){
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(tableView)
        cardView.addSubview(tabBar)
        bgView.addSubview(label)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.87)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
        
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(self.bgView.snp.left).offset(24)
        }
        tabBar.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(UIViewController.tabbarHeight))
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = Data_Colors.mainColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    override func viewDidLayoutSubviews() {
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
   
    func selectToTabBarIndex(menuIndex: Int) {
        myIndex = menuIndex
//        array = UserDefaults.standard.object(forKey: "SavedArray") as! [CellModel]
        self.tableView.reloadData()
        //        let indexPath = IndexPath(item: menuIndex, section: 0)
        //        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        //
        //        setTitleForIndex(index: menuIndex)
    }
    
    func setUpMenuButton(){
        let share = image(with:  UIImage(named: "63g"), scaledTo: CGSize(width: 24, height: 24))
        let setting = UIBarButtonItem(image: share, style: .done, target: self, action: #selector(onMenuButtonPressed))
        
        self.navigationItem.rightBarButtonItems = [setting]
    }
    
    
    @objc func onMenuButtonPressed(){
        self.performSegue(withIdentifier: "segueTime", sender: self)
    }
    
    
    
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    func getReviews(url:String) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let json = value as? Array<[String: Any]> else {
                    
                    return
                }
                for item in json {
                    let array = UserReviews(user_id: item["user_id"] as! Int,
                                            username: item["username"] as? String,
                                            avatar: item["avatar"] as? String,
                                            like: item["like"] as! Int,
                                            datein: item["datein"] as! String,
                                            narrative: item["narrative"] as? String)
                    self.arrayRev.append(array)
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

extension MainNatificationViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 2 == myIndex{
            return array.filter({$0.cell == 1}).count
        }else if myIndex == 1{
            return array.filter({$0.cell == 2}).count
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = array
       
        if myIndex == 1{
            model = array.filter({$0.cell == 2})
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.configureOfData(cellModel:model[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }else if myIndex == 2{
            model = array.filter({$0.cell == 1})
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            cell.configureCell(cellModel: model[indexPath.row])
            cell.selectionStyle = .none

            return cell
        }else{
            if array[indexPath.row].cell == 1{
                let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
                cell.configureCell(cellModel: model[indexPath.row])
                cell.selectionStyle = .none

                return cell
            }else if array[indexPath.row].cell == 2{
                let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
                print(model[indexPath.row].secondCellModel?.label)
                cell.configureOfData(cellModel: model[indexPath.row])
                cell.selectionStyle = .none

                return cell
            }
        }
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.configureOfData(cellModel: model[indexPath.row])
            cell.selectionStyle = .none

            return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if array[indexPath.row].cell == 1{
//            let viewController = IDTaskViewController()
//            self.show(viewController, sender: self)
//

//            let vc = ReviewsViewController()
//            vc.id = PassData.UserID
//            vc.arrayReviews = arrayRev
//            self.show(vc, sender: self)
        
//
//        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if array[indexPath.row].cell == 2{
            return 165
        }else if array[indexPath.row].cell == 4{
            return 165
        }else{
            return 165
        }
    }
    
    
    
}

//
//  City_ViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class City_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Выйти из профила", for: .normal)
        btn.backgroundColor = .white
        return btn
    }()
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    var Title_Date = ""
    
    var Country_Data = ["Qazaqstan","2","3","4"]
    var City_Data = [["Almaty"],["1","2"],["1","2","3"],["1","2","3","4"]]
    var allCityData = ["Алматы","Астана","Актау","Шымкент","Караганды"]
    var callback : ((String)->())?

    let url = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=getOther&get=cities"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Город"
        createViews()
        tableView.separatorColor = Data_Colors.Background_Color
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    func createViews() -> Void {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(tableView)
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cityCell")
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "allCityCell")
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(cardView.snp.bottom)
        }
    }
//    func jsonDataParse(){
//        Networking.getCity(url: self.url) { (response) in
//            self.allCityData = response
//            print(self.allCityData)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCityData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "allCityCell", for: indexPath) as! CityTableViewCell
            cell.label.text = "Все"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
            cell.label.text = allCityData[indexPath.row-1]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            PassData.dataOfCity = "Все"
            callback!("Все")
        }else{
            
            let vc = Filter_ViewController()
            vc.cityName = allCityData[indexPath.row-1]
            PassData.dataOfCity = allCityData[indexPath.row-1]
            callback!(allCityData[indexPath.row-1])
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

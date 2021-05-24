//
//  New_InFilterViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class New_InFilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let tableview: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.register(NewFilterCell.self, forCellReuseIdentifier: "infol")
        view.register(NewFilterCell.self, forCellReuseIdentifier: "space")
        view.register(TypeHeaderView.self, forCellReuseIdentifier: "inTypeOfHeader")
        return view
    }()
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Green")
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
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    var Data_Title = ""
    var Data_Fierst_Cell = ""
    var Data_Cell = [Category]()
    var Data_In_Cell = [Category](){
        didSet{
            for index in 0..<Data_In_Cell.count{
                for i in SaveDateFromFilter.shared.arrayForSaveAllFilterValue{
                    if i.id == Data_In_Cell[index].parent_id{
                        if Data_In_Cell[index].id == i.inFilterModel.category.id{
                            Data_In_Cell[index].isSelected = true
                        }
                    }
                }
            }
        }
    }
    var accessTo = false
    var Filter = true
    var selectAllCell = false
    var subId:Int?
    var catID:String?
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for i in Data_In_Cell{
            if i.isSelected{
                SaveDateFromFilter.shared.arrayForSaveAllFilterValue.append(FilterModel(inFilterModel: InFilterModel(category:i), id: i.parent_id))
            }
        }
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createViews()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors:[#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
        
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
            make.bottom.equalTo(cardView.snp.bottom).offset(-(16 + UIViewController.tabbarHeight))
            make.height.equalTo(50)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data_In_Cell.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inTypeOfHeader", for: indexPath) as! TypeHeaderView
            cell.label.text = "Все Подкотегории"
            cell.accessoryType = selectAllCell ? .checkmark : .none
            cell.tintColor = .orange
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath)
            cell.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9254901961, blue: 0.937254902, alpha: 1)
            return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "infol", for: indexPath) as! NewFilterCell
            cell.label.text =  Data_In_Cell[indexPath.row - 2].name
            cell.tintColor = .orange
            if accessTo{
                translateToTheBool(bool: selectAllCell)
                cell.accessoryType = Data_In_Cell[indexPath.row-2].isSelected ? .checkmark : .none
            }else{
                print(Data_In_Cell[indexPath.row-2].isSelected)
                cell.accessoryType = Data_In_Cell[indexPath.row-2].isSelected ? .checkmark : .none
            }
            return cell
        }
    }
    
    func translateToTheBool(bool:Bool){
        for index in 0..<Data_In_Cell.count{
            Data_In_Cell[index].isSelected = bool
        }
    }
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    @objc func buttonPressed() {
        popViewControllerss(popViews: 2, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            selectAllCell = !selectAllCell
            accessTo = true
            self.tableview.reloadData()
        case 1:
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectionStyle = .none
            break
        default:
            accessTo = false
            if let cell = tableView.cellForRow(at: indexPath){
                Data_In_Cell[indexPath.row-2].isSelected = !Data_In_Cell[indexPath.row-2].isSelected
                cell.accessoryType = Data_In_Cell[indexPath.row-2].isSelected ? .checkmark : .none
                //                if Data_In_Cell[indexPath.row].isSelected == true{
                //                    cell.accessoryType = .checkmark
                //                }else{
                //                    cell.accessoryType = .none
                //                }
                //                cell.accessoryType = cell.accessoryType == .checkmark ? .none : .checkmark
            }
            self.tableview.reloadData()
        }
        self.tableview.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 90
        case 1:
            return 10
        default:
            return 80
        }
    }
    
}





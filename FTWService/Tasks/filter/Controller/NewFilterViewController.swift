//
//  NewFilterViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

struct FilterModel{
    var inFilterModel:InFilterModel
    var id:Int
}
struct InFilterModel {
    var category:Category
}

class SaveDateFromFilter{
    static var shared = SaveDateFromFilter()
    var arrayForSaveAllFilterValue = [FilterModel]()
}

import UIKit

class NewFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    private let tableview: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.register(NewFilterCell.self, forCellReuseIdentifier: "fol")
        view.register(NewFilterCell.self, forCellReuseIdentifier: "space1")
        view.register(TypeHeaderView.self, forCellReuseIdentifier: "typeOfHeader")
        return view
    }()
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        return view
    }()
    private let label: UILabel = {
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
    private let saveButton:UIButton = {
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
    var Data_Cell = [Category](){
        didSet{
            print(Data_Cell)
        }
        
    }
    var Data_In_Cell = [Category](){
        didSet{
            print(Data_In_Cell)
        }
    }
    var Filter = true
    var All_Select = true
    var subId:Int?
    var catID:String?
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Data_Title
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
            make.height.equalTo(45)
        }
    }
    @objc func buttonPressed() {
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data_Cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "fol", for: indexPath) as! NewFilterCell
            cell.label.text = Data_Cell[indexPath.row].name
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
            
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = New_InFilterViewController()
            let cell = tableView.cellForRow(at: indexPath)
            let index = tableView.indexPath(for: cell!)
            let items = Data_Cell[(index?.row)!].id
            vc.Data_Title = Data_Cell[indexPath.row].name
            DispatchQueue.global().async {
                Networking.getCategory(url: self.url, id: items) { (category, id) in
                    self.Data_In_Cell = category
                    vc.Data_In_Cell = self.Data_In_Cell
                    vc.tableview.reloadData()
                }
            }
            show(vc, sender: self)
        
        self.tableview.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }
}

class NewFilterCell: UITableViewCell {
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        configureViews()
    }
    
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TypeHeaderView: UITableViewCell {
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "LABEL"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        configureViews()
    }
    
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

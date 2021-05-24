//
//  InCategoryViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import MaterialComponents
import Shimmer
class InCategoryViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {
    let tableview: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
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
    private let shimmerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    private let shimmerTableview: UITableView = {
        let tableview = UITableView()
        tableview.isUserInteractionEnabled = false
        return tableview
    }()
    private var shimmer:FBShimmeringView!
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    var categoryIds = [Int]()
    var Data_Title = ""
    var category = [Category]()
    var podCategory = [Category]()
    var controller = true
    fileprivate func configureViews() {
        //        navigationItem.title = "Cоздать задания"
        view.backgroundColor = .clear
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(InCategoryTableViewCell.self, forCellReuseIdentifier: "categoriess")
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.separatorColor = UIColor.groupTableViewBackground
        tableview.backgroundColor = .clear
        tableview.tableFooterView = UIView()
        cardView.isHidden = true
        self.view.addSubview(cardView)
        cardView.addSubview(tableview)
        cardView.addSubview(label)
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
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        
    }
    fileprivate func shimmerEffect() {
        self.view.addSubview(bgView)
        shimmerView.isHidden = false
        shimmerTableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        shimmerTableview.separatorColor = UIColor.groupTableViewBackground
        shimmerTableview.backgroundColor = .clear
        shimmerTableview.delegate = self
        shimmerTableview.dataSource = self
        shimmerTableview.register(ShimmerCatTableViewCell.self, forCellReuseIdentifier: "categoryShimmer")
        shimmer = FBShimmeringView(frame: shimmerTableview.frame)
        self.view.addSubview(shimmerView)
        shimmerView.addSubview(shimmerTableview)
        shimmerView.addSubview(shimmer)
        shimmer.contentView = shimmerTableview
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        shimmerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerTableview)
        }
        shimmerTableview.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerView.snp.top)
            make.left.equalTo(shimmerView.snp.left)
            make.right.equalTo(shimmerView.snp.right)
            make.bottom.equalTo(shimmerView.snp.bottom)
        }
        shimmer.isShimmering = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shimmerEffect()
        configureViews()
        setUpMenuButton()
        jsonData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    private func setUpMenuButton() {
        if controller {
            let item = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(sidemenuAction))
            self.navigationItem.rightBarButtonItem = item
        }
    }
    @objc func sidemenuAction() {
        dismiss(animated: true, completion: nil)
    }
  
    func jsonData() {
        Networking.getCategory(url: url, id: 0) { (category, id) in
            self.category = category
            self.categoryIds = id
            DispatchQueue.main.async {
                self.shimmer.isShimmering = false
                self.shimmerView.isHidden = true
                self.shimmer.isHidden = true
                self.cardView.isHidden = false
                self.tableview.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            return category.count
        } else {
            return 12
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoriess", for: indexPath) as! InCategoryTableViewCell
            cell.label.text = category[indexPath.row].name
            let sentImage = #imageLiteral(resourceName: "right")
            let sentImageView = UIImageView(image: sentImage.maskWithColor(color: #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)))
            sentImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            cell.accessoryView = sentImageView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryShimmer", for: indexPath) as! ShimmerCatTableViewCell
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PodCategoryTableViewController()
        _ = tableView.cellForRow(at: indexPath)
        self.tableview.deselectRow(at: indexPath, animated: true)
        let items = category[indexPath.row].id
        let selectedCell = category[indexPath.row].name
        let categoryName = ["CatTask":selectedCell]
        PassData.category = selectedCell
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "selectedcellCat"), object: nil, userInfo: categoryName)
        viewController.titleText = category[indexPath.row].name
        DispatchQueue.global().async {
            Networking.getCategory(url: self.url, id: items) { (category, id) in
                self.podCategory = category
                viewController.categoties = self.podCategory
                viewController.shimmer.isShimmering = false
                viewController.shimmer.isHidden = true
                viewController.shimmerTableview.isHidden = true
                viewController.tableview.isHidden = false
                viewController.tableview.reloadData()
            }
        }
        self.show(viewController, sender: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 65
            
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



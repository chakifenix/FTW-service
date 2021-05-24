//
//  PodCategoryTableViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import Shimmer
class PodCategoryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    let shimmerTableview: UITableView = {
        let tableview = UITableView()
        tableview.isUserInteractionEnabled = false
        return tableview
    }()
    var shimmer:FBShimmeringView!
    var categoties = [Category]()
    var titleText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MenuTableViewCell.self, forCellReuseIdentifier: "podcategorys")
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.separatorColor = UIColor.groupTableViewBackground
        tableview.isHidden = true
        shimmerTableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        shimmerTableview.separatorColor = UIColor.groupTableViewBackground
        shimmerTableview.backgroundColor = .clear
        shimmerTableview.delegate = self
        shimmerTableview.dataSource = self
        shimmerTableview.register(ShimmerCatTableViewCell.self, forCellReuseIdentifier: "podCategoryShimmer")
        shimmerTableview.isHidden = false
        shimmer = FBShimmeringView(frame: shimmerTableview.frame)
        label.text = titleText
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(tableview)
        bgView.addSubview(label)
        cardView.addSubview(shimmerTableview)
        cardView.addSubview(shimmer)
        shimmer.contentView = shimmerTableview
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
        shimmerTableview.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(cardView.snp.bottom)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerTableview)
        }
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(24)
        }
        shimmer.isShimmering = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
    }
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            return categoties.count
        } else {
            return 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "podcategorys", for: indexPath) as! MenuTableViewCell
            cell.label.text = categoties[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            let sentImage = #imageLiteral(resourceName: "right")
            let sentImageView = UIImageView(image: sentImage.maskWithColor(color: #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)))
            sentImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            cell.accessoryView = sentImageView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "podCategoryShimmer", for: indexPath) as! ShimmerCatTableViewCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = categoties[indexPath.row].name
        PassData.podCategory = selectedCell
        let podcatId = categoties[indexPath.row].id
        PassData.podCategorID = "\(podcatId)"
        let vc = Create_TasksViewController()
        vc.category = selectedCell
        self.show(vc, sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 65
            
        }    }
    
}



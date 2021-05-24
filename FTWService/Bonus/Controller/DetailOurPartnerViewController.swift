//
//  DetailOurPartnerViewController.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/5/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class DetailOurPartnerViewController: UIViewController {
    
    let cellID = "cell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return view
    }()
    
    let headerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        
        //        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return view
    }()
    
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("ОК", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    let tableview: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cells")
        view.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        view.register(DetailHeaderViewCell.self, forCellReuseIdentifier: "cellHeader")
        view.register(DetailDescriptionViewCell.self, forCellReuseIdentifier: "description")
        view.register(DetailTableViewLine.self, forCellReuseIdentifier: "lineCell")
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blueFon")
        return view
    }()
    let currencyLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    var saleNameArray = [SaleName]()
    var partnerItem:Partners?{
        didSet{
            Networking.getSaleName(id: partnerItem!.id!) { (data) in
                self.saleNameArray = data
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Starbucks"
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        self.tableview.delegate = self
        self.tableview.dataSource = self
        setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
        //        searchBarConstants()
        
    }
    
    @objc func buttonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    func setupConstraint(){
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        self.view.addSubview(currencyLabel)
        self.view.addSubview(saveButton)
        cardView.addSubview(tableview)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        
        currencyLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-8)
            make.right.equalTo(view.snp.right).offset(-8)
            make.size.equalTo(CGSize(width:100, height: 20))
        }
        
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardView.snp.top).offset(8)
            make.left.equalTo(self.cardView.snp.left).offset(16)
            make.right.equalTo(self.cardView.snp.right).offset(-16)
            make.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-35)
            make.left.equalTo(self.view.snp.left).offset(24)
            make.right.equalTo(self.view.snp.right).offset(-24)
            make.height.equalTo(45)
        }
    }
    
    
    
}


extension DetailOurPartnerViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleNameArray.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader", for: indexPath) as! DetailHeaderViewCell
            
            cell.Title.text = partnerItem?.name
            cell.isUserInteractionEnabled = false
            if let images = partnerItem?.logo{
                let urlString = "https://orzu.org/\(images)"
                print(urlString)
                guard let url = URL(string: urlString) else{return cell}
                let gueue = DispatchQueue.global(qos: .utility)
                gueue.async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            cell.qrImage.image = UIImage(data: data)
                        }
                    }
                }
                
            }
            
            
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as! DetailDescriptionViewCell
            cell.isUserInteractionEnabled = false
            cell.discription.text = partnerItem?.discription
            cell.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "lineCell", for: indexPath) as! DetailTableViewLine
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
            print(saleNameArray[indexPath.row-2].sale_name,"fafafa")
            print(indexPath.row,"000")
            print(indexPath.row-2,"-222222")
            cell.title.text = saleNameArray[indexPath.row-2].sale_name
            if let sale_percent = saleNameArray[indexPath.row-2].sale_percent{
                cell.pracent.text = String(sale_percent)
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 130
        }else if indexPath.row == 1{
            return 100
        }else{
            return 45
        }
    }
    
}



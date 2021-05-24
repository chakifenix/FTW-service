//
//  SortMenuViewController.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/18/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class SortMenuViewController: UIViewController {
    private let tableview:UITableView = {
        let table = UITableView()
        table.register(CityTableViewCell.self, forCellReuseIdentifier: "sortMenu")
        table.isScrollEnabled = false
        table.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        table.separatorStyle = .none
        return table
    }()
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Готова", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    let array = ["Cкидка(по возрастанию)","Cкидка(по убывынию)","Дата добавления(от нового к старому)","По алфавиту","Лучшие совпадение"]
    fileprivate func setupConst() {
        self.view.addSubview(tableview)
        self.view.addSubview(saveButton)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(32)
            make.left.right.bottom.equalTo(self.view)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сортировка"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        self.view.layer.cornerRadius = 40
        self.view.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.view.layer.masksToBounds = true
        setupConst()
    
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    @objc func buttonAction() {
        
    }

}
extension SortMenuViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortMenu", for: indexPath) as! CityTableViewCell
        cell.label.text = array[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//
//  LevelBonusController.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/19/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class LevelBonusController: UIViewController {
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blueFon")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    private let titleStep:UILabel = {
        let label = UILabel()
        label.text = "Шаг 3 из 3"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let levelLabel:UILabel = {
        let label = UILabel()
        label.text = "Уровень"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let tableview: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.register(LevelBonusCell.self, forCellReuseIdentifier: "levelbonus")
        return view
    }()
    let array = [LevelBonus(level: "VIP", persent: 50, description: "Чтобы стать VIP клиентом нужно"),LevelBonus(level: "Стандард", persent: 30, description: "Чтобы стать Стандард клиентом нужно"),LevelBonus(level: "Новичок", persent: 15, description: "Чтобы стать Навичком нужно")]
    var saleName = ""
    var discrSale = ""
    var subcatID:Int!
    var catId:Int!
    var percent = 15
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
        tableview.dataSource = self
        tableview.delegate = self
        setupConstraint()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    func setupConstraint(){
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        self.view.addSubview(saveButton)
        cardView.addSubview(titleStep)
        cardView.addSubview(tableview)
        cardView.addSubview(levelLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        titleStep.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.centerX.equalTo(cardView.snp.centerX)
        }
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleStep.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(levelLabel.snp.bottom).offset(4)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(saveButton.snp.top)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
        
    }
    @objc func buttonAction() {
        let id = UserDefaults.standard.integer(forKey: "ID")
        let token = UserDefaults.standard.string(forKey: "token")
        self.showLoader()
        let partnerParam = ["userid":"\(id)","name":PassData.partnerName,"city":PassData.partnerCity,"partnersdisc":PassData.partnerDescr,"utoken":token!,"subcatid":"\(PassData.partnerSubCatID)","percent":String(self.percent)]
        let queue = DispatchQueue.init(label: "Partner", qos: .utility)
        queue.async {
            Networking.partnerUrl(url: Constans().createPartner, param: partnerParam) { (value, err) in
                guard let result = value as? String else {return}
                let idPartner = result.split(separator: ":")
                print(idPartner[1])
                let param = ["idPartner":"\(idPartner[1])","namePartner":PassData.partnerName,"partner_city":PassData.partnerCity,"description":self.discrSale,"utoken":token!,"partners_subcat":"\(String(describing: self.subcatID))","partners_cat":"\(String(describing: self.catId))","sale_percent":"\(self.percent)","sale_name":self.saleName,"idUser":String(id)]
                
                Networking.partnerUrl(url: Constans().createSale, param: param) { (value, err) in
                    let result = value as! String
                    let saleid = result.split(separator: ":")
                    let queue = DispatchQueue.global(qos: .utility)
                    let saleImageParam = ["sale_id":String(saleid[1])]
                    queue.async {
                        Networking.uploadImages(fileUrl: PassData.partnerImageUrl!, url: Constans().uploadImage, param: ["partnerid_logo":String(idPartner[1])]){ (value) in
                            print(value)
                        }

                        Networking.uploadImages(fileUrl: PassData.saleImageUrl!, url: Constans().uploadImage, param: saleImageParam){ (value) in
                            print(value)
                        }
                    }
                    self.showAlert(text: "Вы стали партнером!", completion: {
                    })
                }
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
extension LevelBonusController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "levelbonus", for: indexPath) as! LevelBonusCell
        cell.selectionStyle = .none
        cell.Title.text = array[indexPath.row].level
        cell.percent.text = "Cкидка до \(array[indexPath.row].persent)%"
        cell.discription.text = array[indexPath.row].description
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableview.frame.size.height * 0.3
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LevelBonusCell
        if indexPath.row == 2 {
            cell.Inview.backgroundColor = .orange
        }
        cell.Inview.backgroundColor = .orange
        cell.discription.textColor = .white
        cell.percent.textColor = .white
        cell.Title.textColor = .white
        percent = array[indexPath.row].persent
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LevelBonusCell
        cell.Inview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.discription.textColor = .gray
        cell.percent.textColor = .gray
        cell.Title.textColor = .gray
    }
    
    
}

class LevelBonus {
    var level:String
    var persent:Int
    var description:String
    
    init(level:String,persent:Int,description:String) {
        self.level = level
        self.persent = persent
        self.description = description
    }
}
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

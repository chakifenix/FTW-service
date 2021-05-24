//
//  PartnersVipTableViewCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/19/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class PartnersVipTableViewCell: UITableViewCell {
    
    let vipLevelView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let levelLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "Уровень"
        return label
    }()
    
    let vipTypeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "VIP"
        return label
    }()
    let standardTypeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "Стандардт"
        return label
    }()
    let typeVipActionLabel:UILabel = {
        let label = UILabel()
        label.text = "Скидки до 50%"
        label.textColor = .white
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 10.0)
        return label
    }()
    let typeStandardActionLabel:UILabel = {
        let label = UILabel()
        label.text = "Скидки до 30%"
        label.textColor = .white

        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 10.0)
        return label
    }()
    let typeBeginnerActionLabel:UILabel = {
        let label = UILabel()
        label.text = "Скидки до 15%"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 10.0)
        label.textColor = .white
        return label
    }()
    let beginnerTypeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "Новичок"
        return label
    }()
    let standardLevelView:UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 10.0)
        label.text = "Категория"
        return label
    }()
    
    let beginnerLevelView:UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    
     let categoryBonusLabel:UILabel = {
        let label = UILabel()
        label.text = "Название категории"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        return label
    }()
    let discriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 10.0)
        label.text = "Описание:"
        return label
    }()
    let discriptionCompanyLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "Описание компании и функционал скидок"
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        let vip = UITapGestureRecognizer(target: self, action: #selector(self.vipHandleTap(_:)))
        vipLevelView.addGestureRecognizer(vip)
        let standard = UITapGestureRecognizer(target: self, action: #selector(self.standardHandleTap(_:)))
        standardLevelView.addGestureRecognizer(standard)
        let beginner = UITapGestureRecognizer(target: self, action: #selector(self.beginnerHandleTap(_:)))
        beginnerLevelView.addGestureRecognizer(beginner)
        setupConstraint()
    }
    
    @objc func vipHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.vipLevelView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        self.typeVipActionLabel.textColor = .white
        self.vipTypeLabel.textColor = .white
        self.standardLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
   
        self.beginnerLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    @objc func standardHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.vipLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.standardLevelView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        
        self.beginnerLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    @objc func beginnerHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.vipLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.standardLevelView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
   
        self.beginnerLevelView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
    }
    
    func setupConstraint(){
        self.addSubview(vipLevelView)
        self.addSubview(standardLevelView)
        self.addSubview(beginnerLevelView)
        self.addSubview(levelLabel)
        self.addSubview(categoryLabel)
        self.addSubview(categoryBonusLabel)
        self.addSubview(discriptionLabel)
        self.addSubview(discriptionCompanyLabel)
    
        self.vipLevelView.addSubview(vipTypeLabel)
        self.vipLevelView.addSubview(typeVipActionLabel)
        self.standardLevelView.addSubview(standardTypeLabel)
        self.standardLevelView.addSubview(typeStandardActionLabel)
        self.beginnerLevelView.addSubview(beginnerTypeLabel)
        self.beginnerLevelView.addSubview(typeBeginnerActionLabel)
        
        vipLevelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(standardLevelView.snp.left).offset(-18)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(self.snp.height).multipliedBy(0.5)
        }
        standardLevelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(self.snp.height).multipliedBy(0.5)
        }
        beginnerLevelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.standardLevelView.snp.right).offset(18)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(self.snp.height).multipliedBy(0.5)
        }
        levelLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(vipLevelView.snp.top).offset(-12)
            make.left.equalTo(vipLevelView.snp.left)
        }
        
        vipTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.vipLevelView.snp.left).offset(8)
            make.top.equalTo(self.snp.centerY)
        }
        typeVipActionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.vipTypeLabel.snp.left)
            make.top.equalTo(self.vipTypeLabel.snp.bottom).offset(2)
        }
        standardTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.standardLevelView.snp.left).offset(8)
            make.top.equalTo(self.snp.centerY)
        }
        typeStandardActionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.standardTypeLabel.snp.left)
            make.top.equalTo(self.standardTypeLabel.snp.bottom).offset(2)
        }
        
        beginnerTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.beginnerLevelView.snp.left).offset(8)
            make.top.equalTo(self.snp.centerY)
        }
        typeBeginnerActionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.beginnerTypeLabel.snp.left)
            make.top.equalTo(self.beginnerTypeLabel.snp.bottom).offset(2)
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vipLevelView.snp.bottom).offset(12)
            make.left.equalTo(vipLevelView.snp.left)
        }
        categoryBonusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.left.equalTo(vipLevelView.snp.left)
        }
        discriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(categoryBonusLabel.snp.bottom).offset(12)
            make.left.equalTo(vipLevelView.snp.left)
        }
        discriptionCompanyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(discriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(vipLevelView.snp.left)
        }
    }
    
}



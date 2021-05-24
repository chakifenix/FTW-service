//
//  MainTaskCell.swift
//  resources
//
//  Created by MacOs User on 10/26/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

//
//  MainTaskCell.swift
//  resources
//
//  Created by Magzhan Imangazin on 10/24/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit

class MainTaskCell: UITableViewCell {
    let Category:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.init(name: "AppleSDGothicNeo-Light", size: 13)
        return label
    }()
    let Title:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.init(name: "AppleSDGothicNeo-SemiBold", size: 18)
        return label
    }()
    let Time:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.init(name: "AppleSDGothicNeo-Light", size: 15)
        return label
    }()
    let cityLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.init(name: "AppleSDGothicNeo-Light", size: 15)
        return label
    }()
    let LabelPrice:UILabel = {
        let label = UILabel()
        label.textColor = Data_Colors.gradientColor
        label.font = UIFont.init(name: "AppleSDGothicNeo-Light", size: 13)
        return label
    }()
    let cashService:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "за услугу"
        label.font = UIFont.init(name: "AppleSDGothicNeo-Light", size: 13)
        return label
    }()
    let views:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let Inview:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Inview.layer.cornerRadius = 25
        Inview.layer.shadowColor = UIColor.black.cgColor
        Inview.layer.shadowRadius = 5
        Inview.layer.shadowOpacity = 0.1
        Inview.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundColor = .clear
        addSubview(Inview)
        Inview.addSubview(views)
        views.addSubview(cityLabel)
        views.addSubview(LabelPrice)
        views.addSubview(cashService)
        views.addSubview(Category)
        views.addSubview(Time)
        views.addSubview(Title)
        addSubViewsAndlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        Inview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-8)
        }
        views.snp.makeConstraints { (make) in
            make.top.equalTo(Inview.snp.top).offset(10)
            make.left.equalTo(Inview.snp.left).offset(16)
            make.right.equalTo(Inview.snp.right).offset(-16)
            make.bottom.equalTo(Inview.snp.bottom).offset(-10)
        }
        Category.snp.makeConstraints { (make) in
            make.top.equalTo(views.snp.top)
            make.left.equalTo(views.snp.left)
        }
        Title.snp.makeConstraints { (make) in
            make.top.equalTo(Category.snp.bottom).offset(8)
            make.left.equalTo(Category.snp.left)
            make.right.equalTo(views.snp.right)
        }
        LabelPrice.snp.makeConstraints { (make) in
            make.top.equalTo(Title.snp.bottom).offset(12)
            make.left.equalTo(Title.snp.left)
        }
        cashService.snp.makeConstraints { (make) in
            make.centerY.equalTo(LabelPrice.snp.centerY)
            make.left.equalTo(LabelPrice.snp.right).offset(4)
        }
        Time.snp.makeConstraints { (make) in
            make.top.equalTo(LabelPrice.snp.bottom).offset(6)
            make.left.equalTo(LabelPrice.snp.left).priority(.high)
            make.width.equalTo(views.snp.width).multipliedBy(0.6)
        }
        cityLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(Time.snp.centerY)
            make.right.equalTo(views.snp.right)
        }
    }
}

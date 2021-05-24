//
//  AllTaskShimmerCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class AllTaskShimmerCell: UITableViewCell {
    let views:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    let shimmerView1:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        return view
    }()
    let shimmerView2:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        return view
    }()
    let shimmerView3:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        return view
    }()
    let shimmerView4:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        return view
    }()
    let shimmerView5:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        return view
    }()
    let shimmerView6:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        view.layer.cornerRadius = 6
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
        //        views.shimmerAnimation = true
        addSubview(views)
        views.addSubview(shimmerView1)
        views.addSubview(shimmerView2)
        views.addSubview(shimmerView3)
        views.addSubview(shimmerView4)
        views.addSubview(shimmerView5)
        views.addSubview(shimmerView6)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        makeConst()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeConst() {
        views.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(122)
            
        }
        shimmerView1.snp.makeConstraints { (make) in
            make.top.equalTo(views.snp.top).offset(10)
            make.left.equalTo(views.snp.left).offset(15)
            make.size.equalTo(CGSize(width: 145, height: 23))
        }
        shimmerView2.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerView1.snp.bottom).offset(4)
            make.left.equalTo(views.snp.left).offset(15)
            make.right.equalTo(views.snp.right).offset(-15)
            make.height.equalTo(23)
        }
        shimmerView3.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerView2.snp.bottom).offset(4)
            make.left.equalTo(views.snp.left).offset(15)
            make.size.equalTo(CGSize(width: 170, height: 23))
        }
        shimmerView4.snp.makeConstraints { (make) in
            
            make.top.equalTo(shimmerView3.snp.bottom).offset(6)
            make.left.equalTo(views.snp.left).offset(15)
            make.size.equalTo(CGSize(width: 46, height: 18))
        }
        shimmerView5.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerView3.snp.bottom).offset(6)
            make.left.equalTo(shimmerView4.snp.right).offset(6)
            make.size.equalTo(CGSize(width: 70, height: 18))
        }
        shimmerView6.snp.makeConstraints { (make) in
            make.bottom.equalTo(views.snp.bottom).offset(-11)
            make.right.equalTo(views.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 18))
        }
    }
}

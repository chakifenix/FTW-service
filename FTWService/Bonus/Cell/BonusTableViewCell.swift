//
//  BonusTableViewCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/11/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import Alamofire

class BonusTableViewCell: UITableViewCell {
    let label:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Добавления партнера"
        return label
    }()
    let addcashLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .green
        label.text = "+100"
        return label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.textAlignment = .center
        label.text = "27.05.1998"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()
    var requestArray:BonusActivity?{
        didSet{
            print(requestArray)
            self.dateLabel.text = requestArray!.date
            self.label.text = requestArray!.reason
            self.addcashLabel.text = "\((requestArray?.pl_mn)!)\((requestArray?.value)!)"
            self.addcashLabel.textColor = requestArray!.pl_mn == "-" ? .red : .green
        }
    }
    let lineview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint(){
        addSubview(dateLabel)
        addSubview(label)
        addSubview(lineview)
        addSubview(addcashLabel)
        addcashLabel.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.top)
            make.right.equalToSuperview().offset(-24)
        }
        dateLabel.snp.makeConstraints { (make) in
            let text = dateLabel.text
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(24)
            make.width.equalTo((text?.size(OfFont: UIFont.boldSystemFont(ofSize: 12)).width)! + 16)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
        
    }
}

//
//  OurPartnersViewCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/5/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
class OurPartnersViewCell: UITableViewCell {
    
    let Inview:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let partnersImageView:WebImage = {
        let image = WebImage()
        image.image = UIImage(named: "STAR")
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let percent:UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        label.text = "20%"
        label.textColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        return label
    }()
    
    let Title:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        label.text = "Starbucks"
        return label
    }()
    
    let discription:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Скидка от партнеров"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Inview.layer.cornerRadius = 25
        Inview.layer.shadowColor = UIColor.black.cgColor
        Inview.layer.shadowRadius = 5
        Inview.layer.shadowOpacity = 0.1
        Inview.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundColor = .clear
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint(){
        addSubview(Inview)
        self.Inview.addSubview(partnersImageView)
        self.Inview.addSubview(Title)
        self.Inview.addSubview(percent)

        self.Inview.addSubview(discription)
        Inview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-8)
        }
        partnersImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(Inview.snp.left).offset(24)
            make.width.height.equalTo(50)
        }
      
        Title.snp.makeConstraints { (make) in
            make.left.equalTo(partnersImageView.snp.right).offset(24)
            make.centerY.equalTo(partnersImageView.snp.centerY).offset(-8)
        }
        percent.snp.makeConstraints { (make) in
            make.right.equalTo(Inview.snp.right).offset(-16)
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 50, height: 25))
        }
        discription.snp.makeConstraints { (make) in
            make.top.equalTo(self.Title.snp.bottom)
            make.left.equalTo(partnersImageView.snp.right).offset(24)
            make.right.equalTo(percent.snp.left).offset(8)
        }
    }
}

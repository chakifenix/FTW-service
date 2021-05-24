//
//  SearchBarView.swift
//  OrzuServiceProject
//
//  Created by Imangazy Magzhan on 5/2/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class SearchBarView: UIView,UITextFieldDelegate{
    
    lazy var searchBar: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.delegate = self
        textField.attributedPlaceholder =  NSAttributedString(string: "Найти...", attributes: [NSAttributedString.Key.font: UIFont(name: "ProximaNova-Regular", size: 18)])
        textField.leftViewMode = .always
        textField.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9647058824, blue: 0.9882352941, alpha: 1)
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "bell")
        
        var viewLeft: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        viewLeft.addSubview(imageView)
        
        textField.leftView = viewLeft
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.font = UIFont(name: "ProximaNova-Regular", size: 18)
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    
    
    var mainTaskViewController:MainViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupView(){
        addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(50)
        }
    }
    
}


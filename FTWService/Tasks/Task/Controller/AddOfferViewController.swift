//
//  AddOfferViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Alamofire
class AddOfferViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    let bluewView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return view
    }()
    let userImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileWhite")
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Имя Фамилья"
        return label
    }()
    
    let cardView:MDCCard = {
        let view = MDCCard()
        view.cornerRadius = 40
        view.isInteractable = false
        return view
    }()
    let backButton:UIButton = {
        let button = UIButton()
        button.setTitle("Нaзад", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    let addButton:UIButton = {
        let button = UIButton()
        button.setTitle("Опубликовать", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //        button.backgroundColor = #colorLiteral(red: 0.3536864519, green: 0.7271710634, blue: 0.3864591122, alpha: 1)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
     let textField:UITextView = {
        let textfield = UITextView()
        textfield.text = "Напишите предложение"
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = .lightGray
        textfield.layer.cornerRadius = 10
        textfield.layer.borderColor = #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)
        textfield.layer.borderWidth = 2
//        textfield.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        textfield.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        return textfield
    }()
    let CashtextField:UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 10
        textfield.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        textfield.layer.borderWidth = 2
        textfield.placeholder = "Предложите цену"
        textfield.addPadding(.left(12))
        return textfield
    }()
    var userName = ""
    var taskId:String = ""
    var userimage:UIImage?
    var isChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Отклик"
        nameLabel.text = userName
        userImage.image = userimage
        hideKeyboardWhenTappedAround()
        textField.delegate = self
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        configureViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            self.hideLoader()
    }
    
    func configureViews() {
        self.view.addSubview(cardView)
        cardView.addSubview(textField)
        cardView.addSubview(addButton)
        cardView.addSubview(nameLabel)
        cardView.addSubview(backButton)
        cardView.addSubview(userImage)
        cardView.addSubview(CashtextField)
        
        backButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addReviews), for: .touchUpInside)
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(64)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.65)
        }
        userImage.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.top).offset(3)
            make.left.equalTo(userImage.snp.right).offset(10)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.bottom).offset(20)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.bottom.equalTo(CashtextField.snp.top).offset(-16)
        }
        CashtextField.snp.makeConstraints { (make) in
            make.left.equalTo(textField.snp.left)
            make.right.equalTo(textField.snp.right)
            make.height.equalTo(45)
            make.bottom.equalTo(backButton.snp.top).offset(-16)
        }
        backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.left.equalTo(textField.snp.left)
            make.right.equalTo(cardView.snp.centerX).offset(-8)
            make.height.equalTo(45)
        }
        addButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.right.equalTo(textField.snp.right)
            make.left.equalTo(cardView.snp.centerX).offset(8)
            make.height.equalTo(45)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.applyGradientWithoutCorner(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    @objc func cancelAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func addReviews() {
        self.showLoader()
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=task_requests&act=input&") else {return}
        var param = [String:String]()
        let loginId = UserDefaults.standard.integer(forKey: "ID")
        let token = UserDefaults.standard.string(forKey: "token")
        guard let text = textField.text,let cashText = CashtextField.text else {return}
        param = ["task_id": taskId, "narrative": "\(text)","userid":"\(loginId)","amount":cashText,"utoken":token!]
      
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let result = value as! String
                if result == "This user has already added a request" {
                    self.showAlert(text: "Вы уже оставили отклик!", completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                } else {
                    self.showAlert(text: "Вы оставили отклик!", completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            case .failure(let error):
                print(error)
                self.hideLoader()
            }
        }
        
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textField.textColor == UIColor.lightGray {
            textField.text = ""
            textField.textColor = UIColor.black
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
}


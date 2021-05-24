//
//  AddReviewsViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import MaterialComponents
import Alamofire
import SnapKit
class AddReviewsViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
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
        return label
    }()
    let datelabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
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
        button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        button.layer.borderWidth = 2
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
        textfield.text = "Напишите отзыв"
        textfield.textColor = UIColor.lightGray
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.layer.cornerRadius = 10
        textfield.layer.borderColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
        textfield.layer.borderWidth = 2
        textfield.textContainerInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        return textfield
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "coolSmile")
        image.isUserInteractionEnabled = true
        image.alpha = 1
        return image
    }()
    let NormaliconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "normalSmile")
        image.isUserInteractionEnabled = true
        image.alpha = 0.5
        return image
    }()
    let BadiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "badSmile")
        image.isUserInteractionEnabled = true
        image.alpha = 0.5
        return image
    }()
    private let formatDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    var name = ""
    var userimage:UIImage?
    var callback : ((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Отзывы"
        nameLabel.text = name
        userImage.image = userimage
        datelabel.text = formatDay.string(from: Date())
        hideKeyboardWhenTappedAround()
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(goodImageSelect))
        iconLike.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(normalImageSelect))
        NormaliconLike.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(badImageSelect))
        BadiconLike.addGestureRecognizer(tap3)
        textField.delegate = self
        //        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        configureViews()
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(true)
    //        navigationController?.navigationBar.tintColor = .white
    //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    //        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
    //
    ////        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    ////        navigationController?.navigationBar.titleTextAttributes = textAttributes
    //    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.applyGradientWithoutCorner(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    func configureViews() {
        self.view.addSubview(cardView)
        cardView.addSubview(textField)
        cardView.addSubview(iconLike)
        cardView.addSubview(addButton)
        cardView.addSubview(nameLabel)
        cardView.addSubview(datelabel)
        cardView.addSubview(backButton)
        cardView.addSubview(userImage)
        cardView.addSubview(BadiconLike)
        cardView.addSubview(NormaliconLike)
        
        backButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addReviews), for: .touchUpInside)
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(64)
            make.left.equalTo(self.view.snp.left).offset(24)
            make.right.equalTo(self.view.snp.right).offset(-24)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.65)
        }
        userImage.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.top).offset(2)
            make.left.equalTo(userImage.snp.right).offset(10)
        }
        datelabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.left.equalTo(nameLabel.snp.left)
        }
        iconLike.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImage.snp.centerY)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        NormaliconLike.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImage.snp.centerY)
            make.right.equalTo(iconLike.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        BadiconLike.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImage.snp.centerY)
            make.right.equalTo(NormaliconLike.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.bottom.equalTo(backButton.snp.top).offset(-32)
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
    
    @objc func goodImageSelect() {
        iconLike.alpha = 1
        BadiconLike.alpha = 0.5
        NormaliconLike.alpha = 0.5
    }
    @objc func normalImageSelect() {
        iconLike.alpha = 0.5
        BadiconLike.alpha = 0.5
        NormaliconLike.alpha = 1
    }
    @objc func badImageSelect() {
        iconLike.alpha = 0.5
        BadiconLike.alpha = 1
        NormaliconLike.alpha = 0.5
    }
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addReviews() {
        self.showLoader()
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=reviews&act=input&") else {return}
        var param = [String:String]()
        let loginId = UserDefaults.standard.integer(forKey: "ID")
        let token = UserDefaults.standard.string(forKey: "token")
        let userId = PassData.UserID
        guard let text = textField.text else {return}
        if iconLike.alpha == 1 {
            param = ["userid": "\(loginId)", "narrative": "\(text)","like_user_id":userId,"like":"\(2)","utoken":token!]
        }
        else if NormaliconLike.alpha == 1 {
            param = ["userid": "\(loginId)", "narrative": "\(text)","like_user_id":userId,"like":"\(1)","utoken":token!]
        }
        else if BadiconLike.alpha == 1 {
            param = ["userid": "\(loginId)", "narrative": "\(text)","like_user_id":userId,"like":"\(0)","utoken":token!]
        }
        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.showAlert(text: "Вы оставили отзыв!", completion: {
                    self.callback!("Success")
                    self.navigationController?.popViewController(animated: true)
                })
                var paramBonus = [String:String]()
                if self.BadiconLike.alpha == 1 {
                    paramBonus = ["act":"edit_bonus_feedback_minus","userid":String(loginId),"useridTo":userId,"utoken":token!]
                } else {
                    paramBonus = ["act":"edit_bonus_feedback_plus","userid":String(loginId),"useridTo":userId,"utoken":token!]
                }
                let queue = DispatchQueue.global(qos: .utility)
                queue.async {
                    Networking.partnerUrl(url: Constans().addBonus, param: paramBonus, completion: { (val, err) in
                    })
                }
               
            case .failure(let error):
                print(error)
            }
        }
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "MyTask")
        //        self.present(controller, animated: true, completion: nil)
        
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
}

extension UIView {
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = self.frame.size.height/2
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradientWithoutCorner(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradientforLabel(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 32, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 32, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}


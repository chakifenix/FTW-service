//
//  CashTaskViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import iOSDropDown
class CashTaskViewController: UIViewController {
    let label = UILabel()
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let cardView: AnimateView = {
        let view = AnimateView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    private let chooseBtn1: UILabel = {
        let label = UILabel()
        label.text = "Указать цену самому"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.alpha = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private let chooseBtn2: UILabel = {
        let label = UILabel()
        label.text = "Исполнитель предложит цену"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.alpha = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private let lineview: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    private let triangle1: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tran")
        image.alpha = 0
        return image
    }()
    private let triangle2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tran")
        return image
    }()
    private let textField:UITextField = {
        let text = UITextField()
        text.placeholder = "Укажите цену"
        text.borderStyle = .none
        text.keyboardType = .numberPad
        text.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return text
    }()
    private let stepIndex:UILabel = {
        let label = UILabel()
        label.text = "Шаг 4 из 6"
        label.textColor = .lightGray
        return label
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Укажите цену"
        label.textColor = .black
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.triangle1.alpha = 1
                self.chooseBtn1.alpha = 1
                self.chooseBtn2.alpha = 1
            })
            
        }
        createViews()
        setContinueButton(enabled: false)
        hideKeyboardWhenTappedAround()
        setupBarButton()
        let tapForChooseButton1 = UITapGestureRecognizer(target: self, action: #selector(chooseButtonAction1))
        chooseBtn1.addGestureRecognizer(tapForChooseButton1)
        let tapForChooseButton2 = UITapGestureRecognizer(target: self, action: #selector(chooseButtonAction2))
        chooseBtn2.addGestureRecognizer(tapForChooseButton2)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
        print("Some changes")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardSettings()
    }
    func keyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func setupBarButton() {
        let right = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCalcelAction))
        navigationItem.rightBarButtonItem = right
    }
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        button.center = CGPoint(x: cardView.center.x, y: cardView.frame.height - kbFrameSize!.height - button.frame.height/2 - 16)
    }
    @objc func kbDidHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        button.center = CGPoint(x: cardView.center.x, y: cardView.frame.height - 64)
    }
    @objc func handleCalcelAction() {
        print("Cancel")
        self.showAlertAction(title: nil, message: "Введенные данные будет потеряны.Удалить заданиие?", titleOk: "Удалить", cancelTitle: "Продолжить создание") { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    private func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        bgView.addSubview(chooseBtn1)
        bgView.addSubview(chooseBtn2)
        triangle1.isHidden = false
        triangle2.isHidden = true
        bgView.addSubview(triangle1)
        bgView.addSubview(triangle2)
        cardView.addSubview(stepIndex)
        cardView.addSubview(titleLabel)
        cardView.addSubview(lineview)
        cardView.addSubview(textField)
        cardView.addSubview(button)
        //        let segmentItem = ["Указать цену самому","Исполнитель предложит цену"]
        //        segmentControl = UISegmentedControl(items: segmentItem)
        //        segmentControl.selectedSegmentIndex = 0
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(128)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        chooseBtn1.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(28)
            make.width.equalTo(100)
        }
        chooseBtn2.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(chooseBtn1.snp.right).offset(24)
            make.width.equalTo(140)
        }
        triangle1.snp.makeConstraints { (make) in
            make.top.equalTo(chooseBtn1.snp.bottom).offset(1)
            make.centerX.equalTo(chooseBtn1.snp.centerX)
            make.size.equalTo(CGSize(width: 25, height: 16))
        }
        triangle2.snp.makeConstraints { (make) in
            make.top.equalTo(chooseBtn2.snp.bottom).offset(1)
            make.centerX.equalTo(chooseBtn2.snp.centerX)
            make.size.equalTo(CGSize(width: 25, height: 16))
        }
        stepIndex.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.centerX.equalTo(cardView.snp.centerX)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stepIndex.snp.bottom).offset(24)
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(6)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.height.equalTo(1)
        }
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        
        
    }
    @objc func textFieldChanged() {
        guard
            let textFieldtext = textField.text
            else {return}
        lineview.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)
        let formFilled = !(textFieldtext.isEmpty)
        setContinueButton(enabled: formFilled)
    }
    func setContinueButton(enabled: Bool) {
        if enabled {
            button.alpha = 1
            button.isEnabled = true
        } else {
            button.alpha = 0.5
            button.isEnabled = false
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
    @objc func buttonPressed() {
        guard let taskText = textField.text else {return}
        PassData.cashTask = triangle1.isHidden == false ? taskText: "wtasker"
        let vc = MoreTaskViewController()
        self.show(vc, sender: self)
        
    }
    @objc func chooseButtonAction1() {
        triangle1.isHidden = false
        triangle2.isHidden = true
        label.isHidden = true
        button.alpha = 0.5
        button.isEnabled = false
        chooseBtn1.font = UIFont.boldSystemFont(ofSize: 15)
        chooseBtn2.font = UIFont.systemFont(ofSize: 15)
        textField.isHidden = false
        lineview.isHidden = false
        titleLabel.isHidden = false
    }
    @objc func chooseButtonAction2() {
        triangle1.isHidden = true
        triangle2.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Исполнитель предложит цену сам."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = false
        self.cardView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.topAnchor.constraint(equalTo: stepIndex.bottomAnchor, constant: 32).isActive = true
        label.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        button.alpha = 1
        button.isEnabled = true
        chooseBtn1.font = UIFont.systemFont(ofSize: 15)
        chooseBtn2.font = UIFont.boldSystemFont(ofSize: 15)
        textField.isHidden = true
        lineview.isHidden = true
        titleLabel.isHidden = true
        
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

extension CashTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    
}

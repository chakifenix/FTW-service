//
//  Create_TasksViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
class Create_TasksViewController: UIViewController {
    
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
        return view
    }()
    private let cardView: AnimateView = {
        let view = AnimateView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    private let tableview: UITableView = {
        let table = UITableView()
        return table
    }()
    private let viewTable: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.text = "Например,ремонт техники"
        label.textColor = .lightGray
        return label
    }()
    private let textField:UITextField = {
        let text = UITextField()
        text.placeholder = "Названия задания"
        text.borderStyle = .none
        text.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return text
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
    let identify = "CatSuggest"
    let url = "https://orzu.org/tasks/taskajaxupload?find="
    var category = ""
    var suggestArray = [String]()
    var kbHeight:CGFloat?
    var heightCardView:Constraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.titleLabel.alpha = 1
            })
            
        }
        createViews()
        tableview.dataSource = self
        tableview.delegate = self
        viewTable.isHidden = true
        tableview.separatorStyle = .none
        setContinueButton(enabled: "")
        hideKeyboardWhenTappedAround()
        keyboardSettings()
        setupBarButton()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardSettings()
    }
    func keyboardSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        kbHeight = kbFrameSize?.height
        print(cardView.frame.size.height)
        heightCardView?.update(offset: 64)
        exampleLabel.isHidden = true
    }
    @objc func kbDidHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        button.center = CGPoint(x: cardView.center.x, y: cardView.frame.height - 64)
        //        heightCardView?.update(offset: 124)
    }
    
    private func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        bgView.addSubview(titleLabel)
        titleLabel.text = category
        let stepIndex = UILabel()
        stepIndex.text = "Шаг 1 из 6"
        stepIndex.textColor = .lightGray
        
        let textTitle = UILabel()
        textTitle.text = "Что нужно сделать"
        textTitle.textColor = .lightGray
        
        
        cardView.addSubview(stepIndex)
        cardView.addSubview(textTitle)
        cardView.addSubview(exampleLabel)
        cardView.addSubview(lineview)
        cardView.addSubview(textField)
        cardView.addSubview(button)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            heightCardView = make.top.equalTo(self.view.snp.top).offset(128).constraint
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(24)
            make.right.equalTo(bgView.snp.right).offset(-36)
        }
        stepIndex.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.centerX.equalTo(cardView.snp.centerX)
        }
        textTitle.snp.makeConstraints { (make) in
            make.top.equalTo(stepIndex.snp.bottom).offset(24)
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(textTitle.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(6)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.height.equalTo(1)
        }
        exampleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(8)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        
        
    }
    private func createTableView() {
        cardView.addSubview(viewTable)
        viewTable.isHidden = false
        button.snp.remakeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-(kbHeight!+6))
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        viewTable.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(4)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.bottom.equalTo(button.snp.top)
        }
        tableview.register(catSuggest.self, forCellReuseIdentifier: identify)
        viewTable.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(viewTable)
        }
    }
    func jsonData(string: String) {
        guard let url = URL(string:"https://orzu.org/tasks/taskajaxupload?find=\(string)") else {return}
        print(url)
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = value as! [String]
                self.suggestArray = json
                self.tableview.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func setupBarButton() {
        let right = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCalcelAction))
        navigationItem.rightBarButtonItem = right
    }
    @objc func textFieldChanged() {
        guard
            let textFieldtext = textField.text
            else {return}
        createTableView()
        lineview.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)
        let encodedTexts = textFieldtext.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts else {return}
        let str = String(utf8String: rusTextt.cString(using: .utf8)!)
        jsonData(string: str!)
        setContinueButton(enabled: textFieldtext)
    }
    @objc func buttonPressed() {
        guard let taskText = textField.text else {return}
        PassData.createTask = taskText
        let vc = LocationTaskViewController()
        self.show(vc, sender: self)
    }
    func setContinueButton(enabled: String) {
        if enabled != "" {
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
    @objc func handleCalcelAction() {
        print("Cancel")
        self.showAlertAction(title: nil, message: "Введенные данные будет потеряны.Удалить заданиие?", titleOk: "Удалить", cancelTitle: "Продолжить создание") { (_) in
            self.navigationController?.popToRootViewController(animated: true)
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
extension Create_TasksViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath) as! catSuggest
        cell.label.text = suggestArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.text = suggestArray[indexPath.row]
        setContinueButton(enabled: "\(suggestArray[indexPath.row])")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.button.center = CGPoint(x: self.cardView.center.x, y: self.cardView.frame.height - 64)
            self.viewTable.isHidden = true
        }
    }
}
extension Create_TasksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    
}
class catSuggest:UITableViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"Apple SD Gothic Neo Regular", size: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubViewsAndlayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubViewsAndlayout() {
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
    }
}



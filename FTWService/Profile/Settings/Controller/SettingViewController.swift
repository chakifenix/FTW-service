//
//  SettingViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let tableview: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Green")
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
    private let lineview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Выйти из профиля", for: .normal)
        btn.backgroundColor = .white
        return btn
    }()
    let Quitlabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Выйти из профиля"
        label.isUserInteractionEnabled = true
        return label
    }()

    
    let userdef = UserDefaults.standard
    var nameLabel = ""
    var fname = ""
    var location = ""
    var descrMe = ""
    var birth = ""
    var gender = ""
    var savedImage:UIImage?
    let array = ["Редактировать","Смена пароля","Уведомления"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isScrollEnabled = false
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        Quitlabel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    @objc func tapAction() {
        let alert = UIAlertController(title: "", message: "Вы уверены, что хотите выйти из профиля?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Выйти", style: .default) { (action) in
            self.userdef.removeObject(forKey: "ID")
            self.userdef.removeObject(forKey: "token")
            self.userdef.removeObject(forKey: "login")
            self.userdef.removeObject(forKey: "name")
            self.userdef.removeObject(forKey: "SMS")
            UserDefaults.standard.removeObject(forKey: "SaveData")
            self.userdef.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginPage")
                self.present(vc, animated: true, completion: nil)
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert,animated: true)
    }
    func createViews() -> Void {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        //        self.view.addSubview(titleName)
        cardView.addSubview(tableview)
        cardView.addSubview(lineview)
        cardView.addSubview(Quitlabel)
        tableview.register(SettingCell.self, forCellReuseIdentifier: "settingCell")
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        //        titleName.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.view.snp.top).offset(28)
        //            make.centerX.equalTo(self.view.snp.centerX).offset(15)
        //            make.size.equalTo(CGSize(width: 100, height: 30))
        //        }
        
        cardView.snp.makeConstraints { (make) in
            let heightView = self.view.frame.height * 0.8
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(heightView)
        }
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.height.equalTo(180)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(tableview.snp.bottom)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.height.equalTo(20)
        }
        Quitlabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(tableview.snp.right)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
        cell.label.text = array[indexPath.row]
        let sentImage = #imageLiteral(resourceName: "right")
        let sentImageView = UIImageView(image: sentImage.maskWithColor(color: #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)))
        sentImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        cell.accessoryView = sentImageView
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = EditSettingsViewController()
            vc.nameTextField.text = nameLabel
            vc.fnameTextField.text = fname
            vc.locationTextField.text = location
            vc.aboutMeTextField.text = descrMe
            vc.DaytextField.text = birth
            vc.userImage.image = savedImage
            if gender == "Мужчина" {
                vc.MenRadioButton.isSelected = true
            } else {
                vc.WomenRadioButton.isSelected = true
            }
            self.show(vc, sender: self)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "changePassword")
            self.show(controller, sender: self)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "natSet") as! SettingsOfNatificationsController
            self.show(vc, sender: self)
        default:
            break
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
class SettingCell: UITableViewCell {
    let image1: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "accountt")
        return image
    }()
    
    let label:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        backgroundColor = .clear
        configureViews()
    }
    func configureViews() {
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

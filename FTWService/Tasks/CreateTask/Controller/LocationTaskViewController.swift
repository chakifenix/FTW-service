//
//  LocationTaskViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MapKit
import MaterialComponents
import YandexMapKitSearch
import SnapKit
class LocationTaskViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    private let chooseBtn1: UIButton = {
        let button = UIButton()
        button.setTitle("Указать место", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(choosePlaceAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.alpha = 0
        return button
    }()
    private let chooseBtn2: UIButton = {
        let button = UIButton()
        button.setTitle("Удаленно", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.alpha = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(remoteButtonAction), for: .touchUpInside)
        return button
    }()
    private let textField:UITextField = {
        let text = UITextField()
        text.placeholder = "Город,район или точный адрес"
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
    private let identify = "YandexCell"
    private let tableview: UITableView = {
        let table = UITableView()
        return table
    }()
    private let suggestView: UIView = {
        let view = UIView()
        return view
    }()
    private let label = UILabel()
    let stepIndex = UILabel()
    let textTitle = UILabel()
    private var suggestResults: [YMKSuggestItem] = []
    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    
    private let BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))
    private let SEARCH_OPTIONS = YMKSearchOptions()
    var kbHeight:CGFloat?
    var heightCardView:Constraint?
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
        tableview.delegate = self
        tableview.dataSource = self
        //setContinueButton(enabled: false)
        hideKeyboardWhenTappedAround()
        setupBarButton()
        // Do any additional setup after loading the view.
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
        heightCardView?.update(offset: 64)
        
    }
    @objc func kbDidHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        button.center = CGPoint(x: cardView.center.x, y: cardView.frame.height - 64)
    }
    private func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        bgView.addSubview(chooseBtn1)
        bgView.addSubview(chooseBtn2)
        stepIndex.text = "Шаг 2 из 6"
        stepIndex.textColor = .lightGray
        textTitle.text = "Укажите место"
        textTitle.textColor = .black
        triangle1.isHidden = false
        triangle2.isHidden = true
        bgView.addSubview(triangle1)
        bgView.addSubview(triangle2)
        cardView.addSubview(stepIndex)
        cardView.addSubview(textTitle)
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
        chooseBtn1.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(32)
            make.size.equalTo(CGSize(width: 120, height: 20))
        }
        chooseBtn2.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(chooseBtn1.snp.right).offset(32)
            make.size.equalTo(CGSize(width: 100, height: 20))
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
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        
        
    }
    func setupBarButton() {
        let right = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCalcelAction))
        navigationItem.rightBarButtonItem = right
    }
    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items
        tableview.reloadData()
    }
    func onSuggestError(_ error: Error) {
        let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if suggestError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if suggestError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    @objc func textFieldChanged(_ sender: UITextField) {
        guard
            let textFieldtext = textField.text
            else {return}
        lineview.backgroundColor = Data_Colors.gradientColor
        let formFilled = !(textFieldtext.isEmpty)
        setContinueButton(enabled: formFilled)
        if suggestResults.count != 0 {
            createTableView()
        }
        let suggestHandler = {(response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
        
        searchManager.suggest(
            withText: sender.text!,
            window: BOUNDING_BOX,
            searchOptions: SEARCH_OPTIONS,
            responseHandler: suggestHandler)
    }
    @objc func handleCalcelAction() {
        print("Cancel")
        self.showAlertAction(title: nil, message: "Введенные данные будет потеряны.Удалить заданиие?", titleOk: "Удалить", cancelTitle: "Продолжить создание") { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func createTableView() {
        self.view.addSubview(suggestView)
        tableview.register(YandexTableViewCell.self, forCellReuseIdentifier: identify)
        tableview.separatorStyle = .none
        suggestView.isHidden = false
        suggestView.addSubview(tableview)
        button.snp.remakeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-(kbHeight!+6))
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        suggestView.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(4)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.bottom.equalTo(button.snp.top)
        }
        tableview.snp.makeConstraints { (make) in
            make.edges.equalTo(suggestView)
        }
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
        PassData.location = triangle1.isHidden == false ? taskText : "Удаленно"
        let vc = DateTaskViewController()
        self.show(vc, sender: self)
    }
    @objc func choosePlaceAction() {
        chooseBtn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        triangle1.isHidden = false
        triangle2.isHidden = true
        textField.isHidden = false
        label.isHidden = true
        textTitle.isHidden = false
        stepIndex.isHidden = false
        lineview.isHidden = false
        button.alpha = 0.5
        button.isEnabled = false
        suggestView.isHidden = false
    }
    @objc func remoteButtonAction() {
        chooseBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        triangle1.isHidden = true
        triangle2.isHidden = false
        textTitle.isHidden = true
        stepIndex.isHidden = true
        textField.isHidden = true
        lineview.isHidden = true
        suggestView.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Встреча не нужна, исполнитель выполнит заказ там, где ему удобнее. Для исполнителей из любых городов."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = false
        self.cardView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32).isActive = true
        label.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        button.alpha = 1
        button.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identify, for: indexPath) as! YandexTableViewCell
        cell.label.text = self.suggestResults[indexPath.row].displayText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        textField.text = suggestResults[indexPath.row].displayText
        setContinueButton(enabled: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
            self.button.center = CGPoint(x: self.cardView.center.x, y: self.cardView.frame.height - 64)
            self.suggestView.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
extension LocationTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
}

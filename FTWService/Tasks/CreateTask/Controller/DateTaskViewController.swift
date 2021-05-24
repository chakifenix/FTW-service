//
//  DateTaskViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import FSCalendar
import MaterialComponents
import iOSDropDown
class DateTaskViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate,UIGestureRecognizerDelegate {
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
        label.text = "Договорюсь с исполнителем"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.alpha = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    private let chooseBtn2: UIButton = {
        let button = UIButton()
        button.setTitle("Указать период", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 0
        button.sizeToFit()
        button.alpha = 0
        button.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        return button
    }()
    private let chooseBtn3: UIButton = {
        let button = UIButton()
        button.setTitle("Точная дата", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 0
        button.sizeToFit()
        button.alpha = 0
        button.addTarget(self, action: #selector(buttonAction3), for: .touchUpInside)
        return button
    }()
    private let lineview: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let lineview2: UIView = {
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
        
        return image
    }()
    private let triangle2: UIImageView = {
        let image = UIImageView()
        image.alpha = 0
        image.image = UIImage(named: "tran")
        return image
    }()
    private let triangle3: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tran")
        return image
    }()
    private let startLabelText:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.isUserInteractionEnabled = true
        label.text = "Когда начать"
        return label
    }()
    private let finishLabelText:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.isUserInteractionEnabled = true
        label.text = "Когда закончить"
        return label
    }()
    private let startData:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "--.--.--"
        return label
    }()
    private let finishData:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "--.--.--"
        return label
    }()
    private let menuTime: DropDown = {
        let view = DropDown()
        view.text = "В любое время"
        view.selectedRowColor = .lightGray
        return view
    }()
    private var calendar = FSCalendar()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private let formatDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    private let timeView: MDCCard = {
        let View = MDCCard()
        View.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return View
    }()
    private let labelDate:UILabel = {
        let label  = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        label.text = "В любое время"
        return label
    }()
    private let tableview: UITableView = {
        let table = UITableView()
        return table
    }()
    private let viewTable: MDCCard = {
        let view = MDCCard()
        return view
    }()
    var dropDownString = ""
    let calendarVC = CalendarViewController()
    var coverView:UIView?
    let label = UILabel()
    let stepIndex = UILabel()
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var isStartCalendarPressed = false
    var isFinishCalendarPressed = false
    let array = ["В любое время","утром (до 12)","днем (с 12 до 17)","вечером (с 17 до 22)","ночью (после 22)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.chooseBtn3.alpha = 1
                self.chooseBtn1.alpha = 1
                self.chooseBtn2.alpha = 1
                self.triangle2.alpha = 1
            })
            
        }
        createViews()
        let starttap =  UITapGestureRecognizer(target: self, action: #selector(tapFunction1(sender:)))
        startLabelText.addGestureRecognizer(starttap)
        let finishtap =  UITapGestureRecognizer(target: self, action: #selector(tapFunction2(sender:)))
        finishLabelText.addGestureRecognizer(finishtap)
        let tapForChooseButton1 = UITapGestureRecognizer(target: self, action: #selector(buttonAction1(sender:)))
        chooseBtn1.addGestureRecognizer(tapForChooseButton1)
        hideKeyboardWhenTappedAround()
        calendarVC.delegate = self
        setContinueButton(enabled: false)
        setupBarButton()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    //    func isHiddenSettings() {
    //
    //        label.isHidden = true
    //        timeView.isHidden = true
    //        cardView.addSubview(timeView)
    //        timeView.addSubview(labelDate)
    //        tableview.delegate = self
    //        tableview.dataSource = self
    //        tableview.register(TimeTableViewCell.self, forCellReuseIdentifier: "timeCell")
    //        tableview.separatorStyle = .none
    //        tableview.isScrollEnabled = false
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dropDownAction))
    //        timeView.addGestureRecognizer(tap)
    //        timeView.snp.makeConstraints { (make) in
    //            make.top.equalTo(startLabelText.snp.bottom).offset(32)
    //            make.left.equalTo(cardView.snp.left).offset(24)
    //            make.right.equalTo(cardView.snp.right).offset(-24)
    //            make.height.equalTo(50)
    //        }
    //        labelDate.snp.makeConstraints { (make) in
    //            make.centerY.equalTo(timeView.snp.centerY)
    //            make.left.equalTo(timeView.snp.left).offset(16)
    //        }
    //    }
    private func createViews() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        bgView.addSubview(chooseBtn1)
        bgView.addSubview(chooseBtn2)
        bgView.addSubview(chooseBtn3)
        menuTime.optionArray = array
        menuTime.rowHeight = 40
        menuTime.listHeight = 200
        menuTime.didSelect { (str, _, _) in
            self.menuTime.text = str
            self.dropDownString = str
            if self.startData.text != "--.--.--" {
                self.setContinueButton(enabled: true)
            }
        }
        stepIndex.text = "Шаг 3 из 6"
        stepIndex.textColor = .lightGray
        triangle1.isHidden = true
        triangle2.isHidden = false
        triangle3.isHidden = true
        menuTime.isHidden = true
        bgView.addSubview(triangle1)
        bgView.addSubview(triangle2)
        bgView.addSubview(triangle3)
        cardView.addSubview(stepIndex)
        cardView.addSubview(lineview)
        cardView.addSubview(lineview2)
        cardView.addSubview(button)
        cardView.addSubview(startLabelText)
        cardView.addSubview(finishLabelText)
        cardView.addSubview(startData)
        cardView.addSubview(finishData)
        cardView.addSubview(menuTime)
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
            make.left.equalTo(bgView.snp.left).offset(24)
            make.width.equalTo(cardView.snp.width).multipliedBy(0.3)
        }
        chooseBtn2.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.centerX.equalTo(cardView.snp.centerX)
            make.width.equalTo(cardView.snp.width).multipliedBy(0.25)
        }
        chooseBtn3.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.width.equalTo(cardView.snp.width).multipliedBy(0.25)
            
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
        triangle3.snp.makeConstraints { (make) in
            make.top.equalTo(chooseBtn3.snp.bottom).offset(1)
            make.centerX.equalTo(chooseBtn3.snp.centerX)
            make.size.equalTo(CGSize(width: 25, height: 16))
        }
        stepIndex.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.centerX.equalTo(cardView.snp.centerX)
        }
        
        startLabelText.snp.makeConstraints { (make) in
            make.top.equalTo(stepIndex.snp.bottom).offset(32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        finishLabelText.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        startData.snp.makeConstraints { (make) in
            make.top.equalTo(startLabelText.snp.top)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        finishData.snp.makeConstraints { (make) in
            make.top.equalTo(finishLabelText.snp.top)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(startLabelText.snp.bottom).offset(12)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.height.equalTo(1)
        }
        lineview2.snp.makeConstraints { (make) in
            make.top.equalTo(finishLabelText.snp.bottom).offset(12)
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
        menuTime.snp.makeConstraints { (make) in
            make.top.equalTo(startLabelText.snp.bottom).offset(32)
            make.left.equalTo(startLabelText.snp.left)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(40)
        }
        
    }
    //    func createTimeTableView() {
    //        viewTable.isHidden = false
    //        cardView.addSubview(viewTable)
    //        viewTable.addSubview(tableview)
    //        viewTable.snp.makeConstraints { (make) in
    //            make.top.equalTo(timeView.snp.top)
    //            make.left.equalTo(timeView.snp.left)
    //            make.right.equalTo(timeView.snp.right)
    //            make.height.lessThanOrEqualTo(cardView.snp.height).multipliedBy(0.4)
    //        }
    //        tableview.snp.makeConstraints { (make) in
    //            make.edges.equalTo(viewTable)
    //        }
    //    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func setupBarButton() {
        let right = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCalcelAction))
        navigationItem.rightBarButtonItem = right
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
    func setContinueButton(enabled: Bool) {
        if enabled {
            button.alpha = 1
            button.isEnabled = true
        } else {
            button.alpha = 0.5
            button.isEnabled = false
        }
    }
    @objc func buttonAction1(sender:UITapGestureRecognizer) {
        chooseBtn1.font = UIFont.boldSystemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        chooseBtn3.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        triangle1.isHidden = false
        triangle2.isHidden = true
        triangle3.isHidden = true
        startLabelText.isHidden = true
        finishLabelText.isHidden = true
        startData.isHidden = true
        finishData.isHidden = true
        lineview.isHidden = true
        lineview2.isHidden = true
        menuTime.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Дату выполнения задачи обсудите с выбранным исполнителем"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = false
        self.cardView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.topAnchor.constraint(equalTo:  stepIndex.bottomAnchor, constant: 32).isActive = true
        label.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 24).isActive = true
        label.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -24).isActive = true
        setContinueButton(enabled: true)
        
    }
    @objc func buttonAction2() {
        chooseBtn1.font = UIFont.systemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        chooseBtn3.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        triangle1.isHidden = true
        triangle2.isHidden = false
        triangle3.isHidden = true
        startLabelText.isHidden = false
        finishLabelText.isHidden = false
        startData.isHidden = false
        finishData.isHidden = false
        lineview.isHidden = false
        lineview2.isHidden = false
        label.isHidden = true
        menuTime.isHidden = true
        setContinueButton(enabled: false)
        
    }
    @objc func buttonAction3() {
        startData.text = "--.--.--"
        chooseBtn1.font = UIFont.systemFont(ofSize: 15)
        chooseBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        chooseBtn3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        triangle1.isHidden = true
        triangle2.isHidden = true
        triangle3.isHidden = false
        label.isHidden = true
        menuTime.isHidden = false
        startLabelText.isHidden = false
        finishLabelText.isHidden = true
        startData.isHidden = false
        finishData.isHidden = true
        lineview.isHidden = false
        lineview2.isHidden = true
        setContinueButton(enabled: false)
    }
    @objc func buttonPressed() {
        guard let startDay = startData.text,let finishDay = finishData.text  else {return}
        if triangle1.isHidden == false {
            PassData.wtasker = "wtasker"
        } else if triangle2.isHidden == false {
            PassData.startdayTask = startDay
            PassData.finishdayTask = finishDay
        } else if triangle3.isHidden == false {
            PassData.selectedIndexDay = dropDownString
            PassData.exactDay = startDay
        }
        let vc = CashTaskViewController()
        self.show(vc, sender: self)
    }
    //    @objc func dropDownAction() {
    ////        createTimeTableView()
    //    }
    @objc func tapFunction1(sender:UITapGestureRecognizer) {
        isStartCalendarPressed = true
        isFinishCalendarPressed = false
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.modalPresentationStyle = .overCurrentContext
        self.present(calendarVC, animated: true, completion: nil)
    }
    @objc func tapFunction2(sender:UITapGestureRecognizer) {
        isStartCalendarPressed = false
        isFinishCalendarPressed = true
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.modalPresentationStyle = .overCurrentContext
        self.present(calendarVC, animated: true, completion: nil)
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


extension DateTaskViewController:customCalendar {
    func getDate(date: Date) {
        if isStartCalendarPressed {
            startData.text = self.formatter.string(from: date)
            if triangle3.isHidden == false {
                setContinueButton(enabled: true)
            }
        }
        if isFinishCalendarPressed {
            finishData.text = self.formatter.string(from: date)
        }
        if startData.text != "--.--.--" && finishData.text != "--.--.--" {
            setContinueButton(enabled: true)
        }
    }
    
    
}
//extension DateTaskViewController: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return array.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeTableViewCell
//        cell.label.text = array[indexPath.row]
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        labelDate.text = array[indexPath.row]
//        dropDownString = array[indexPath.row]
//        UIView.animate(withDuration: 0.1) {
//            self.viewTable.isHidden = true
//        }
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = tableview.frame.size.height/5
//        return height
//    }
//
//}


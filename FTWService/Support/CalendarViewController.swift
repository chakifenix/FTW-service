//
//  CalendarViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import FSCalendar
import MaterialComponents
import SnapKit
protocol customCalendar {
    func getDate(date: Date)
}
class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate {
    private let View: UIView = {
        let View = UIView()
        View.backgroundColor = UIColor.groupTableViewBackground
        View.translatesAutoresizingMaskIntoConstraints = false
        View.layer.cornerRadius = 45
        View.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return View
    }()
    private let button:UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let formatDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    var selectedDate: Date?
    var calendar: FSCalendar!
    var delegate:customCalendar?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        createCalendar()
        hideKeyboardWhenTappedAround()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    fileprivate func createCalendar() {
        self.view.addSubview(View)
        let calendar = FSCalendar()
        calendar.layer.cornerRadius = 45
        calendar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        calendar.delegate = self
        calendar.dataSource = self
        let locale = Locale(identifier: "ru_RU")
        calendar.locale = locale
        calendar.backgroundColor = UIColor.groupTableViewBackground
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        //        for x in calendar.calendarWeekdayView.weekdayLabels {
        //            x.textColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        //        }
        //        for x in calendar.calendarHeaderView {
        //            x.textColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        //        }
        View.addSubview(calendar)
        self.calendar = calendar
        View.addSubview(button)
        View.addSubview(cancelButton)
        View.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        View.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -0).isActive = true
        View.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        View.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        calendar.topAnchor.constraint(equalTo: View.topAnchor).isActive = true
        calendar.leftAnchor.constraint(equalTo: View.leftAnchor,constant: 24).isActive = true
        calendar.rightAnchor.constraint(equalTo: View.rightAnchor,constant: -24).isActive = true
        calendar.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: View.bottomAnchor,constant: -16).isActive = true
        button.rightAnchor.constraint(equalTo: View.rightAnchor,constant: -24).isActive = true
        button.leftAnchor.constraint(equalTo: View.centerXAnchor, constant: 6).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: View.bottomAnchor,constant: -16).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: View.leftAnchor,constant: 24).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: View.centerXAnchor, constant: -6).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func hideKeyboardWhenTappedAround() {
        let viewCancel = UIView()
        viewCancel.backgroundColor = .clear
        self.view.addSubview(viewCancel)
        viewCancel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(View.snp.top).offset(-5)
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        viewCancel.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func buttonPressed() {
        if selectedDate == nil {
            selectedDate = calendar.today
            delegate?.getDate(date: selectedDate!)
            selectedDate = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending && date != calendar.today {
            return false
        }
        else {
            return true
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        print(date)
        selectedDate = date
        delegate?.getDate(date: date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.topAnchor.constraint(equalTo: View.topAnchor, constant: 64).isActive = true
        calendar.leftAnchor.constraint(equalTo: View.leftAnchor).isActive = true
        calendar.rightAnchor.constraint(equalTo: View.rightAnchor).isActive = true
        calendar.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 0).isActive = true
        self.view.layoutIfNeeded()
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


//
//  SettingsOfNatificationsController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class SettingsOfNatificationsController: UIViewController {
    
    @IBOutlet weak var doNotDistrubViewOutlet: UIView!
    
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var tillDateView: UIView!
    @IBOutlet weak var selectTimeViewOutlet: UIView!
    @IBOutlet weak var specifyTimeViewOutlet: UIView!
    
    @IBOutlet weak var doNotDistrubView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var fromDateLabel: UILabel!
    
    @IBOutlet weak var doNotDistrubSwitch: UISwitch!
    @IBOutlet weak var tillDateLabel: UILabel!
    @IBOutlet weak var specifyTimeOfSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        cardView.clipsToBounds = true
        //        cardView.layer.cornerRadius = 35
        //        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
        //
        let tapForDoNotDistrubView = UITapGestureRecognizer(target: self, action: #selector(self.doNotDistrubeGeasture(_:)))
        doNotDistrubView.addGestureRecognizer(tapForDoNotDistrubView)
        
        let tapSpecifyTimeDistrubView = UITapGestureRecognizer(target: self, action: #selector(self.specifyTimeGeasture(_:)))
        specifyTimeViewOutlet.addGestureRecognizer(tapSpecifyTimeDistrubView)
        
        let fromTap = UITapGestureRecognizer(target: self, action: #selector(self.fromDateViewTap(_:)))
        fromDateView.addGestureRecognizer(fromTap)
        
        let tillTap = UITapGestureRecognizer(target: self, action: #selector(self.tillDateViewTap(_:)))
        tillDateView.addGestureRecognizer(tillTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosing), name:NSNotification.Name(rawValue: "dateTime"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        //        navigationController?.navigationBar.tintColor = .white
    }
    @objc func handlePopupClosing(notification: Notification){
        let dateVC = notification.object as! PopUpDateTimeViewController
        switch dateVC.index {
        case 0:
            self.fromDateLabel.text =  dateVC.date
        case 1:
            self.tillDateLabel.text = dateVC.date
        default:
            ()
        }
    }
    @objc func fromDateViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpDateTime") as! PopUpDateTimeViewController //
        self.addChild(popUpVC) // 2
        popUpVC.view.frame = self.view.frame  // 3
        popUpVC.index = 0
        self.view.addSubview(popUpVC.view) // 4
        popUpVC.didMove(toParent: self)
    }
    @objc func tillDateViewTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpDateTime") as! PopUpDateTimeViewController //
        self.addChild(popUpVC) // 2
        popUpVC.index = 1
        popUpVC.view.frame = self.view.frame  // 3
        self.view.addSubview(popUpVC.view) // 4
        popUpVC.didMove(toParent: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func saveButton_TouchUp_Inside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doNotDistrubeGeasture(_ sender: UITapGestureRecognizer? = nil){
        if doNotDistrubSwitch.isOn == false{
            doNotDistrubSwitch.isOn = true
            specifyTimeViewOutlet.isHidden = false
            if specifyTimeOfSwitch.isOn{
                selectTimeViewOutlet.isHidden = false
            }
        }else{
            doNotDistrubSwitch.isOn = false
            specifyTimeViewOutlet.isHidden = true
            if selectTimeViewOutlet.isHidden == false{
                selectTimeViewOutlet.isHidden = true
            }
        }
    }
    
    @objc func specifyTimeGeasture(_ sender: UITapGestureRecognizer? = nil){
        if specifyTimeOfSwitch.isOn == false{
            specifyTimeOfSwitch.isOn = true
            selectTimeViewOutlet.isHidden = false
        }else{
            specifyTimeOfSwitch.isOn = false
            selectTimeViewOutlet.isHidden = true
        }
    }
    
    
    
    
    
    @IBAction func doNotDisturbAction(_ sender: UISwitch) {
        if sender.isOn {
            specifyTimeViewOutlet.isHidden = false
            if specifyTimeOfSwitch.isOn{
                selectTimeViewOutlet.isHidden = false
            }
        }else{
            specifyTimeViewOutlet.isHidden = true
            if selectTimeViewOutlet.isHidden == false{
                selectTimeViewOutlet.isHidden = true
            }
        }
    }
    @IBAction func specifyTimeSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            selectTimeViewOutlet.isHidden = false
        }else{
            selectTimeViewOutlet.isHidden = true
        }
    }
    
}

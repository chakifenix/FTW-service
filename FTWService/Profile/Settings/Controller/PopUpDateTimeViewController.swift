//
//  File.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit

class PopUpDateTimeViewController: UIViewController {
    
    
    var date = ""
    var index = 0
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveDate_Touch_Up_Inside(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        date = dateFormatter.string(from: datePicker.date)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dateTime"), object: self)
        self.view.removeFromSuperview()
        
        
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

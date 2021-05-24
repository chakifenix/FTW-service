//
//  PopOverViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import Foundation
import UIKit

struct CountryModel {
    var name:String
    var phone:String
    var image:UIImage
    var selectedCountryName:String
}


class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var index = 0
    
    var countryArray: [CountryModel] = [CountryModel(name: "Kazakhstan (KZ)", phone: "+7", image: #imageLiteral(resourceName: "kzt"), selectedCountryName: "Казахстан"),CountryModel(name: "Tajikistan (TJ)", phone: "+992", image: #imageLiteral(resourceName: "az"), selectedCountryName: "Таджикистан"),CountryModel(name: "Uzbekistan (UZ)", phone: "+998", image:#imageLiteral(resourceName: "uz"), selectedCountryName: "Узбекистан")]//Tajikistan
    
    //,CountryModel(name: "Kyrgyzstan (KG)", phone: "+996", image: #imageLiteral(resourceName: "KG"), selectedCountryName: "KYRGYZSTAN")
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Popupview.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Apply radius to Popupview
        //        Popupview.layer.cornerRadius = 10
        //        Popupview.layer.masksToBounds = true
        
    }
    
    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryArray.count;
    }
    
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Company Name : " + countryArray[indexPath.row].name)
        
        //        Shared.shared.companyName = countryArray[indexPath.row].name
        //        Shared.shared.countryNumber = countryArray[indexPath.row].phone
        //        Shared.shared.countryFlag = countryArray[indexPath.row].image
        //
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginPage") as! LoginViewController
        //        self.present(newViewController, animated: true, completion: nil)
        
        index = indexPath.row
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KRARAR"), object: self)
        
        self.view.removeFromSuperview()
        
        //            self.view.removeFromSuperview()
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        
        cell.countryLabel.text = countryArray[indexPath.row].name
        cell.countryImageView.image = countryArray[indexPath.row].image
        
        return cell
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
}


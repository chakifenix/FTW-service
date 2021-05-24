//
//  SelectCityViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import Alamofire
class SelectCityViewController: UIViewController {
    
    
    @IBOutlet weak var btnDrop:UIButton!
    var userName = "Mako"
    var pickerView = UIPickerView()
    var typeValue = "Алматы"
    @IBOutlet weak var nextButton: UIButton!
    var cityArray = [CityModel]()
    var param = [String:String]()
    let url = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=getOther&get=cities"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonDataParse()
        for city in cityArray {
            if city.name == typeValue {
                pickerView.selectRow(city.id - 1, inComponent: 0, animated: false)
                print(city.id - 1)
            }
            
        }
    }
    
    //$2y$10$DZXirFtMP.yg9GIlrXZTcOERZ37LZzyaXxw3x6nisBBzhLplGNDwa
    @IBAction func onClickDropButton(_ sender: Any) {
        let alert = UIAlertController(title: "Выбирайте свой город", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self

        alert.addAction(UIAlertAction(title: "Изменить", style: .default, handler: { (UIAlertAction) in
            self.btnDrop.setTitle("\(self.typeValue)", for: .normal)
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    
    
    func jsonDataParse(){
        Networking.getCity(url: self.url) { (response) in
            self.cityArray = response
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
                //                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        //      postMethod()
        let userId = UserDefaults.standard.integer(forKey: "ID")
        let userName = UserDefaults.standard.string(forKey: "name")
        let token = UserDefaults.standard.string(forKey: "token")
        param = ["appid":"$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS", "opt": "user_param", "act":"edit_city","userid":"\(userId)","date":"period","utoken":token!,"name":userName!,"city":typeValue]
        let testurl = "https://orzu.org/api?"
        
        guard let url = URL(string: testurl) else {return}
        //        let encodedTexts = testurl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //        guard let rusTextt = encodedTexts else {return}
        //        let str = String(utf8String: rusTextt.cString(using: .utf8)!)
        //        guard let url = URL(string: str!) else{return}
        //        print(url)

        Alamofire.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }

        let controller = TabBarViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard.instantiateViewController(withIdentifier: "MyTask")
        //        self.present(controller, animated: true, completion: nil)
        
        
    }
    //
    //    func postMethod(){
    //
    //
    //    }
    //
}




extension SelectCityViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeValue = cityArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
}



//
//  LoginViewController.swift
//  resources
//
//  Created by MacOs User on 7/11/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import FirebaseMessaging
class LoginViewController: UIViewController {
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var forgotButton: UILabel! {
        didSet {
            forgotButton.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)
            forgotButton.layer.borderWidth = 1.0
            forgotButton.layer.cornerRadius = 10
        }
    }
    
    
    @IBOutlet weak var underViewNumberBig: UIView!
    @IBOutlet weak var underViewPassword: UIView!
    @IBOutlet weak var underViewNumber: UIView!
    @IBOutlet weak var sigUpButton: UIButton!
    @IBOutlet weak var phoneText: UITextField!{
        didSet{
            phoneText.setLineView(color: .lightGray)
            phoneText.delegate = self
        }
    }
    @IBOutlet weak var passwordText: UITextField! {
        didSet{
            passwordText.setLineView(color: .lightGray)
            passwordText.delegate = self
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet var btnSelect: UIButton! 
    @IBOutlet var cardView: AnimateView!
    @IBOutlet var cardViewConstriant: NSLayoutConstraint!
    //    @IBOutlet var cardView: UIView!{
    //        didSet{
    //            cardView.clipsToBounds = true
    //            cardView.layer.cornerRadius = 35
    //            cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    //        }
    //    }
    @IBOutlet var numberLabel: UILabel!
    
    @IBOutlet var countryFlagImage: UIImageView!
    
    var activateTextField:UITextField!
    var token:String?
    let indicator:JTMaterialSpinner = {
        let indicator = JTMaterialSpinner()
        indicator.circleLayer.lineWidth = 7
        indicator.isHidden = true
        indicator.circleLayer.strokeColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        indicator.animationDuration = 1.5
        return indicator
    }()
    let userDef = UserDefaults.standard
    var dataProvider:DataProvider!
    var isVC = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.saveButton.alpha = 1
            })
            
        }
        
        configureViews()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserLocation(notification:)), name: NSNotification.Name.init(rawValue: "country"), object: nil)
        //set flag textField
        // hide keyboard
        
    }
    fileprivate func configureViews() {
        //         self.sigUpButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
        let tap = UITapGestureRecognizer(target: self, action: #selector(forgotButtonPressed))
        forgotButton.addGestureRecognizer(tap)
        phoneText.tag = 0
        passwordText.tag = 1
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosing), name:NSNotification.Name(rawValue: "KRARAR"), object: nil)
    }
    
    private func settingsUserCountry(country:String) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        popUpVC.countryArray.forEach({ (city) in
            if city.selectedCountryName == Constans().userCountry {
                btnSelect.setTitle(city.name,for: .normal)
                countryFlagImage.image  = city.image
                numberLabel.text = city.phone
            }
        })
    }
    @objc func handlePopupClosing(notification: Notification){
        let dateVC = notification.object as! PopOverViewController
        let index = dateVC.index
        let cn : String = dateVC.countryArray[index].name
        btnSelect.setTitle(cn,for: .normal)
        countryFlagImage.image  = dateVC.countryArray[index].image
        numberLabel.text = dateVC.countryArray[index].phone
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    @objc func forgotButtonPressed() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "forgotPassword") as! ForgotPasswordViewController
        self.show(vc, sender: self)
    }
    @IBAction func showPopUp(_ sender: UIButton) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        
        self.addChild(popUpVC) // 2
        popUpVC.view.frame = self.view.frame  // 3
        self.view.addSubview(popUpVC.view) // 4
        
        popUpVC.didMove(toParent: self)
        
    }
    @objc func handleUserLocation(notification:Notification) {
        guard let userInfo = notification.userInfo, let country = userInfo["userCountry"] as? String else {return}
        settingsUserCountry(country: country)
    }
    @IBAction func phonetextField(_ sender: UITextField) {
    }
    
    @IBAction func passwordTextField(_ sender: UITextField) {
    }
    
    func loginParse(phoneNumber: String,password: String) {
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_auth&phone=\(phoneNumber)&password=\(password)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let val = value as? [String:Any]
                guard let jsonValue = val  else {
                    return
                }
                let jsonObject = LoginModel(json: jsonValue)
                let token = jsonObject._token
                let id = jsonObject.id
                self.userDef.set(id, forKey: "ID")
                self.userDef.set(token, forKey: "token")
                self.userDef.set(true, forKey: "login")
                Messaging.messaging().subscribe(toTopic: "user_\(id)") { error in
                    print("Subscribed to weather topic")
                }
                self.hideLoader()
                let queue = DispatchQueue.init(label: "UserQueue",attributes: .concurrent)
                queue.async {
                    self.checkIDURL()
                }
                let controller = TabBarViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "Response status code was unacceptable: 500." {
                    self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                } else {
                    self.showErrorMessage("Этот логин не совпадает")
                }
            }
        }
    }
    func checkIDURL() {
        let id = userDef.integer(forKey: "ID")
        guard let chechIdUrl = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_user&user=\(id)&param=more") else {return}
        Alamofire.request(chechIdUrl).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let item1 =  value as! [String:Any]
                let user = UserInfo(json: item1)
                let urlString = "https://orzu.org\(user.avatar!)"
                let _ = self.userDef.set(urlString, forKey: "Avatar")
                let name = user.name
                PassData.wallet = String(user.wallet!) + " " + "Ni"
                self.userDef.set(name!, forKey: "name")
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    @objc func textFieldChanged(tag:UITextField) {
        guard
            let phoneText = phoneText.text,
            let passwordText = passwordText.text
            else {return}
        let formFilled = !(phoneText.isEmpty) && !(passwordText.isEmpty)
        
//            switch tag.tag {
//            case 0:
//                underViewNumberBig.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//                underViewNumber.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//                underViewPassword.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//            case 1:
//                underViewNumberBig.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//                underViewNumber.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//                underViewPassword.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//            default:
//                ()
//            }
        
//        if !(phoneText.isEmpty){
//            underViewNumberBig.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//            underViewNumber.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//        }else{
//            underViewNumberBig.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//            underViewNumber.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//        }
//
//        if !(passwordText.isEmpty){
//            underViewPassword.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
//        }else{
//            underViewPassword.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
//        }
        //        setContinueButton(enabled: formFilled)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if passwordText.text != "" && phoneText.text != "" {
            showLoader()
            self.loginParse(phoneNumber: "\(+7)\(self.phoneText!.text!)", password: self.passwordText.text!)
        } else {
            self.showErrorMessage("Не заполнены все поля!")
        }
    }
    
    @IBAction func performActions(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.performSegue(withIdentifier: "registers", sender: self)
        case 1:
            print("1")
        default:
            ()
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setLineView(color: Data_Colors.gradientColor)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setLineView(color: .lightGray)
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = textField.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        return count <= 10
//    }
//    func formatToPhoneNumber(withPhoneTextField: UITextField, tableTextField: UITextField, range: NSRange, string: String) -> Bool {
//
//        if (tableTextField == withPhoneTextField) {
//
//            let newString = (tableTextField.text! as NSString).replacingCharacters(in: range, with: string)
//            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//
//            let decimalString = components.joined(separator: "") as NSString
//            let length = decimalString.length
//            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
//
//            if length == 0 || (length > 11 && !hasLeadingOne) || length > 12 {
//                let newLength = (tableTextField.text! as NSString).length + (string as NSString).length - range.length as Int
//
//                return (newLength > 11) ? false : true
//            }
//
//            var index = 0 as Int
//            let formattedString = NSMutableString()
//
//            if hasLeadingOne {
//                formattedString.append("1 ")
//                index += 1
//            }
//
//            if (length - index) > 1{
//                let zeroNumber = decimalString.substring(with: NSMakeRange(index, 1))
//                formattedString.appendFormat("%@ ", zeroNumber)
//                index += 1
//            }
//
//            if (length - index) > 3 {
//                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("(%@) ", areaCode)
//                index += 3
//            }
//
//            if length - index > 3 {
//                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
//                formattedString.appendFormat("%@ ", prefix)
//                index += 3
//            }
//
//            if (length - index) > 3{
//                let prefix = decimalString.substring(with: NSMakeRange(index, 2))
//                formattedString.appendFormat("%@ ", prefix)
//                index += 2
//            }
//
//            let remainder = decimalString.substring(from: index)
//            formattedString.append(remainder)
//            tableTextField.text = formattedString as String
//
//            return false
//        } else {
//            return true
//        }
//    }
}


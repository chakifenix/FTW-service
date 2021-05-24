//
//  SMSValidationViewController.swift
//  resources
//
//  Created by MacOs User on 7/19/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseMessaging
class SMSValidationViewController: UIViewController {
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel?
    @IBOutlet weak var textField: UITextField!{
        didSet{
                textField.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
                textField.layer.borderWidth = 1.0
                textField.layer.masksToBounds = true
                textField.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    var phone = ""
    var name = ""
    var password = ""
    let userdef = UserDefaults.standard
    var token:String?
    var id:String?
    var status:String?
    var isForget = false
    var seconds = 60
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneLabel!.text = phone
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        hideKeyboardWhenTappedAround()
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds >= 0{
            timerLabel.text = String(seconds)
        }else{
            timerLabel.isHidden = true
            restartButton.isHidden = false
        }
  
    }
    
    @IBAction func restart(_ sender: UIButton) {
        smsValidation()
        seconds = 60
        timerLabel.isHidden = false
        restartButton.isHidden = true
    }
    

    func loginParse(phoneNumber: String,password: String,name: String) {
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=register_user&phone=\(phoneNumber)&password=\(password)&name=\(name)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let val = value as? [String:Any]
                guard let jsonValue = val  else {
                    //                    self.showAlertVC(title: "Ошибка", message: "Пользователь уже зарегистрирован!")
                    return
                    
                }
                let jsonObject = RegisterModel(json: jsonValue)
                self.token = jsonObject._token
                self.id = jsonObject.id
                self.status = jsonObject.auth_status
                self.userdef.set(name, forKey: "name")
                self.userdef.set(self.id, forKey: "ID")
                self.userdef.set(self.token, forKey: "token")
                self.performSegue(withIdentifier: "citySelect", sender: nil)
                Messaging.messaging().subscribe(toTopic: "user_\(self.id)") { error in
                    print("Subscribed to weather topic")
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    func changePassword(phoneNumber: String,password: String) {
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=forget_password&phone=\(phoneNumber)&password=\(password)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                //                self.showSuccess("Вы успешно изменили пароль!")
                self.showAlert(text: "Вы успешно изменили пароль!", completion: {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
                    self.present(vc, animated: true, completion: nil)
                })
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    @IBAction func saveAction(_ sender: Any) {
        self.showLoader()
        guard let verifyId = userdef.string(forKey: "verificationID"),let text = textField.text else {return}
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verifyId,
            verificationCode: text)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                print("User is not sign")
                self.showErrorMessage("Ваш телефон не совпадает!")
                return
            }
            print("Succesfully")
            if self.isForget {
                self.changePassword(phoneNumber: self.phone, password: self.password)
            } else {
                self.loginParse(phoneNumber: self.phone, password: self.password, name: self.name)
                
            }
            
            // User is signed in
            // ...
        }
        //        SMSParse(phoneNumber: (phoneLabel?.text)!, SMS: textField.text!)
        //        let user = userdef.string(forKey: "SMS")
        //        if user != nil {
        //            self.performSegue(withIdentifier: "citySelect", sender: nil)
        //        }
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func smsValidation(){
         Auth.auth().languageCode = "ru"
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                guard let verifyId = verificationID else {return}
                self.userdef.set(verifyId, forKey: "verificationID")
                    return
                }
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

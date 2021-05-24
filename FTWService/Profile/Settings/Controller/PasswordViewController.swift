//
//  PasswordViewController.swift
//  resources
//
//  Created by MacOs User on 9/5/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
class PasswordViewController: UIViewController {
    
    @IBOutlet var oldPassword: UITextField! {
        didSet{
            oldPassword.setLineView(color: .lightGray)
            oldPassword.delegate = self
        }
    }
    
    @IBOutlet var confirmNewPassword: UITextField! {
        didSet{
            confirmNewPassword.setLineView(color: .lightGray)
            confirmNewPassword.delegate = self
        }
    }
    @IBOutlet var newPassword: UITextField! {
        didSet{
            newPassword.setLineView(color: .lightGray)
            newPassword.delegate = self
        }
    }
    @IBOutlet var signBackImage: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.backgroundColor = Data_Colors.mainColor
        }
    }
    
    
    @IBOutlet var cardView: AnimateView!
    var param = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.nextButton.alpha = 1
            })
            
        }
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = Data_Colors.mainColor
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
        view.endEditing(true)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
    
    @IBAction func saveButton(_ sender: UIButton) {
        self.showLoader()
        if oldPassword.text != "",confirmNewPassword.text != "",newPassword.text != ""{
            if newPassword.text ==  confirmNewPassword.text{
                jsonParse(newPasswordTF: newPassword.text!, oldPasswordTF: oldPassword.text!)
                navigationController?.popViewController(animated: true)
            }else{
                self.showErrorMessage("Ваш пароли не совпадает")
                oldPassword.text = ""
                confirmNewPassword.text = ""
                newPassword.text = ""
            }
        }else{
            self.showErrorMessage("Не заполнены все поля!")
        }
    }
    
    
    //
    func jsonParse(newPasswordTF:String,oldPasswordTF:String){
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.integer(forKey: "ID")
        let name  = UserDefaults.standard.string(forKey: "name")
        param = ["appid":"$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS", "opt": "user_param", "act":"edit_password","userid":String(id),"utoken":token!,"name":name!,"password":newPasswordTF,"old_password":oldPasswordTF]
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
                self.showAlert(text: "Вы пароль изменен!", completion: {
                    self.view.endEditing(true)
                })
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    //
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension PasswordViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setLineView(color: Data_Colors.gradientColor)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setLineView(color: .lightGray)
    }
}

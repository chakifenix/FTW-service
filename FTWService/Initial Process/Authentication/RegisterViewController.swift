//
//  RegisterViewController.swift
//  resources
//
//  Created by MacOs User on 7/12/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextFIeld: UITextField! {
        didSet {
            nameTextFIeld.setLineView(color: .lightGray)
            self.nameTextFIeld.delegate = self
        }
    }
    
    
    @IBOutlet weak var underViewNumberShort: UIView!
    @IBOutlet weak var phoneTextField: UITextField! {
        didSet{
            phoneTextField.setLineView(color: .lightGray)
            phoneTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.setLineView(color: .lightGray)
            self.passwordTextField.delegate = self
        }
    }
    @IBOutlet var countryFlagImage: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var registerArray = [String]()
    let userdef = UserDefaults.standard
    var token:String?
    var id:String?
    var status:String?
    @IBOutlet var cardView: AnimateView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.saveButton.alpha = 1
            })
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosing), name:NSNotification.Name(rawValue: "KRARAR"), object: nil)
        hideKeyboardWhenTappedAround()
        settingsUserCountry()
        //        setupCustomPhoneTextField()
        // Do any additional setup after loading the view.
    }
    
    @objc func handlePopupClosing(notification: Notification){
        let dateVC = notification.object as! PopOverViewController
        let index = dateVC.index
        print(dateVC.countryArray)
        let cn : String = dateVC.countryArray[index].name
        btnSelect.setTitle(cn,for: .normal)
        countryFlagImage.image  = dateVC.countryArray[index].image
        numberLabel.text = dateVC.countryArray[index].phone
    }
    fileprivate func settingsUserCountry() {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        popUpVC.countryArray.forEach({ (city) in
            if city.selectedCountryName == Constans().userCountry {
                btnSelect.setTitle(city.name,for: .normal)
                countryFlagImage.image  = city.image
                numberLabel.text = city.phone
            }
        })
    }
    @objc func resetTapped() {
        view.endEditing(true)
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func smsValidation() {
        Auth.auth().languageCode = "ru"
        guard let nameText = nameTextFIeld.text,let passwordText = passwordTextField.text else {
            return
        }
        let phoneNumber = "\(self.numberLabel.text!)\(self.phoneTextField!.text!)"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                guard let verifyId = verificationID else {return}
                self.userdef.set(verifyId, forKey: "verificationID")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SMS") as? SMSValidationViewController {
                    let navbar = UINavigationController(rootViewController: viewController)
                    viewController.phone = phoneNumber
                    viewController.name = nameText
                    viewController.password = passwordText
                    self.show(navbar, sender: true)
                    self.hideLoader()
                }
                return
            }
            print(error?.localizedDescription)
            self.showErrorMessage("Неправильный номер телефона!")
            // Sign in using the verificationID and the code sent to the user
            // ...
        }
    }
    
    func checkPhoneNumber(phoneNumber: String) {
        guard let url = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=user_param&act=check_phone&phone=\(phoneNumber)") else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let result = value as! String
                if result == "phone exists" {
                    self.showErrorMessage("Пользователь уже зарегистрирован!")
                    
                }else {
                    self.smsValidation()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "Response status code was unacceptable: 500." {
                    self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                }
                
            }
        }
    }
    
    @IBAction func showPopUp(_ sender: UIButton) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        
        self.addChild(popUpVC) // 2
        popUpVC.view.frame = self.view.frame  // 3
        self.view.addSubview(popUpVC.view) // 4
        
        popUpVC.didMove(toParent: self)
        
    }
    

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let nameText = nameTextFIeld.text,let passwordText = passwordTextField.text else {
            return
        }
        let phoneNumber = "\(self.numberLabel.text!)\(self.phoneTextField!.text!)"
        if nameText == "" || passwordText == "" || phoneNumber == "" {
            self.showErrorMessage("Не заполнены все поля!")
        } else {
            self.showLoader()
            checkPhoneNumber(phoneNumber: phoneNumber)
        }
    }
    
    /*
     // MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setLineView(color: #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1))
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
}



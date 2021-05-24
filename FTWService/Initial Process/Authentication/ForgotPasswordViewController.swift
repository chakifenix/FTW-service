//
//  ForgotPasswordViewController.swift
//  resources
//
//  Created by MacOs User on 11/13/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var cardView: AnimateView!
    @IBOutlet weak var phoneTextFiled: UITextField!{
        didSet{
            phoneTextFiled.setLineView(color: .lightGray)
            phoneTextFiled.delegate = self
        }
    }
        
    @IBOutlet weak var passwoedTextField: UITextField! {
        didSet{
            passwoedTextField.setLineView(color: .lightGray)
            passwoedTextField.delegate = self
        }
    }
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var counryFlagImage: UIImageView!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var undeViewNumber: UIView!
    
    
    let userdef = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsUserCountry()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.button.alpha = 1
            })
            // Do any additional setup after loading the view.
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handlePopupClosing), name:NSNotification.Name(rawValue: "KRARAR"), object: nil)

        // hide keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    fileprivate func settingsUserCountry() {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        popUpVC.countryArray.forEach({ (city) in
            if city.selectedCountryName == Constans().userCountry {
                countryButton.setTitle(city.name,for: .normal)
                counryFlagImage.image  = city.image
                numberLabel.text = city.phone
            }
        })
    }
    @objc func handlePopupClosing(notification: Notification){
        let dateVC = notification.object as! PopOverViewController
        let index = dateVC.index
        let cn : String = dateVC.countryArray[index].name
        countryButton.setTitle(cn,for: .normal)
        counryFlagImage.image  = dateVC.countryArray[index].image
        numberLabel.text = dateVC.countryArray[index].phone
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func countryButtonAction(_ sender: Any) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopOverViewController //
        
        self.addChild(popUpVC) // 2
        popUpVC.view.frame = self.view.frame  // 3
        self.view.addSubview(popUpVC.view) // 4
        
        popUpVC.didMove(toParent: self)
    }
    @IBAction func buttonAction(_ sender: Any) {
        guard let phoneText = phoneTextFiled.text,let password = passwoedTextField.text else {
            return
        }
        if phoneText != "" && password != "" {
            showLoader()
            let phoneNumber = "\(self.numberLabel.text!)\(phoneText)"
            checkPhoneNumber(phoneNumber: phoneNumber)
        }else {
            self.showErrorMessage("Не заполнены все поля!")
        }
    }
    func smsValidation() {
        Auth.auth().languageCode = "ru"
        guard let phoneText = phoneTextFiled.text,let passwordText = passwoedTextField.text else {
            return
        }
        let phoneNumber = "\(self.numberLabel.text!)\(phoneText)"
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                self.hideLoader()
                guard let verifyId = verificationID else {return}
                self.userdef.set(verifyId, forKey: "verificationID")
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SMS") as? SMSValidationViewController {
                    let navbar = UINavigationController(rootViewController: viewController)
                    viewController.phone = phoneNumber
                    viewController.password = passwordText
                    viewController.isForget = true
                    self.show(navbar, sender: true)
                }
                return
            }
            print(error?.localizedDescription)
            self.showErrorMessage("Ваш лимит иcчерпан!")
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
                    self.smsValidation()
                }else {
                    self.showErrorMessage("Такой пользователь не существует!")
                }
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "Response status code was unacceptable: 500." {
                    self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                }
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
    
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
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


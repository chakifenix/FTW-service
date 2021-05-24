//
//  EditSettingsViewController.swift
//  resources
//
//  Created by MacOs User on 9/2/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Alamofire
protocol editProfile {
    func editProfile()
}
class EditSettingsViewController: UIViewController {
    let url = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=user_param&act=edit&"
    let userImage: UIImageView = {
        let Userview = UIImageView()
        Userview.clipsToBounds = true
        Userview.layer.cornerRadius = 64
        Userview.layer.borderColor = UIColor.white.cgColor
        Userview.layer.borderWidth = 1
        Userview.contentMode = .scaleAspectFill
        Userview.isUserInteractionEnabled = true
        return Userview
    }()
    
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Green")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let cardView: AnimateView = {
        let view = AnimateView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    private let views: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Имя"
        return label
    }()
    let fnameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Фамилия"
        return label
    }()
    let locationLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Город проживания"
        return label
    }()
    let aboutMe:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "О себе"
        return label
    }()
    let UserBirth:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "Дата рождения"
        return label
    }()
    lazy var nameTextField:UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.borderStyle = .none
        textfield.setLineViewWithOffset(color: .lightGray)
        return textfield
    }()
    lazy var fnameTextField:UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.borderStyle = .none
        textfield.setLineViewWithOffset(color: .lightGray)
        return textfield
    }()
     lazy var locationTextField:UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.borderStyle = .none
        textfield.setLineViewWithOffset(color: .lightGray)
        return textfield
    }()
    lazy var aboutMeTextField:UITextView = {
        let textfield = UITextView()
        textfield.delegate = self
        textfield.sizeToFit()
        textfield.isScrollEnabled = false
        textfield.isEditable = true
        textfield.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy "
        textfield.font = UIFont.systemFont(ofSize: 16)
        return textfield
    }()
    let DaytextField:UITextField = {
        let textfield = UITextField()
        textfield.layer.cornerRadius = 5
        textfield.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        textfield.layer.borderWidth = 2
        textfield.placeholder = "День"
        textfield.addPadding(.left(10))
        return textfield
    }()
    let birthLineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentSize.height = 750
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Cохранить", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.alpha = 0
        return button
    }()
    let dataPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        let loc = Locale(identifier: "ru_RU")
        picker.locale = loc
        return picker
    }()
    let toolbar:UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        return toolbar
    }()
    let MenRadioButton: KGRadioButton =  {
        let radio = KGRadioButton()
        return radio
    }()
    let WomenRadioButton: KGRadioButton = {
        let radio = KGRadioButton()
        return radio
    }()
    let GendarLabel:UILabel = {
        let label = UILabel()
        label.text = "Пол"
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        return label
    }()
    let menLabel:UILabel = {
        let label = UILabel()
        label.text = "Мужчина"
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        return label
    }()
    let womenLabel:UILabel = {
        let label = UILabel()
        label.text = "Женщина"
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Редактировать"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.alpha = 0
        label.numberOfLines = 0
        return label
    }()
    private let pickerview:UIPickerView = {
        let pickerview = UIPickerView()
        return pickerview
    }()
    var delegate:editProfile?
    var imageFileURL:URL?
    var isChangedPhoto = false
    var pathChangedImage:String? = ""
    var city = ["Душанбе","Алматы","Бишкек","Ташкент"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        let size = self.descrMe.heightForLabel(text: aboutMeTextField.text ?? "Description", font: UIFont.systemFont(ofSize: 16), width: self.view.frame.width - 48)
//        self.scrollView.contentSize.height += size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, animations: {
                self.saveButton.alpha = 1
                self.titleLabel.alpha = 1
                
            })
            
        }
        configureViews()
        setupConst()
        showDatePicker()
        hidesKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.barTintColor =  #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
    }
    fileprivate func configureViews() -> Void {
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        MenRadioButton.addTarget(self, action: #selector(menRadioAction(sender:)), for: .touchUpInside)
        WomenRadioButton.addTarget(self, action: #selector(womenRadioAction(sender:)), for: .touchUpInside)
        aboutMeTextField.delegate = self
        locationTextField.delegate = self
        nameTextField.delegate = self
        fnameTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageEdit))
        userImage.addGestureRecognizer(tap)
    }
    @objc func backButtonFunc(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    
    @objc func imageEdit() {
        addImageAction()
    }
    @objc func menRadioAction(sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        WomenRadioButton.isSelected = !sender.isSelected
        
    }
    @objc func womenRadioAction(sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        MenRadioButton.isSelected = !sender.isSelected
    }
    @objc func saveAction() {
        guard let editProfileUrl = URL(string: url),
            let NameText = nameTextField.text,
            let fnameText = fnameTextField.text,
            let location = locationTextField.text,
            let aboutYourself = aboutMeTextField.text,
            let dateLabel = DaytextField.text else {return}
        var param = [String:Any]()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.yyyy"
        let dayFormat = DateFormatter()
        dayFormat.dateFormat = "d"
        let monthFormat = DateFormatter()
        monthFormat.dateFormat = "MM"
        let yearFormat = DateFormatter()
        yearFormat.dateFormat = "yyyy"
        let token = UserDefaults.standard.string(forKey: "token")
        let loginId = UserDefaults.standard.integer(forKey: "ID")
        print(token!)
        if let date = dateFormatterGet.date(from: dateLabel) {
            let brday = dayFormat.string(from: date)
            let month = monthFormat.string(from: date)
            let year = yearFormat.string(from: date)
            if isChangedPhoto {
                if MenRadioButton.isSelected == true {
                    param = ["userid":"\(loginId)","name":NameText,"fname":fnameText,"city":location,"about":aboutYourself,"gender":"male","bday":brday,"bmonth":month,"byear":year,"utoken":token!]
                } else if WomenRadioButton.isSelected == true {
                    param = ["userid":"\(loginId)","name":NameText,"fname":fnameText,"city":location,"about":aboutYourself,"gender":"female","bday":brday,"bmonth":month,"byear":year,"utoken":token!]
                }
            } else {
                print("NO Changed!!!!")
                if MenRadioButton.isSelected == true {
                    param = ["userid":"\(loginId)","name":NameText,"fname":fnameText,"city":location,"about":aboutYourself,"gender":"male","bday":brday,"bmonth":month,"byear":year,"utoken":token!]
                } else if WomenRadioButton.isSelected == true {
                    param = ["userid":"\(loginId)","name":NameText,"fname":fnameText,"city":location,"about":aboutYourself,"gender":"female","bday":brday,"bmonth":month,"byear":year,"utoken":token!]
                }
            }
            
            Alamofire.request(editProfileUrl,method: .get,parameters: param).validate().responseJSON { (response) in
                switch response.result {
                case .success( _):
                    self.delegate?.editProfile()
                    self.showAlert(text: "Настройки сохранены!", completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                //                    self.showToast(message: "Настройка сохранено!")
                case .failure(let error):
                    self.showErrorMessage("Вы должны заполнить все поля!")
                    print(error.localizedDescription)
                    if error.localizedDescription == "Response status code was unacceptable: 500." {
                        self.showErrorMessage("Сервер не отвечает. Повторите попытку позже!")
                    }
                }
            }
        }
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        DaytextField.text = formatter.string(from: dataPicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func addImageAction() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo-1")
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 64, y: self.view.frame.size.height-80, width: self.view.frame.size.width - 128, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name:"AppleSDGothicNeo-Light", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func showDatePicker(){
        //Formate Date
        //ToolBar
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
        DaytextField.inputAccessoryView = toolbar
        DaytextField.inputView = dataPicker
        locationTextField.inputAccessoryView = toolbar
        locationTextField.inputView = pickerview
        pickerview.delegate = self
    }
}
// MARK: - UITextFieldDelegate
extension EditSettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setLineViewWithOffset(color: Data_Colors.gradientColor)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setLineViewWithOffset(color: .lightGray)
    }
}
extension EditSettingsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        birthLineView.backgroundColor = Data_Colors.gradientColor
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        birthLineView.backgroundColor = .lightGray

    }
}
// MARK: - ImagePicker
extension EditSettingsViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = info[.editedImage] as? UIImage
        let orientationFixedImage = newImage?.fixedOrientation()
        userImage.image = orientationFixedImage
        let imgNameOr = UUID().uuidString
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgNameOr + ".jpg")
        let data = orientationFixedImage!.pngData()! as NSData
        data.write(toFile: localPath, atomically: false)
        let photoURL = URL.init(fileURLWithPath: localPath)
        
        if let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.showLoader()
            Networking.uploadImage(fileUrl: photoURL, url: Constans().uploadImage, userId: String(Constans().userid), token: Constans().token!, apikey: Constans().API_KEY) { (value) in
                print(value)
                self.showAlert(text: "Фото профиля изменено!", completion: {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "profileImage"), object: nil, userInfo: ["photoUser": self.userImage.image!])
                })
            }
            //NotificationCenter.default.post(name: NSNotification.Name.init("changeMenuImage"), object: nil,userInfo: ["photo":imageMenu!])
//            UserDefaults.standard.set(true, forKey: "MenuforImage")
//            UserDefaults.standard.set(fileUrl, forKey: "imageFile")
        }
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            
            let data = newImage!.pngData()! as NSData
            data.write(toFile: localPath, atomically: false)
            let photoURL = URL.init(fileURLWithPath: localPath)
            print(photoURL)
            self.showLoader()
            Networking.uploadImage(fileUrl: photoURL, url: Constans().uploadImage, userId: String(Constans().userid), token: Constans().token!, apikey: Constans().API_KEY){ (value) in
                self.hideLoader()
                self.showAlert(text: "Фото профиля изменено!", completion: {
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "profileImage"), object: nil, userInfo: ["photoUser": self.userImage.image!])
                })
            }
        }
        isChangedPhoto = true
        dismiss(animated: true)
    }
}
// MARK: - PickerVIew

extension EditSettingsViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return city.count

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return city[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            locationTextField.text = city[row]
        
    }

}

// MARK: - SetupConst
extension EditSettingsViewController {
    func setupConst() {
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        self.view.addSubview(saveButton)
        self.bgView.addSubview(titleLabel)
        cardView.addSubview(scrollView)
        scrollView.addSubview(views)
        views.addSubview(userImage)
        views.addSubview(aboutMe)
        views.addSubview(nameLabel)
        views.addSubview(fnameLabel)
        views.addSubview(locationLabel)
        views.addSubview(aboutMeTextField)
        views.addSubview(nameTextField)
        views.addSubview(fnameTextField)
        views.addSubview(locationTextField)
        views.addSubview(DaytextField)
        views.addSubview(UserBirth)
        views.addSubview(birthLineView)
        views.addSubview(MenRadioButton)
        views.addSubview(WomenRadioButton)
        views.addSubview(menLabel)
        views.addSubview(womenLabel)
        views.addSubview(GendarLabel)
        
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.top).offset(-16)
            make.left.equalTo(bgView.snp.left).offset(24)
            make.right.equalTo(bgView.snp.right).offset(-36)
        }
        cardView.snp.makeConstraints { (make) in
            let heightView = self.view.frame.height * 0.8
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(heightView)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.leading.equalTo(cardView.snp.leading)
            make.trailing.equalTo(cardView.snp.trailing)
            make.bottom.equalTo(saveButton.snp.centerY)
        }
        views.snp.makeConstraints { (make) in
            let width = Double(scrollView.contentSize.width)
            let height = Double(scrollView.contentSize.height)
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        userImage.snp.makeConstraints { (make) in
            make.top.equalTo(views.snp.top).offset(24)
            make.centerX.equalTo(views.snp.centerX)
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userImage.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        fnameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.left.equalTo(nameLabel.snp.left)
        }
        fnameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fnameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameTextField.snp.right)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fnameTextField.snp.bottom).offset(16)
            make.left.equalTo(nameLabel.snp.left)
        }
        locationTextField.snp.makeConstraints { (make) in
            make.top.equalTo(locationLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameTextField.snp.right)
        }
        aboutMe.snp.makeConstraints { (make) in
            make.top.equalTo(locationTextField.snp.bottom).offset(16)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        aboutMeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameTextField.snp.right)
        }
        birthLineView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMeTextField.snp.bottom).offset(4)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameTextField.snp.right)
            make.height.equalTo(1)
        }
        UserBirth.snp.makeConstraints { (make) in
            make.top.equalTo(birthLineView.snp.bottom).offset(12)
            make.left.equalTo(nameLabel.snp.left)
        }
        DaytextField.snp.makeConstraints { (make) in
            make.top.equalTo(UserBirth.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalTo(nameTextField.snp.right)
            make.height.equalTo(35)
        }
        GendarLabel.snp.makeConstraints { (make) in
            make.top.equalTo(DaytextField.snp.bottom).offset(12)
            make.left.equalTo(DaytextField.snp.left)
        }
        MenRadioButton.snp.makeConstraints { (make) in
            make.top.equalTo(GendarLabel.snp.bottom).offset(12)
            make.left.equalTo(nameLabel.snp.left)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        menLabel.snp.makeConstraints { (make) in
            make.top.equalTo(GendarLabel.snp.bottom).offset(12)
            make.left.equalTo(MenRadioButton.snp.right).offset(8)
        }
        WomenRadioButton.snp.makeConstraints { (make) in
            make.top.equalTo(GendarLabel.snp.bottom).offset(12)
            make.left.equalTo(menLabel.snp.right).offset(16)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        womenLabel.snp.makeConstraints { (make) in
            make.top.equalTo(GendarLabel.snp.bottom).offset(12)
            make.left.equalTo(WomenRadioButton.snp.right).offset(8)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-(16 + UIViewController.tabbarHeight))
            make.left.equalTo(self.view.snp.left).offset(24)
            make.right.equalTo(self.view.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        
    }
}

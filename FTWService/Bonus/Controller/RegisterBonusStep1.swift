//
//  RegisterBonusStep1.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/19/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class RegisterBonusStep1: UIViewController {
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "blueFon")
        view.isUserInteractionEnabled = true
        return view
    }()
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    private let titleStep:UILabel = {
        let label = UILabel()
        label.text = "Шаг 1 из 4"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let companyLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Как ваша компания называется?"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let descrLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Чем компания занимается?"
        return label
    }()
    private let nameField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Названия компания"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textfield
    }()
    private let descriptionField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Описания компания"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textfield
    }()
    private let cityLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Выбрать город"
        return label
    }()
    private let cityTextField:UITextField = {
        let textfield = UITextField()
        textfield.text = "Душанбе"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        return textfield
    }()
    private let lineview1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    private let lineview2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    private let lineview4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    private let lineview5: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    private let pickerview:UIPickerView = {
        let pickerview = UIPickerView()
        return pickerview
    }()
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentSize.height = 700
        view.showsHorizontalScrollIndicator = true
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let views: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    private let addPhoto: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить фото", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.sizeToFit()
        button.addTarget(self, action: #selector(addPhotoAction), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        return button
    }()
    private let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "bluePhoto")
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        view.isHidden = true
        return view
    }()
    private let catLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Выбрать категорию"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    private let podCatLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Выбрать подкатегорию"
        return label
    }()
    private let catTextField:UITextField = {
        let textfield = UITextField()
        textfield.text = "Установка и ремонт техники"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        return textfield
    }()
    private let podCatTextfield:UITextField = {
        let textfield = UITextField()
        textfield.text = "Холодильники и морозильные камеры"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        return textfield
    }()
    var city = ["Душанбе","Алматы","Бишкек","Ташкент"]
    var isCityPicker = false
    var isCatPicker = true
    var isPodPicker = false
    var category = [Category]()
    var podCategory = [Category]()
    var subcatId = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        jsonData()
        setupConstraint()
        createPickerView()
        createToolbar()
        hideKeyboardWhenTappedAround()
        setContinueButton(enabled: false)
        nameField.delegate = self
        descriptionField.delegate = self
        let cancelItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = cancelItem
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setupConstraint(){
        let image1 = resizeImage(image: (UIImage(named: "addBlue")?.maskWithColor(color: #colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)))!, targetHeight: 24)
        addPhoto.setImage(image1, for: .normal)
        addPhoto.setImage(image1, for: .highlighted)
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        self.view.addSubview(saveButton)
        cardView.addSubview(scrollView)
        scrollView.addSubview(views)
        views.addSubview(titleStep)
        views.addSubview(descrLabel)
        views.addSubview(nameField)
        views.addSubview(descriptionField)
        views.addSubview(companyLabel)
        views.addSubview(lineview1)
        views.addSubview(lineview2)
        views.addSubview(addPhoto)
        views.addSubview(imageView)
        views.addSubview(cityLabel)
        views.addSubview(cityTextField)
        views.addSubview(catLabel)
        views.addSubview(catTextField)
        views.addSubview(podCatLabel)
        views.addSubview(podCatTextfield)
        views.addSubview(lineview4)
        views.addSubview(lineview5)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.85)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top)
            make.leading.equalTo(cardView.snp.leading)
            make.trailing.equalTo(cardView.snp.trailing)
            make.bottom.equalTo(saveButton.snp.top)
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
        titleStep.snp.makeConstraints { (make) in
            make.top.equalTo(views.snp.top).offset(16)
            make.centerX.equalTo(views.snp.centerX)
        }
        addPhoto.snp.makeConstraints { (make) in
            make.top.equalTo(titleStep.snp.bottom).offset(32)
            make.left.equalTo(views.snp.left).offset(24)
            make.right.equalTo(views.snp.right).offset(-24)
            make.height.equalTo(50)
        }
        companyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addPhoto.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        nameField.snp.makeConstraints { (make) in
            make.top.equalTo(companyLabel.snp.bottom).offset(8)
            make.left.equalTo(companyLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview1.snp.makeConstraints { (make) in
            make.top.equalTo(nameField.snp.bottom).offset(4)
            make.left.equalTo(nameField.snp.left)
            make.right.equalTo(nameField.snp.right)
            make.height.equalTo(1)
        }
        descrLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview1.snp.bottom).offset(32)
            make.left.equalTo(views.snp.left).offset(24)
        }
        descriptionField.snp.makeConstraints { (make) in
            make.top.equalTo(descrLabel.snp.bottom).offset(8)
            make.left.equalTo(companyLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview2.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionField.snp.bottom).offset(4)
            make.left.equalTo(nameField.snp.left)
            make.right.equalTo(nameField.snp.right)
            make.height.equalTo(1)
        }
        cityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview5.snp.bottom).offset(32)
            make.left.equalTo(views.snp.left).offset(24)
        }
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.left.equalTo(companyLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
  
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
        catLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview2.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        catTextField.snp.makeConstraints { (make) in
            make.top.equalTo(catLabel.snp.bottom).offset(8)
            make.left.equalTo(catLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview4.snp.makeConstraints { (make) in
            make.top.equalTo(catTextField.snp.bottom).offset(4)
            make.left.equalTo(nameField.snp.left)
            make.right.equalTo(nameField.snp.right)
            make.height.equalTo(1)
        }
        podCatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview4.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        podCatTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(podCatLabel.snp.bottom).offset(8)
            make.left.equalTo(catLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview5.snp.makeConstraints { (make) in
            make.top.equalTo(podCatTextfield.snp.bottom).offset(4)
            make.left.equalTo(nameField.snp.left)
            make.right.equalTo(nameField.snp.right)
            make.height.equalTo(1)
        }
    }
    func createPickerView()
    {
        pickerview.delegate = self
        //        pickerview.delegate?.pickerView?(pickerview, didSelectRow: 0, inComponent: 0)
        cityTextField.inputView = pickerview
        catTextField.inputView = pickerview
        podCatTextfield.inputView = pickerview
        
    }
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "Готова", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        cityTextField.inputAccessoryView = toolbar
        catTextField.inputAccessoryView = toolbar
        podCatTextfield.inputAccessoryView = toolbar
        
    }
    fileprivate func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage {
        // Get current image size
        let size = image.size
        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return new image
        return newImage!
    }
    func jsonData() {
        DataProvider.getCategoryArray(url: Constans().category, id: 0) { (result) in
            guard let category = result else {return}
            self.category = category
        }
        DataProvider.getCategoryArray(url: Constans().category, id: 1) { (result) in
            guard let category = result else {return}
            self.podCategory = category
        }
        
    }
    func addPhotoonlyOne() {
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func handleCancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func textFieldChanged() {
        guard
            let textFieldtext1 = descriptionField.text,let textFieldtext2 = nameField.text
            else {return}
        let formFilled = !(textFieldtext1.isEmpty) && !(textFieldtext2.isEmpty)
        setContinueButton(enabled: formFilled)
    }
    func setContinueButton(enabled: Bool) {
        if enabled {
            saveButton.alpha = 1
            saveButton.isEnabled = true
        } else {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        }
    }
    @objc func textfieldChanged(sender:UITextField) {
        if sender == podCatTextfield {
            isPodPicker = true
            isCatPicker = false
            isCityPicker = false
        } else if sender == catTextField {
            isPodPicker = false
            isCatPicker = true
            isCityPicker = false
        } else {
            isPodPicker = false
            isCatPicker = false
            isCityPicker = true
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func addPhotoAction() {
        imageView.isHidden = false
        addPhoto.isHidden = true
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleStep.snp.bottom).offset(32)
            make.centerX.equalTo(cardView.snp.centerX)
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        companyLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        addPhotoonlyOne()
    }
    
    @objc func doneClick() {
        view.endEditing(true)
    }
    @objc func cancelClick() {
        view.endEditing(true)
        
    }
    @objc func buttonAction() {
        _ = UserDefaults.standard.integer(forKey: "ID")
        _ = UserDefaults.standard.string(forKey: "token")
        guard let partnerName = nameField.text,let disc = descriptionField.text,let city = cityTextField.text else{return}
        PassData.partnerName = partnerName
        PassData.partnerCity = city
        PassData.partnerSubCatID = subcatId
        PassData.partnerDescr = disc
        let vc = PartnersViewController()
        self.show(vc, sender: self)
        
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
extension RegisterBonusStep1:UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isCityPicker {
            return city.count
        } else if isCatPicker {
            return category.count
        } else {
            return podCategory.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isCityPicker {
            return city[row]
        } else if isCatPicker {
            return category[row].name
        } else {
            return podCategory[row].name
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isCityPicker {
            cityTextField.text = city[row]
        } else if isCatPicker {
            catTextField.text = category[row].name
            Networking.getCategory(url: Constans().category, id: category[row].id) { (category, id) in
                self.podCategory = category
                self.podCatTextfield.text = self.podCategory[0].name
                self.subcatId = self.podCategory[0].id
            }
        } else {
            podCatTextfield.text = podCategory[row].name
            subcatId = podCategory[row].id
        }
        
    }
}
extension RegisterBonusStep1:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        imageView.image = newImage
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        if let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            PassData.partnerImageUrl = fileUrl
        }
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            let data = newImage!.pngData()! as NSData
            data.write(toFile: localPath, atomically: false)
            let photoURL = URL.init(fileURLWithPath: localPath)
                PassData.partnerImageUrl = photoURL
        }
        
        dismiss(animated: true)
    }
}
extension RegisterBonusStep1: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
}

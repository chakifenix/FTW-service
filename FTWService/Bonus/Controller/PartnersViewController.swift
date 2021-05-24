//
//  PartnersViewController.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/20/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController {
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
        label.text = "Шаг 2 из 3"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
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
    private let descrSaleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Чем ваша скидка хороша?"
        return label
    }()
    private let descrSaleTextField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Описание скидки"
        textfield.borderStyle = .none
        return textfield
    }()
    private let saleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Опишите вашу скидку"
        return label
    }()
    private let saleTextField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Название скидки"
        textfield.borderStyle = .none
        return textfield
    }()
    private let lineview1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let lineview2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let lineview3: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let lineview4: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
    var category = [Category]()
    var podCategory = [Category]()
    var isPickers = true
    var subcatID = 2
    var catID = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonData()
        setupConstraint()
        createPickerView()
        createToolbar()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
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
        views.addSubview(catLabel)
        views.addSubview(podCatLabel)
        views.addSubview(catTextField)
        views.addSubview(podCatTextfield)
        views.addSubview(lineview1)
        views.addSubview(lineview2)
        views.addSubview(saleLabel)
        views.addSubview(saleTextField)
        views.addSubview(descrSaleLabel)
        views.addSubview(descrSaleTextField)
        views.addSubview(lineview3)
        views.addSubview(lineview4)
        views.addSubview(addPhoto)
        views.addSubview(imageView)
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
        saleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addPhoto.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        saleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(saleLabel.snp.bottom).offset(8)
            make.left.equalTo(saleLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
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
        catLabel.snp.makeConstraints { (make) in
            make.top.equalTo(saleTextField.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        catTextField.snp.makeConstraints { (make) in
            make.top.equalTo(catLabel.snp.bottom).offset(8)
            make.left.equalTo(catLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview3.snp.makeConstraints { (make) in
            make.top.equalTo(catTextField.snp.bottom).offset(4)
            make.left.equalTo(catTextField.snp.left)
            make.right.equalTo(catTextField.snp.right)
            make.height.equalTo(1)
        }
        lineview1.snp.makeConstraints { (make) in
            make.top.equalTo(saleTextField.snp.bottom).offset(4)
            make.left.equalTo(catTextField.snp.left)
            make.right.equalTo(catTextField.snp.right)
            make.height.equalTo(1)
        }
        podCatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview3.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        podCatTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(podCatLabel.snp.bottom).offset(8)
            make.left.equalTo(catLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview4.snp.makeConstraints { (make) in
            make.top.equalTo(podCatTextfield.snp.bottom).offset(4)
            make.left.equalTo(catTextField.snp.left)
            make.right.equalTo(catTextField.snp.right)
            make.height.equalTo(1)
        }
        descrSaleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview4.snp.bottom).offset(16)
            make.left.equalTo(views.snp.left).offset(24)
        }
        descrSaleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(descrSaleLabel.snp.bottom).offset(8)
            make.left.equalTo(catLabel.snp.left)
            make.right.equalTo(views.snp.right).offset(-24)
        }
        lineview2.snp.makeConstraints { (make) in
            make.top.equalTo(descrSaleTextField.snp.bottom).offset(4)
            make.left.equalTo(catTextField.snp.left)
            make.right.equalTo(catTextField.snp.right)
            make.height.equalTo(1)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
    }
    func createPickerView()
    {
        pickerview.delegate = self
        //        pickerview.delegate?.pickerView?(pickerview, didSelectRow: 0, inComponent: 0)
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
        catTextField.inputAccessoryView = toolbar
        podCatTextfield.inputAccessoryView = toolbar
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
        saleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
        }
        addPhotoonlyOne()
    }
    @objc func buttonAction() {
        guard let saleName = saleTextField.text,let disc = descrSaleLabel.text else{return}
        let vc = LevelBonusController()
        vc.saleName = saleName
        vc.discrSale = disc
        vc.subcatID = subcatID
        vc.catId = catID
        self.show(vc, sender: self)
    }
    @objc func doneClick() {
        view.endEditing(true)
    }
    @objc func cancelClick() {
        view.endEditing(true)
        
    }
    @objc func textfieldChanged(sender:UITextField) {
        if sender == podCatTextfield {
            isPickers = false
        } else {
            isPickers = true
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
extension PartnersViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return isPickers ? category.count:podCategory.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isPickers ? category[row].name:podCategory[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isPickers {
            catTextField.text = category[row].name
            catID = category[row].id
            Networking.getCategory(url: Constans().category, id: category[row].id) { (category, id) in
                self.podCategory = category
                self.podCatTextfield.text = self.podCategory[0].name
                self.subcatID = self.podCategory[0].id
            }
        } else {
            podCatTextfield.text = podCategory[row].name
            self.subcatID = podCategory[row].id
        }
    }
}
extension PartnersViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            PassData.saleImageUrl = fileUrl
            print(fileUrl)
        }
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            let data = newImage!.pngData()! as NSData
            data.write(toFile: localPath, atomically: false)
            let photoURL = URL.init(fileURLWithPath: localPath)
            PassData.saleImageUrl = photoURL
        }
        
        dismiss(animated: true)
    }
    
}

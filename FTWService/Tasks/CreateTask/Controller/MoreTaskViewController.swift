//
//  MoreTaskViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import MaterialComponents
import BSImagePicker
import Photos
import SnapKit
import Alamofire
class MoreTaskViewController: UIViewController {
    
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Green")
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
    private let lineview: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private let addViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить изображения", for: .normal)
        button.setTitleColor(Data_Colors.gradientColor, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(addPhotoViewAction), for: .touchUpInside)
        return button
    }()
    private let addPhoto: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить фото", for: .normal)
        button.setTitleColor(Data_Colors.gradientColor, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.sizeToFit()
        button.addTarget(self, action: #selector(addPhotoAction), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)
        button.layer.borderWidth = 2
        return button
    }()
    private let gobutton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private let textField:UITextField = {
        let text = UITextField()
        text.placeholder = "Напишите описания"
        text.borderStyle = .none
        text.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return text
    }()
    private let stepIndex:UILabel = {
        let label = UILabel()
        label.text = "Шаг 5 из 6"
        label.textColor = .lightGray
        return label
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Укажите детали"
        label.textColor = .black
        return label
    }()
    var selectedImage = [PHAsset]()
    var imageArray = [UIImage]()
    
    let photoView: UIView = {
        let view = UIView()
        return view
    }()
    let photoImage1:UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    let photoImage2:UIImageView =  {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    let photoImage3:UIImageView =  {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    let photoImage4:UIImageView =  {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    let photoImage5:UIImageView =  {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    let photoImage6:UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        return view
    }()
    
    let xBtn1: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let xBtn2: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let xBtn3: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let xBtn4: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let xBtn5: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let xBtn6: UIImageView = {
        let view = UIImageView()
        return view
    }()
    var heightConst:Constraint?
    var firstHeight:Constraint?
    var tappedImage1 = false
    var tappedImage2 = false
    var tappedImage3 = false
    var tappedImage4 = false
    var tappedImage5 = false
    var tappedImage6 = false
    var isPresssed = false
    var arrayPath = [PickerArrayModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        addPhoto.isHidden = true
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setContinueButton(enabled: false)
        hideKeyboardWhenTappedAround()
        createTap()
        setupBarButton()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gobutton.applyGradient(colors:  [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    private func createViews() {
        photoImage1.contentMode = .scaleToFill
        photoImage1.isUserInteractionEnabled = true
        photoImage1.image = UIImage(named: "bluePhoto")
        
        photoImage2.contentMode = .scaleToFill
        photoImage2.isUserInteractionEnabled = true
        photoImage2.image = UIImage(named: "bluePhoto")
        
        photoImage3.contentMode = .scaleToFill
        photoImage3.isUserInteractionEnabled = true
        photoImage3.image = UIImage(named: "bluePhoto")
        
        photoImage4.contentMode = .scaleToFill
        photoImage4.isUserInteractionEnabled = true
        photoImage4.image = UIImage(named: "bluePhoto")
        
        photoImage5.contentMode = .scaleToFill
        photoImage5.isUserInteractionEnabled = true
        photoImage5.image = UIImage(named: "bluePhoto")
        
        photoImage6.contentMode = .scaleToFill
        photoImage6.isUserInteractionEnabled = true
        photoImage6.image = UIImage(named: "bluePhoto")
        
        xBtn1.isUserInteractionEnabled = true
        xBtn1.image = UIImage(named: "x-red")
        xBtn1.isHidden = true
        
        xBtn2.isUserInteractionEnabled = true
        xBtn2.image = UIImage(named: "x-red")
        xBtn2.isHidden = true
        
        xBtn3.isUserInteractionEnabled = true
        xBtn3.image = UIImage(named: "x-red")
        xBtn3.isHidden = true
        
        xBtn4.isUserInteractionEnabled = true
        xBtn4.image = UIImage(named: "x-red")
        xBtn4.isHidden = true
        
        xBtn5.isUserInteractionEnabled = true
        xBtn5.image = UIImage(named: "x-red")
        xBtn5.isHidden = true
        
        xBtn6.isUserInteractionEnabled = true
        xBtn6.image = UIImage(named: "x-red")
        xBtn6.isHidden = true
        let image1 = resizeImage(image: (UIImage(named: "addBlue")?.maskWithColor(color: #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)))!, targetHeight: 24)
        addPhoto.setImage(image1, for: .normal)
        addPhoto.setImage(image1, for: .highlighted)
        let image2 = resizeImage(image: (UIImage(named: "link")?.maskWithColor(color: #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)))!, targetHeight: 24)
        addViewButton.setImage(image2, for: .normal)
        addViewButton.setImage(image2, for: .highlighted)
        photoView.isHidden = true
        self.view.addSubview(bgView)
        self.view.addSubview(cardView)
        cardView.addSubview(stepIndex)
        //        cardView.addSubview(titleLabel)
        cardView.addSubview(photoView)
        cardView.addSubview(lineview)
        cardView.addSubview(textField)
        cardView.addSubview(gobutton)
        cardView.addSubview(addPhoto)
        cardView.addSubview(addViewButton)
        
        photoView.addSubview(photoImage1)
        photoView.addSubview(photoImage2)
        photoView.addSubview(photoImage3)
        photoView.addSubview(photoImage4)
        photoView.addSubview(photoImage5)
        photoView.addSubview(photoImage6)
        photoView.addSubview(xBtn1)
        photoView.addSubview(xBtn2)
        photoView.addSubview(xBtn3)
        photoView.addSubview(xBtn4)
        photoView.addSubview(xBtn5)
        photoView.addSubview(xBtn6)
        
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        cardView.snp.makeConstraints { (make) in
            let heightView = self.view.frame.height * 0.8
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(heightView)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        stepIndex.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.centerX.equalTo(cardView.snp.centerX)
        }
        //        titleLabel.snp.makeConstraints { (make) in
        //            make.top.equalTo(stepIndex.snp.bottom).offset(24)
        //            make.left.equalTo(cardView.snp.left).offset(24)
        //        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(stepIndex.snp.bottom).offset(32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(6)
            make.left.equalTo(cardView.snp.left).offset(16)
            make.right.equalTo(cardView.snp.right).offset(-16)
            make.height.equalTo(1)
        }
        addViewButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(16)
            make.left.equalTo(cardView.snp.left).offset(24)
            //            make.width.equalTo(cardView.snp.width).multipliedBy(0.55)
            make.height.equalTo(30)
        }
        addPhoto.snp.makeConstraints { (make) in
            make.bottom.equalTo(gobutton.snp.top).offset(-16)
            make.left.equalTo(gobutton.snp.left)
            make.right.equalTo(gobutton.snp.right)
            make.height.equalTo(45)
        }
        photoView.snp.makeConstraints { (make) in
            //            let heightSize = addPhoto.frame.maxY - lineview.frame.minY
            make.top.equalTo(lineview.snp.bottom)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            //            make.height.lessThanOrEqualTo(heightSize)
            make.bottom.equalTo(addPhoto.snp.top)
        }
        
        photoImage1.snp.makeConstraints { (make) in
            make.bottom.equalTo(photoView.snp.centerY).offset(-16)
            make.left.equalTo(photoView.snp.left)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        
        photoImage2.snp.makeConstraints { (make) in
            make.bottom.equalTo(photoView.snp.centerY).offset(-16)
            make.centerX.equalTo(photoView.snp.centerX)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        
        photoImage3.snp.makeConstraints { (make) in
            make.bottom.equalTo(photoView.snp.centerY).offset(-16)
            make.right.equalTo(photoView.snp.right)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        
        photoImage4.snp.makeConstraints { (make) in
            make.top.equalTo(photoView.snp.centerY).offset(16)
            make.left.equalTo(photoView.snp.left)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        
        photoImage5.snp.makeConstraints { (make) in
            make.top.equalTo(photoView.snp.centerY).offset(16)
            make.centerX.equalTo(photoImage2.snp.centerX)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        photoImage6.snp.makeConstraints { (make) in
            make.top.equalTo(photoView.snp.centerY).offset(16)
            make.right.equalTo(photoView.snp.right)
            make.width.height.equalTo(photoView.snp.width).multipliedBy(0.3)
        }
        xBtn1.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage1.snp.top).offset(-8)
            make.centerX.equalTo(photoImage1.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        xBtn2.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage2.snp.top).offset(-8)
            make.centerX.equalTo(photoImage2.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        xBtn3.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage3.snp.top).offset(-8)
            make.centerX.equalTo(photoImage3.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        xBtn4.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage4.snp.top).offset(-8)
            make.centerX.equalTo(photoImage4.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        xBtn5.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage5.snp.top).offset(-8)
            make.centerX.equalTo(photoImage5.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        xBtn6.snp.makeConstraints { (make) in
            make.top.equalTo(photoImage6.snp.top).offset(-8)
            make.centerX.equalTo(photoImage6.snp.right).offset(-3)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        gobutton.snp.makeConstraints { (make) in
            make.bottom.equalTo(cardView.snp.bottom).offset(-32)
            make.left.equalTo(cardView.snp.left).offset(24)
            make.right.equalTo(cardView.snp.right).offset(-24)
            make.height.equalTo(45)
        }
        
        
    }
    func createTap() {
        let tapImage1 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage1))
        photoImage1.addGestureRecognizer(tapImage1)
        
        let tapImage2 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage2))
        photoImage2.addGestureRecognizer(tapImage2)
        
        let tapImage3 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage3))
        photoImage3.addGestureRecognizer(tapImage3)
        
        let tapImage4 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage4))
        photoImage4.addGestureRecognizer(tapImage4)
        
        let tapImage5 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage5))
        photoImage5.addGestureRecognizer(tapImage5)
        
        let tapImage6 = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage6))
        photoImage6.addGestureRecognizer(tapImage6)
        
        let XbuttonTap1 = UITapGestureRecognizer(target: self, action: #selector(Xtapped1))
        xBtn1.addGestureRecognizer(XbuttonTap1)
        
        let XbuttonTap2 = UITapGestureRecognizer(target: self, action: #selector(Xtapped2))
        xBtn2.addGestureRecognizer(XbuttonTap2)
        
        let XbuttonTap3 = UITapGestureRecognizer(target: self, action: #selector(Xtapped3))
        xBtn3.addGestureRecognizer(XbuttonTap3)
        
        let XbuttonTap4 = UITapGestureRecognizer(target: self, action: #selector(Xtapped4))
        xBtn4.addGestureRecognizer(XbuttonTap4)
        
        let XbuttonTap5 = UITapGestureRecognizer(target: self, action: #selector(Xtapped5))
        xBtn5.addGestureRecognizer(XbuttonTap5)
        
        let XbuttonTap6 = UITapGestureRecognizer(target: self, action: #selector(Xtapped6))
        xBtn6.addGestureRecognizer(XbuttonTap6)
    }
    func setupBarButton() {
        let right = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCalcelAction))
        navigationItem.rightBarButtonItem = right
    }
    @objc func tappedPhotoImage1() {
        tappedImage1 = true
        tappedImage2 = false
        tappedImage3 = false
        tappedImage4 = false
        tappedImage5 = false
        tappedImage6 = false
        
        addPhotoonlyOne()
    }
    @objc func tappedPhotoImage2() {
        tappedImage1 = false
        tappedImage2 = true
        tappedImage3 = false
        tappedImage4 = false
        tappedImage5 = false
        tappedImage6 = false
        addPhotoonlyOne()
        
    }
    @objc func tappedPhotoImage3() {
        tappedImage1 = false
        tappedImage2 = false
        tappedImage3 = true
        tappedImage4 = false
        tappedImage5 = false
        tappedImage6 = false
        addPhotoonlyOne()
        
    }
    @objc func tappedPhotoImage4() {
        tappedImage1 = false
        tappedImage2 = false
        tappedImage3 = false
        tappedImage4 = true
        tappedImage5 = false
        tappedImage6 = false
        addPhotoonlyOne()
        
    }
    @objc func tappedPhotoImage5() {
        tappedImage1 = false
        tappedImage2 = false
        tappedImage3 = false
        tappedImage4 = false
        tappedImage5 = true
        tappedImage6 = false
        addPhotoonlyOne()
        
    }
    @objc func tappedPhotoImage6() {
        tappedImage1 = false
        tappedImage2 = false
        tappedImage3 = false
        tappedImage4 = false
        tappedImage5 = false
        tappedImage6 = true
        addPhotoonlyOne()
    }
    
    
    func checkImagePathMethod(index:Int){
        print(arrayPath.count)
        for i in 0..<arrayPath.count-1{
            if arrayPath[i].index == index{
                arrayPath.remove(at: i)
            }
        }
    }
    
    @objc func Xtapped1() {
        photoImage1.image = UIImage(named: "bluePhoto")
        self.xBtn1.isHidden = true
        checkImagePathMethod(index: 1)
    }
    @objc func Xtapped2() {
        photoImage2.image = UIImage(named: "bluePhoto")
        self.xBtn2.isHidden = true
        checkImagePathMethod(index: 2)
        
    }
    @objc func Xtapped3() {
        photoImage3.image = UIImage(named: "bluePhoto")
        self.xBtn3.isHidden = true
        checkImagePathMethod(index: 3)
        
    }
    @objc func Xtapped4() {
        photoImage4.image = UIImage(named: "bluePhoto")
        self.xBtn4.isHidden = true
        checkImagePathMethod(index: 4)
        
    }
    @objc func Xtapped5() {
        photoImage5.image = UIImage(named: "bluePhoto")
        self.xBtn5.isHidden = true
        checkImagePathMethod(index: 5)
    }
    @objc func Xtapped6() {
        photoImage6.image = UIImage(named: "bluePhoto")
        self.xBtn6.isHidden = true
        checkImagePathMethod(index: 6)
        
    }
    
    @objc func handleCalcelAction() {
        print("Cancel")
        self.showAlertAction(title: nil, message: "Введенные данные будет потеряны.Удалить заданиие?", titleOk: "Удалить", cancelTitle: "Продолжить создание") { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @objc func textFieldChanged() {
        guard
            let textFieldtext = textField.text
            else {return}
        lineview.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)
        let formFilled = !(textFieldtext.isEmpty)
        setContinueButton(enabled: formFilled)
    }
    func setContinueButton(enabled: Bool) {
        if enabled {
            gobutton.alpha = 1
            gobutton.isEnabled = true
        } else {
            gobutton.alpha = 0.5
            gobutton.isEnabled = false
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func addPhotoViewAction() {
        self.photoView.isHidden = false
        self.addPhoto.isHidden = false
        self.addViewButton.isHidden = true
    }
    @objc func addPhotoAction() {
        isPresssed = true
        let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 6
            
            self.bs_presentImagePickerController(vc, animated: true,
                                                 select: { (asset: PHAsset) -> Void in
                                                    
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                self.arrayPath.removeAll()
                
                for (index,x) in assets.enumerated(){
                    PHImageManager.default().requestImageData(for: x, options: options, resultHandler: { (data, str, img, key) in
                        let image = assets[index].image
                        if let dict = key as NSDictionary? as! [String:Any]? {
                            let fileURL = dict["PHImageFileURLKey"] as? URL
                            let heic = fileURL?.absoluteString.split(separator: ".")
                            if String(heic![1]) == "HEIC" {
                                  let filePath = self.getOrientationFixedImage(image: image)
                                    self.arrayPath.append(PickerArrayModel(pathImage: filePath, index: index + 1))
                            } else {
                                let filePath = self.getOrientationFixedImage(image: image)
                                self.arrayPath.append(PickerArrayModel(pathImage: filePath, index: index + 1))
                            }
                        }
                    })
                    
                }
                for i in 0..<assets.count {
                    self.selectedImage.append(assets[i])
                    if self.selectedImage.count == 6{
                        self.photoImage1.image = assets[0].image
                        self.photoImage2.image = assets[1].image
                        self.photoImage3.image = assets[2].image
                        self.photoImage4.image = assets[3].image
                        self.photoImage5.image = assets[4].image
                        self.photoImage6.image = assets[5].image
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = false
                        self.xBtn3.isHidden = false
                        self.xBtn4.isHidden = false
                        self.xBtn5.isHidden = false
                        self.xBtn6.isHidden = false
                        
                    }
                    else if self.selectedImage.count == 5 {
                        self.photoImage1.image = assets[0].image
                        self.photoImage2.image = assets[1].image
                        self.photoImage3.image = assets[2].image
                        self.photoImage4.image = assets[3].image
                        self.photoImage5.image = assets[4].image
                        self.photoImage6.image = UIImage(named: "bluePhoto")
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = false
                        self.xBtn3.isHidden = false
                        self.xBtn4.isHidden = false
                        self.xBtn5.isHidden = false
                        self.xBtn6.isHidden = true
                    }
                    else if self.selectedImage.count == 4 {
                        self.photoImage1.image = assets[0].image
                        self.photoImage2.image = assets[1].image
                        self.photoImage3.image = assets[2].image
                        self.photoImage4.image = assets[3].image
                        self.photoImage5.image = UIImage(named: "bluePhoto")
                        self.photoImage6.image = UIImage(named: "bluePhoto")
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = false
                        self.xBtn3.isHidden = false
                        self.xBtn4.isHidden = false
                        self.xBtn5.isHidden = true
                        self.xBtn6.isHidden = true
                    }
                    else if self.selectedImage.count == 3 {
                        self.photoImage1.image = assets[0].image
                        self.photoImage2.image = assets[1].image
                        self.photoImage3.image = assets[2].image
                        self.photoImage4.image = UIImage(named: "bluePhoto")
                        self.photoImage5.image = UIImage(named: "bluePhoto")
                        self.photoImage6.image = UIImage(named: "bluePhoto")
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = false
                        self.xBtn3.isHidden = false
                        self.xBtn4.isHidden = true
                        self.xBtn5.isHidden = true
                        self.xBtn6.isHidden = true
                    }
                    else if self.selectedImage.count == 2 {
                        self.photoImage1.image = assets[0].image
                        self.photoImage2.image = self.getUIImage(asset: assets[1])
                        self.photoImage3.image = UIImage(named: "bluePhoto")
                        self.photoImage4.image = UIImage(named: "bluePhoto")
                        self.photoImage5.image = UIImage(named: "bluePhoto")
                        self.photoImage6.image = UIImage(named: "bluePhoto")
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = false
                        self.xBtn3.isHidden = true
                        self.xBtn4.isHidden = true
                        self.xBtn5.isHidden = true
                        self.xBtn6.isHidden = true
                    }
                    else if self.selectedImage.count == 1 {
                        self.photoImage1.image = assets[0].image
                        
                        self.photoImage2.image = UIImage(named: "bluePhoto")
                        self.photoImage3.image = UIImage(named: "bluePhoto")
                        self.photoImage4.image = UIImage(named: "bluePhoto")
                        self.photoImage5.image = UIImage(named: "bluePhoto")
                        self.photoImage6.image = UIImage(named: "bluePhoto")
                        self.xBtn1.isHidden = false
                        self.xBtn2.isHidden = true
                        self.xBtn3.isHidden = true
                        self.xBtn4.isHidden = true
                        self.xBtn5.isHidden = true
                        self.xBtn6.isHidden = true
                    }
                }
                
            }, completion: nil)
        selectedImage.removeAll()
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    @objc func buttonPressed() {
        var newArray = [UIImage]()
        var array = [photoImage1,photoImage2,photoImage3,photoImage4,photoImage5,photoImage6]
        for i in array{
            if i.image != UIImage(named: "bluePhoto"){
                newArray.append(i.image!)
            }
        }
        guard let taskText = textField.text else {return}
        _ = PassData.category
        _ = PassData.podCategory
        let idCat =  PassData.podCategorID
        let task = PassData.createTask
        let location = PassData.location
        let startDay = PassData.startdayTask
        let finishDay = PassData.finishdayTask
        let cash = PassData.cashTask
        let remote = PassData.wtasker
        let exactTime = PassData.selectedIndexDay
        let exactDay = PassData.exactDay
        _ = UserDefaults.standard.integer(forKey: "ID")
        let vc = AnketaViewController()
        vc.imageArray = newArray
        vc.pathArray = arrayPath
        vc.location = location
        vc.narrative = taskText
        vc.tasknameText = task
        vc.cashText = cash == "wtasker" ? "Договорюсь с исполнителем" : cash
        if remote != "" {
            vc.textDate = "Предложите цену"
        } else if startDay != "" && finishDay != "" {
            vc.textDate = "\(startDay)-\(finishDay)"
        }
        else if exactDay != "" && exactTime != "" {
            vc.textDate = "\(exactDay)"
        }
        self.show(vc, sender: self)
    }
    
    
    func addPhotoonlyOne() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo-1")
        isPresssed = true
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
        selectedImage.removeAll()
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension MoreTaskViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        if tappedImage1 {
            let newImage = info[.editedImage] as? UIImage
            photoImage1.image = newImage
            photoImage1.contentMode = .scaleToFill
            photoImage1.clipsToBounds = true
            xBtn1.isHidden = false
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 1))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 1)
            }
        }
        if tappedImage2 {
            let newImage = info[.editedImage] as? UIImage
            photoImage2.image = newImage
            photoImage2.contentMode = .scaleToFill
            photoImage2.clipsToBounds = true
            xBtn2.isHidden = false
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 2))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 2)
            }
        }
        if tappedImage3 {
            let newImage = info[.editedImage] as? UIImage
            photoImage3.image = newImage
            photoImage3.contentMode = .scaleToFill
            photoImage3.clipsToBounds = true
            xBtn3.isHidden = false
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 3))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 3)
            }
            
        }
        if tappedImage4 {
            let newImage = info[.editedImage] as? UIImage
            photoImage4.image = newImage
            photoImage4.contentMode = .scaleToFill
            photoImage4.clipsToBounds = true
            xBtn4.isHidden = false
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 4))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 4)
            }
            
        }
        if tappedImage5 {
            let newImage = info[.editedImage] as? UIImage
            photoImage5.image = newImage
            photoImage5.contentMode = .scaleToFill
            photoImage5.clipsToBounds = true
            xBtn5.isHidden = false
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 5))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 5)
            }
        }
        if tappedImage6 {
            let newImage = info[.editedImage] as? UIImage
            photoImage6.image = newImage
            photoImage6.contentMode = .scaleToFill
            photoImage6.clipsToBounds = true
            xBtn6.isHidden = false
            
            if let _ = info[UIImagePickerController.InfoKey.imageURL] as? URL,let newImage = newImage {
                arrayPath.append(PickerArrayModel(pathImage: getOrientationFixedImage(image: newImage), index: 6))
            }
            if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                getUrlPathFormCamera(image: newImage!, index: 6)
            }
        }
        dismiss(animated: true)
    }
    func getUrlPathFormCamera(image:UIImage,index:Int) {
        let imgName = UUID().uuidString
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgName + ".jpg")
        let data = image.pngData()! as NSData
        data.write(toFile: localPath, atomically: false)
        let photoURL = URL.init(fileURLWithPath: localPath)
        print(photoURL)
        arrayPath.append(PickerArrayModel(pathImage: photoURL, index: index))
    }
    func getOrientationFixedImage(image: UIImage) -> URL {
        let orientationFixedImage = image.fixedOrientation()
        let imgNameOr = UUID().uuidString
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgNameOr + ".jpg")
        let data = orientationFixedImage!.pngData()! as NSData
        data.write(toFile: localPath, atomically: false)
        let photoURL = URL.init(fileURLWithPath: localPath)
        return photoURL
    }
}
extension MoreTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    
}
extension PHAsset {
    
    var image : UIImage {
        var thumbnail = UIImage()
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.version = .original
        option.isSynchronous = true
        manager.requestImageData(for: self, options: option) { data, _, _, _ in
            
            if let data = data {
                thumbnail = UIImage(data: data)!
            }
        }
        return thumbnail
    }
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

struct PickerArrayModel {
    var pathImage:URL
    var index:Int
}

extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}

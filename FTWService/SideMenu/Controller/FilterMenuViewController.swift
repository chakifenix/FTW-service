//
//  FilterMenuViewController.swift
//  OrzuServiceProject
//
//  Created by Magzhan Imangazin on 12/18/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import iOSDropDown
protocol filterPartner {
    func filterPartner(city:String,catID:Int)
}
class FilterMenuViewController: UIViewController {
    private let locationName:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "Выбрать город"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let categorName:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Выбрать категорию"
        return label
    }()
    private let podcategorName:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Выбрать подкатегорию"
        return label
    }()
    private let saveButton:UIButton = {
        let button = UIButton()
        button.setTitle("Готова", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    private let menuLoc:UITextField = {
        let textfield = UITextField()
        textfield.text = "Душанбе"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        textfield.addPadding(.left(16))
        return textfield
    }()
    private let menuCat:UITextField = {
        let textfield = UITextField()
        textfield.text = "Установка и ремонт техники"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        textfield.addPadding(.left(16))
        return textfield
    }()
    private let menuPod:UITextField = {
        let textfield = UITextField()
        textfield.text = "Холодильники и морозильные камеры"
        textfield.borderStyle = .none
        textfield.addTarget(self, action: #selector(textfieldChanged(sender:)), for: .touchDown)
        textfield.addPadding(.left(16))
        return textfield
    }()
    let locationView:UIView = {
       let view = UIView()
       view.backgroundColor = .white
       view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        return view
    }()
    let categorView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        return view
    }()
    let podcategorView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        return view
    }()
    private let pickerview:UIPickerView = {
        let pickerview = UIPickerView()
        return pickerview
    }()
    let searchBar = UISearchController(searchResultsController: nil)
    private lazy var searchTextField: UITextField? = { [unowned self] in
        var textField: UITextField?
        self.searchBar.searchBar.subviews.forEach({ view in
            view.subviews.forEach({ view in
                if let view  = view as? UITextField {
                    textField = view
                }
            })
        })
        return textField
        }()
    var delegate:filterPartner?
    var city = ["Душанбе","Алматы","Бишкек","Ташкент"]
    var isCityPicker = true
    var isCatPicker = false
    var isPodPicker = false
    var category = [Category]()
    var podCategory = [Category]()
    var subcatId = 2
    fileprivate func setupConst() {
        self.view.addSubview(locationName)
        self.view.addSubview(saveButton)
        self.view.addSubview(categorName)
        self.view.addSubview(podcategorName)
        self.view.addSubview(locationView)
        self.view.addSubview(podcategorView)
        self.view.addSubview(categorView)
        locationView.addSubview(menuLoc)
        categorView.addSubview(menuCat)
        podcategorView.addSubview(menuPod)
        locationName.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(16)
            make.left.equalTo(self.view.snp.left).offset(24)
        }
        locationView.snp.makeConstraints { (make) in
            make.top.equalTo(locationName.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
        menuLoc.snp.makeConstraints { (make) in
            make.top.bottom.left.height.right.equalTo(locationView)
        }
        categorName.snp.makeConstraints { (make) in
            make.top.equalTo(locationView.snp.bottom).offset(24)
            make.left.equalTo(self.view.snp.left).offset(24)
        }
        categorView.snp.makeConstraints { (make) in
            make.top.equalTo(categorName.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
        menuCat.snp.makeConstraints { (make) in
            make.top.bottom.left.height.right.equalTo(categorView)
        }
        podcategorName.snp.makeConstraints { (make) in
            make.top.equalTo(categorView.snp.bottom).offset(24)
            make.left.equalTo(self.view.snp.left).offset(24)
        }
        podcategorView.snp.makeConstraints { (make) in
            make.top.equalTo(podcategorName.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(40)
        }
        menuPod.snp.makeConstraints { (make) in
            make.top.bottom.left.height.right.equalTo(podcategorView)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-32)
            make.left.equalTo(self.view.snp.left).offset(16)
            make.right.equalTo(self.view.snp.right).offset(-16)
            make.height.equalTo(50)
        }
    }
    fileprivate func navigationSettings() {
        title = "Фильтр"
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        navigationItem.largeTitleDisplayMode = .automatic
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        self.view.layer.cornerRadius = 40
        self.view.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.view.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSettings()
        createPickerView()
        createToolbar()
        setupConst()
        searchBarConfigure()
        jsonData()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    func createPickerView()
    {
        pickerview.delegate = self
        //        pickerview.delegate?.pickerView?(pickerview, didSelectRow: 0, inComponent: 0)
        menuLoc.inputView = pickerview
        menuCat.inputView = pickerview
        menuPod.inputView = pickerview
        
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
        menuLoc.inputAccessoryView = toolbar
        menuCat.inputAccessoryView = toolbar
        menuPod.inputAccessoryView = toolbar
        
    }
    func searchBarConfigure() {
        searchBar.searchBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        searchBar.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
//        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Найти"
        searchBar.searchBar.tintColor = .black
        searchBar.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        navigationItem.searchController = searchBar
        if let bg = self.searchTextField?.subviews.first {
            bg.backgroundColor = .white
            bg.layer.cornerRadius = 10
            bg.clipsToBounds = true
        }
    }
    @objc func textfieldChanged(sender:UITextField) {
        if sender == menuPod {
            isPodPicker = true
            isCatPicker = false
            isCityPicker = false
        } else if sender == menuCat {
            isPodPicker = false
            isCatPicker = true
            isCityPicker = false
        } else {
            isPodPicker = false
            isCatPicker = false
            isCityPicker = true
        }
    }
    @objc func doneClick() {
        view.endEditing(true)
    }
    @objc func cancelClick() {
        view.endEditing(true)
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

    @objc func buttonAction() {
        guard let city = menuLoc.text else {return}
        dismiss(animated: true) {
            self.showLoader()
            self.delegate?.filterPartner(city: city, catID: self.subcatId)
        }
    }
    
}
extension FilterMenuViewController:UIPickerViewDelegate,UIPickerViewDataSource {
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
            menuLoc.text = city[row]
        } else if isCatPicker {
            menuCat.text = category[row].name
            Networking.getCategory(url: Constans().category, id: category[row].id) { (category, id) in
                self.podCategory = category
                self.menuPod.text = self.podCategory[0].name
                self.subcatId = self.podCategory[0].id
            }
        } else {
            menuPod.text = podCategory[row].name
            subcatId = podCategory[row].id
        }
        
    }
}

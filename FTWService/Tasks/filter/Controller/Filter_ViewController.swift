//
//  Filter_TableViewController.swift
//  resources
//
//  Created by MacOs User on 6/4/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
protocol filterCategoryDelegate {
    func filterCategory(array:[FilterModel])
    func filterCity(city:String)
}
class Filter_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    //let urlArray = [url39,url63]
    let array = ["Категории","Город","Оплата картой","Бизнес-задания"]
    let images = ["all","point","card","work"]
    let ditail = ["Все категории","Алматы","Через Сделку без риска","Безналичная оплата"]
    var categoryIds = [Int]()
    var category = [Category]()
    var In_Data_Cell = [[Category]]()
    var categories = [Category]()
    var cityName = "Алматы"
    var delegate:filterCategoryDelegate?
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 45
            cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Фильтры"
        Networking.getCategory(url: url,id: 0) { (category, id) in
            self.category = category
            self.categoryIds = id
            print(self.categoryIds)
        }
        tableview.separatorColor = Data_Colors.Background_Color
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        tableview.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.barTintColor =  #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.applyGradient(colors: [#colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1),#colorLiteral(red: 0.03137254902, green: 0.5254901961, blue: 0.2392156863, alpha: 1)])
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Categories", for: indexPath) as! Filter_TableViewCell
            cell.Ditail.text = array[indexPath.row]
            cell.Title.text = ditail[indexPath.row]
            cell.Image_Main.image = UIImage(named: images[indexPath.row])
            let sentImage = #imageLiteral(resourceName: "right")
            let sentImageView = UIImageView(image: sentImage.maskWithColor(color: #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)))
            sentImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            cell.accessoryView = sentImageView
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Categories", for: indexPath) as! Filter_TableViewCell
            cell.Ditail.text = array[indexPath.row]
            cell.Title.text = cityName
            cell.Image_Main.image = UIImage(named: images[indexPath.row])
            let sentImage = #imageLiteral(resourceName: "right")
            let sentImageView = UIImageView(image: sentImage.maskWithColor(color: #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)))
            sentImageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            cell.accessoryView = sentImageView
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnCheck", for: indexPath) as! SwitchFilter_TableViewCell
            cell.Title.text = array[indexPath.row-1]
            cell.Ditail.text = ditail[indexPath.row-1]
            cell.Main_Image.image = UIImage(named: images[indexPath.row-1])
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnCheck", for: indexPath) as! SwitchFilter_TableViewCell
            cell.Title.text = array[indexPath.row-1]
            cell.Ditail.text = ditail[indexPath.row-1]
            cell.Main_Image.image = UIImage(named: images[indexPath.row-1])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Space_Cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row{
        case 0:
            return 80.0
        case 1:
            return 80.0
        case 3:
            return 80.0
        case 4:
            return 80.0
        default:
            return 10.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            PassData.dataOfCity = ""
            let viewController = NewFilterViewController()
            viewController.Data_Title = "Категории"
            viewController.Data_Fierst_Cell = "Все категории"
            viewController.Data_Cell = category
            viewController.Data_In_Cell = categories
            viewController.Filter = true
            self.show(viewController, sender: self)

        case 1:
            let viewController = City_ViewController()
            viewController.Title_Date = array[indexPath.row-1]
            viewController.callback = { result in
                self.cityName = result
                self.tableview.reloadData()
            }
            self.show(viewController, sender: self)
            
        default:
            if let cell : SwitchFilter_TableViewCell = tableView.cellForRow(at: indexPath) as? SwitchFilter_TableViewCell {
                //                label.text = Switch_main.isOn ? "UISwitch is ON" : "UISwitch is OFF"
                cell.Switch_main.setOn(!cell.Switch_main.isOn, animated: true)
                let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                selectionFeedbackGenerator.selectionChanged()
            }
            break
        }
    }
    @IBAction func cleanButtonPressed(_ sender: Any) {
        SaveDateFromFilter.shared.arrayForSaveAllFilterValue.removeAll()
        PassData.dataOfCity = ""
        cityName = "Алматы"
        tableview.reloadData()
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        let array = SaveDateFromFilter.shared.arrayForSaveAllFilterValue
        print(PassData.dataOfCity)
        if PassData.dataOfCity != "" {
            delegate?.filterCity(city: PassData.dataOfCity)
        } else {
            delegate?.filterCategory(array: array)
        }
       
        navigationController?.popViewController(animated: true)
        SaveDateFromFilter.shared.arrayForSaveAllFilterValue.removeAll()
    }
}


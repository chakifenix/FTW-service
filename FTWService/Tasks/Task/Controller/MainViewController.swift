//
//  MainViewController.swift
//  resources
//
//  Created by Magzhan Imangazin on 10/22/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Shimmer
import Alamofire

class MainViewController: UIViewController,getPodCategory {
    static let shared = MainViewController()
    func getMainTaskfromAllCategory() {
        page = 1
        filterBool = false
        searchBool = false
        fillerByCategories = false
        mainTaskBool = false
        filterCity(city: city)
    }
    
    func getPodCategory(id: Int) {
        page = 1
        filterID = id
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts,
            let str = String(utf8String: rusTextt.cString(using: .utf8)!)
            else {return}
        Networking.getFilterTask(url: Constans().filter_Cat_Id, continueUrl: "&catid[]=\(String(id))&citycat=\(str)&requestscat=no&page=1") { (task,err)  in
            guard let filterarray = task else {
                self.filterBool = true
                self.searchBool = false
                self.fillerByCategories = false
                self.mainTaskBool = false
                self.All_Resources = []
                self.AddButton_ON = false
                self.mainTableview.reloadData()
                return
            }
            self.filterBool = true
            self.searchBool = false
            self.fillerByCategories = false
            self.mainTaskBool = false
            self.All_Resources = filterarray
            self.AddButton_ON = filterarray.count<5 ? false : true
            self.mainTableview.reloadData()
        }
    }

    let mainTableview: UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        view.register(CategoryCollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell1")
        view.register(MainTaskCell.self, forCellReuseIdentifier: "MainTask")
        view.register(activityIndicatorCell.self, forCellReuseIdentifier: "refreshCell")
        view.separatorStyle = .none
        return view
    }()
    private var seacrhBarIsEmpty:Bool {
        guard let text = searchBar.searchBar.text else {return false}
        return text.isEmpty
    }
    var isSearchFilter:Bool {
        return searchBar.isActive && !seacrhBarIsEmpty
    }
    
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
    lazy var refresher : UIRefreshControl = {
        let refreshe_Control = UIRefreshControl()
        refreshe_Control.tintColor = Data_Colors.gradientColor
        refreshe_Control.addTarget(self, action:#selector(ResourcesData), for: .valueChanged)
        return refreshe_Control
    }()
    private var shimmer:FBShimmeringView!
    private let shimmerTable:UITableView = {
        let view = UITableView()
        view.isUserInteractionEnabled = false
        return view
    }()
    private let shimmerViews: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return view
    }()
    private let collectionTaskShimmer:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isUserInteractionEnabled = false
        return collection
    }()
    
    private let collectionImageShimmer: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isUserInteractionEnabled = false
        return collection
    }()
    var filterID:Int?
    var flag:Bool?
    var searchText:String?
    var page = 1
    var category = [Category]()
    var podCategory = [Category]()
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var All_Resources: [MainTask] = [] // for all
    var AddButton_ON = false
    var fatchingMore = false
    var filterBool = false
    var searchBool = false
    var fillerByCategories = false
    var mainTaskBool = false
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    var city = "Алматы"
    var cityArray = ["Душанбе","Алматы","Бишкек","Ташкент"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        SettingShimmerView()
        createViews()
        Start_Data()
        setUpMenuButton()
        cleanData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flag = false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    func createViews() {
        searchBarConfigure()
        //        searchBarConstants()
        mainTableview.delegate = self
        mainTableview.dataSource = self
        mainTableview.isHidden = true
        self.view.addSubview(mainTableview)
        mainTableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalToSuperview().offset(-(UIViewController.tabbarHeight))
        }
        
    }
    func SettingShimmerView() {
        shimmerViews.isHidden = false
        shimmerTable.delegate = self
        shimmerTable.dataSource = self
        collectionTaskShimmer.dataSource = self
        collectionTaskShimmer.delegate = self
        collectionImageShimmer.dataSource = self
        collectionImageShimmer.delegate = self
        
        shimmerTable.backgroundColor = .clear
        shimmerTable.separatorStyle = .none
        collectionImageShimmer.register(ShimmerCollectionViewCell.self, forCellWithReuseIdentifier: "shimmerImage")
        collectionTaskShimmer.register(ShimmerCollectionViewCell.self, forCellWithReuseIdentifier: "shimmerLabel")
        shimmerTable.register(AllTaskShimmerCell.self, forCellReuseIdentifier: "MainTaskShimmer")
        
        shimmer = FBShimmeringView(frame: shimmerViews.frame)
        self.view.addSubview(shimmerViews)
        self.view.addSubview(shimmer)
        shimmer.contentView = shimmerViews
        shimmerViews.addSubview(shimmerTable)
        shimmerViews.addSubview(collectionImageShimmer)
        shimmerViews.addSubview(collectionTaskShimmer)
        
        shimmerViews.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerViews)
        }
        collectionTaskShimmer.snp.makeConstraints { (make) in
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            make.top.equalTo(shimmerViews.snp.top).offset(topBarHeight)
            make.left.equalTo(shimmerViews.snp.left)
            make.right.equalTo(shimmerViews.snp.right)
            make.height.equalTo(shimmerViews.snp.height).multipliedBy(0.08)
        }
        collectionImageShimmer.snp.makeConstraints { (make) in
            make.top.equalTo(collectionTaskShimmer.snp.bottom)
            make.left.equalTo(shimmerViews.snp.left)
            make.right.equalTo(shimmerViews.snp.right)
            make.height.equalTo(shimmerViews.snp.height).multipliedBy(0.2)
        }
        shimmerTable.snp.makeConstraints { (make) in
            make.top.equalTo(collectionImageShimmer.snp.bottom)
            make.left.equalTo(shimmerViews.snp.left).offset(24)
            make.right.equalTo(shimmerViews.snp.right).offset(-24)
            make.bottom.equalTo(shimmerViews.snp.bottom)
        }
        shimmer.isShimmering = true
    }
    func searchBarConfigure() {
        navigationItem.title = "Найти задания"
        navigationController?.navigationBar.prefersLargeTitles = false
        mainTableview.refreshControl = refresher
        mainTableview.refreshControl?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        self.extendedLayoutIncludesOpaqueBars = true
        mainTableview.tableHeaderView?.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        searchBar.searchBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        searchBar.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Найти задания"
        searchBar.searchBar.tintColor = .black
        searchBar.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        mainTableview.tableHeaderView = searchBar.searchBar
        if let bg = self.searchTextField?.subviews.first {
            bg.backgroundColor = .white
            bg.layer.cornerRadius = 10
            bg.clipsToBounds = true
        }
    }
    func setUpMenuButton(){
        let filterImage = image(with:  UIImage(named: "filterImage"), scaledTo: CGSize(width: 24, height: 24))
        let filterItem = UIBarButtonItem(image: filterImage!, style: .done, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = filterItem
        
    }
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    //MARK: START_DATA_METHOD V78G5e3
    func Start_Data() -> Void {
        cityArray.forEach { (city) in
            if city == Constans.shared.userCity {
                self.city = Constans.shared.userCity!
            }
        }
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts,
            let str = String(utf8String: rusTextt.cString(using: .utf8)!)
            else {return}
        Networking.getMainTasks(url: Constans().cityUrl, continueUrl: str) { (task, err) in
            guard let resource = task else {
                self.All_Resources = []
                self.AddButton_ON = false
                self.shimmer.isShimmering = false
                self.shimmer.isHidden = true
                self.shimmerViews.isHidden = true
                self.mainTableview.isHidden = false
                self.mainTableview.reloadData()
                return
            }
            self.All_Resources = resource
            self.AddButton_ON = self.All_Resources.count < 5 ? false : true
            DispatchQueue.main.async {
                self.shimmer.isShimmering = false
                self.shimmer.isHidden = true
                self.shimmerViews.isHidden = true
                self.mainTableview.isHidden = false
                self.mainTableview.reloadData()
            }
        }
    }
    
    func taskUpdate() -> Void {
        self.page = 1
        Networking.getMainTasks(url: Constans().Get_Data, continueUrl: "&page=1") { (task,err)  in
            guard let resource = task else {
                self.All_Resources = []
                self.AddButton_ON = self.All_Resources.count<5 ? false : true
                self.mainTableview.reloadData()
                return
            }
            self.All_Resources = resource
            self.AddButton_ON = self.All_Resources.count<5 ? false : true
            self.mainTableview.reloadData()
        }
    }
    func tasksAdd() -> Void {
        if filterBool {
            let addUrl = String(filterID!) + "&page=\(page)"
            Networking.getFilterTask(url: Constans().filter_Cat_Id, continueUrl: addUrl) { (task,err)  in
                guard let resource = task else {
                    self.AddButton_ON = false
                    self.mainTableview.reloadData()
                    
                    return
                }
                self.filterBool = true
                self.AddButton_ON = resource.count<5 ? false : true
                self.All_Resources += resource
                self.mainTableview.reloadData()
                
            }
        } else if searchBool {
            let addUrl = searchText! + "&page=\(page)"
            Networking.getMainTasks(url: Constans().searchUrl, continueUrl: addUrl) { (task, err) in
                guard let resource = task else {
                    return
                }
                self.searchBool = true
                self.AddButton_ON = resource.count<5 ? false : true
                self.All_Resources += resource
                self.mainTableview.reloadData()
                
            }
            
        } else if fillerByCategories {
            let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            guard let rusTextt = encodedTexts,let str = String(utf8String: rusTextt.cString(using: .utf8)!) else {return}
            Networking.getFilterTask(url: Constans().filter_Cat_Id, continueUrl: "\(filterContinueUrl)&citycat=\(str)&requestscat=no&page=\(page)") { (task, err) in
                guard let resource = task else {return}
                self.fillerByCategories = true
                self.AddButton_ON = resource.count < 5 ? false : true
                self.All_Resources += resource
                self.mainTableview.reloadData()
            }
        }else if mainTaskBool{
            
            Networking.getMainTasks(url: Constans().Get_Data, continueUrl: "&page=\(page)") { (task,err)  in
                guard let resource = task else {
                    self.AddButton_ON = false
                    self.mainTableview.reloadData()
                    return
                }
                self.AddButton_ON = resource.count<5 ? false : true
                self.All_Resources += resource
                self.mainTableview.reloadData()
                
            }
        }else {
            taskAddforCity(city: city)
            //            Networking.getMainTasks(url: Constans().Get_Data, continueUrl: "&page=\(page)") { (task,err)  in
            //                guard let resource = task else {
            //                    self.AddButton_ON = false
            //                    return
            //                }
            //                self.AddButton_ON = resource.count<5 ? false : true
            //                self.All_Resources += resource
            //                self.mainTableview.reloadData()
            //            }
        }
    }
    func taskAddforCity(city:String) {
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts else {return}
        let str = String(utf8String: rusTextt.cString(using: .utf8)!)
        Networking.getMainTasks(url: Constans().cityUrl, continueUrl:"\(str!)&page=\(page)"){ (task, err) in
            guard let resource = task else {
                self.AddButton_ON = false
                self.mainTableview.reloadData()
                return
            }
            self.All_Resources += resource
            self.AddButton_ON = self.All_Resources.count < 5 ? false : true
            self.mainTableview.reloadData()
            
        }
    }
    func beginBatchFatch() -> Void {
        
        fatchingMore = true
        self.page += 1
        //        self.tableview.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.tasksAdd()
            self.fatchingMore = false
        })
        
    }
    func cleanData() -> Void {
        PassData.category = ""
        PassData.podCategory = ""
        PassData.createTask = ""
        PassData.location = ""
        PassData.startdayTask = ""
        PassData.finishdayTask = ""
        PassData.cashTask = ""
        PassData.wtasker = ""
        PassData.selectedIndexDay = ""
        PassData.exactDay = ""
        PassData.podCategorID = ""
    }
    @objc func filterAction() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Filter_VC") as! Filter_ViewController
        vc.delegate = self
        vc.cityName = city
        self.show(vc, sender: self)
    }
    @objc func ResourcesData() {
        self.filterCity(city: city)
        if CheckInternet.Connection(){
            mainTableview.reloadData()
        }else{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "internet") as? InternetConnectionViewController {
                self.present(viewController,animated: true)
                
            }
        }
        let deadline = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            self.refresher.endRefreshing()
            
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

extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTaskShimmer {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shimmerLabel", for: indexPath) as! ShimmerCollectionViewCell
            cell.imageView.isHidden = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shimmerImage", for: indexPath) as! ShimmerCollectionViewCell
            cell.labelView.isHidden = true
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTaskShimmer {
            return CGSize(width: collectionView.frame.size.width * 0.33, height: collectionView.frame.size.height*0.5)
        } else {
            return CGSize(width: collectionView.frame.size.width * 0.7, height: collectionView.frame.size.height * 0.8)
        }
    }
    
}
extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mainTableview {
            return 3
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableview {
            if section == 1 {
                if All_Resources.count == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                        tableView.setEmptyViewWithOffset(name: "photo", message: "Ничего не найдено")
                    })
                } else {
                    tableView.restoreView()
                }
                return All_Resources.count
                
            }
            else {
                return 1
            }
            
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == shimmerTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTaskShimmer", for: indexPath) as! AllTaskShimmerCell
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell1", for: indexPath) as! CategoryCollectionTableViewCell
                cell.delegate = self
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainTask", for: indexPath) as! MainTaskCell
                cell.selectionStyle = .none
                var resource: MainTask!
                resource = All_Resources[indexPath.row]
                cell.Category.text = resource.sub_cat_name
                cell.Title.text = resource.task
                if resource.amount == "Предложите цену" {
                    cell.LabelPrice.text = resource.amount
                } else {
                    guard let current = resource.current else {
                        return cell
                    }
                    cell.LabelPrice.text = "\(resource.amount!) \(current)"
                }
                cell.cityLabel.text = resource.city
                if resource.cdate == nil && resource.work_with == nil{
                    cell.Time.text = resource.cdate_l
                } else if resource.cdate == nil  && resource.cdate_l == nil {
                    cell.Time.text = "Дата по договоренности"
                }
                else if resource.cdate_l == nil && resource.work_with == nil && resource.edate != nil {
                    cell.Time.text = "с \(resource.cdate!) - до \(resource.edate!)"
                }
                else if resource.cdate == nil  && resource.cdate_l == nil && resource.edate == nil {
                    cell.Time.text = "c \(resource.cdate!)"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "refreshCell") as! activityIndicatorCell
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = .clear
                if AddButton_ON {
                    cell.refresh.isHidden = false
                    cell.refresh.beginRefreshing()
                } else {
                    cell.refresh.isHidden = true
                    tableView.estimatedRowHeight = 200.0
                    //                        self.mainTableview.isScrollEnabled = false
                }
                //                    if PassData.isIndicatorHidden {
                //                        cell.Refresh.isHidden = true
                //                    } else {
                //                        cell.Refresh.beginRefreshing()
                //                        cell.Refresh.isHidden = false
                //                    }
                return cell
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if flag != nil {
                if flag! {return}
                flag = true
                let viewController = IDTaskViewController()
                viewController.modalPresentationStyle = .fullScreen
                let cell = tableView.cellForRow(at: indexPath) as! MainTaskCell
                var resource: MainTask!
                resource = All_Resources[indexPath.row]
                let index = resource.id
                viewController.hidesBottomBarWhenPushed = true
                viewController.index = index
                viewController.navigationItem.largeTitleDisplayMode = .never
                viewController.title = "Задания №\(resource.id!)"
                viewController.amount = cell.LabelPrice.text ?? "нет данных"
                viewController.Title = resource.task ?? "нет данных"
                viewController.dateT = cell.Time.text ?? "нет данных"
                viewController.taskIndex = resource.id!
                viewController.taskId = String(resource.id!)
                PassData.taskId = String(resource.id!)
                viewController.callbackDelete = { result in
                    self.Start_Data()
                }
                self.show(viewController, sender: self)
            }
        } else if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! CategoryCollectionTableViewCell
            cell.selectionStyle = .none
        } else {
            if AddButton_ON {
                let cell = tableView.cellForRow(at: indexPath) as! activityIndicatorCell
                cell.isUserInteractionEnabled = false
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
                cell.isUserInteractionEnabled = false
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTableview {
            if indexPath.section == 0 {
                let height = 200
                return CGFloat(height)
            } else if indexPath.section == 1 {
                return 138
            } else {
                return 50
            }
        } else {
            return 140
        }
    }
    
}
extension MainViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        self.page = 1
        let text = searchController.searchBar.text!
        let encodedTexts = text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts else {return}
        searchText = String(utf8String: rusTextt.cString(using: .utf8)!)
        Networking.getMainTasks(url: Constans().searchUrl, continueUrl: searchText!) { (task, err) in
            guard let resource = task else {
                self.searchBool = true
                self.filterBool = false
                self.fillerByCategories = false
                self.mainTaskBool = false
                self.All_Resources = []
                self.AddButton_ON = false
                self.mainTableview.reloadData()
                return
            }
            self.searchBool = true
            self.filterBool = false
            self.fillerByCategories = false
            self.mainTaskBool = false
            self.All_Resources = resource
            self.AddButton_ON = self.All_Resources.count<5 ? false : true
            self.mainTableview.reloadData()
        }
    }
}
extension MainViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height{
            if !fatchingMore && AddButton_ON{
                beginBatchFatch()
            }
        }
        
    }
}
var filterContinueUrl = ""
extension MainViewController:filterCategoryDelegate {
    func filterCity(city: String){
        self.page = 1
        self.city = city
        if city == "Все" {
            self.mainTaskBool = true
            self.searchBool = false
            self.filterBool = false
            self.fillerByCategories = false
            taskUpdate()
            self.mainTableview.reloadData()
            
        }else{
            let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            guard let rusTextt = encodedTexts else {return}
            let str = String(utf8String: rusTextt.cString(using: .utf8)!)
            Networking.getMainTasks(url: Constans().cityUrl, continueUrl: str!){ (task, err) in
                guard let resource = task else {
                    self.All_Resources = []
                    self.AddButton_ON = false
                    self.mainTaskBool = false
                    self.searchBool = false
                    self.filterBool = false
                    self.fillerByCategories = false
                    self.mainTableview.reloadData()
                    return
                }
                self.mainTaskBool = false
                self.searchBool = false
                self.filterBool = false
                self.fillerByCategories = false
                self.All_Resources = resource
                self.AddButton_ON = self.All_Resources.count < 5 ? false : true
                self.mainTableview.reloadData()
                
            }
        }
    }
    
    func filterCategory(array: [FilterModel]) {
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts,let str = String(utf8String: rusTextt.cString(using: .utf8)!) else {return}
        self.page = 1
        for item in array {
            filterContinueUrl = filterContinueUrl + "&catid[]=\(item.inFilterModel.category.id)"
        }
        Networking.getFilterTask(url: Constans().filter_Cat_Id, continueUrl: "\(filterContinueUrl)&citycat=\(str)&requestscat=no&page=1") { (task, err) in
            guard let resource = task else {return}
            self.fillerByCategories = true
            self.All_Resources = resource
            self.AddButton_ON = self.All_Resources.count < 5 ? false : true
            self.mainTableview.reloadData()
        }
        filterContinueUrl = ""
    }
}



//
//  MyTaskTableViewController.swift
//  resources
//
//  Created by MacOs User on 7/24/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import Alamofire
import Shimmer
import JTMaterialSpinner
class MyTaskTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var AllID_Resources: [MainTask] = []
    let url = "https://orzu.org/public/tasks/view/"
    let taskUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_task&tasks="
    let indicator = JTMaterialSpinner()
    @IBOutlet var tableview: UITableView!
    var flag: Bool?
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
    lazy var refresher : UIRefreshControl = {
        let refreshe_Control = UIRefreshControl()
        refreshe_Control.tintColor = Data_Colors.gradientColor
        refreshe_Control.addTarget(self, action:#selector(ResourcesData), for: .valueChanged)
        return refreshe_Control
    }()
    var AddButton_ON = false
    var fatchingMore = false
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        shimmerEffect()
        tableview.restoreView()
        tableview.isHidden = true
        tableview.refreshControl = refresher
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -(UIViewController.tabbarHeight)).isActive = true
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        flag = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        getTask(id: Constans().userid)
        configureIndicator()
    }
    
    func configureIndicator() {
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = view.center
        self.view.addSubview(indicator)
        indicator.isHidden = true
        indicator.beginRefreshing()
        indicator.circleLayer.lineWidth = 4.0
        indicator.circleLayer.strokeColor = Constans().blue.cgColor
        indicator.animationDuration = 1.5
    }
    func shimmerEffect() {
        shimmerViews.isHidden = false
        shimmerTable.delegate = self
        shimmerTable.dataSource = self
        shimmerTable.backgroundColor = .clear
        shimmerTable.separatorStyle = .none
        shimmerTable.register(AllTaskShimmerCell.self, forCellReuseIdentifier: "MyTaskShimmer")
        
        shimmer = FBShimmeringView(frame: shimmerViews.frame)
        self.view.addSubview(shimmerViews)
        self.view.addSubview(shimmer)
        shimmer.contentView = shimmerViews
        shimmerViews.addSubview(shimmerTable)
        
        shimmerViews.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerViews)
        }
        shimmerTable.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerViews.snp.top)
            make.left.equalTo(shimmerViews.snp.left).offset(16)
            make.right.equalTo(shimmerViews.snp.right).offset(-16)
            make.bottom.equalTo(shimmerViews.snp.bottom)
        }
        shimmer.isShimmering = true
    }
    // MARK: - Table view data source
    
    func getTask(id:Int) -> Void {
        Networking.getMainTasks(url: Constans().id_Data, continueUrl: "&userid=\(id)&page=\(1)") { (task,err)  in
            guard let resource = task else {
                self.AllID_Resources = []
                self.AddButton_ON = self.AllID_Resources.count<5 ? false : true
                self.shimmer.isShimmering = false
                self.shimmer.isHidden = true
                self.shimmerViews.isHidden = true
                self.tableview.isHidden = false
                self.tableview.reloadData()
                return
            }
            self.AllID_Resources = resource
            self.AddButton_ON = self.AllID_Resources.count<5 ? false : true
            self.shimmer.isShimmering = false
            self.shimmer.isHidden = true
            self.shimmerViews.isHidden = true
            self.tableview.isHidden = false
            self.tableview.reloadData()
        }
    }
    func taskUpdate(id:Int) -> Void {
        Networking.getMainTasks(url: Constans().id_Data, continueUrl: "&userid=\(id)&page=\(1)") { (task,err)  in
            guard let resource = task else {
                self.AllID_Resources = []
                self.AddButton_ON = self.AllID_Resources.count<5 ? false : true
                self.tableview.reloadData()
                return
            }
            self.AllID_Resources = resource
            self.AddButton_ON = self.AllID_Resources.count<5 ? false : true
            self.tableview.reloadData()
        }
    }
    func tasksAdd(id:Int) -> Void {
        Networking.getMainTasks(url: Constans().id_Data, continueUrl: "&userid=\(id)&page=\(page)") { (task,err)  in
            guard let resource = task else {
                self.AddButton_ON = false
                return
            }
            self.AddButton_ON = resource.count<5 ? false : true
            self.AllID_Resources += resource
            self.tableview.reloadData()
        }
    }
    func beginBatchFatch() -> Void {
        
        fatchingMore = true
        self.page += 1
        //        self.tableview.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            let loginId = UserDefaults.standard.integer(forKey: "ID")
            self.tasksAdd(id: loginId)
            self.fatchingMore = false
        })
        
    }
    @objc func ResourcesData() {
        let loginId = UserDefaults.standard.integer(forKey: "ID")
        self.taskUpdate(id: loginId)
        if CheckInternet.Connection(){
            tableview.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            if AllID_Resources.count == 0 {
                tableView.setEmptyView(name: "photo", message: "Вы пока не создали")
            } else {
                tableView.restoreView()
            }
            return AllID_Resources.count
        } else {
            return 10
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Task_Cell") as! TaskCell
            let resource: MainTask = AllID_Resources[indexPath.row]
            cell.Сategory.text = resource.sub_cat_name
            cell.Title.text = resource.task
            cell.LabelPrice.text = resource.amount
            if resource.cdate == nil && resource.work_with == nil{
                cell.Time.text = resource.cdate_l
            } else if resource.cdate == nil  && resource.cdate_l == nil {
                cell.Time.text = "Дата по договоренности"
            }
            else if resource.cdate_l == nil && resource.work_with == nil && resource.edate != nil {
                cell.Time.text = "с \(resource.cdate!) - до \(resource.edate!)"
            }
            else if resource.cdate == nil  && resource.cdate_l == nil && resource.edate == nil {
                cell.Time.text = "Начать \(resource.cdate!)"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyTaskShimmer") as! AllTaskShimmerCell
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isTouched = flag {
            if flag! {return}
            flag = true
            let viewController = IDTaskViewController()
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            let resource: MainTask = AllID_Resources[indexPath.row]
            let index = resource.id
            _ = resource.task
            viewController.index = index
            viewController.callbackDelete = { result in
                let userId = UserDefaults.standard.integer(forKey: "ID")
                self.getTask(id:userId)
                self.tableview.reloadData()
            }
            viewController.dateT = cell.Time.text!
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.largeTitleDisplayMode = .never
            viewController.title = "Задания №\(resource.id!)"
            viewController.amount = cell.LabelPrice.text!
            viewController.Title = resource.task!
            viewController.taskId = String(resource.id!)
            viewController.isTask = "myTask"
            self.show(viewController, sender: self)

        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    
    
}

extension MyTaskTableViewController:UIScrollViewDelegate {
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

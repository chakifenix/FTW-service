//
//  SecondContainerVC.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 1/22/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit
import SideMenu
class SecondContainerVC: UIViewController {
    
    private var partnerArray = [Partners]()
    
    let tableview: UITableView = {
        let view = UITableView()
        view.register(OurPartnersViewCell.self, forCellReuseIdentifier: "cellOur")
        view.register(CellForHeaderCell.self, forCellReuseIdentifier: "cellForHeader")
        view.register(SwipeCollectionViewController.self, forCellReuseIdentifier: "swipeCollection")
        view.register(TextPartnersVipTableViewCell.self, forCellReuseIdentifier: "programPartnersText")
        view.separatorStyle = .none
        view.layer.cornerRadius = 45
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 45
        self.tableview.delegate = self
        self.tableview.dataSource = self
        getParseJson()
        
        self.view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func getParseJson(){
        Networking.getPartners(url: Constans().partnerList) { (data) in
        guard let result = data else {return}
        self.partnerArray = result
        self.tableview.reloadData()
        }
    }
    
        func sideMenuConfigure(_ viewcontroller:UIViewController) {
            SideMenuManager.default.menuPresentMode = .menuSlideIn
            let rightMenuNavigationController = UISideMenuNavigationController(rootViewController: viewcontroller)
            rightMenuNavigationController.menuWidth = 275
            SideMenuManager.default.menuRightNavigationController = rightMenuNavigationController
            SideMenuManager.default.menuAnimationFadeStrength = 0.6
            SideMenuManager.default.menuShadowOpacity = 0.1
            SideMenuManager.defaultManager.menuFadeStatusBar = false
            self.present(SideMenuManager.default.menuRightNavigationController!, animated: true)
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



extension SecondContainerVC: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if partnerArray.count == 0 {
                tableView.setEmptyView(name: "photo", message: "Нет партнёров в данной категории")
            } else {
                tableView.restoreView()
            }
            return partnerArray.count+1
    }
  //  MARK: CELL FOR ROW AT TABLEVIEW

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellForHeader", for: indexPath) as! CellForHeaderCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOur", for: indexPath) as! OurPartnersViewCell
            cell.percent.text = partnerArray[indexPath.row-1].percent
            guard let images = partnerArray[indexPath.row-1].logo else{return cell}
            let urlString = "https://orzu.org/\(images)"
            cell.partnersImageView.set(imageUrl: urlString)
            cell.Title.text = partnerArray[indexPath.row-1].name
            cell.discription.text = partnerArray[indexPath.row-1].discription
            cell.selectionStyle = .none
            return cell
        }
        
        
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row != 0 {
            let vc = DetailOurPartnerViewController()
            vc.partnerItem = self.partnerArray[indexPath.row-1]
            self.show(vc, sender: self)
            }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 0{
                return 80
            }else{
                return 120
            }
        
    }



}


extension SecondContainerVC:sideMenuProtocol {
    func showSortSideMenu() {
        sideMenuConfigure(SortMenuViewController())
        
    }
    
    func showFilterSideMenu() {
        let vc = FilterMenuViewController()
        vc.delegate = self
        sideMenuConfigure(vc)
    }
    
    
}

extension SecondContainerVC:filterPartner {
    func filterPartner(city: String, catID: Int) {
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts,let str = String(utf8String: rusTextt.cString(using: .utf8)!) else{return}
        Networking.getPartners(url: Constans().sortPartners + "catid=\(catID)" + "&city=\(str)" + "&sort=DESC") { (value) in
            guard let result = value else {
                self.hideLoader()
                self.partnerArray = []
                self.tableview.reloadData()
                return
            }
            self.hideLoader()
            self.partnerArray = result
            self.tableview.reloadData()
        }
    }
    
    
}

//
//  FirstViewContainerVC.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 1/22/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class FirstViewContainerVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
        var subChanger = true
        var charbool = true
    let cellID = "cell"
     private var partnerArray = [Partners]()
//     let flowLayout = ZoomAndSnapFlowLayout()
    let imagecolllection: UICollectionView = {
        let layout = LeftedFlowLayout()
//        layout.minimumLineSpacing = 5
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.register(PodSwipeCollectionViewCell.self, forCellWithReuseIdentifier: "swipes")
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
        }()

        var bonusActivity = [BonusActivity]()
        private let triangle1: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "tran")
            //        image.alpha = 0
            return image
        }()
    
        private let triangle2: UIImageView = {
            
            let image = UIImageView()
            image.image = UIImage(named: "tran")
            image.isHidden = true
            return image
        }()
    
        let tableview: UITableView = {
            let view = UITableView()
            view.register(ChargeBonusTableViewCell.self, forCellReuseIdentifier: "cell")
    //        view.register(OurPartnersViewCell.self, forCellReuseIdentifier: "cellOur")
            view.register(QRPhotoTableViewCell.self, forCellReuseIdentifier: "qr")
            view.register(BonusTableViewCell.self, forCellReuseIdentifier: "CreateBonus")
    //        view.register(CellForHeaderCell.self, forCellReuseIdentifier: "cellForHeader")
    //        view.register(SwipeCollectionViewController.self, forCellReuseIdentifier: "swipeCollection")
            view.register(PartnersVipTableViewCell.self, forCellReuseIdentifier: "programPartners")
    //        view.register(TextPartnersVipTableViewCell.self, forCellReuseIdentifier: "programPartnersText")
            view.separatorStyle = .none
            view.layer.cornerRadius = 45
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 45
        self.imagecolllection.delegate = self
        self.imagecolllection.dataSource = self
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.imagecolllection.tag = 1
        setupSelectCategoryCollectionView()
        getJsonData()
        configureActionsCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func configureActionsCollectionView(){
        imagecolllection.showsVerticalScrollIndicator = false
        imagecolllection.showsHorizontalScrollIndicator = false
        imagecolllection.backgroundColor = .clear
        imagecolllection.decelerationRate = .fast
        imagecolllection.collectionViewLayout = LeftedFlowLayout()
    }
    private func getJsonData() {
        let id = UserDefaults.standard.integer(forKey: "ID")
        guard let url = URL(string: Constans().bonusActivity + String(id)) else {return}
        Networking.getUserBonusActivity(url: url) { (value) in
            guard let result = value else {return}
            self.bonusActivity = result
            self.tableview.reloadData()
        }
    }

//    let selectCategoryCollectionView:SelectCategoryCollectionView = {
//        let mb = SelectCategoryCollectionView()
//        return mb
//    }()
//
    
    func setupSelectCategoryCollectionView(){
        self.view.addSubview(imagecolllection)
        self.view.addSubview(tableview)
        imagecolllection.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(20)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.25)
        }
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(self.imagecolllection.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.bottom.equalTo(self.view.snp.bottom).offset(-10)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subChanger{
            return bonusActivity.count + 2
        }
        return 1
        
    }
    //MARK: CELL FOR ROW AT TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if subChanger{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "qr", for: indexPath) as! QRPhotoTableViewCell
                cell.selectionStyle = .none
                //                        cell.delegate = self
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChargeBonusTableViewCell
                cell.bonusTitleLabel.text = "Накопление бонусов:"
                cell.selectionStyle = .none
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreateBonus", for: indexPath) as! BonusTableViewCell
                cell.selectionStyle = .none
                cell.requestArray = bonusActivity[indexPath.row-2]
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "programPartners", for: indexPath) as! PartnersVipTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        if !changer{
//        //            if indexPath.row != 0 {
//        //            let vc = DetailOurPartnerViewController()
//        //            vc.partnerItem = partnerArray[indexPath.row-1]
//        //            self.show(vc, sender: self)
//        //            }
//        //        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if subChanger{
            if indexPath.row == 0{
                return 236
            }else if indexPath.row == 1{
                return 60
            } else {
                return 80
            }
        }else{
            return 180
        }
        
    }
}




//MARK : COLLECTION VIEW DELEGATE AND DATASOURCE

extension FirstViewContainerVC : UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "swipes", for: indexPath) as! PodSwipeCollectionViewCell
        cell.index = indexPath.row
        
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = RegisterBonusStep1().inNavigation()
            self.show(vc, sender: self)
        }

    }
}

//
extension FirstViewContainerVC:UIScrollViewDelegate {

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let imagecolllection = scrollView as? UICollectionView {
            
                let offsetX = scrollView.contentOffset.x
                print(offsetX,"asdfgh")
                    if subChanger{
                            if offsetX >= 213.0{
                                subChanger = false
                                if charbool{
                                    self.tableview.reloadData()
                                }
                                charbool = true
                            }
                        }else{
                            if offsetX == 0.0{
                                subChanger = true
                                if charbool{
                                    self.tableview.reloadData()
                                }
                                charbool = true
                            }
                        }
    
            
        } else{
            print("cant cast")
        }
    }
}
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offsetX = scrollView.contentOffset.x
//        let offsetY = scrollView.contentOffset.y
//        let contentWidth = scrollView.contentSize.width
//        print(offsetX)
//        if subChanger{
//                if offsetX >= 252.0{
//                    subChanger = false
////                    self.tableview.isScrollEnabled = false
//                    if charbool{
//                        self.tableview.reloadData()
//                    }
//                    charbool = true
//                }
//            }else{
//                if offsetX == 0.0{
////                    self.tableview.isScrollEnabled = true
//                    subChanger = true
//                    if charbool{
//                        self.tableview.reloadData()
//                    }
//                    charbool = true
//                }
//            }
//
//}



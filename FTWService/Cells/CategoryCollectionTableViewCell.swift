//
//  CategoryCollectionTableViewCell.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
protocol getPodCategory {
    func getPodCategory(id:Int)
    func getMainTaskfromAllCategory()
}
class CategoryCollectionTableViewCell: UITableViewCell {
    var checkerConte = true
    var podCategory = [Category]()
    var delegate:getPodCategory?
    var newIndexPath = 0
    var first: TasksCollectionViewCell?
    private var previousNumber: Int? // used in randomNumber()
    let imagecolllection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    var category = [Category]()
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    
    let collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    var isSelectedCell = false
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        jsonData()
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        collectionview.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "categorCells")
        collectionview.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "allCategor")
        self.imagecolllection.dataSource = self
        self.imagecolllection.delegate = self
        imagecolllection.register(podCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "imagecollection")
        addSubview(collectionview)
        addSubview(imagecolllection)
        collectionview.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        imagecolllection.snp.makeConstraints { (make) in
            make.top.equalTo(collectionview.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func randomNumber() -> Int {
        var randomNumber = arc4random_uniform(5)
        while previousNumber == Int(randomNumber) {
            randomNumber = arc4random_uniform(5)
        }
        previousNumber = Int(randomNumber)
        return Int(randomNumber)
    }
    func jsonData() {
        let queue = DispatchQueue(label: "CategoryQueue",attributes: .concurrent)
        queue.async {
            DataProvider.getCategoryArray(url: self.url, id: 0) { (result) in
                guard let category = result else {return}
                self.category = category
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
        queue.async {
            DataProvider.getCategoryArray(url: self.url, id: 1) { (result) in
                guard let category = result else {return}
                self.podCategory = category
                DispatchQueue.main.async {
                    self.imagecolllection.reloadData()
                }
            }
        }
        
    }
    
}
extension CategoryCollectionTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionview {
            return category.count
            
        }
        return podCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCategor", for: indexPath) as! TasksCollectionViewCell
                cell.label.text = "Все категории"
                first = cell
                if (checkerConte){
                    cell.label.textColor = Data_Colors.gradientColor
                    
                }
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorCells", for: indexPath) as! TasksCollectionViewCell
                cell.label.text = category[indexPath.row - 1].name
                
                cell.label.textColor = category[indexPath.row-1].isSelected ? Data_Colors.gradientColor : .black
                
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecollection", for: indexPath) as! podCategoryCollectionViewCell
            var imageArray: [String] = ["photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg", "photo5.jpg"]
            //imageArr is array of images
            let index = randomNumber()
            let image = UIImage.init(named: imageArray[index])
            cell.imageview.image = image
            cell.label.text = podCategory[indexPath.row].name
            return cell
        }
    }
    func checkerTrueFunc(){
        for i in 0..<category.count{
            category[i].isSelected = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                if let cell = collectionView.cellForItem(at: indexPath) as? TasksCollectionViewCell {
                    print(indexPath)
                    cell.label.textColor = Data_Colors.gradientColor
                    delegate?.getMainTaskfromAllCategory()
                    checkerConte = true
                    checkerTrueFunc()
                    self.collectionview.reloadData()
                }
            }else {
                if let cell = collectionView.cellForItem(at: indexPath) as? TasksCollectionViewCell {
                    self.imagecolllection.scrollToItem(at: [0,0], at: .right, animated: true)
                    checkerConte = false
                    checkerTrueFunc()
                    category[indexPath.row-1].isSelected = true
                    newIndexPath = indexPath.row
                    //                    category[newIndexPath].isSelected = false
                    cell.label.textColor = Data_Colors.gradientColor
                    first?.label.textColor = .black
                    isSelectedCell = true
                    let catId = category[indexPath.row - 1].id
                    self.collectionview.reloadData()
                    Networking.getCategory(url: url, id: catId) { (category, id) in
                        self.podCategory = category
                        DispatchQueue.main.async {
                            self.imagecolllection.reloadData()
                        }
                    }
                    //                    childVc.filterBool = true
                    //                    childVc.selectedResources = childVc.All_Resources
                    //                    childVc.tableview.reloadData()
                }
            }
        } else {
            let catId = podCategory[indexPath.row].id
            delegate?.getPodCategory(id: catId)
        }
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        if collectionView == collectionview {
    //            if let cell = collectionView.cellForItem(at: indexPath) as? TasksCollectionViewCell {
    ////                category[indexPath.row].isSelected = false
    ////                cell.label.textColor = .black
    ////                 self.collectionview.reloadData()
    //                DispatchQueue.main.async {
    //
    //                    self.imagecolllection.reloadData()
    //                }
    //            }
    //        }
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                let label = UILabel(frame: CGRect.zero)
                label.text = "Все категорииии"
                label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
                label.sizeToFit()
                return CGSize(width: label.frame.width, height: collectionView.frame.size.height)
            } else {
                let label = UILabel(frame: CGRect.zero)
                label.text = category[indexPath.row - 1].name
                label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 16.0)
                label.sizeToFit()
                return CGSize(width: label.frame.width, height: collectionView.frame.size.height)
            }
        } else {
            return CGSize(width: 120, height: collectionView.frame.size.height)
        }
    }
}

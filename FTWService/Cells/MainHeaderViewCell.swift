//
//  MainHeaderViewCell.swift
//  OrzuServiceProject
//
//  Created by Zhanibek Santay on 5/1/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit

class MainHeaderViewCell: UICollectionReusableView {
    
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
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    let dividerLine:UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    var category = [Category]()
    let url = "https://orzu.org/api?%20appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_cat"
    
    let collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
       setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isSelectedCell = false
    func setupLayout(){
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
        addSubview(dividerLine)
        collectionview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
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
        
        dividerLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(imagecolllection.snp.top).offset(-3)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(1)
        }
        
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
extension MainHeaderViewCell: UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionview {
            return category.count
        }
//        return podCategory.count
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCategor", for: indexPath) as! TasksCollectionViewCell
                cell.label.text = "Все категории"
                first = cell
                if (checkerConte){
                    cell.label.textColor = #colorLiteral(red: 0.2124414444, green: 0.8114148974, blue: 0.6365436912, alpha: 1)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorCells", for: indexPath) as! TasksCollectionViewCell
                cell.label.text = category[indexPath.row - 1].name
                cell.label.textColor = category[indexPath.row-1].isSelected  ? #colorLiteral(red: 0.2124414444, green: 0.8114148974, blue: 0.6365436912, alpha: 1) : .lightGray
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecollection", for: indexPath) as! podCategoryCollectionViewCell
            var imageArray = [#imageLiteral(resourceName: "category"), #imageLiteral(resourceName: "photo3"), #imageLiteral(resourceName: "photo2"), #imageLiteral(resourceName: "photo4")]
            //imageArr is array of images
            let image = imageArray[indexPath.row]
            cell.imageview.image = image
//            cell.label.text = podCategory[indexPath.row].name
            cell.label.text = "text"
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
                    cell.label.textColor = #colorLiteral(red: 0.2124414444, green: 0.8114148974, blue: 0.6365436912, alpha: 1)
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
                    cell.label.textColor = .black
                    first?.label.textColor = .lightGray
                    isSelectedCell = true
                    let catId = category[indexPath.row - 1].id
                    self.collectionview.reloadData()
                    Networking.getCategory(url: url, id: catId) { (category, id) in
                        self.podCategory = category
                        DispatchQueue.main.async {
                            self.imagecolllection.reloadData()
                        }
                    }
                }
            }
        } else {
            let catId = podCategory[indexPath.row].id
            delegate?.getPodCategory(id: catId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionview {
            if indexPath.row == 0 {
                let label = UILabel(frame: CGRect.zero)
                label.text = "Все категорииии"
                label.textColor = .black
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
            return CGSize(width: 140, height: collectionView.frame.size.height * 0.8)
        }
    }
}

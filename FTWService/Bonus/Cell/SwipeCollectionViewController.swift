//
//  SwipeCollectionViewController.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/18/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class SwipeCollectionViewController: UITableViewCell {
    

//    let flowLayout = ZoomAndSnapFlowLayout()
    
    let imagecolllection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.register(PodSwipeCollectionViewCell.self, forCellWithReuseIdentifier: "swipes")
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.imagecolllection.dataSource = self
        self.imagecolllection.delegate = self
//        self.imagecolllection.collectionViewLayout = flowLayout
        self.imagecolllection.contentInsetAdjustmentBehavior = .always
        setupConstraint()


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraint(){
        print("1")
        self.addSubview(imagecolllection)
        imagecolllection.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

 
}

extension SwipeCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "swipes", for: indexPath) as! PodSwipeCollectionViewCell
        cell.index = indexPath.row
        return cell
    }

}

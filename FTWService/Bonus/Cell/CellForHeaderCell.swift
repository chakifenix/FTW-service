//
//  CellForHeaderCell.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/12/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
protocol sideMenuProtocol {
    func showSortSideMenu()
    func showFilterSideMenu()
}
class CellForHeaderCell: UITableViewCell {
    var delegate:sideMenuProtocol?
    let label:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .lightGray
        label.text = "Вы достигли 10 000 bi, Ваши скидки активны"
        return label
    }()
    let sortButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Сортировка"), for: .normal)
        button.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        return button
    }()
    let filterButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Фильтр"), for: .normal)
        return button
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        sortButton.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        self.addSubview(label)
        addSubview(sortButton)
        addSubview(filterButton)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(sortButton.snp.left).offset(-8)
        }
        sortButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(filterButton.snp.left).offset(-16)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        filterButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        // Configure the view for the selected state
    }
    @objc func sortAction() {
       delegate?.showSortSideMenu()

    }
    @objc func filterAction() {
       delegate?.showFilterSideMenu()

    }
}

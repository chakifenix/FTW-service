//
//  QRPhotoTableViewCell.swift
//  NewTestingProject
//
//  Created by Zhanibek Santay on 12/8/19.
//  Copyright © 2019 Zhanibek Santay. All rights reserved.
//

import UIKit
import SnapKit
protocol buttonProtocol {
    func savePhoto(image:UIImage)
}
class QRPhotoTableViewCell: UITableViewCell {
    var delegate:buttonProtocol?

    let shareButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1)
        button.setTitle("Экспортировать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        //        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    let qrImage:UIImageView = {
         let imageView = UIImageView()
         return imageView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    fileprivate func setupView() {
        let swiftLeeLogo = #imageLiteral(resourceName: "mytaskNew")
        let qr = image(with: swiftLeeLogo, scaledTo: CGSize(width: 64, height: 64))
        let qrURLImage = URL(string: "https://www.orzu.org")?.qrImage(using: .black, logo: qr)
        qrImage.image = UIImage(ciImage: qrURLImage!)
        backgroundColor = .clear
        addSubview(qrImage)
        addSubview(shareButton)
        qrImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 170, height: 170))
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.qrImage.snp.bottom).offset(18)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(28)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)

        setupView()
    }
    
    @objc func shareAction() {

        delegate?.savePhoto(image: qrImage.image!)
      
    }
    
    
  
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

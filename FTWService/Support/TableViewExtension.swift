//
//  TableViewExtension.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import SVProgressHUD
extension UITableView {
    func setEmptyView(name: String,message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageview = UIImageView()
        let messageLabel = UILabel()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.font = UIFont.systemFont(ofSize: CGFloat(25))
        emptyView.addSubview(imageview)
        emptyView.addSubview(messageLabel)
        imageview.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 128).isActive = true
        messageLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        imageview.image = UIImage(named: name)
        self.backgroundView = emptyView
    }
    func setLabel(text:String) {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        self.backgroundView = label
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    func setEmptyViewWithOffset(name: String,message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageview = UIImageView()
        let messageLabel = UILabel()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.font = UIFont.systemFont(ofSize: CGFloat(25))
        emptyView.addSubview(imageview)
        emptyView.addSubview(messageLabel)
        imageview.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor,constant: 32).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 128).isActive = true
        messageLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        imageview.image = UIImage(named: name)
        self.backgroundView = emptyView
    }
    func restoreView() {
        self.backgroundView?.isHidden = true
    }
}
extension UICollectionView {
    func setLabel(text:String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let label = UILabel()
//        label.center = self.center
        label.textColor = .lightGray
        label.text = text
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 19.0)
        emptyView.addSubview(label)
        self.backgroundView = emptyView
        label.snp.makeConstraints { (make) in
               make.top.equalTo(emptyView.snp.top).offset(16)
               make.centerX.equalTo(emptyView.snp.centerX)
    }
    }
    func restoreView() {
           self.backgroundView?.isHidden = true
       }
}
//extension UIViewController {
//
//    func presentDetail(_ viewControllerToPresent: UINavigationController) {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//
//        present(viewControllerToPresent, animated: true)
//}
//}
extension UIImage {
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
extension UIViewController {
    static let navBarHeight = UINavigationController().navigationBar.bounds.height
    static let tabbarHeight = UITabBarController().tabBar.bounds.height
    func getStatusBarFrame() -> CGRect {
        var statusBarFrame: CGRect
        
        if #available(iOS 13.0, *) {
            statusBarFrame = UIApplication.shared.statusBarFrame
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        return statusBarFrame
    }
    func showLoader() {
        SVProgressHUD.setBorderColor(Data_Colors.mainColor)
        SVProgressHUD.setBorderWidth(0.8)
        SVProgressHUD.setForegroundColor(Data_Colors.mainColor)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.show()
    }
    
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
    func showErrorMessage(_ message: String) {
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.setBorderWidth(0.8)
        SVProgressHUD.setForegroundColor(Data_Colors.mainColor)
        SVProgressHUD.setBorderColor(Data_Colors.mainColor)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.dismiss(withDelay: 1)
    }
    func showErrorMessageWithBlock(message: String,completion:@escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.setBorderWidth(0.8)
        SVProgressHUD.setForegroundColor(Data_Colors.mainColor)
        SVProgressHUD.setBorderColor(Data_Colors.mainColor)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.dismiss(withDelay: 1,completion: completion)
    }
    func showSuccess(_ text: String) {
        SVProgressHUD.showSuccess(withStatus: text)
        SVProgressHUD.setBorderWidth(0.8)
        SVProgressHUD.setForegroundColor(Data_Colors.mainColor)
        SVProgressHUD.setBorderColor(Data_Colors.mainColor)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.dismiss(withDelay: 1)
    }
    func showAlert(text:String,completion:@escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.showSuccess(withStatus: text)
        SVProgressHUD.setBorderWidth(0.8)
        SVProgressHUD.setForegroundColor(Data_Colors.mainColor)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setBorderColor(Data_Colors.mainColor)
        SVProgressHUD.dismiss(withDelay: 1, completion: completion)
        
    }
    func showAlertAction(title:String?,message:String,titleOk:String,cancelTitle:String,completion:@escaping(UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: titleOk, style: .default, handler: completion)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        let messageFont = [kCTFontAttributeName: UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont as [NSAttributedString.Key : Any])
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func hidesKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismisskeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismisskeyboard() {
        view.endEditing(true)
    }
    func inNavigation() -> UIViewController {
        return UINavigationController(rootViewController: self)
    }
}
extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
extension UITextField {
    func setLineView(color:UIColor) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(1)
        }
    }
    func setLineViewWithOffset(color:UIColor) {
        let view = UIView()
        view.backgroundColor = color
        addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(6)
        }
    }}

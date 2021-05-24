//
//  Extension.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 12/18/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import CoreGraphics

extension CIImage {
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
    
}
extension URL {
    /// Creates a QR code for the current URL in the given color.
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = absoluteString.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        
        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        return qrFilter.outputImage?.transformed(by: qrTransform)
    }
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> CIImage? {
        let tintedQRImage = qrImage?.tinted(using: color)
        
        guard let logo = logo?.cgImage else {
            return tintedQRImage
        }
        
        return tintedQRImage?.combined(with: CIImage(cgImage: logo))
    }
}

extension UIImageView {
    @IBInspectable
    var changeColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!);
            return color
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
}
extension UIImage {
    func changeSize(scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return newImage
    }
    func fixOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width ,y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        case .upMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        default: break
        }
        
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace,
            let context: CGContext = CGContext(data: nil,
                                               width: Int(size.width),
                                               height: Int(size.height),
                                               bitsPerComponent: cgImage.bitsPerComponent,
                                               bytesPerRow: 0,
                                               space: colorSpace,
                                               bitmapInfo: cgImage.bitmapInfo.rawValue)
            else { return self }
        context.concatenate(transform)
        var rect: CGRect
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
        default:
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        context.draw(cgImage, in: rect)
        guard let image = context.makeImage() else { return self }
        return UIImage(cgImage: image)
    }
    
}
extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}



public extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    public static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
extension UITableViewCell {
    func addlineView() {
        let lineview = UIView()
        lineview.backgroundColor = UIColor.lightGray
        addSubview(lineview)
        lineview.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-1)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
    }
}
extension UIImage {
    
    class func textEmbededImage(image: UIImage, string: String, color:UIColor, imageAlignment: Int = 0, segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 15.0)
        let expectedTextSize: CGSize = (string as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        let width: CGFloat = expectedTextSize.width + image.size.width + 5.0
        let height: CGFloat = max(expectedTextSize.height, image.size.width)
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2.0
        let textOrigin: CGFloat = (imageAlignment == 0) ? image.size.width + 5 : 0
        let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
        string.draw(at: textPoint, withAttributes: [NSAttributedString.Key.font: font])
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        let alignment: CGFloat =  (imageAlignment == 0) ? 0.0 : expectedTextSize.width + 5.0
        context.draw(image.cgImage!, in: CGRect.init(x: alignment, y: ((height - image.size.height) / 2.0), width: image.size.width, height: image.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
extension Date {
    
    func timeAgoSinceDate(day: String) -> String {
        // From Time
        let fromDate = self
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE,dd MMM yyyy,HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        dateFormatterPrint.dateFormat = "HH:mm"
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "год назад" : "\(interval)" + " " + "лет назад"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "Только что" : "\(interval)" + " " + "Только что"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval >= 0  {
            if interval == 0 {
                if let date = dateFormatterGet.date(from: day){
                    return "сегодня" + "в" + "\(dateFormatterPrint.string(from: date))"
                }
            }
            else if interval == 1 {
                return "\(interval)" + " " + "вчера"
            } else if interval == 2 {
                return "позавчера"
            } else if interval >= 3 {
                return day
            }
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            if interval == 1 {
                return "\(interval)" + " " + "час назад"
            } else if interval <= 4 && interval != 1 {
                return "\(interval)" + " " + "часa назад"
            } else if interval >= 5 {
                return "\(interval)" + " " + "часов назад"
                
            }
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            if interval == 1 {
                return "одну минуту назад"
            } else if interval <= 4 && interval != 1 {
                return "\(interval)" + " " + "минуты назад"
            } else if interval >= 5 {
                return "\(interval)" + " " + "минут назад"
                
            }
        }
        
        return "только что"
    }
}

extension UIView {
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
}
extension UIView {
    
    func addShadow(position: VerticalLocation, color: UIColor = .black, opacity: Float = 0.3, radius: CGFloat = 2) {
        switch position {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 0.5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -0.5), color: color, opacity: opacity, radius: radius)
        }
    }
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.3, radius: CGFloat = 2) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
enum VerticalLocation:String {
    case bottom
    case top
}
extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}

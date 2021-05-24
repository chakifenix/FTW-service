//
//  Start_ViewController.swift
//  resources
//
//  Created by MacOs User on 6/7/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import JTMaterialSpinner
import Alamofire
import Lottie
import CoreLocation
class Start_ViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var Loading_View: JTMaterialSpinner!
    
    @IBOutlet weak var Logo_Wight_Constraint: NSLayoutConstraint!
    @IBOutlet weak var Logo_Heght_Constraint: NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var page = 1
    var AddButton_ON = false
    
    let imageview = UIImageView()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageviewSettings()
        LoadingViewSettings()
        Animation_Logo()
        getLocation()
    }
    func getLocation() {
        self.locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }
    func imageviewSettings() {
        animationView.animation = Animation.named("tick")
        animationView.play()
    }
    func LoadingViewSettings() {
        Loading_View.circleLayer.lineWidth = 4.0
        Loading_View.circleLayer.strokeColor = Constans().blue.cgColor
        Loading_View.animationDuration = 1.5
    }
    func Animation_Logo(){
        
        UIView.animate(withDuration: 0.5, delay: 2,
                       options: .curveEaseInOut,
                       animations: {
                        self.imageview.frame.origin.y -= (self.view.bounds.height/2)
                        self.imageview.alpha = 0
        }){ _ in
            self.Loading_View.beginRefreshing()
           self.Data_Update()
        }
    }
    
    func Data_Update(){
        let city = "Алматы"
        let encodedTexts = city.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let rusTextt = encodedTexts,
            let str = String(utf8String: rusTextt.cString(using: .utf8)!)
            else {return}
        Networking.getMainTasks(url: Constans().cityUrl, continueUrl: str) { (task,err)  in
            guard let resource = task else {
                self.appDelegate.All_Resources = []
                self.Loading_View.endRefreshing()
                self.OpenVC()
                return
            }
            self.appDelegate.All_Resources = resource
            self.Loading_View.endRefreshing()
            self.OpenVC()
        }
    }
    func OpenVC(){
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let LoginToken = UserDefaults.standard.string(forKey: "token")
        let registerToken = UserDefaults.standard.string(forKey: "SMS")
        if launchedBefore  {
            if LoginToken != nil || registerToken != nil {
                _ = UIStoryboard(name: "Main", bundle: nil)
                let controller = TabBarViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LoginPage")
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Welcome")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    func startAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 0.9
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            gradientLayer.add(animation, forKey: "")
        }
    }
    func stopAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
    func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in view.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.shimmerAnimation
        })
    }
    
}
extension Start_ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        retreiveCityName(lattitude: locValue.latitude, longitude: locValue.longitude) { (country,city) in
            guard let country = country else {return}
            PassData.country = country
            UserDefaults.standard.set(country, forKey: "country")
            UserDefaults.standard.set(city, forKey: "city")
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "country"), object: nil, userInfo: ["userCountry": country])
        }
        
    }
    func retreiveCityName(lattitude: Double, longitude: Double, completionHandler: @escaping (_ country:String?,_ city:String?) -> Void)
    {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lattitude, longitude: longitude), preferredLocale: Locale(identifier: "ru_RU")) { (placeMarks, error) in
            print(placeMarks?.first?.name)
            PassData.city = placeMarks?.first?.locality
            completionHandler(placeMarks?.first?.country,placeMarks?.first?.locality)
        }
    }
}

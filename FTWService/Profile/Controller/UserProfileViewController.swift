//
//  UserProfileViewController.swift
//  resources
//
//  Created by MacOs User on 8/22/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import Alamofire
import Shimmer
protocol ChangedUserImageProtocol {
    func changedImage(image:UIImage)
}
class UserProfileViewController: UIViewController {
    
    let userUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_user&user="
    let reviewUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=reviews&act=view&userid="
    let apikey = "$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS"
    var checkController = true
    var delegate: ChangedUserImageProtocol?
    private let bonusView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.isUserInteractionEnabled = true
        return view
    }()
    private let bonusLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)
        return label
    }()
    let shimmerUserImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileWhite")
        return view
    }()
    let buttonShimmer:UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentSize.height = 800
        view.showsHorizontalScrollIndicator = true
        view.isUserInteractionEnabled = true
        return view
    }()
    let online: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3536864519, green: 0.7271710634, blue: 0.3864591122, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    var shimmerView: FBShimmeringView!
    let EmptyShimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var arrayRev = [UserReviews]()
    var heightSizes = [CGFloat]()
    var stringName = ""
    var stringFname: String?
    var id = ""
    var user:UserInfo?
    var userDetailArray = [UserDetail]()
    var headerView: UserHeader?
    var newImage:UIImage?
    lazy var collectionview:UICollectionView = {
        let layout = StretchyHeaderLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserHeader")
        collectionView.register(HorizontalDetailTaskCell.self, forCellWithReuseIdentifier: "HorizontalDetailTaskCell")
        collectionView.register(DetailTaskCell.self, forCellWithReuseIdentifier: "DetailTaskCell")
        collectionView.register(UserReviewCollectionViewCell.self, forCellWithReuseIdentifier: "UserReviewCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpMenuButton()
        shimmerEffect()
        createViews()
        getValueInJson()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideLoader()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        notificationObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = .default
       navigationController?.navigationBar.tintColor = .black
       navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
       navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bonusView.applyGradientforLabel(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
        buttonShimmer.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func getValueInJson() {
        let queue = DispatchQueue.init(label: "Queue", attributes: .concurrent)
        queue.async {
            self.parseJson(url: "\(self.userUrl)\(Constans().userid)&param=more")
        }
        queue.async {
            self.getReviews(url: "\(self.reviewUrl)\(Constans().userid)&sort=all&page=1")
        }
    }
    func setUpMenuButton(){
        let share = image(with:  UIImage(named: "63g"), scaledTo: CGSize(width: 24, height: 24))
        let setting = UIBarButtonItem(image: share, style: .done, target: self, action: #selector(onMenuButtonPressed))
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share24"), style: .done, target: self, action: #selector(onMenuButtonPressed2))
        let signToTheCityItem = UIBarButtonItem(image: UIImage(named: "check"), style: .done, target: self, action: #selector(onMenuButtonSignToCity))
        self.navigationItem.rightBarButtonItems = [setting,shareBarItem,signToTheCityItem]

//        userImage.addGestureRecognizer(tap)
    }
//    func notificationObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(portfileEdited), name: NSNotification.Name.init(rawValue: "profile"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(portfileImageEdited), name: NSNotification.Name.init(rawValue: "profileImage"), object: nil)
//    }
    
    
    
    //TODO: TEST
//    @objc func portfileEdited(notification: Notification) {
//        guard let userInfo = notification.userInfo, let arrayUser = userInfo["profileArray"] as? [String:Any] else {return}
//        self.parseJson(url: "\(self.userUrl)\(Constans().userid)&param=more")
//
//    }
//    @objc func portfileImageEdited(notification: Notification) {
//        guard let userInfo = notification.userInfo, let image = userInfo["photoUser"] as? UIImage else {return}
//        userImage.image = image
//        self.delegate?.changedImage(image: self.userImage.image!)
//    }
    @objc func onMenuButtonSignToCity(){
        let vc = FollowsViewController()
        self.show(vc, sender: self)
    }
    
    @objc func onMenuButtonPressed() {
        let vc = SettingViewController()
        guard let locationUser = user?.city,
            let birthUser = user?.birthday,
            let genderUser = user?.sex == "male" ?  "Мужчина" : "Женщина",
            let descrMe = user?.about else {
                vc.nameLabel = stringName
                vc.fname = stringFname != nil ? stringFname!: ""
                vc.savedImage = newImage
                self.show(vc, sender: self)
                return
        }
        vc.location = locationUser
        vc.birth = birthUser
        vc.gender = genderUser
        vc.descrMe = descrMe
        vc.nameLabel = stringName
        vc.fname = stringFname != nil ? stringFname!: ""
        vc.savedImage = newImage
        self.show(vc, sender: self)
    }
    
    @objc func onMenuButtonPressed2() {
        let message = "Привет,посмотри мой профиль на ORZU"
        let id = UserDefaults.standard.integer(forKey: "ID")
        if let link = URL(string: "https://orzu.org/profile/\(id)")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func showAllReviews() {
        let vc = ReviewsViewController()
        vc.id = id
        vc.arrayReviews = arrayRev
        vc.sizeArray = heightSizes
        self.show(vc, sender: self)
    }
    @objc func imageEditAction() {
        addImageAction()
    }
    func addImageAction() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo-1")
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    func parseJson(url:String) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let checkUserName = value as! [String:Any]
                self.user = UserInfo(json: checkUserName)
                self.id = String(self.user!.Id!)
                self.stringName = self.user!.name!
                self.stringFname = self.user?.fname
                let birth = UserDetail(title:"Дата рождения",detail:self.user?.birthday)
                let sex = UserDetail(title:"Пол",detail:self.user?.sex)
                self.userDetailArray.append(birth)
                self.userDetailArray.append(sex)
                DispatchQueue.main.async {
                    self.shimmerView.isShimmering = false
                    self.shimmerView.isHidden = true
                    self.EmptyShimmerView.isHidden = true
                    self.scrollView.isHidden = false
                    self.emptyView.isHidden = false
                    self.collectionview.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getReviews(url:String) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let json = value as? Array<[String: Any]> else {
                    return
                }
                for item in json {
                    let array = UserReviews(user_id: item["user_id"] as! Int,
                                            username: item["username"] as? String,
                                            avatar: item["avatar"] as? String,
                                            like: item["like"] as! Int,
                                            datein: item["datein"] as! String,
                                            narrative: item["narrative"] as? String)
                    if array.username != nil {
                        let size = UILabel().heightForLabel(text: array.narrative ?? "heightSize", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 100)
                        self.arrayRev.append(array)
                        self.heightSizes.append(size)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
extension UserProfileViewController: editProfile {
    func editProfile() {
        self.parseJson(url: "\(self.userUrl)\(Constans().userid)&param=more")
    }
    
    
}
extension UserProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        var selectedImage: UIImage!
        //
        let token = UserDefaults.standard.string(forKey: "token")
        let newImage = info[.editedImage] as? UIImage
        let orientationFixedImage = newImage?.fixedOrientation()
        //        let normolize = orientationFixedImage.no
        //        let orientationFixedImage = newImage?.fixedOrientation()
        self.newImage = orientationFixedImage
        headerView?.imageView.image = orientationFixedImage
        let imgNameOr = UUID().uuidString
        let documentDirectory = NSTemporaryDirectory()
        let localPath = documentDirectory.appending(imgNameOr + ".jpg")
        
        let data = orientationFixedImage!.pngData()! as NSData
        data.write(toFile: localPath, atomically: false)
        let photoURL = URL.init(fileURLWithPath: localPath)
        
        if let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.showLoader()
            Networking.uploadImage(fileUrl: photoURL, url: Constans().uploadImage, userId: id, token: token!, apikey: apikey) { (value) in
                self.showSuccess("Фото профиля изменено!")
//                self.delegate?.changedImage(image: self.userImage.image!)
            }
            //NotificationCenter.default.post(name: NSNotification.Name.init("changeMenuImage"), object: nil,userInfo: ["photo":imageMenu!])
            UserDefaults.standard.set(true, forKey: "MenuforImage")
            UserDefaults.standard.set(fileUrl, forKey: "imageFile")
        }
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            
            let data = newImage!.pngData()! as NSData
            data.write(toFile: localPath, atomically: false)
            let photoURL = URL.init(fileURLWithPath: localPath)
            print(photoURL)
            self.showLoader()
            Networking.uploadImage(fileUrl: photoURL, url: Constans().uploadImage, userId: id, token: token!, apikey: apikey){ (value) in
                self.hideLoader()
                self.showSuccess("Фото профиля изменено!")
//                self.delegate?.changedImage(image: self.userImage.image!)
            }
        }
        dismiss(animated: true)
    }
    
    
}
extension UserProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user != nil ? 2 + userDetailArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserReviewCollectionViewCell", for: indexPath) as! UserReviewCollectionViewCell
            cell.myProfile = true
            cell.reviewArray = arrayRev
            cell.titleLabel.text = "Мои Отзывы"
            cell.buttonAction = { [weak self] in
                self?.showAllReviews()
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailTaskCell", for: indexPath) as! DetailTaskCell
                       cell.titleLabel.text = "О себе"
                        cell.descrLabel.text = user?.about
                       return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalDetailTaskCell", for: indexPath) as! HorizontalDetailTaskCell
            let arr = userDetailArray[indexPath.row]
            cell.titleLabel.text = arr.title
            cell.descrLabel.text = arr.detail == ".." ? "Нет данных" : arr.title != "Пол" ? arr.detail : arr.detail == "male" ?  "Мужчина" : "Женщина"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserHeader", for: indexPath) as! UserHeader
        headerView?.user = user
        headerView?.tapAction = { [weak self] in
            self?.addImageAction()
        }
        //        headerView.homeController = self
        //        headerView.imageArray = self.allParseImageFromParam
        //        configureHeaderView()
        return headerView!
    }
    
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        switch indexPath.row {
        case 3:
            return CGSize(width: size.width, height: arrayRev.count != 0 ? 200 : 140)  
                    case 2:
                        let size = CGSize(width: self.view.frame.width, height: 1000)
                        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                        let textSize = NSString(string: user?.about ?? "textSize").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
                        return CGSize(width: size.width, height: textSize.height + 30)
        case 4:
        return CGSize(width: size.width, height: 120)
        default:
            return CGSize(width: size.width, height: 30)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 170)
    }
}
extension UserProfileViewController {
    func createViews() {
        self.view.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func shimmerEffect() {
        EmptyShimmerView.isHidden = false
        let nameView = UIView()
        nameView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameView.layer.cornerRadius = 10
        
        let locationView = UIView()
        locationView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        locationView.layer.cornerRadius = 10
        
        let shimmerCard = UIView()
        shimmerCard.backgroundColor = .white
        shimmerCard.layer.cornerRadius = 40
        shimmerCard.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let day = UIView()
        day.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        day.layer.cornerRadius = 10
        
        let gender = UIView()
        gender.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        gender.layer.cornerRadius = 10
        
        let about = UIView()
        about.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        about.layer.cornerRadius = 10
        
        let rev = UIView()
        rev.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        rev.layer.cornerRadius = 10
        
        let myday = UIView()
        myday.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        myday.layer.cornerRadius = 10
        
        let Mygender = UIView()
        Mygender.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        Mygender.layer.cornerRadius = 10
        
        let descr = UIView()
        descr.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        descr.layer.cornerRadius = 10
        
        let RevuserImage = UIImageView()
        RevuserImage.image = UIImage(named: "profileWhite")
        RevuserImage.layer.cornerRadius = 10
        
        let revName = UIView()
        revName.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        revName.layer.cornerRadius = 10
        
        let Revday = UIView()
        Revday.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        Revday.layer.cornerRadius = 10
        
        let revDescr = UIView()
        revDescr.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        revDescr.layer.cornerRadius = 10
        
        
        let iconLike = UIImageView()
        iconLike.image = #imageLiteral(resourceName: "icon-small-1")
        shimmerView = FBShimmeringView(frame: EmptyShimmerView.frame)
        shimmerView.shimmeringOpacity = 0.1
        shimmerView.shimmeringSpeed = 550
        shimmerView.shimmeringDirection = .right
        //        shimmerView.shimmeringHighlightLength = 0.1
        self.view.addSubview(EmptyShimmerView)
        self.view.addSubview(shimmerView)
        shimmerView.contentView = EmptyShimmerView
        
        EmptyShimmerView.addSubview(shimmerUserImage)
        EmptyShimmerView.addSubview(nameView)
        EmptyShimmerView.addSubview(locationView)
        EmptyShimmerView.addSubview(shimmerCard)
        
        shimmerCard.addSubview(day)
        shimmerCard.addSubview(myday)
        shimmerCard.addSubview(gender)
        shimmerCard.addSubview(Mygender)
        shimmerCard.addSubview(about)
        shimmerCard.addSubview(descr)
        shimmerCard.addSubview(rev)
        shimmerCard.addSubview(RevuserImage)
        shimmerCard.addSubview(revName)
        shimmerCard.addSubview(revDescr)
        shimmerCard.addSubview(Revday)
        shimmerCard.addSubview(buttonShimmer)
        shimmerCard.addSubview(iconLike)
        
        EmptyShimmerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        shimmerView.snp.makeConstraints { (make) in
            make.edges.equalTo(EmptyShimmerView.snp.edges)
        }
        
        shimmerUserImage.snp.makeConstraints { (make) in
            make.top.equalTo(EmptyShimmerView.snp.top).offset(12)
            make.centerX.equalTo(EmptyShimmerView.snp.centerX)
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerUserImage.snp.bottom).offset(6)
            make.centerX.equalTo(shimmerUserImage.snp.centerX)
            make.size.equalTo(CGSize(width: 120, height: 20))
            
        }
        
        locationView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom).offset(6)
            make.centerX.equalTo(nameView.snp.centerX)
            make.size.equalTo(CGSize(width: 160, height: 20))
        }
        
        shimmerCard.snp.makeConstraints { (make) in
            make.top.equalTo(locationView.snp.bottom).offset(12)
            make.left.equalTo(EmptyShimmerView.snp.left)
            make.right.equalTo(EmptyShimmerView.snp.right)
            make.bottom.equalTo(EmptyShimmerView.snp.bottom)
        }
        day.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerCard.snp.top).offset(20)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        
        myday.snp.makeConstraints { (make) in
            make.top.equalTo(day.snp.top)
            make.left.equalTo(day.snp.right).offset(24)
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.height.equalTo(20)
        }
        gender.snp.makeConstraints { (make) in
            make.top.equalTo(day.snp.bottom).offset(20)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        
        Mygender.snp.makeConstraints { (make) in
            make.top.equalTo(gender.snp.top)
            make.left.equalTo(gender.snp.right).offset(24)
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.height.equalTo(20)        }
        about.snp.makeConstraints { (make) in
            make.top.equalTo(Mygender.snp.bottom).offset(20)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        descr.snp.makeConstraints { (make) in
            make.top.equalTo(about.snp.bottom).offset(12)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.height.equalTo(23)
        }
        rev.snp.makeConstraints { (make) in
            make.top.equalTo(descr.snp.bottom).offset(20)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        RevuserImage.snp.makeConstraints { (make) in
            make.top.equalTo(rev.snp.bottom).offset(12)
            make.left.equalTo(rev.snp.left)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        revName.snp.makeConstraints { (make) in
            make.top.equalTo(RevuserImage.snp.top).offset(4)
            make.left.equalTo(RevuserImage.snp.right).offset(12)
            make.size.equalTo(CGSize(width: 46, height: 17))
        }
        Revday.snp.makeConstraints { (make) in
            make.top.equalTo(revName.snp.bottom).offset(4)
            make.left.equalTo(RevuserImage.snp.right).offset(12)
            make.size.equalTo(CGSize(width: 46, height: 17))
        }
        revDescr.snp.makeConstraints { (make) in
            make.top.equalTo(Revday.snp.bottom).offset(12)
            make.left.equalTo(Revday.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.height.equalTo(20)
        }
        iconLike.snp.makeConstraints { (make) in
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.top.equalTo(revName.snp.top)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        buttonShimmer.snp.makeConstraints { (make) in
            make.top.equalTo(revDescr.snp.bottom).offset(32)
            make.left.equalTo(shimmerCard.snp.left).offset(16)
            make.right.equalTo(shimmerCard.snp.right).offset(-16)
            make.height.equalTo(shimmerCard.snp.height).multipliedBy(0.08)
        }
        shimmerView.isShimmering = true
    }
}
class UserHeader: UICollectionReusableView {
    private let view:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    private let buttonView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Магжан Имангазы"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let locationLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Алматы"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let imageView:WebImage = {
        let view = WebImage()
        view.image = #imageLiteral(resourceName: "forBouns")
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    let GoodiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "greenGood")
        return image
    }()
    let NormaliconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "brownNormal")
        image.isUserInteractionEnabled = true
        return image
    }()
    let BadiconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "redBad")
        image.isUserInteractionEnabled = true
        return image
    }()
    let SumGoodIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "1"
        return label
    }()
    let SumNormalIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "1"
        return label
    }()
    let SumBadIcon:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "0"
        return label
    }()
    private let lineview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return view
    }()
    let SumCreatedTasks:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        label.numberOfLines = 0
        return label
    }()
    let SumFinishedTasks:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)
        label.numberOfLines = 0
        return label
    }()
    var user:UserInfo? {
        didSet {
            guard let user = user else {return}
            self.nameLabel.text = user.fname == nil ? user.name : user.name! + " " + user.fname!
            self.SumBadIcon.text = String(user.sad!)
            self.SumNormalIcon.text = String(user.neutral!)
            self.SumGoodIcon.text = String(user.happy!)
            self.locationLabel.text = user.city
            let urlString = "https://orzu.org/\(user.avatar!)"
            self.imageView.set(imageUrl: urlString)
            configureAttributedText()
            UserDefaults.standard.set(urlString, forKey: "Avatar")
//            if user.status! == true {
//                self.online.isHidden = false
//            } else {
//                self.online.isHidden = true
//            }
        }
    }
    var tapAction: (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConst()
        configureAttributedText()
        setupTapGesture()
    }
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageEditAction))
        imageView.addGestureRecognizer(tap)
    }
    func configureAttributedText() {
        let CreatedTaskAttributedText = NSMutableAttributedString(string: "1", attributes: [NSAttributedString.Key.font : UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        CreatedTaskAttributedText.append(NSAttributedString(string:"\nЗадания создано",attributes: [NSAttributedString.Key.font : UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        SumCreatedTasks.attributedText = CreatedTaskAttributedText
        SumCreatedTasks.textAlignment = .center
        let FinishedTaskAttributedText = NSMutableAttributedString(string: "3", attributes: [NSAttributedString.Key.font : UIFont(name:"AppleSDGothicNeo-Light", size: 18.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    FinishedTaskAttributedText.append(NSAttributedString(string:"\nЗадания cделано",attributes: [NSAttributedString.Key.font : UIFont(name:"AppleSDGothicNeo-Light", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        SumFinishedTasks.attributedText = FinishedTaskAttributedText
        SumFinishedTasks.textAlignment = .center
    }
    @objc func imageEditAction() {
        tapAction!()
    }
    func setupConst() {
        backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        addSubview(view)
        view.addSubview(nameLabel)
        view.addSubview(imageView)
        view.addSubview(BadiconLike)
        view.addSubview(SumBadIcon)
        view.addSubview(NormaliconLike)
        view.addSubview(SumNormalIcon)
        view.addSubview(GoodiconLike)
        view.addSubview(SumGoodIcon)
        view.addSubview(locationLabel)
        view.addSubview(lineview)
        view.addSubview(buttonView)
        buttonView.addSubview(SumCreatedTasks)
        buttonView.addSubview(SumFinishedTasks)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0 , left: 0, bottom: 8, right: 0))
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(80)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).offset(8)
            make.left.equalTo(imageView.snp.right).offset(16)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(imageView.snp.right).offset(16)
        }
        BadiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel.snp.left)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumBadIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(BadiconLike.snp.centerY)
            make.left.equalTo(BadiconLike.snp.right).offset(4)
        }
        NormaliconLike.snp.makeConstraints { (make) in
            make.top.equalTo(BadiconLike.snp.top)
            make.left.equalTo(SumBadIcon.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumNormalIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(NormaliconLike.snp.centerY)
            make.left.equalTo(NormaliconLike.snp.right).offset(4)
        }
        GoodiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(NormaliconLike.snp.top)
            make.left.equalTo(SumNormalIcon.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        SumGoodIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(GoodiconLike.snp.centerY)
            make.left.equalTo(GoodiconLike.snp.right).offset(4)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        buttonView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineview.snp.bottom).offset(4)
        }
        SumCreatedTasks.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(32)
        }
        SumFinishedTasks.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-32)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserReviewCollectionViewCell:baseCell {
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let view:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        return view
    }()
    var buttonAction: (()->())?
    var addReviewButtonAction: (()->())?
    var myProfile = false
    var rightButtonViewConst2: Constraint?
    var rightButtonViewConst1: Constraint?
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Посмотреть отзывы", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.layer.borderWidth = 0.5
        return button
    }()
    lazy var addReviewButton: UIButton = {
          let button = UIButton()
          button.setTitle("Добавить отзыв", for: .normal)
          button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
          button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
          button.layer.cornerRadius = 5
          button.isHidden = true
           button.addTarget(self, action: #selector(addReviewsAction), for: .touchUpInside)
          return button
      }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(MyReviewCell.self, forCellWithReuseIdentifier: "MyReviewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private let formatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "dd MMM yyyy"
         formatter.locale = Locale(identifier: "ru_RU")
         return formatter
     }()
    var reviewArray = [UserReviews]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override func setupConst() {
        super.setupConst()
        button.addTarget(self, action: #selector(showAllReviews), for: .touchUpInside)
        addSubview(view)
        addSubview(collectionView)
        view.addSubview(titleLabel)
        addSubview(addReviewButton)
        addSubview(button)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 28, left: 0, bottom: 54, right: 0))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-2)
            make.left.equalToSuperview().offset(16)
        }
        button.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(16)
            rightButtonViewConst1 = make.right.equalToSuperview().offset(-16).constraint
            rightButtonViewConst2 = make.right.equalTo(self.snp.centerX).offset(-4).constraint
            make.height.equalTo(40)
        }
        rightButtonViewConst1?.activate()
        rightButtonViewConst2?.deactivate()
        addReviewButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalTo(self.snp.centerX).offset(4)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
    }
    @objc func showAllReviews() {
        buttonAction!()
    }
    @objc func addReviewsAction() {
        addReviewButtonAction!()
    }
}
extension UserReviewCollectionViewCell:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reviewArray.count == 0 {
            collectionView.setLabel(text:"Пока нет отзывов")
        } else {
            collectionView.restoreView()
        }
        return reviewArray.count != 0 ? reviewArray.count < 2 ? 1 : 2 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyReviewCell", for: indexPath) as! MyReviewCell
        cell.isUserInteractionEnabled = false
        cell.aboutMe.text = reviewArray[indexPath.row].username ?? "User"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatterGet.date(from: reviewArray[indexPath.row].datein) {
                   cell.dateRev.text = formatter.string(from: date)
               }
               cell.descrMe.text = reviewArray[indexPath.row].narrative
               if reviewArray[indexPath.row].like == 0 {
                   cell.iconLike.image = #imageLiteral(resourceName: "redBad")
               } else if reviewArray[indexPath.row].like == 1 {
                   cell.iconLike.image = #imageLiteral(resourceName: "brownNormal")
               } else {
                   cell.iconLike.image = #imageLiteral(resourceName: "greenGood")
               }
               guard let avatar = reviewArray[indexPath.row].avatar else {
                   return cell
               }
               let urlString = "https://orzu.org\(avatar)"
               cell.image1.set(imageUrl: urlString)
        return cell
    }
    
    
}
extension UserReviewCollectionViewCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/2 - 24, height: self.collectionView.frame.height - 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
    }
}
class MyReviewCell:baseCell {
    private let view:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.layer.cornerRadius = 5
        return view
    }()
    let image1: WebImage = {
        let image = WebImage()
        image.image = #imageLiteral(resourceName: "STAR")
        image.clipsToBounds = true
        image.layer.cornerRadius = 18
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "profileWhite")
        return image
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "greenGood")
        return image
    }()
    let aboutMe:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 15.0)
        label.text = "Имя Фамилья"
        return label
    }()
    let dateRev:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.text = "26 августа 2019"
        return label
    }()
    let descrMe: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        label.text = "морального ущерба"
        label.numberOfLines = 2
        return label
    }()
    override func setupConst() {
        super.setupConst()
        addSubview(view)
        view.addSubview(image1)
        view.addSubview(iconLike)
        view.addSubview(descrMe)
        view.addSubview(aboutMe)
        view.addSubview(dateRev)
        configureViews()
    }
    func configureViews() {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        image1.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(8)
            make.left.equalToSuperview().offset(2)
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        aboutMe.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(10)
            make.left.equalTo(image1.snp.right).offset(8)
        }
        dateRev.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.bottom).offset(2)
            make.left.equalTo(image1.snp.right).offset(8)
        }
        descrMe.snp.makeConstraints { (make) in
            make.top.equalTo(dateRev.snp.bottom).offset(6)
            make.left.equalTo(dateRev.snp.left)
            make.right.equalToSuperview()
        }
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalToSuperview().offset(-2)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }
}

//
//  UserIDProfileViewController.swift
//  resources
//
//  Created by MacOs User on 8/26/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit
import MaterialComponents
import SnapKit
import Alamofire
import Shimmer
class UserIDProfileViewController: UIViewController {
    let userUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_user&user="
    let reviewUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=reviews&act=view&userid="
    private let buttonShimmer:UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "1")
        view.isUserInteractionEnabled = true
        return view
    }()
    let shimmerUserImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileWhite")
        return view
    }()
    let online: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3536864519, green: 0.7271710634, blue: 0.3864591122, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var shimmerView: FBShimmeringView!
    private let EmptyShimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var arrayRev = [UserReviews]()
    var heightSizes = [CGFloat]()
    var UsernameString = ""
    var userID:Int?
    var userDetailArray = [UserDetail]()
    var user: UserInfo?
    var userImage:UIImage?
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Профиль"
        networking()
        shimmerEffect()
        createViews()
        setUpMenuButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonShimmer.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    func networking() {
        if let id = userID {
            let queue = DispatchQueue.init(label: "Queue", attributes: .concurrent)
            queue.async {
                print(Thread.current)
                self.parseJson(url: "\(self.userUrl)\(id)&param=more")
            }
            queue.async {
                print(Thread.current)
                self.getReviews(url: "\(self.reviewUrl)\(id)&sort=all&page=1")
            }
            
        }
    }
    func setUpMenuButton(){
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share24"), style: .done, target: self, action: #selector(onMenuButtonPressed2))
        self.navigationItem.rightBarButtonItem = shareBarItem
    }
    @objc func onMenuButtonPressed() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Allsetting") as! SettingViewController
        self.show(vc, sender: self)
    }
    
    @objc func onMenuButtonPressed2() {
        let message = "Привет,посмотри профиль на ORZU"
        let id = UserDefaults.standard.integer(forKey: "ID")
        if let link = URL(string: "https://orzu.org/profile/\(id)")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func showAllReviews() {
        let vc = ReviewsViewController()
        vc.id = PassData.UserID
        vc.arrayReviews = arrayRev
        vc.sizeArray = heightSizes
        print(heightSizes)
        self.show(vc, sender: self)
    }
    func addReviewsAction() {
        let vc = AddReviewsViewController()
        vc.name = user!.name!
        vc.userimage = userImage
        vc.callback = { result in
            if let id = self.userID {
                self.getReviews(url: "\(self.reviewUrl)\(id)&sort=all&page=1")
            }
        }
        //        vc.callbackDelete = { result in
        //            print("Call")
        //            let id = PassData.UserID
        //            self.updateReviews(url: "\(self.reviewUrl)\(id)&sort=all&page=1")
        //            self.reviewsView.reloadData()
        //        }
        self.show(vc, sender: self)
    }
    func parseJson(url:String) {
        guard let url = URL(string: url) else {return}
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let checkUserName = value as! [String:Any]
                self.user = UserInfo(json: checkUserName)
                let birth = UserDetail(title:"Дата рождения",detail:self.user?.birthday)
                let sex = UserDetail(title:"Пол",detail:self.user?.sex)
                self.userDetailArray.append(birth)
                self.userDetailArray.append(sex)
                DispatchQueue.main.async {
                    self.shimmerView.isShimmering = false
                    self.shimmerView.isHidden = true
                    self.EmptyShimmerView.isHidden = true
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UserIDProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user != nil ? 2 + userDetailArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserReviewCollectionViewCell", for: indexPath) as! UserReviewCollectionViewCell
            cell.addReviewButton.isHidden = false
            cell.rightButtonViewConst2?.activate()
            cell.rightButtonViewConst1?.deactivate()
            cell.reviewArray = arrayRev
            cell.titleLabel.text = "Отзывы"
            cell.buttonAction = { [weak self] in
                self?.showAllReviews()
            }
            cell.addReviewButtonAction = { [weak self] in
                self?.addReviewsAction()
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
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserHeader", for: indexPath) as! UserHeader
        headerView.user = user
        self.userImage = headerView.imageView.image
        //        headerView.homeController = self
        //        headerView.imageArray = self.allParseImageFromParam
        //        configureHeaderView()
        return headerView
    }
    
}

extension UserIDProfileViewController: UICollectionViewDelegateFlowLayout{
    
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
extension UserIDProfileViewController {
    func createViews() {
        self.view.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func shimmerEffect() {
        self.view.addSubview(bgView)
        
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
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        EmptyShimmerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        shimmerView.snp.makeConstraints { (make) in
            make.edges.equalTo(EmptyShimmerView)
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

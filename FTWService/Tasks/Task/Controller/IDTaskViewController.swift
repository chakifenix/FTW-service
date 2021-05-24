//
//  IDTaskViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import JTMaterialSpinner
import Alamofire
import MaterialComponents
import Shimmer
import SnapKit
var associateObjectValue: Int = 0

class IDTaskViewController: UIViewController,UIScrollViewDelegate {
    var taskIndex = 0
    var url = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&lang=ru&opt=view_task&tasks=all"
    var callbackDelete : ((Int)->())?
    let shimmerUserImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileWhite")
        return view
    }()
    
    private let gobutton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.layer.cornerRadius = 7
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    let imageButton: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "right")
        image.changeColor = #colorLiteral(red: 0, green: 0.3568627451, blue: 0.6039215686, alpha: 1)
        return image
    }()
    //    private let collectionView: UICollectionView = {
    //        let layout = UICollectionViewFlowLayout()
    //        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    //        layout.scrollDirection = .horizontal
    //        collectionView.isPagingEnabled = true
    //        collectionView.isScrollEnabled = true
    //        collectionView.showsHorizontalScrollIndicator = false
    //        collectionView.showsVerticalScrollIndicator = false
    //        collectionView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    //        return collectionView
    //    }()
    
    let EmptyShimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let bgView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Green")
        return view
    }()
    let buttonView: UIView = {
        let buttonView = UIView()
        buttonView.isHidden = true
        buttonView.isUserInteractionEnabled = true
        buttonView.backgroundColor = .white
        buttonView.addShadow(position: .top, color: .black, opacity: 0.5, radius: 5)
        return buttonView
    }()
    var count = 0
    var allParseImageFromParam = [UIImage]()
    var index:Int?
    var Title = ""
    lazy var dateT = ""
    var amount = ""
    var taskId = ""
    var checkIsTherePhotoBool = false
    var taskArray = [Task_Resource]()
    var textSize:CGFloat = 0
    var UserId:Int = 0
    var isTask = ""
    var user:UserInfo?
    private var shimmer: FBShimmeringView!
    var infoArr = [Param]()
    var paramArray = [Param](){
        didSet{
            let dispatchGroup = DispatchGroup()
            let queue = DispatchQueue.global(qos: .utility)
            queue.async(group: dispatchGroup) { [weak self] in
                guard let self = self else {return}
                for param in self.paramArray {
                    if param.param == "image" {
                        let urlString = "https://orzu.org/\(param.value!)"
                        guard let url = URL(string: urlString) else {return}
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async{
                                self.allParseImageFromParam.append(UIImage(data: data)!)
                            }
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.collectionview.reloadData()
            }
        }
    }
    lazy var collectionview:UICollectionView = {
        let layout = StretchyHeaderLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        collectionView.isHidden = true
        collectionView.register(BriefTaskInfoCell.self, forCellWithReuseIdentifier: "Detail")
        collectionView.register(DetailTaskCell.self, forCellWithReuseIdentifier: "MoreTaskDetail")
        collectionView.register(UserTaskCell.self, forCellWithReuseIdentifier: "UserTaskCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    var IsDark = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailInfo(index: index ?? Int(NotifyData.shared.idOffTask!)!)
        viewSettings()
        createViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        gobutton.applyGradient(colors: [#colorLiteral(red: 0.9960784314, green: 0.5490196078, blue: 0, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.2117647059, blue: 0, alpha: 1)])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureNavigationController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.backgroundColor = .clear
//      self.navigationController?.navigationBar.subviews.first?.alpha = 0
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        //        navigationController?.navigationBar.barStyle = .black
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        //        navigationController?.navigationBar.barTintColor = .clear
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        configureNavigationController()
    }
    func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y/140
        if offset > 1 {
            offset = 1
            let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            self.navigationController?.navigationBar.backgroundColor = color
            navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 0, alpha: 1)
            UIApplication.shared.statusBarUIView?.backgroundColor = color
        } else {
            let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarUIView?.backgroundColor = color
            navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
        }
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    fileprivate func viewSettings() {
        settingButton()
        shimmerEffect()
    }
    
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        let x = targetContentOffset.pointee.x
    //        pageControl.currentPage = Int(x/collectionView.frame.width)
    //    }
    
    func settingButton() {
        if isTask == "myTask"{
            gobutton.setTitle("Посмотреть отклики", for: .normal)
            let share = UIImage(named: "more_vert")
            let shareItem = UIBarButtonItem(image: share, style: .done, target: self, action: #selector(shareBarButtonAction))
            self.navigationItem.rightBarButtonItems = [shareItem]
        } else {
            gobutton.setTitle("Добавить предложение", for: .normal)
        }
    }
    
    @objc func buttonPressed() {
        if isTask == "myTask"{
            let vc = ListOfferViewController()
            vc.taskId = taskId
            self.show(vc, sender: self)
        } else {
            let vc = AddOfferViewController()
            //            vc.userName = userName.text!
            vc.taskId = taskId
            //            vc.userimage = userImage.image
            self.show(vc, sender: self)
        }
    }
    
    //MARK:SHARE BAR BUTTON
    @objc func shareBarButtonAction() {
        let shareIcon = #imageLiteral(resourceName: "share24")
        let commentIcon = #imageLiteral(resourceName: "chat-1")
        let bag = image(with: #imageLiteral(resourceName: "bagDelete"), scaledTo: CGSize(width: 20, height: 20))
        
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteaction = UIAlertAction(title: "Удалить", style: .default) { (_) in
            self.tapAction()
        }
        let shareaction = UIAlertAction(title: "Поделиться", style: .default) { (_) in
            let message = "Task"
            //Set the link to share.
            if let link = URL(string: "https://orzu.org/tasks/view/\(self.taskId)")
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        deleteaction.setValue(bag, forKey: "image")
        deleteaction.setValue(UIColor.red, forKey: "titleTextColor")
        deleteaction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        shareaction.setValue(shareIcon, forKey: "image")
        shareaction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let action2 = UIAlertAction(title: "Пожаловаться", style: .default)
        action2.setValue(commentIcon, forKey: "image")
        action2.setValue(UIColor.orange, forKey: "titleTextColor")
        action2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        alertVc.addAction(shareaction)
        alertVc.addAction(deleteaction)
        alertVc.addAction(action2)
        alertVc.addAction(cancel)
        self.present(alertVc,animated: true)
    }
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func tapAction() {
        let alert = UIAlertController(title: "", message: "Вы уверены, что хотите удалить задание?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Удалить", style: .default) { (action) in
            let userId = UserDefaults.standard.integer(forKey: "ID")
            self.url += "&\(userId)&delete=\(self.taskId)"
            //            Networking.deleteRequest(url: self.url)
            guard let url = URL(string: self.url) else { return }
            Alamofire.request(url,method: .get).validate().responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    print(value)
                    self.callbackDelete!(userId)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        okAction.setValue(UIColor(red: 254/255.0, green: 10/255.0, blue: 0/255.0, alpha: 1   ), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert,animated: true)
    }
    func configureDetailInfo(index:Int) {
        Networking.getTask(id: index) { (task, param) in
            self.infoArr.append(Param(param: "Дата", value: self.dateT))
            self.infoArr.append(Param(param: "Оплата", value: "Напрямую исполнителю"))
            self.taskArray = task
            self.paramArray = param
            self.checkIDURL()
            //            self.settingButton()
        }
    }
    
    
    //MARK: Check id
    func checkIDURL() {
        for item in taskArray {
            let id = item.user_id!
            let myId = UserDefaults.standard.integer(forKey: "ID")
            if id == myId,item.Id == taskIndex{
                isTask = "myTask"
            }
            print(id)
            guard let chechIdUrl = URL(string: "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=view_user&user=\(id)") else {return}
            Alamofire.request(chechIdUrl).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let checkUserName = value as! [String:Any]
                    self.user = UserInfo(json: checkUserName)
                    self.UserId = (self.user?.Id!)!
                    DispatchQueue.main.async {
                        self.shimmer.isShimmering = false
                        self.shimmer.isHidden = true
                        self.bgView.isHidden = true
                        self.buttonView.isHidden = false
                        self.collectionview.isHidden = false
                        self.collectionview.reloadData()
                    }
                //                    PassData.UserID = String(user.i)
                case .failure(let error):
                    print(error.localizedDescription)
                    if error.localizedDescription == "Response status code was unacceptable: 400." {
                        self.showErrorMessageWithBlock(message: "Данные не существует!", completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
        settingButton()
    }
    
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
    //            scrollView.contentOffset.x = 0
    //        }
    //        if narrativeText.text!.count < 100 {
    //            scrollView.showsVerticalScrollIndicator = false
    //            if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
    //                scrollView.contentOffset.y = 0
    //            }
    //        }
    //
    //    }
    
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        let shareIcon = #imageLiteral(resourceName: "share")
        let commentIcon = #imageLiteral(resourceName: "chat-1")
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteaction = UIAlertAction(title: "Удалить", style: .default) { (_) in
            
        }
        let shareaction = UIAlertAction(title: "Поделиться", style: .default) { (_) in
            let message = "Task"
            //Set the link to share.
            if let link = URL(string: "https://orzu.org/tasks/view/\(self.taskId)")
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        shareaction.setValue(shareIcon, forKey: "image")
        shareaction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let action2 = UIAlertAction(title: "Пожаловаться", style: .default)
        action2.setValue(commentIcon, forKey: "image")
        action2.setValue(UIColor.red, forKey: "titleTextColor")
        action2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        alertVc.addAction(shareaction)
        alertVc.addAction(action2)
        alertVc.addAction(cancel)
        self.present(alertVc,animated: true)
        
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



extension IDTaskViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Detail", for: indexPath) as! BriefTaskInfoCell
            if taskArray.count != 0 {
                cell.taskLabel.text = self.taskArray[0].task
                cell.cashLabel.text = self.amount
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.locale = Locale(identifier: "ru_RU")
                dateFormatterPrint.dateFormat = "EEEE,dd MMM yyyy,HH:mm:ss"
                if let date = dateFormatterGet.date(from: taskArray[0].created_at!) {
                    cell.dateLabel.text = date.timeAgoSinceDate(day: dateFormatterPrint.string(from: date)) //not forgot
                } else {
                    print("There was an error decoding the string")
                }
                if paramArray[0].param == "address" {
                    cell.locationLabel.text = paramArray[0].value
                }
            }
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreTaskDetail", for: indexPath) as! DetailTaskCell
            if taskArray.count != 0 {
                cell.titleLabel.text = "Описание"
                cell.descrLabel.text = self.taskArray[0].narrative
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserTaskCell", for: indexPath) as! UserTaskCell
            cell.user = user
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreTaskDetail", for: indexPath) as! DetailTaskCell
            if infoArr.count != 0 {
                cell.titleLabel.text = infoArr[indexPath.row - 1].param
                cell.descrLabel.text = infoArr[indexPath.row - 1].value
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            if isTask == "myTask"{
                let vc = UserProfileViewController()
                vc.checkController = false
                self.show(vc, sender: self)
            }else{
                let vc = UserIDProfileViewController()
                vc.userID = self.UserId
                //            vc.UsernameString = userName.text!
                self.show(vc, sender: self)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as! Header
        headerView.homeController = self
        headerView.imageArray = self.allParseImageFromParam
        //        configureHeaderView()
        return headerView
    }
    
}

extension IDTaskViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        switch indexPath.row {
        case 0:
            return CGSize(width: size.width, height: 130)
        case 3:
            let size = CGSize(width: self.view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let textSize = NSString(string: taskArray.count != 0 ? taskArray[0].narrative! : "textSize").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
            return CGSize(width: size.width, height: textSize.height + 68)
        case 4:
            return CGSize(width: size.width, height: 120)
        default:
            return CGSize(width: size.width, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width*9/16)
    }
}
extension IDTaskViewController {
    private func createViews() {
        self.view.addSubview(collectionview)
        buttonView.addSubview(gobutton)
        self.view.addSubview(buttonView)
        collectionview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
        }
        buttonView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        gobutton.snp.makeConstraints { (make) in
            make.top.equalTo(buttonView.snp.top).offset(12)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(45)
        }
    }
    
    func shimmerEffect() {
        EmptyShimmerView.isHidden = false
        let lineview1 = UIView()
        lineview1.backgroundColor = UIColor.groupTableViewBackground
        
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.groupTableViewBackground
        
        let shimmerCard = UIView()
        shimmerCard.backgroundColor = .white
        shimmerCard.layer.cornerRadius = 40
        shimmerCard.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let cashLabel = UIView()
        cashLabel.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        cashLabel.layer.cornerRadius = 10
        
        let locationView1 = UIView()
        locationView1.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        locationView1.layer.cornerRadius = 10
        
        let locationView2 = UIView()
        locationView2.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        locationView2.layer.cornerRadius = 10
        
        let rev = UIView()
        rev.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        rev.layer.cornerRadius = 10
        
        let amountView = UIView()
        amountView.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        amountView.layer.cornerRadius = 10
        
        let myday = UIView()
        myday.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        myday.layer.cornerRadius = 10
        
        let Mygender = UIView()
        Mygender.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        Mygender.layer.cornerRadius = 10
        
        let descr = UIView()
        descr.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.8901960784, blue: 0.9333333333, alpha: 1)
        descr.layer.cornerRadius = 10
        
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
        iconLike.image = #imageLiteral(resourceName: "greenGood")
        let iconLike2 = UIImageView()
        iconLike2.image = #imageLiteral(resourceName: "brownNormal")
        let iconLike3 = UIImageView()
        iconLike3.image = #imageLiteral(resourceName: "redBad")
        
        shimmer = FBShimmeringView(frame: EmptyShimmerView.frame)
        shimmer.shimmeringOpacity = 0.1
        shimmer.shimmeringSpeed = 550
        shimmer.shimmeringDirection = .right
        self.view.addSubview(bgView)
        bgView.addSubview(EmptyShimmerView)
        bgView.addSubview(shimmer)
        shimmer.contentView = EmptyShimmerView
        EmptyShimmerView.addSubview(shimmerCard)
        
        shimmerCard.addSubview(cashLabel)
        shimmerCard.addSubview(myday)
        shimmerCard.addSubview(locationView1)
        shimmerCard.addSubview(Mygender)
        shimmerCard.addSubview(locationView2)
        shimmerCard.addSubview(descr)
        shimmerCard.addSubview(rev)
        shimmerCard.addSubview(amountView)
        shimmerCard.addSubview(revName)
        shimmerCard.addSubview(revDescr)
        shimmerCard.addSubview(Revday)
        shimmerCard.addSubview(iconLike)
        shimmerCard.addSubview(iconLike2)
        shimmerCard.addSubview(iconLike3)
        shimmerCard.addSubview(shimmerUserImage)
        shimmerCard.addSubview(lineview1)
        shimmerCard.addSubview(lineView2)
        bgView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
        }
        EmptyShimmerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.bgView)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(EmptyShimmerView)
        }
        shimmerCard.snp.makeConstraints { (make) in
            make.left.equalTo(EmptyShimmerView.snp.left)
            make.right.equalTo(EmptyShimmerView.snp.right)
            make.bottom.equalTo(EmptyShimmerView.snp.bottom)
            make.height.equalTo(EmptyShimmerView.snp.height).multipliedBy(0.85)
        }
        
        cashLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shimmerCard.snp.top).offset(20)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.width.equalTo(shimmerCard.snp.width).multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        myday.snp.makeConstraints { (make) in
            make.top.equalTo(cashLabel.snp.bottom).offset(10)
            make.left.equalTo(cashLabel.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(23)
        }
        descr.snp.makeConstraints { (make) in
            make.top.equalTo(myday.snp.bottom).offset(10)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.width.equalTo(cashLabel.snp.width)
            make.height.equalTo(20)
        }
        lineview1.snp.makeConstraints { (make) in
            make.top.equalTo(descr.snp.bottom).offset(10)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(1)
        }
        locationView1.snp.makeConstraints { (make) in
            make.top.equalTo(lineview1.snp.bottom).offset(16)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        locationView2.snp.makeConstraints { (make) in
            make.top.equalTo(locationView1.snp.bottom).offset(8)
            make.left.equalTo(locationView1.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(20)
        }
        Mygender.snp.makeConstraints { (make) in
            make.top.equalTo(locationView2.snp.bottom).offset(16)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        
        rev.snp.makeConstraints { (make) in
            make.top.equalTo(Mygender.snp.bottom).offset(8)
            make.left.equalTo(locationView1.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(20)
        }
        amountView.snp.makeConstraints { (make) in
            make.top.equalTo(rev.snp.bottom).offset(16)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        revName.snp.makeConstraints { (make) in
            make.top.equalTo(amountView.snp.bottom).offset(8)
            make.left.equalTo(locationView1.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(20)
        }
        Revday.snp.makeConstraints { (make) in
            make.top.equalTo(revName.snp.bottom).offset(16)
            make.left.equalTo(locationView1.snp.left)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
        revDescr.snp.makeConstraints { (make) in
            make.top.equalTo(Revday.snp.bottom).offset(8)
            make.left.equalTo(Revday.snp.left)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(20)
        }
        lineView2.snp.makeConstraints { (make) in
            make.top.equalTo(revDescr.snp.bottom).offset(10)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.right.equalTo(shimmerCard.snp.right).offset(-24)
            make.height.equalTo(1)
        }
        iconLike.snp.makeConstraints { (make) in
            make.left.equalTo(shimmerUserImage.snp.right).offset(24)
            make.top.equalTo(shimmerUserImage.snp.centerY).offset(2)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        iconLike2.snp.makeConstraints { (make) in
            make.left.equalTo(iconLike.snp.right).offset(16)
            make.top.equalTo(shimmerUserImage.snp.centerY).offset(2)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        iconLike3.snp.makeConstraints { (make) in
            make.left.equalTo(iconLike2.snp.right).offset(16)
            make.top.equalTo(shimmerUserImage.snp.centerY).offset(2)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        shimmerUserImage.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.top).offset(16)
            make.left.equalTo(shimmerCard.snp.left).offset(24)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        shimmer.isShimmering = true
    }
}
class StretchyHeaderLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach({ (attribute) in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader && attribute.indexPath.section == 0{
                guard let collectionview = collectionView else {return}
                let contentOffsetY = collectionview.contentOffset.y
                print(contentOffsetY)
                if contentOffsetY > 0 {
                    return
                }
                let width = collectionview.frame.width
                let height = attribute.frame.height
                print(height,"H")
                attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height - contentOffsetY)
            }
        })
        return attributes
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
class baseCell: UICollectionViewCell {
    let lineview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupConst()
    }
    func setupConst() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class Header: UICollectionReusableView {
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(imageHeaderCell.self, forCellWithReuseIdentifier: "imageHeaderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private  lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return pc
    }()
    var homeController:IDTaskViewController!
    var imageArray = [UIImage]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pageControl.numberOfPages = imageArray.count
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        //           backgroundColor = .red
        //           setupConstraitns()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension Header:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count == 0 ? 1 : imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHeaderCell", for: indexPath) as! imageHeaderCell
        cell.imageview.image = imageArray.count == 0 ? #imageLiteral(resourceName: "no-photo") : imageArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUpZoom") as! ZoomPhotoViewController
        //        self.homeController.addChild(popUpVC) // 2
        //        popUpVC.view.frame = self.homeController.view.frame  // 3
        //        self.homeController.view.addSubview(popUpVC.view) // 4
        popUpVC.zoomImage = imageArray[indexPath.row]
        self.homeController.show(popUpVC, sender: self)
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x/collectionView.frame.width)
    }
    
}
class imageHeaderCell: baseCell {
    let imageview:UIImageView = {
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "no-photo")
        //        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    override func setupConst() {
        super.setupConst()
        addSubview(imageview)
        imageview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
class BriefTaskInfoCell: baseCell  {
    private let view:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let taskLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Ремонт Техники"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.text = "Вчера, 19:22"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    let cashLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        label.text = "5500"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let locationLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Алматы"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    override func setupConst() {
        super.setupConst()
        backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        addSubview(view)
        view.addSubview(taskLabel)
        view.addSubview(dateLabel)
        view.addSubview(cashLabel)
        view.addSubview(lineview)
        view.addSubview(locationLabel)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        taskLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
        }
        cashLabel.snp.makeConstraints { (make) in
            make.top.equalTo(taskLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(16)
        }
        lineview.snp.makeConstraints { (make) in
            make.top.equalTo(cashLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
    }
}
class DetailTaskCell: baseCell {
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let descrLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    var horizontalDetailCell = false
    override func setupConst() {
        super.setupConst()
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(descrLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        descrLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
class UserTaskCell:baseCell {
    private let view:UIView = {
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
    let imageView:WebImage = {
        let view = WebImage()
        view.image = #imageLiteral(resourceName: "forBouns")
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
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
    var user:UserInfo? {
        didSet {
            guard let user = user else {return}
            self.nameLabel.text = user.fname == nil ? user.name : user.name! + " " + user.fname!
            self.SumBadIcon.text = String(user.sad!)
            self.SumNormalIcon.text = String(user.neutral!)
            self.SumGoodIcon.text = String(user.happy!)
            let urlString = "https://orzu.org/\(user.avatar!)"
            self.imageView.set(imageUrl: urlString)
            
        }
    }
    override func setupConst() {
        super.setupConst()
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
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        }
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(64)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).offset(8)
            make.left.equalTo(imageView.snp.right).offset(16)
        }
        BadiconLike.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
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
        
    }
}
class HorizontalDetailTaskCell: baseCell {
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let descrLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    override func setupConst() {
        super.setupConst()
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(descrLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(16)
        }
        descrLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(self.snp.centerX).offset(-4)
            make.right.equalToSuperview().offset(-16)
        }
    }
}

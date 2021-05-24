//
//  ReviewsViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//


import UIKit
import MaterialComponents
import SnapKit
import Alamofire
import Shimmer
class ReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let reviewsView: UITableView = {
        let view = UITableView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    let cardView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    let ShimmerCard:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return view
    }()
    
    let buttonsView:UIView = {
        let view = UIView()
        return view
        
    }()
    
    let allLabel:UILabel = {
        let label = UILabel()
        label.text = "Все"
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 13.0)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    let badButtonView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let badButtonLabel:UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let normalButtonLabel:UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let normalButtonView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let goodButtonView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let goodButtonLabel:UILabel = {
        let label = UILabel()
        label.text = "3"
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    let badButton:UIButton = {
        let button = UIButton()
        let myImage = #imageLiteral(resourceName: "badSmile")
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(myImage, for: .normal)
        button.setTitle("My Amazing Button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        //        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.titleLabel?.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        //        button.addTarget(self, action: #selector(didTapOnSeeAllButton), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    let imageIconArray = [#imageLiteral(resourceName: "badSmile"),#imageLiteral(resourceName: "normalSmile"),#imageLiteral(resourceName: "coolSmile")]
    var selectIndex = 0
    let normalButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "normalSmile"), for: .normal)
        button.setTitle("2", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        //        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        //        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.tag = 1
        //        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.titleLabel?.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        return button
    }()
    
    let goodButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "coolSmile"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("My Amazing Button", for: .normal)
        //        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        button.tag = 2
        return button
    }()
    
    
    //    var segmentControl:UISegmentedControl = {
    //        let segment = UISegmentedControl()
    //        return segment
    //    }()
    let shimmerUserImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "profileWhite")
        return view
    }()
    let shimmerTableVIew: UITableView = {
        let table = UITableView()
        table.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        return table
    }()
    
    var arrayReviews = [UserReviews](){
        didSet{
            for i in arrayReviews{
                switch i.like{
                case 0:
                    badMoodArray.append(i)
                case 1:
                    normalMoodArray.append(i)
                case 2:
                    goodMoodArray.append(i)
                default:
                    ()
                }
            }
            goodButtonLabel.text = "\(goodMoodArray.count)"
            normalButtonLabel.text = "\(normalMoodArray.count)"
            badButtonLabel.text = "\(badMoodArray.count)"
        }
    }
    var badMoodArray = [UserReviews]()
    var normalMoodArray = [UserReviews]()
    var goodMoodArray = [UserReviews]()
    var sizeArray = [CGFloat]()
    private var shimmer: FBShimmeringView!
    lazy var resultArray = arrayReviews
    let reviewUrl = "https://orzu.org/api?appid=$2y$12$esyosghhXSh6LxcX17N/suiqeJGJq/VQ9QkbqvImtE4JMWxz7WqYS&opt=reviews&act=view&userid="
    var id = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5843137255, green: 0.7725490196, blue: 0.2, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Отзывы"
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        shimmerTableVIew.delegate = self
        shimmerTableVIew.dataSource = self
        shimmerTableVIew.separatorStyle = .none
        shimmerTableVIew.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        
        reviewsView.delegate = self
        reviewsView.dataSource = self
        reviewsView.separatorStyle = .none
        
        configureSegmentController()
        createViews()
        reviewsView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        allLabel.addGestureRecognizer(tap)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)){
            self.shimmer.isShimmering = false
            self.shimmer.isHidden = true
            self.shimmerTableVIew.isHidden = true
            self.reviewsView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        allLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        goodButtonView.backgroundColor = .white
        normalButtonView.backgroundColor = .white
        
        badButtonView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        resultArray = arrayReviews
        sizeArray.removeAll()
        arrayReviews.forEach { (review) in
            let size = UILabel().heightForLabel(text: review.narrative ?? "heightSize", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 100)
            sizeArray.append(size)
        }
        DispatchQueue.main.async {
            self.reviewsView.reloadData()
        }
    }
    
    @objc func sortAction(_ sender: UIButton) {
        selectIndex = sender.tag
        switch sender.tag {
        case 0:
            allLabel.backgroundColor = .white
            goodButtonView.backgroundColor = .white
            normalButtonView.backgroundColor = .white
            badButtonView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            resultArray = badMoodArray
            sizeArray.removeAll()
            badMoodArray.forEach { (review) in
                let size = UILabel().heightForLabel(text: review.narrative ?? "heightSize", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 100)
                sizeArray.append(size)
            }
            DispatchQueue.main.async {
                self.reviewsView.reloadData()
            }
        case 1:
            allLabel.backgroundColor = .white
            goodButtonView.backgroundColor = .white
            normalButtonView.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            badButtonView.backgroundColor = .white
            resultArray = normalMoodArray
            sizeArray.removeAll()
            normalMoodArray.forEach { (review) in
                let size = UILabel().heightForLabel(text: review.narrative ?? "heightSize", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 100)
                sizeArray.append(size)
            }
            DispatchQueue.main.async {
                self.reviewsView.reloadData()
            }
        case 2:
            allLabel.backgroundColor = .white
            goodButtonView.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            normalButtonView.backgroundColor = .white
            badButtonView.backgroundColor = .white
            resultArray = goodMoodArray
            sizeArray.removeAll()
            goodMoodArray.forEach { (review) in
                let size = UILabel().heightForLabel(text: review.narrative ?? "heightSize", font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width - 100)
                sizeArray.append(size)
            }
            DispatchQueue.main.async {
                self.reviewsView.reloadData()
            }
        default:
            break
        }
        
    }
    func configureSegmentController() {
        //                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        //                let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        //                navigationController?.navigationBar.titleTextAttributes = textAttributes
        badButton.addTarget(self, action: #selector(sortAction(_:)), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(sortAction(_:)), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(sortAction(_:)), for: .touchUpInside)
        
        //        backBtn.addTarget(self, action: #selector(backButtonFunc(_:)), for: .touchUpInside)
    }
    
    
    
    func createViews() {
        
        self.view.addSubview(cardView)
        self.view.addSubview(buttonsView)
        
        cardView.addSubview(shimmerTableVIew)
        cardView.addSubview(reviewsView)
        buttonsView.addSubview(allLabel)
        buttonsView.addSubview(badButtonView)
        buttonsView.addSubview(normalButtonView)
        buttonsView.addSubview(goodButtonView)
        goodButtonView.addSubview(goodButton)
        goodButtonView.addSubview(goodButtonLabel)
        normalButtonView.addSubview(normalButton)
        normalButtonView.addSubview(normalButtonLabel)
        badButtonView.addSubview(badButton)
        badButtonView.addSubview(badButtonLabel)
        shimmerTableVIew.isHidden = false
        reviewsView.isHidden = true
        shimmerTableVIew.register(ReviewShimmerCell.self, forCellReuseIdentifier: "shimmerReview")
        reviewsView.register(AllReviews.self, forCellReuseIdentifier: "allreview")
        shimmer = FBShimmeringView(frame: shimmerTableVIew.frame)
        cardView.addSubview(shimmer)
        shimmer.contentView = shimmerTableVIew
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonsView.snp.top).offset(64)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(reviewsView.snp.bottom)
        }
        buttonsView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(32)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(35)
        }
        
        
        allLabel.snp.makeConstraints { (make) in
            make.top.equalTo(normalButtonView.snp.top)
            make.right.equalTo(self.badButton.snp.left).offset(-30)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        normalButtonView.snp.makeConstraints { (make) in
            make.centerY.equalTo(buttonsView.snp.centerY)
            make.centerX.equalTo(buttonsView.snp.centerX).offset(22)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        badButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(normalButtonView.snp.top)
            make.right.equalTo(normalButtonView.snp.left).offset(-12)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        goodButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(normalButtonView.snp.top)
            make.left.equalTo(normalButtonView.snp.right).offset(12)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        badButtonLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(badButtonView.snp.centerY)
            make.right.equalTo(badButton.snp.left).offset(-2)
            make.size.equalTo(CGSize(width: 10, height: 15))
        }
        badButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(badButtonView.snp.centerY)
            make.right.equalTo(self.badButtonView.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 25))
        }
        
        normalButtonLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(normalButtonView.snp.centerY)
            make.right.equalTo(normalButton.snp.left).offset(-2)
            make.size.equalTo(CGSize(width: 10, height: 15))
        }
        normalButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(normalButtonView.snp.centerY)
            make.right.equalTo(self.normalButtonView.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 25))
        }
        
        
        goodButtonLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(goodButtonView.snp.centerY)
            make.right.equalTo(goodButton.snp.left).offset(-2)
            make.size.equalTo(CGSize(width: 10, height: 15))
        }
        goodButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(goodButtonView.snp.centerY)
            make.right.equalTo(self.goodButtonView.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 25))
        }
        
        
        reviewsView.snp.makeConstraints { (make) in
            make.top.equalTo(cardView.snp.top).offset(16)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        shimmerTableVIew.snp.makeConstraints { (make) in
            make.top.equalTo(buttonsView.snp.bottom).offset(30)
            make.left.equalTo(cardView.snp.left)
            make.right.equalTo(cardView.snp.right)
            make.height.equalTo(cardView.snp.height).multipliedBy(0.95)
        }
        shimmer.snp.makeConstraints { (make) in
            make.edges.equalTo(shimmerTableVIew)
        }
        shimmer.isShimmering = true
        
    }
    func emptyView() -> UIView {
        let empty = UIView()
        let image = UIImageView()
        image.image = UIImage(named: "noResultColor")
        image.contentMode = .scaleAspectFit
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Вы пока не создали"
        self.view.addSubview(empty)
        empty.addSubview(image)
        empty.addSubview(label)
        empty.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.3)
        }
        image.snp.makeConstraints { (make) in
            make.top.equalTo(empty.snp.top)
            make.centerX.equalTo(empty.snp.centerX)
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.centerX.equalTo(image.snp.centerX)
        }
        return empty
    }
    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reviewsView{
            if resultArray.count == 0{
                
            }else{
                tableView.restoreView()
            }
            return resultArray.count
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reviewsView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "allreview", for: indexPath) as! AllReviews
            cell.reviews = resultArray[indexPath.row]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shimmerReview", for: indexPath) as! ReviewShimmerCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == reviewsView {
            return sizeArray[indexPath.row] < 20 ? 70 : 70 + sizeArray[indexPath.row] + 8
        } else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
class AllReviews: UITableViewCell {
    let image1: WebImage = {
        let image = WebImage()
        image.layer.cornerRadius = 18
        image.clipsToBounds = true
        image.image = UIImage(named: "profileWhite")
        return image
    }()
    let iconLike: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "coolSmile")
        return image
    }()
    let aboutMe:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 15.0)
        return label
    }()
    
    let descrMe: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 12.0)
        label.numberOfLines = 0
        return label
    }()
    
    
    let sumLike:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name:"AppleSDGothicNeo-Light", size: 14.0)
        return label
    }()
    var reviews:UserReviews? {
        didSet {
            guard let reviews = reviews,let imageUrl = reviews.avatar else {return}
            self.aboutMe.text = reviews.username
            //            let dateFormatterGet = DateFormatter()
            //            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //            if let date = dateFormatterGet.date(from: resultArray[indexPath.row].datein) {
            //                cell.dateRev.text = formatter.string(from: date)
            //            }
            self.descrMe.text = reviews.narrative
            if reviews.like == 0 {
                self.iconLike.image = #imageLiteral(resourceName: "redBad")
            } else if reviews.like == 1 {
                self.iconLike.image = #imageLiteral(resourceName: "brownNormal")
            } else {
                self.iconLike.image = #imageLiteral(resourceName: "greenGood")
            }
            self.image1.set(imageUrl: "https://orzu.org\(imageUrl)")
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image1)
        addSubview(aboutMe)
        addSubview(iconLike)
        addSubview(sumLike)
        
        addSubview(descrMe)
        self.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9764705882, alpha: 1)
        configureViews()
    }
    func configureViews() {
        image1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        aboutMe.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.equalTo(image1.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
        }
        descrMe.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.bottom).offset(8)
            make.left.equalTo(aboutMe.snp.left)
            make.right.equalToSuperview().offset(-24)
        }
        iconLike.snp.makeConstraints { (make) in
            make.top.equalTo(aboutMe.snp.top)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        sumLike.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconLike.snp.centerY)
            make.right.equalTo(iconLike.snp.left).offset(-3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


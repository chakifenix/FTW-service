//
//  Welcome_ViewController.swift
//  newOrzu
//
//  Created by MacOs User on 6/11/19.
//  Copyright © 2019 MacOs User. All rights reserved.
//

import UIKit

class Welcome_ViewController: UIViewController , UIScrollViewDelegate{
    
    
    @IBOutlet weak var bagroundImage: UIImageView!
    @IBOutlet weak var PageView: UIScrollView!
        {
        didSet{
            PageView.delegate = self
        }
        
    }
    @IBOutlet weak var Pages: UIPageControl!
    @IBOutlet weak var Next_Button: UIButton!
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        Pages.numberOfPages = slides.count
        Pages.currentPage = 0
        view.bringSubviewToFront(Pages)
        
        Next_Button.layer.cornerRadius = 4
        Next_Button.layer.borderWidth = 1
        Next_Button.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.Image_Slider.image = UIImage(named: "1-1")
        slide1.bagImage.image = UIImage(named: "2-1")
        slide1.Title_Slider.text = "1.Создайте задачу"
        slide1.Ditayl_Slider.text = "Расскажите нам, что нужно для вас сделать. Укажите время, место и описание."
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.bagImage.image = UIImage(named: "2")
        slide2.Image_Slider.image = UIImage(named: "2-1")
        slide2.Title_Slider.text = "2.Выберите исполнителя"
        slide2.Ditayl_Slider.text = "Предлоежение от доверенных исполнителей. Выберите подходящего человека по отзывам и цене для работы."
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.bagImage.image = UIImage(named: "3")
        slide3.Image_Slider.image = UIImage(named: "3-1")
        slide3.Title_Slider.text = "3.Задача выполнена"
        slide3.Ditayl_Slider.text = "Ваш исполнитель прибывает и выполняет свою работу. Оплачивайте через безопасную сделку."
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        PageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        PageView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        PageView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            PageView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        
        Pages.currentPage = Int(pageIndex)
        
        switch Int(pageIndex){
        case 0:
            self.Next_Button.setTitle("Дальше", for: .normal)
            bagroundImage.image = UIImage(named: "1")
            break
        case 1:
            self.Next_Button.setTitle("Дальше", for: .normal)
            bagroundImage.image = UIImage(named: "2")
            break
        case 2:
            self.Next_Button.setTitle("Дальше", for: .normal)
            bagroundImage.image = UIImage(named: "3")
            break
        default:
            self.Next_Button.setTitle("Дальше", for: .normal)
            break
        }
        
    }
    
    @IBAction func Action_Next_Button(_ sender: UIButton) {
        if self.Pages.currentPage < slides.count-1{
            UIView.animate(withDuration: 0.3) {
                self.Pages.currentPage += 1
                self.PageView.contentOffset.x += self.view.frame.width
                if self.Pages.currentPage == self.slides.count-1{
                    self.Next_Button.setTitle("Начать", for: .normal)
                }
            }
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginPage")
            self.present(controller, animated: true, completion: nil)
        }
    }
}

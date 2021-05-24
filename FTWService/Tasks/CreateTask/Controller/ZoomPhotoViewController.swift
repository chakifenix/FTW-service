//
//  ZoomPhotoViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class ZoomPhotoViewController: UIViewController,UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageForZoom: UIImageView!
    var zoomImage:UIImage?
    var get = "" {
        didSet{
            print(get)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = .black
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        //        navigationController?.navigationBar.tintColor = .white
        
        
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        navigationController?.navigationBar.barTintColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageForZoom.image = zoomImage
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        // Do any additional setup after loading the view.
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageForZoom
    }
    
    
    
}

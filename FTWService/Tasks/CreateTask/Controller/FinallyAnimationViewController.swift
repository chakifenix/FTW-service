//
//  FinallyAnimationViewController.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit
import Lottie
class FinallyAnimationViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageviewSettings()
        self.view.backgroundColor = .white
    }
    
    
    func imageviewSettings() {
        animationView.animation = Animation.named("1")
        animationView.play()
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        let controller = TabBarViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}

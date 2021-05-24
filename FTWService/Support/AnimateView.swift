//
//  AnimateView.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class AnimateView:UIView{
    enum Direction:Int{
        case fromDown = 0
        case fromTop = 1
    }
    
    var bool = true
    @IBInspectable var direction = 0
    
    override func layoutSubviews() {
        print(1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 35
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        if (bool){
            bool = false
            initAnim()
            UIView.animateKeyframes(withDuration: 0.8, delay: 0.0, animations: {
                if let s = self.superview{
                    if self.direction == Direction.fromDown.rawValue{
                        self.center.y -= s.bounds.height
                    }else{
                        self.center.y += s.bounds.height
                    }
                }
            }, completion: nil)
        }
    }
    
    
    
    
    func initAnim(){
        if let s = self.superview{
            if direction == Direction.fromDown.rawValue{
                self.center.y += s.bounds.height
            }else{
                self.center.y -= s.bounds.height
            }
        }
    }
}


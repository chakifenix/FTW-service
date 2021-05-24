//
//  CellModel.swift
//  newOrzu
//
//  Created by MacOs User on 11/21/19.
//  Copyright © 2019 Orzu. All rights reserved.
//

import UIKit

class CellModel{
   
    let cell:Int
    //    let label:String?
    //    let image:UIImage?
    let firstCellModel:FirstCellModel?
    let secondCellModel:SecondCellModel?
//    let thirdCellModel:ThirdCellModel?
//    let fourthCellModel:FourthCellModel?
//    let fivethCellModel:FivethCellModel?
    
    init(firstCell:FirstCellModel,cell:Int) {
        self.firstCellModel = firstCell
        self.secondCellModel = nil
        self.cell = cell
//        self.thirdCellModel = nil
//        self.fourthCellModel = nil
//        self.fivethCellModel = nil
    }
    init(secondCell:SecondCellModel,cell:Int) {
        self.secondCellModel = secondCell
        self.firstCellModel = nil
        self.cell = cell
//        self.thirdCellModel = nil
//        self.fourthCellModel = nil
//        self.fivethCellModel = nil
    }
//    init(thirdCell:ThirdCellModel,cell:Int) {
//        self.secondCellModel = nil
//        self.firstCellModel = nil
//        self.cell = cell
////        self.thirdCellModel = thirdCell
////        self.fourthCellModel = nil
////        self.fivethCellModel = nil
//    }
//
//    init(fourthCell:FourthCellModel,cell:Int) {
//        self.secondCellModel = nil
//        self.firstCellModel = nil
//        self.cell = cell
//        self.thirdCellModel = nil
//        self.fourthCellModel = fourthCell
//        self.fivethCellModel = nil
//    }
//
//    init(fivethCell:FivethCellModel,cell:Int) {
//        self.secondCellModel = nil
//        self.firstCellModel = nil
//        self.cell = cell
//        self.thirdCellModel = nil
//        self.fourthCellModel = nil
//        self.fivethCellModel = fivethCell
//
//    }
}


struct FirstCellModel{
    let label:String
    let time:String
    let city:String
    let title:String
    
}

struct SecondCellModel {
    let label:String
    let time:String
    let city:String
}

struct ThirdCellModel {
    var g = 0
}

struct FourthCellModel {
    var g = "AAA"
}

struct FivethCellModel{
    var g = 5
}


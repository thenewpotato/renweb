//
//  GradeColorPicker.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/12/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import UIKit

class GradeColorPicker {
    
    let green = UIColor(red: 80.0 / 255.0, green: 160.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    let yellow = UIColor.orange
    let red = UIColor.red
    
    init() {}
    
    func getColor(letterGrade: String) -> UIColor {
        if (letterGrade.prefix(1) == "A") || (letterGrade == "B+") || (letterGrade == "P") {
            return green
        } else if (letterGrade.prefix(1) == "B") || (letterGrade.prefix(1) == "C") {
            return yellow
        } else if (letterGrade.prefix(1) == "D") || (letterGrade.prefix(1) == "F"){
            return red
        } else {
            return green
        }
    }
    
    func getColor(numericalGrade: String) -> UIColor {
        if numericalGrade == "" {
            return green
        } else if Float(numericalGrade)! > 87 {
            return green
        } else if Float(numericalGrade)! > 69.45 {
            return yellow
        } else {
            return red
        }
    }
    
}

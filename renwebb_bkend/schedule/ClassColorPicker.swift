//
//  ClassColorPicker.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/9/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import UIKit

class ClassColorPicker {
    
    let colors = [
        UIColor.blue.cgColor,
        UIColor.purple.cgColor,
        UIColor(red: 204.0 / 255.0, green: 51.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor, // reddish pink
        UIColor.red.cgColor,
        UIColor.brown.cgColor,
        UIColor.orange.cgColor,
        UIColor(red: 80.0 / 255.0, green: 160.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0).cgColor, // dark green
        UIColor.cyan.cgColor]
    var defaults: UserDefaults
    
    init() {
        defaults = UserDefaults.standard
        
    }
    
    func getColor(classCode: String) -> CGColor {
        // it doesn't seem like default.integer has the optional type in case that no values are set... thus using defaults.string then converting to int for now
        if let colorIndex = defaults.string(forKey: classCode) {
            return colors[Int(colorIndex)!]
        } else {
            defaults.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        }
    }
    
}

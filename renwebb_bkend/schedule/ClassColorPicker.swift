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
    
    var colors = [
        UIColor.blue,
        UIColor.purple,
        UIColor(red: 204.0 / 255.0, green: 51.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), // reddish pink
        UIColor.red,
        UIColor.brown,
        UIColor.orange,
        UIColor(red: 80.0 / 255.0, green: 160.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0), // dark green
        UIColor(red: 0.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0), // cyan
        UIColor(red: 0.0 / 255.0, green: 102.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0),
        UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0),
        UIColor(red: 102.0 / 255.0, green: 153.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)]
    var defaults: UserDefaults
    var counter = 0
    
    // one ClassColorPicker object PER (SCHEDULE), NOT (SCHEDULE CLASS)
    init() {
        defaults = UserDefaults.standard
        colors.shuffle()
    }
    
    func autoSetColor(classCode: String){
        let color = colors[counter]
        let encodedColorData = NSKeyedArchiver.archivedData(withRootObject: color)
        defaults.set(encodedColorData, forKey: classCode)
        counter += 1
    }
    
    func changeColor(classCode: String, color: UIColor) {
        let encodedColorData = NSKeyedArchiver.archivedData(withRootObject: color)
        defaults.set(encodedColorData, forKey: classCode)
    }
    
    func deleteColor(classCode: String) {
        defaults.set(nil, forKey: classCode)
    }
    
    func getColor(classCode: String) -> UIColor?{
        if let encodedColorData = defaults.object(forKey: classCode) as? Data {
            let decodedColor = NSKeyedUnarchiver.unarchiveObject(with: encodedColorData)
            return decodedColor as? UIColor
        } else {
            autoSetColor(classCode: classCode)
            return getColor(classCode: classCode)
        }
    }
    
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

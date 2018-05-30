//
//  ClassGrade.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/29/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation

class ClassGrade {
    
    var className: String
    var termGrade: String
    var termLetter: String
    var categories: [GradeCategory]
    
    init() {
        className = ""
        termGrade = ""
        termLetter = ""
        categories = []
    }
    
    init(className: String, termGrade: String, termLetter: String, categories: [GradeCategory]) {
        self.className = className
        self.termGrade = termGrade
        self.termLetter = termLetter
        self.categories = categories
    }
    
}

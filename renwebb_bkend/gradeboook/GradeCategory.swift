//
//  GradeCategory.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/29/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation

class GradeCategory {
    
    var name: String
    var categoryAverage: String
    var weight: String
    var assignments: [GradeAssignment]
    
    init() {
        name = ""
        categoryAverage = ""
        weight = ""
        assignments = []
    }
    
    init(name: String, average: String, weight: String, assignments: [GradeAssignment]) {
        self.name = name
        categoryAverage = average
        self.weight = weight
        self.assignments = assignments
    }
    
}

//
//  GradeAssignment.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/29/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation

class GradeAssignment {
    
    var name: String
    var points: String
    var max: String
    var average: String
    var status: GradebookAssignmentStatus
    var date: String
    
    init() {
        name = ""
        points = ""
        max = ""
        average = ""
        status = GradebookAssignmentStatus.valid
        date = ""
    }
    
    init(name: String, points: String, max: String, average: String, status: GradebookAssignmentStatus, date: String) {
        self.name = name
        self.points = points
        self.max = max
        self.average = average
        self.status = status
        self.date = date
    }
    
}

//
//  GradebookViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/20/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded GradebookViewController");
        let gradebook = Gradebook(gradebookUrls: ["http://focused-agnesi-78c2b4.bitballoon.com/", "http://musing-swirles-49f0d8.bitballoon.com/", "http://confident-sinoussi-b711b8.bitballoon.com/", "http://reverent-mcnulty-b4dc9e.bitballoon.com/"])
        gradebook.getGrades(completion: { gradeEntries in
            if gradeEntries != nil {
                for gradeEntry in gradeEntries! {
                    print(gradeEntry.className + "\n")
                    print(gradeEntry.termGrade)
                    print(gradeEntry.termLetter)
                    for category in gradeEntry.categories {
                        print(category.name)
                        print(category.weight)
                        for assignment in category.assignments {
                            print(assignment.name)
                            print(assignment.points)
                            print(assignment.max)
                            print(assignment.average)
                            print(assignment.date)
                            print(assignment.status)
                        }
                    }
                    print("\n")
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

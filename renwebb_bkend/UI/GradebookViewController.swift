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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonOnClick(_ sender: UIButton) {
        let gradebook = Gradebook(gradebookUrls: ["http://confident-liskov-306c03.bitballoon.com/", "http://musing-payne-5fe142.bitballoon.com/", "http://naughty-jones-1c6e25.bitballoon.com/", "http://romantic-clarke-0497a3.bitballoon.com/"])
        gradebook.getGrades(completion: { gradeEntries in
            if gradeEntries != nil {
                for gradeEntry in gradeEntries! {
                    print(gradeEntry.className + "\n")
                    print(gradeEntry.termGrade)
                    print(gradeEntry.termLetter)
                    for category in gradeEntry.categories {
                        print(category.name)
                        print(category.weight)
                        print(category.categoryAverage)
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

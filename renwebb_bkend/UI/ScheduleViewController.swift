//
//  ScheduleViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/20/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var schedule: Schedule?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded ScheduleViewController")
        schedule = Schedule(scheduleUrl: Login.scheduleURL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        schedule!.getDay(date: formatter.date(from: "2018-02-13")!, completion: { classes in
            for classEntry in classes {
                print("m " + classEntry.name)
                print("m " + classEntry.time)
                print("m " + classEntry.loc)
                print("m " + classEntry.HW)
                print("m " + classEntry.CW)
                print("\n")
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

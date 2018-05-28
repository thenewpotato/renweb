//
//  ScheduleViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/20/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded ScheduleViewController")
        let schedule = Schedule(url: Login.scheduleURL, date: Date())
        schedule.getDay(completion: { (classes) -> (Void) in
            for classEntry in classes {
                print(classEntry.name)
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

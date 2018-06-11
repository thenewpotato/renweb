//
//  SchedulePageViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/10/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class SchedulePageViewController: UIPageViewController {

    var dateOfCurrentPage: Date?
    var schedule: Schedule?
    let formatter = DateFormatter()
    let formatterForUi = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatterForUi.dateFormat = "EEEE, MMM. dd"
        
        schedule = Schedule(scheduleUrl: Login.scheduleURL)
        
        formatter.dateFormat = "yyyy-MM-dd"
        dateOfCurrentPage = formatter.date(from: "2018-02-15")
        dataSource = self
        let todayView = storyboard?.instantiateViewController(withIdentifier: "scheduleTableViewController") as! ScheduleTableViewController
        todayView.initialize(date: dateOfCurrentPage, schedule: schedule)
        setViewControllers([todayView], direction: .forward, animated: true, completion: nil)
        self.navigationItem.title = formatterForUi.string(from: dateOfCurrentPage!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonYesterday(_ sender: Any) {
        dateOfCurrentPage = Calendar.current.date(byAdding: .day, value: -1, to: dateOfCurrentPage!)
        let yesterdayView = storyboard?.instantiateViewController(withIdentifier: "scheduleTableViewController") as! ScheduleTableViewController
        yesterdayView.initialize(date: dateOfCurrentPage, schedule: schedule)
        setViewControllers([yesterdayView], direction: .reverse, animated: true, completion: nil)
        self.navigationItem.title = formatterForUi.string(from: dateOfCurrentPage!)
    }
    
    @IBAction func buttonTomorrow(_ sender: Any) {
        dateOfCurrentPage = Calendar.current.date(byAdding: .day, value: 1, to: dateOfCurrentPage!)
        let tomorrowView = storyboard?.instantiateViewController(withIdentifier: "scheduleTableViewController") as! ScheduleTableViewController
        tomorrowView.initialize(date: dateOfCurrentPage, schedule: schedule)
        setViewControllers([tomorrowView], direction: .forward, animated: true, completion: nil)
        self.navigationItem.title = formatterForUi.string(from: dateOfCurrentPage!)
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

extension SchedulePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}

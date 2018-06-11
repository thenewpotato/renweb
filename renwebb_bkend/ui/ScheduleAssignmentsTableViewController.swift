//
//  ScheduleAssignmentsTableViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/11/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleAssignmentsTableViewController: UITableViewController {
    
    let cellIdentifier = "ScheduleAssignmentsTableViewCell"
    var classSchedule: ClassSchedule?
    
    func initialize(classSchedule: ClassSchedule) {
        self.classSchedule = classSchedule
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded ScheduleAssignmentsTableViewController")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 2
        if classSchedule?.CW == "" {
            count -= 1
        }
        if classSchedule?.HW == "" {
            count -= 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleAssignmentsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        // MARK: configure the cell...
        
        cell.ViewContainer.layer.cornerRadius = 8
        cell.ViewContainer.layer.masksToBounds = true
        cell.ViewContainer.layer.backgroundColor = classSchedule?.color
        
        cell.labelClassName.text = classSchedule?.name
        
        if indexPath.row == 0 {
            cell.labelAssignmentType.text = "Lesson Plans"
            cell.labelAssignmentBody.text = classSchedule?.CW
        } else if indexPath.row == 1 {
            cell.labelAssignmentType.text = "Homework"
            cell.labelAssignmentBody.text = classSchedule?.HW
        }
        
        let shadowPath = UIBezierPath(rect: cell.ViewContainer.bounds)
        cell.ViewShadow.layer.masksToBounds = false
        cell.ViewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        cell.ViewShadow.layer.shadowColor = UIColor.black.cgColor
        cell.ViewShadow.layer.shadowOpacity = 0.1
        cell.ViewShadow.layer.shadowPath = shadowPath.cgPath

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

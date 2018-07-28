//
//  ScheduleTableViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/7/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController, ColorChangeDelegate {
    
    let cellIdentifier = "ScheduleTableViewCell"
    var schedule: Schedule?
    var date: Date?
    var classes = [ClassSchedule]()
    
    func initialize(date: Date?, schedule: Schedule?) {
        self.date = date
        self.schedule = schedule
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded ScheduleTableViewController")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Shows overlay activity indicator
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        schedule!.getDay(date: date!, completion: { newClasses in
            self.dismiss(animated: false, completion: nil)
            self.classes.append(contentsOf: newClasses)
            let indexPaths = (self.classes.count - newClasses.count ..< self.classes.count)
                .map { IndexPath(row: $0, section: 0) }
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        })
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
        return classes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        let scheduleClass = classes[indexPath.row]
        

        // MARK: configure the cell...
        cell.ViewContainer.layer.cornerRadius = 8
        cell.ViewContainer.layer.masksToBounds = true
        cell.ViewContainer.layer.backgroundColor = scheduleClass.color
        
        let shadowPath = UIBezierPath(rect: cell.ViewShadow.bounds)
        cell.ViewShadow.layer.masksToBounds = false
        cell.ViewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        cell.ViewShadow.layer.shadowColor = UIColor.black.cgColor
        cell.ViewShadow.layer.shadowOpacity = 0.1
        cell.ViewShadow.layer.shadowPath = shadowPath.cgPath

        cell.LabelClassName.numberOfLines = 1
        cell.LabelClassName.text = scheduleClass.name
        cell.LabelClassLoc.text = scheduleClass.loc
        cell.LabelClassTime.text = scheduleClass.time
        cell.LabelClassAssignments.text = "→"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell else {
            fatalError("The retrieved cell is not an instance of ScheduleTableViewCell.")
        }
        UIView.animate(withDuration: 0.0001, animations: {
            cell.ViewContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell.ViewShadow.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        })
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell else {
            fatalError("The retrieved cell is not an instance of ScheduleTableViewCell.")
        }
        UIView.animate(withDuration: 0.05, animations: {
            cell.ViewContainer.transform = CGAffineTransform.identity
            cell.ViewShadow.transform = CGAffineTransform.identity
        }, completion: { _ in
            // Presents HW/CW assignments view within the tab bar and the navigation bar
            let classToPresent = self.classes[indexPath.row]
            if (classToPresent.CW != "") || (classToPresent.HW != "") {
                let scheduleAssignmentsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "scheduleAssignmentsTableViewController") as! ScheduleAssignmentsTableViewController
                scheduleAssignmentsTableViewController.initialize(classSchedule: classToPresent)
                scheduleAssignmentsTableViewController.delegate = self
                self.navigationController?.pushViewController(scheduleAssignmentsTableViewController, animated: true)
            } else {
                let emptyViewController = self.storyboard?.instantiateViewController(withIdentifier: "emptyViewController") as! EmptyViewController
                emptyViewController.initialize(classSchedule: classToPresent)
                emptyViewController.delegate = self
                self.navigationController?.pushViewController(emptyViewController, animated: true)
            }
        
            
        })
    }
    
    // MARK: - ColorChangeDelegate method
    
    func colorChanged(color: UIColor, name: String) {
        tableView.reloadData()
        var picker = ClassColorPicker()
        picker.changeColor(classCode: name, color: color)
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

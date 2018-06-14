//
//  GradebookTableViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/7/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookTableViewController: UITableViewController {
    
    let cellIdentifier = "gradebookTableViewCell"
    let allAssignmentsNormalMessage = "All assignments normal →"
    let someAssignmentsAbormalMessage = " assignments are missing →"
    weak var delegate: GradebookCategoryPageViewControllerDelegate?
    var gradebook: Gradebook?
    var gradeColorPicker: GradeColorPicker?
    var grades = [ClassGrade]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded GradebookTableViewController")
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

        gradebook = Gradebook(gradebookUrls: ["https://thenewpotato.github.io/renwebb/0.html", "https://thenewpotato.github.io/renwebb/1.html", "https://thenewpotato.github.io/renwebb/2.html", "https://thenewpotato.github.io/renwebb/3.html", "https://thenewpotato.github.io/renwebb/4.html", "https://thenewpotato.github.io/renwebb/5.html"])
        gradeColorPicker = GradeColorPicker()
        gradebook!.getGrades(completion: { newGrades in
            self.dismiss(animated: true, completion: nil)
            self.grades.append(contentsOf: newGrades!)
            let indexPaths = (self.grades.count - newGrades!.count ..< self.grades.count)
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
        return grades.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("making cell...")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GradebookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GradebookTableViewCell.")
        }
        let grade = grades[indexPath.row]

        // MARK: configure the cell...
        cell.ViewContainer.layer.cornerRadius = 8
        cell.ViewContainer.layer.masksToBounds = true
        cell.ViewContainer.layer.backgroundColor = gradeColorPicker?.getColor(letterGrade: grade.termLetter).cgColor
        
        let shadowPath = UIBezierPath(rect: cell.ViewShadow.bounds)
        cell.ViewShadow.layer.masksToBounds = false
        cell.ViewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        cell.ViewShadow.layer.shadowColor = UIColor.black.cgColor
        cell.ViewShadow.layer.shadowOpacity = 0.1
        cell.ViewShadow.layer.shadowPath = shadowPath.cgPath
        
        cell.labelClassName.numberOfLines = 1
        cell.labelClassName.text = grade.className
        cell.labelNumericalGrade.text = grade.termGrade
        cell.labelLetterGrade.text = grade.termLetter
        
        var abnormalAssignments = 0
        for category in grade.categories {
            for assignment in category.assignments {
                if assignment.status == GradebookAssignmentStatus.missing {
                    abnormalAssignments += 1
                }
            }
        }
        if abnormalAssignments > 0 {
            cell.labelNavigation.text = String(abnormalAssignments) + someAssignmentsAbormalMessage
        } else {
            cell.labelNavigation.text = allAssignmentsNormalMessage
        }

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
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GradebookTableViewCell else {
            fatalError("The retrieved cell is not an instance of GradebookTableViewCell.")
        }
        UIView.animate(withDuration: 0.0001, animations: {
            cell.ViewContainer.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            cell.ViewShadow.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        })
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GradebookTableViewCell else {
            fatalError("The retrieved cell is not an instance of GradebookTableViewCell.")
        }
        UIView.animate(withDuration: 0.05, animations: {
            cell.ViewContainer.transform = CGAffineTransform.identity
            cell.ViewShadow.transform = CGAffineTransform.identity
        }, completion: { _ in
            // Presents categories
            let classToPresent = self.grades[indexPath.row]
            let gradebookCategoryPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "gradebookCategoryPageViewController") as? GradebookCategoryPageViewController
            self.delegate = gradebookCategoryPageViewController
            self.delegate?.didInstantiateController(classToPresent: classToPresent)
            self.navigationController?.pushViewController(gradebookCategoryPageViewController!, animated: true)
        })
    }

}

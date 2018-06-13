//
//  GradebookCategoriesTableViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/12/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookCategoriesTableViewController: UITableViewController {
    
    let cellIdentifier = "gradebookCategoriesTableViewCell"
    var gradeColorPicker: GradeColorPicker?
    var gradeClass: ClassGrade?
    
    func initialize(gradeClass: ClassGrade) {
        self.gradeClass = gradeClass
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded GradebookCategoriesTableViewController")
        gradeColorPicker = GradeColorPicker()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return gradeClass!.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GradebookCategoriesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GradebookCategoriesTableViewCell.")
        }
        let category = gradeClass!.categories[indexPath.row]
        
        // MARK: configure the cell...
        
        cell.ViewContainer.layer.cornerRadius = 8
        cell.ViewContainer.layer.masksToBounds = true
        cell.ViewContainer.layer.backgroundColor = gradeColorPicker?.getColor(numericalGrade: category.categoryAverage).cgColor
        
        cell.labelClassName.text = gradeClass?.className
        cell.labelCategoryName.text = category.name
        cell.labelWeight.text = category.weight
        cell.labelCategoryAverage.text = category.categoryAverage
        
        // TODO: Shadow implementation in GradebookCategoriesTableCell
        
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

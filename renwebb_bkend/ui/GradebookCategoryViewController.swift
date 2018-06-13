//
//  GradebookCategoryViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/13/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookCategoryViewController: UIViewController, GradebookCategoryViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelClassName: UILabel!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelCategoryWeight: UILabel!
    @IBOutlet weak var labelCategoryAverage: UILabel!
    @IBOutlet weak var labelAssignmentStatus: UILabel!
    @IBOutlet weak var tableViewAssignments: UITableView!
    let tableViewAssignmentsCellIdentifier = "gradebookAssignmentTableCell"
    var categoryToPresent = GradeCategory()
    var className: String?
    
    // Delegate method
    func didInstantiateController(categoryToPresent: GradeCategory, className: String) {
        self.categoryToPresent = categoryToPresent
        self.className = className
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContainer.layer.cornerRadius = 8
        viewContainer.layer.masksToBounds = true
        viewContainer.layer.backgroundColor = GradeColorPicker().getColor(numericalGrade: categoryToPresent.categoryAverage).cgColor
        
        let shadowPath = UIBezierPath(rect: viewShadow.bounds)
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOpacity = 0.1
        viewShadow.layer.shadowPath = shadowPath.cgPath
        
        labelClassName.text = className
        labelCategoryName.text = categoryToPresent.name
        labelCategoryWeight.text = categoryToPresent.weight
        labelCategoryAverage.text = categoryToPresent.categoryAverage
        
        tableViewAssignments.delegate = self
        tableViewAssignments.dataSource = self
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
    
    // MARK: tableViewAssignments delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryToPresent.assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewAssignmentsCellIdentifier, for: indexPath) as? GradebookAssignmentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GradebookAssignmentTableViewCell.")
        }
        let assignment = categoryToPresent.assignments[indexPath.row]
        
        // MARK: configure the cell...
        cell.labelAssignmentName.text = assignment.name
        
        return cell
    }
    

}

protocol GradebookCategoryViewControllerDelegate: class {
    // This delegate handles the information passing from GradebookCategoryPageVC to GradebookCategoryVC
    func didInstantiateController(categoryToPresent: GradeCategory, className: String)
}

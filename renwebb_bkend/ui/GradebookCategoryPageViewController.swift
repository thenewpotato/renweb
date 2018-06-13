//
//  GradebookCategoryPageViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/13/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookCategoryPageViewController: UIPageViewController, GradebookCategoryPageViewControllerDelegate {
    
    weak var gradebookCategoryViewControllerDelegate: GradebookCategoryViewControllerDelegate?
    var classGrade: ClassGrade?
    var categoryVCs = [GradebookCategoryViewController]()
    
    // Delegate method
    func didInstantiateController(classToPresent: ClassGrade) {
        classGrade = classToPresent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for category in classGrade!.categories {
            let categoryVC = storyboard?.instantiateViewController(withIdentifier: "gradebookCategoryViewController") as! GradebookCategoryViewController
            gradebookCategoryViewControllerDelegate?.didInstantiateController(categoryToPresent: category, className: classGrade!.className)
            categoryVCs.append(categoryVC)
        }
        setViewControllers(categoryVCs, direction: .forward, animated: true, completion: nil)
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

protocol GradebookCategoryPageViewControllerDelegate: class {
    // This delegate handles the information passing from GradebookTableVC to GradebookCategoryPageVC
    func didInstantiateController(classToPresent: ClassGrade)
}

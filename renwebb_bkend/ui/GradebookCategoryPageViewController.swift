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
    var classGrade = ClassGrade()
    
    // Delegate method
    func didInstantiateController(classToPresent: ClassGrade) {
        print("Processing delegate")
        classGrade = classToPresent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataSource = self
        
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "gradebookCategoryViewController") as! GradebookCategoryViewController
        gradebookCategoryViewControllerDelegate = categoryVC
        gradebookCategoryViewControllerDelegate?.didInstantiateController(categoryToPresent: classGrade.categories[0], className: classGrade.className)
        setViewControllers([categoryVC], direction: .forward, animated: true, completion: nil)
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

extension GradebookCategoryPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let categoryVC = viewController as! GradebookCategoryViewController
        let count = classGrade.categories.index(where: {(gradeCategory) -> Bool in
            gradeCategory.name == categoryVC.categoryToPresent.name
        })!
        if count > 0 {
            let categoryVC = storyboard?.instantiateViewController(withIdentifier: "gradebookCategoryViewController") as! GradebookCategoryViewController
            gradebookCategoryViewControllerDelegate = categoryVC
            gradebookCategoryViewControllerDelegate?.didInstantiateController(categoryToPresent: classGrade.categories[count - 1], className: classGrade.className)
            return categoryVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let categoryVC = viewController as! GradebookCategoryViewController
        let count = classGrade.categories.index(where: {(gradeCategory) -> Bool in
            gradeCategory.name == categoryVC.categoryToPresent.name
        })!
        if count < (classGrade.categories.count - 1) {
            let categoryVC = storyboard?.instantiateViewController(withIdentifier: "gradebookCategoryViewController") as! GradebookCategoryViewController
            gradebookCategoryViewControllerDelegate = categoryVC
            gradebookCategoryViewControllerDelegate?.didInstantiateController(categoryToPresent: classGrade.categories[count + 1], className: classGrade.className)
            return categoryVC
        }
        return nil
    }
    
}


protocol GradebookCategoryPageViewControllerDelegate: class {
    // This delegate handles the information passing from GradebookTableVC to GradebookCategoryPageVC
    func didInstantiateController(classToPresent: ClassGrade)
}

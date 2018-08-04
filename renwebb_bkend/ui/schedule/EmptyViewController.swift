//
//  EmptyViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/11/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickPopViewControllerDelegate {
    
    @IBOutlet weak var labelEmoji: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    var classSchedule: ClassSchedule?
    weak var delegate: ColorChangeDelegate?
    
    func initialize(classSchedule: ClassSchedule) {
        self.classSchedule = classSchedule
    }
    
    func changeMessage(message: String) {
        labelMessage.text = message
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPopOverSegue" {
            let colorPopOverController = segue.destination
            
            colorPopOverController.modalPresentationStyle = UIModalPresentationStyle.popover
            colorPopOverController.popoverPresentationController?.delegate = self
            
            let colorController = colorPopOverController as! ColorPickerPopViewController
            colorController.colorPickerDelegate = self
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate method
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - ColorPickPopViewControllerDelegate method
    
    func colorResponse(color: UIColor) {
        classSchedule?.color = color.cgColor
        delegate?.colorChanged(color: color, name: classSchedule!.name)
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

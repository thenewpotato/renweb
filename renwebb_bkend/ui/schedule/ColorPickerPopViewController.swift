//
//  ColorPickerPopViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 7/28/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

protocol ColorPickPopViewControllerDelegate: class {
    func colorResponse(color: UIColor)
}

class ColorPickerPopViewController: UIViewController, ChromaColorPickerDelegate {
    
    weak var colorPickerDelegate: ColorPickPopViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 300, height: 300)
        // Do any additional setup after loading the view.
        
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 295, height: 295))
        neatColorPicker.delegate = self //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.white
        
        view.addSubview(neatColorPicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        self.dismiss(animated: true, completion: nil)
        colorPickerDelegate?.colorResponse(color: color)
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

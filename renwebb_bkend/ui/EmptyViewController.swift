//
//  EmptyViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/11/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    
    @IBOutlet weak var labelEmoji: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

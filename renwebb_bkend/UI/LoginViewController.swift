//
//  ViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 3/10/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TFpass: UITextField!
    @IBOutlet weak var ActIndLogin: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.TFpass.delegate = self
        ActIndLogin.hidesWhenStopped = true
        
        ActIndLogin.startAnimating()
        Login.attemptKeychainLogin(completion: { (success) -> Void in
            self.ActIndLogin.stopAnimating()
            if success {
                print("Login success! " + "Student ID " + Login.studentID)
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(tabBarController, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleUserLogin(username: String, password: String) {
        ActIndLogin.startAnimating()
        Login.attemptUserLogin(username: username, password: password, completion: { (success) -> Void in
            self.ActIndLogin.stopAnimating()
            if success {
                print("Login success! " + "Student ID " + Login.studentID)
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(tabBarController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Login failed", message: "Please check credentials and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TFpass {
            textField.resignFirstResponder()
            handleUserLogin(username: "thenewpotato", password: TFpass.text!)
            return false
        }
        return true
    }
    
    @IBAction func BLogin(_ sender: UIButton) {
        handleUserLogin(username: "thenewpotato", password: TFpass.text!)
    }
    
}


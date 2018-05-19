//
//  ViewController.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 3/10/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TFpass: UITextField!
    @IBOutlet weak var ActIndLogin: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.TFpass.delegate = self
        ActIndLogin.hidesWhenStopped = true
        
        let loginComb: [String]? = getKey()
        if loginComb != nil {
            login(username: loginComb![0], password: loginComb![1])
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getKey() -> [String]? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Login.server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { return nil }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                return nil
        }
        return [account, password]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TFpass {
            textField.resignFirstResponder()
            // TODO: add to Keychain
            // TODO: login
            return false
        }
        return true
    }
    
    func login(username: String, password: String) {
        ActIndLogin.startAnimating()
        Login.initializeRenweb(username: username, password: password, completion: { (success) -> Void in
            self.ActIndLogin.stopAnimating()
            if success {
                print(Login.studentID)
                print(Login.scheduleURL)
                print(Login.gradeURLs)
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
            } else {
                // TODO: erase from Keychain
                let alert = UIAlertController(title: "Login failed", message: "Please check credentials and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    print("what does this do?")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func BLogin(_ sender: UIButton) {
        // TODO: add to Keychain
        // TODO: login
        /*login = Login(pass: TFpass.text!, Lurl: Lurl)*/
    }
    
}


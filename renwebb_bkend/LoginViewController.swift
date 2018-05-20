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
        self.TFpass.delegate = self
        ActIndLogin.hidesWhenStopped = true
        
        /*
        do {
            try deleteKeyChainItem()
        } catch KeychainError.unhandledError(let status) {
            print(status)
        } catch {
            
        }
        */
        
        do {
            let loginComb: [String]? = try getKeyChainItem()
            login(username: loginComb![0], password: loginComb![1])
        } catch KeychainError.noPassword {
            
        } catch KeychainError.unexpectedPasswordData {
            
        } catch KeychainError.unhandledError(let status) {
            print (status)
        } catch {
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getKeyChainItem() throws -> [String]? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Login.server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError.unexpectedPasswordData
        }
        return [account, password]
    }
    
    func addKeyChainItem(username: String, password: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: username,
                                    kSecAttrServer as String: Login.server,
                                    kSecValueData as String: password.data(using: String.Encoding.utf8)!]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    func deleteKeyChainItem() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: Login.server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TFpass {
            textField.resignFirstResponder()
            login(username: "thenewpotato", password: TFpass.text!)
            return false
        }
        return true
    }
    
    func login(username: String, password: String) {
        ActIndLogin.startAnimating()
        Login.initializeRenweb(username: username, password: password, completion: { (success) -> Void in
            self.ActIndLogin.stopAnimating()
            if success {
                do {
                    let _ = try self.getKeyChainItem()
                } catch KeychainError.noPassword {
                    do {
                        try self.addKeyChainItem(username: "thenewpotato", password: password)
                    } catch KeychainError.unhandledError(let status) {
                        print(status)
                    } catch {
                        
                    }
                } catch KeychainError.unexpectedPasswordData {
                    
                } catch KeychainError.unhandledError(let status) {
                    print (status)
                } catch {
                    
                }
                print(Login.studentID)
                print(Login.scheduleURL)
                print(Login.gradeURLs)
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
            } else {
                do {
                    try self.deleteKeyChainItem()
                } catch KeychainError.unhandledError(let status) {
                    print(status)
                } catch {
                    
                }
                let alert = UIAlertController(title: "Login failed", message: "Please check credentials and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    print("what does this do?")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func BLogin(_ sender: UIButton) {
        login(username: "thenewpotato", password: TFpass.text!)
        /*login = Login(pass: TFpass.text!, Lurl: Lurl)*/
    }
    
}


//
//  Login.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 3/10/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup
import UIKit

class Login {
    
    static let server = "https://tws-tn.client.renweb.com/pw/"
    static var scheduleURL = String()
    static var gradeURLs = [String]()
    static var studentID = String()
    
    static func constructHWURL(date: String) -> String {
        return ""
    }
    
    static func constructCWURL(date: String) -> String {
        return ""
    }
    
    static func initializeRenweb(username: String, password: String, completion: @escaping (Bool) -> ()) {
        let parameters: Parameters = [
            "DistrictCode": "TWS-TN",
            "UserName": username,
            "Password": password,
            "UserType": "PARENTSWEB-STUDENT"
        ]
        let headers: HTTPHeaders = [
        "Referer": "https://tws-tn.client.renweb.com/pw/"
        ]
        let url: URL = URL.init(string: "https://tws-tn.client.renweb.com/pw/")!
        
        // clear cookies
        if let cookies = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies {
            for cookie in cookies {
                Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            }
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
            .downloadProgress { progress in
                // TODO: add spinning indicator
            }
            .responseString { response in
                if response.response?.statusCode == 200 {

                    let cookies = HTTPCookieStorage.shared.cookies!
                    
                    /*for cookie in cookies {
                     print(cookie.value)
                     print(cookie.expiresDate)
                     print(cookie.isSessionOnly)
                     print("\n")
                     }*/
                    
                    // set cookies for future requests
                    Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)
                    
                    //MARK: GET scheduleURL
                    Alamofire.request("https://tws-tn.client.renweb.com/pw/student/schedules.cfm").responseString { response in
                        //print(response.result.value!)
                        do {
                            let doc: Document = try SwiftSoup.parse(response.result.value!)
                            let graybutton: Element? = try doc.select(".graybutton.printout").first()
                            if (graybutton == nil) {
                                completion(false)
                                return
                            }
                            scheduleURL = try "https://tws-tn.client.renweb.com" + graybutton!.attr("href")
                            // TODO: check if all studentIDs are 7 digits
                            studentID = String(scheduleURL.suffix(7))
                        } catch Exception.Error(let message) {
                            print(message)
                        } catch {
                            print("Error retrieving schedule URL!")
                        }
                        
                        //MARK: GET gradeURLs
                        Alamofire.request("https://tws-tn.client.renweb.com/pw/student/grades.cfm").responseString { response in
                            //print(response.result.value!)
                            do {
                                let doc: Document = try SwiftSoup.parse(response.result.value!)
                                let forms: Elements = try doc.select("form")
                                if (forms.array().count > 1) {
                                    for i in 1...(forms.array().count - 1) {
                                        let fields: Elements = try forms.get(i).select("input")
                                        try gradeURLs.append("https://tws-tn.client.renweb.com/renweb/reports/parentsweb/parentsweb_reports.cfm?"
                                            + "District=TWS-TN" + "&ReportType=Gradebook"
                                            + "&sessionid=" + fields.get(2).attr("value")
                                            + "&ReportHash=" + fields.get(3).attr("value")
                                            + "&SchoolCode=TWS-TN"
                                            + "&StudentID=" + fields.get(5).attr("value")
                                            + "&ClassID=" + fields.get(6).attr("value")
                                            + "&TermID=" + fields.get(7).attr("value"))
                                        }
                                } else {
                                    
                                }
                            } catch Exception.Error(let message) {
                                print(message)
                            } catch {
                                print("Error retrieving schedule URL!")
                            }
                            completion(true)
                        }
                    }
                    
                }
        }
    }
    
    static func attemptKeychainLogin(completion: @escaping (Bool) -> ()) {
        do {
            let loginComb: [String]? = try KeychainServices.getKeychainItem()
            initializeRenweb(username: loginComb![0], password: loginComb![1], completion: { (success) -> Void in
                if success {
                    completion(true)
                } else {
                    do {
                        try KeychainServices.deleteKeychainItems()
                    } catch KeychainError.unhandledError(let status) {
                        print(status)
                    } catch {
                        
                    }
                    completion(false)
                }
            })
        } catch KeychainError.noPassword {
            completion(false)
        } catch KeychainError.unexpectedPasswordData {
            completion(false)
        } catch KeychainError.unhandledError(let status) {
            print (status)
            completion(false)
        } catch {
            completion(false)
        }
    }
    
    static func attemptUserLogin(username: String, password: String, completion: @escaping (Bool) -> ()) {
        initializeRenweb(username: username, password: password, completion: { (success) -> Void in
            if success {
                do {
                    let _ = try KeychainServices.getKeychainItem()
                } catch KeychainError.noPassword {
                    do {
                        try KeychainServices.addKeychainItem(username: "thenewpotato", password: password)
                    } catch KeychainError.unhandledError(let status) {
                        print(status)
                    } catch {
                        
                    }
                } catch KeychainError.unexpectedPasswordData {
                    
                } catch KeychainError.unhandledError(let status) {
                    print (status)
                } catch {
                    
                }
                completion(true)
            } else {
                do {
                    try KeychainServices.deleteKeychainItems()
                } catch KeychainError.unhandledError(let status) {
                    print(status)
                } catch {
                    
                }
                completion(false)
            }
        })
    }
}

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
    
    static func constructHWURL(weekOf: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return "https://tws-tn.client.renweb.com/pw/student/homework-print.cfm?studentid=" + studentID + "&weekof=" + formatter.string(from: weekOf) + "&events=0"
    }
    
    static func constructCWURL(weekOf: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return "https://tws-tn.client.renweb.com/pw/student/lesson-plans-print.cfm?studentid=" + studentID + "&weekof=" + formatter.string(from: weekOf) + "&events=0"
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
                                // TODO: temporary adjustment: scheduleURL and studentID manually set ,completion from false to true: schedule shutdown
                                scheduleURL = "https://tws-tn.client.renweb.com/pw/NAScopy/schedules/StudentSchedule-Grid.cfm?District=TWS-TN&School=TWS-TN&StudentID=1211639&YearID=262&TermID=4&Page=1&End=1&prompt0=TWS-TN&prompt1=TWS-TN&prompt2=262&prompt3=4&templateid=0&ReportHash=25C3AA6A8D9980067991DEE5980EF7D8&hashval=25C3AA6A8D9980067991DEE5980EF7D8"
                                studentID = "1211639"
                                completion(true)
                                
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
                                    gradeURLs.removeAll()
                                    for i in 2...(forms.array().count - 2) {
                                        let fields: Elements = try forms.get(i).select("input")
                                        try gradeURLs.append("https://tws-tn.client.renweb.com/pw/NAScopy/Gradebook/GradeBookProgressReport-PW.cfm?"
                                            + "District=TWS-TN" + "&ReportType=Gradebook"
                                            + "&sessionid=" + fields.get(2).attr("value")
                                            + "&ReportHash=" + fields.get(3).attr("value")
                                            + "&SchoolCode=TWS-TN"
                                            + "&StudentID=" + fields.get(5).attr("value")
                                            + "&ClassID=" + fields.get(6).attr("value")
                                            + "&TermID=" + fields.get(7).attr("value"))
                                        try print(fields.get(3).attr("value"))
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

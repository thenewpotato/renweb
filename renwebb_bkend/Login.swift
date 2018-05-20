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
                    
                    /*
                     self.getScheduleUrl(completion: {scheduleUrl in
                     if let scheduleUrl = scheduleUrl {
                     print(scheduleUrl)
                     DispatchQueue.main.async {
                     Lurl.text = scheduleUrl
                     }
                     }
                     })
                     */
                    
                    /*
                     // MARK: HTTP(GET) request and process schedule
                     Alamofire.request(scheduleURL!).responseString { response in
                     print(response.result.value!)
                     do {
                     let doc: Document = try SwiftSoup.parse(response.result.value!)
                     let courseEntries = try doc.select("body > table:nth-child(2) > tbody:nth-child(2) > tr")
                     
                     } catch Exception.Error(let message) {
                     print(message)
                     } catch {
                     print("Error processing schedule!")
                     }
                     }
                     */
                    
                    //MARK: GET scheduleURL
                    Alamofire.request("https://tws-tn.client.renweb.com/pw/student/schedules.cfm").responseString { response in
                        print(response.result.value!)
                        do {
                            let doc: Document = try SwiftSoup.parse(response.result.value!)
                            let graybutton: Element? = try doc.select(".graybutton.printout").first()
                            if (graybutton == nil) {
                                completion(false)
                                return
                            }
                            scheduleURL = try "https://tws-tn.client.renweb.com" + graybutton!.attr("href")
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
                                    try studentID = fields.get(5).attr("value")
                                    }
                                }
                                /*print(gradeURLs.count)
                                 print(gradeURLs[0])
                                 Alamofire.request(gradeURLs[0]).responseString { response in
                                 print(response.result.value!)
                                 }*/
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
    
    /*
    init (pass: String, Lurl: UILabel) {
        // MARK: Declare variables
        let parameters: Parameters = [
            "DistrictCode": "TWS-TN",
            "UserName": "thenewpotato",
            "Password": pass,
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
        
        // MARK: HTTP(POST) intial login
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
            .downloadProgress { progress in
                // TODO: add spinning indicator
            }
            .responseString { response in
            if response.response?.statusCode == 200 {
                
                print("Login Success!")
                let cookies = HTTPCookieStorage.shared.cookies!
                
                /*for cookie in cookies {
                    print(cookie.value)
                    print(cookie.expiresDate)
                    print(cookie.isSessionOnly)
                    print("\n")
                }*/
                
                // set cookies for future requests
                Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookies(cookies, for: response.response?.url, mainDocumentURL: nil)
                
                self.getBaseURLs()
                
                /*
                self.getScheduleUrl(completion: {scheduleUrl in
                    if let scheduleUrl = scheduleUrl {
                        print(scheduleUrl)
                        DispatchQueue.main.async {
                            Lurl.text = scheduleUrl
                        }
                    }
                })
                */
 
                /*
                // MARK: HTTP(GET) request and process schedule
                Alamofire.request(scheduleURL!).responseString { response in
                    print(response.result.value!)
                    do {
                        let doc: Document = try SwiftSoup.parse(response.result.value!)
                        let courseEntries = try doc.select("body > table:nth-child(2) > tbody:nth-child(2) > tr")
                        
                    } catch Exception.Error(let message) {
                        print(message)
                    } catch {
                        print("Error processing schedule!")
                    }
                }
                */
            }
        }
        
    }
    
    func getBaseURLs() {
        var scheduleURL = String()
        var gradeURLs = [String]()
        var studentId = String()
        
        //MARK: GET scheduleURL
        Alamofire.request("https://tws-tn.client.renweb.com/pw/student/schedules.cfm").responseString { response in
            //print(response.result.value!)
            do {
                let doc: Document = try SwiftSoup.parse(response.result.value!)
                let graybutton: Element = try doc.select(".graybutton.printout").first()!
                scheduleURL = try "https://tws-tn.client.renweb.com" + graybutton.attr("href")
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
                        try studentId = fields.get(5).attr("value")
                    }
                    /*print(gradeURLs.count)
                    print(gradeURLs[0])
                    Alamofire.request(gradeURLs[0]).responseString { response in
                        print(response.result.value!)
                    }*/
                } catch Exception.Error(let message) {
                    print(message)
                } catch {
                    print("Error retrieving schedule URL!")
                }
            }
        }
    }
    
    func getScheduleUrl(completion: @escaping (String?) -> ()){
        // MARK: HTTP(GET) parse out schedule url
        var scheduleURL: String?
        Alamofire.request("https://tws-tn.client.renweb.com/pw/student/schedules.cfm").responseString { response in
            print(response.result.value!)
            do {
                let doc: Document = try SwiftSoup.parse(response.result.value!)
                let graybutton: Element = try doc.select(".graybutton.printout").first()!
                scheduleURL = try "https://tws-tn.client.renweb.com" + graybutton.attr("href")
            } catch Exception.Error(let message) {
                print(message)
            } catch {
                print("Error retrieving schedule URL!")
            }
            completion(scheduleURL)
        }
    }
    */
}

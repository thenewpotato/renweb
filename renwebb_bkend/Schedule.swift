//
//  Schedule.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/22/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import SwiftSoup
import Alamofire

class Schedule {
    
    var url: String
    var weekday: Int
    
    init(url: String, date: Date) {
        self.url = url
        let weekday = Calendar.current.component(.weekday, from: date)
        // Monday needs to be 1, ...
        self.weekday = weekday - 1
    }
    
    func getDay(completion: @escaping ([Class]) -> ()) {
        getDoc(url: url, completion: { (doc) -> (Void) in
            if doc != nil {
                let classes = self.parseDay(doc: doc!)
                completion(classes)
            }
        })
    }
    
    func getDoc(url: String, completion: @escaping (Document?) -> ()) {
        Alamofire.request(url).responseString { response in
            var doc: Document?;
            do {
                doc = try SwiftSoup.parse(response.result.value!)
            } catch {
                print("Error constructing schedule Document")
            }
            completion(doc)
        }
    }
    
    func parseDay(doc: Document) -> [Class] {
        var classes: [Class] = []
        do {
            let trs: Elements = try doc.select("#AutoNumber2 > tbody > tr")
            // Each class row contains 3 tr elements; i represents the index of the class row, not the tr element
            for i in 1...((trs.size() - 1) / 3) {
                let classNameIndex = 3 * i - 2
                let classTimeIndex = 3 * i - 1
                let classLocIndex = 3 * i
                let className: String = try trs.get(classNameIndex).select("td").get(weekday).text()
                let classTime: String = try trs.get(classTimeIndex).select("td").get(weekday).text()
                let classLoc: String = try trs.get(classLocIndex).select("td").get(weekday).text()
                if className != "" && classTime != "" && classLoc != "" {
                    let newClass: Class = Class()
                    newClass.name = className
                    newClass.time = classTime
                    newClass.loc = classLoc
                    classes.append(newClass)
                }
            }
        } catch {
            print("Error parsing schedule Document")
        }
        return classes
    }
    
}

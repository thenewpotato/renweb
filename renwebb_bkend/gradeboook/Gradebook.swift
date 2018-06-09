//
//  Gradebook.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 5/29/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import SwiftSoup
import Alamofire

class Gradebook {
    
    var gradebookUrls: [String]
    var gradebookDocs: [Document]
    var classes: [ClassGrade]?
    var urlCount: Int
    
    init(gradebookUrls: [String]) {
        self.gradebookUrls = gradebookUrls
        gradebookDocs = []
        urlCount = -1
        classes = []
    }
    
    func getGrades(completion: @escaping ([ClassGrade]?) -> ()) {
        gradebookDocs.removeAll()
        classes?.removeAll()
        urlCount = -1
        getDoc(completion: { done in
            if done {
                self.parseDocs()
                completion(self.classes)
            }
        })
    }
    
    private func getDoc(completion: @escaping (Bool) -> ()) {
        self.urlCount += 1
        print(gradebookUrls[urlCount])
        Alamofire.request(gradebookUrls[urlCount]).responseString { response in
            do {
                var gradebookDoc = try SwiftSoup.parse(response.result.value!)
                let table = try gradebookDoc.select("table").first()
                let h3 = try gradebookDoc.select("h3").first()
                // case that Document shows authentication error
                if (table == nil) && (h3 == nil) {
                    print("Gradebook timed out... retrying login")
                    Login.attemptKeychainLogin(completion: {success in
                        if success {
                            print("Re-login success! Appending Document...")
                            self.gradebookUrls = Login.gradeURLs
                            Alamofire.request(self.gradebookUrls[self.urlCount]).responseString { newResponse in
                                do {
                                    gradebookDoc = try SwiftSoup.parse(newResponse.result.value!)
                                    self.gradebookDocs.append(try SwiftSoup.parse(response.result.value!))
                                    if self.urlCount == self.gradebookUrls.count - 1 {
                                        completion(true)
                                    } else {
                                        self.getDoc(completion: { done in
                                            if done {
                                                completion(true)
                                            }
                                        })
                                    }
                                } catch {
                                    print("Error parsing Doc #" + String(self.urlCount))
                                }
                            }
                        } else {
                            print("Failed to re-login... redirecting to login page")
                        }
                    })
                // case that Document is normal
                } else if try gradebookDoc.select("table").size() > 1 {
                    self.gradebookDocs.append(try SwiftSoup.parse(response.result.value!))
                    if self.urlCount == self.gradebookUrls.count - 1 {
                        completion(true)
                    } else {
                        self.getDoc(completion: { done in
                            if done {
                                completion(true)
                            }
                        })
                    }
                // case that Document is empty
                } else {
                    print("Doc empty")
                    if self.urlCount == self.gradebookUrls.count - 1 {
                        completion(true)
                    } else {
                        self.getDoc(completion: { done in
                            if done {
                                completion(true)
                            }
                        })
                    }
                }
            } catch {
                print("Error parsing Doc #" + String(self.urlCount))
            }
        }
    }
    
    private func parseDocs() {
        for doc in gradebookDocs {
            let newClass = ClassGrade()
            do {
                let tables = try doc.select("body > table")
                let className = try tables.get(0).select("tbody > tr").last()?.text()
                newClass.className = className!
                // i represents the index of a category
                for i in 1...((tables.size() - 1) / 2) {
                    let newCategory = GradeCategory()
                    let titleIndex = 2 * i - 1
                    let assignmentIndex = 2 * i
                    let title = try tables.get(titleIndex).select("tbody > tr:nth-child(2) > td").first()?.text()
                    let weight = try tables.get(titleIndex).select("tbody > tr:nth-child(2) > td:nth-child(3)").text()
                    let assignmentTrs = try tables.get(assignmentIndex).select("tbody > tr")
                    newCategory.name = title!
                    newCategory.weight = weight
                    
                    // the last category of a term has 4 extra rows instead of 2
                    var subtractIndex = 2
                    if i == ((tables.size() - 1) / 2) {
                        subtractIndex = 4
                    }
                    if assignmentTrs.size() > subtractIndex {
                        
                        // l represents the index of an assignment
                        for l in 1...(assignmentTrs.size() - subtractIndex) {
                            let assignmentTr = assignmentTrs.get(l)
                            let newAssignment = GradeAssignment()
                            newAssignment.name = try assignmentTr.select("td:nth-child(1)").text()
                            print("assignment name: " + newAssignment.name )
                            newAssignment.points = try assignmentTr.select("td:nth-child(2)").text()
                            print("assignment points: " + newAssignment.points)
                            newAssignment.max = try assignmentTr.select("td:nth-child(3)").text()
                            print("assignment max: " + newAssignment.max )
                            newAssignment.average = try assignmentTr.select("td:nth-child(4)").text()
                            print("assignment average: " + newAssignment.average )
                            newAssignment.status = try assignmentTr.select("td:nth-child(5)").text()
                            print("assignment status: " + newAssignment.status )
                            newAssignment.date = try assignmentTr.select("td:nth-child(6)").text()
                            print("assignment status: " + newAssignment.date )
                            newCategory.assignments.append(newAssignment)
                        }
                        newCategory.categoryAverage = try (assignmentTrs.get(assignmentTrs.size() - 1).select("td:nth-child(2)").text())
                    }
                    newClass.categories.append(newCategory)
                    if i == ((tables.size() - 1) / 2) {
                        // total term grade is wrapped within the class category's assignment table
                        newClass.termGrade = try (assignmentTrs.get(assignmentTrs.size() - 1).select("td:nth-child(2)").text())
                        newClass.termLetter = try(assignmentTrs.get(assignmentTrs.size() - 1).select("td:nth-child(3)").text())
                    }
                }
                classes?.append(newClass)
            } catch {
                print("Error parsing Gradebook")
            }
        }
    }
    
}

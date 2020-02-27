//
//  Firebase.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 4/12/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import Firebase

class Firebase {
    
    // Firebase database reference
    var databaseRef: DatabaseReference?
    
    func getAutoIds(completion: @escaping([String]?, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("scoreCards").observeSingleEvent(of: .value, with: { (snapshot) in
            var autoIds: [String] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key as String
                autoIds.append(key)
                completion(autoIds, nil)
            }
        })
    }
    
    func getScoreCard(autoId: String, completion: @escaping(ScoreCard?, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("scoreCards").child(autoId).observe(.value) { (snapshot: DataSnapshot) in
            // To check if autoIds[(indexPath as NSIndexPath).row] is empty, if not then proceed to display cell
            if snapshot.hasChild("date") {
                let snapshotValue = snapshot.value as! NSDictionary
                    if let date = snapshotValue["date"] as? String {
                        if let golfCourseName = snapshotValue["golfCourseName"] as? String {
                                if let holePars = snapshotValue["holePars"] as? [Int] {
                                    if let p1Name = snapshotValue["p1Name"] as? String {
                                        if let p2Name = snapshotValue["p2Name"] as? String {
                                            if let p3Name = snapshotValue["p3Name"] as? String {
                                                if let p4Name = snapshotValue["p4Name"] as? String {
                                                    if let p1Scores = snapshotValue["p1Scores"] as? [Int] {
                                                        if let p2Scores = snapshotValue["p2Scores"] as? [Int] {
                                                            if let p3Scores = snapshotValue["p3Scores"] as? [Int] {
                                                                if let p4Scores = snapshotValue["p4Scores"] as? [Int] {
                                                                    if let createdByUID = snapshotValue["createdByUID"] as? String {
                                                                        if let status = snapshotValue["status"] as? String {
                                                                            let date = date
                                                                            let golfCourseName = golfCourseName
                                                                            let holePars = holePars
                                                                            let p1Name = p1Name
                                                                            let p2Name = p2Name
                                                                            let p3Name = p3Name
                                                                            let p4Name = p4Name
                                                                            let p1Scores = p1Scores
                                                                            let p2Scores = p2Scores
                                                                            let p3Scores = p3Scores
                                                                            let p4Scores = p4Scores
                                                                            let createdByUID = createdByUID
                                                                            let status = status
                                                                            
                                                                            let scoreCard = ScoreCard(date: date, golfCourseName: golfCourseName, holePars: holePars, p1Name: p1Name, p2Name: p2Name, p3Name: p3Name, p4Name: p4Name, p1Scores: p1Scores, p2Scores: p2Scores, p3Scores: p3Scores, p4Scores: p4Scores, createdByUID: createdByUID, status: status)
                                                                            
                                                                            completion(scoreCard, nil)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteScoreCards(autoId: String, completion: @escaping(Bool, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("scoreCards").observeSingleEvent(of: .value, with: { (snapshot) in
            self.databaseRef!.child("scoreCards").child(autoId).removeValue()
            completion(true, nil)
        })
    }
    
    func setCompleteRound(autoId: String, completion: @escaping(Bool, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("scoreCards").child(autoId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.databaseRef!.child("scoreCards").child(autoId).updateChildValues(["status": "Round Completed"], withCompletionBlock: { (error, _) in
                if error != nil {
                    print(error?.localizedDescription ?? "Failed to update status")
                }
            })
            completion(true, nil)
        })
    }
    
    func getGolfCourses(completion: @escaping([GolfCourse]?, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("golfCourses").observeSingleEvent(of: .value, with: { (snapshot) in
            var golfCourses: [GolfCourse] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key as String
                let value = snap.value as! NSDictionary
                    if let holePars = value["holePars"] as? [Int] {
                        let golfCourse = GolfCourse(golfCourseName: key, holePars: holePars)
                        golfCourses.append(golfCourse)
                }
            }
            completion(golfCourses, nil)
        })
    }
    
    func getGolfGames(completion: @escaping([GolfGame]?, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("golfGames").observeSingleEvent(of: .value, with: { (snapshot) in
            var golfGames: [GolfGame] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key as String
                let golfGame = GolfGame(golfGameName: key)
                golfGames.append(golfGame)
            }
            completion(golfGames, nil)
        })
    }
    
    func updateScore(autoId: String, tag: Int, targetScores: String, op: String){
        databaseRef = Database.database().reference()
        databaseRef!.child("scoreCards").child(autoId).observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            if let scores = snapshotValue[targetScores] as? [Int] {
                
                // Get the p1Score value
                let score = scores[tag] as Int
                
                // Create new dict for status value
                var newValue = ["\(tag)": (score + 1)] as [String: Any]
                
                if op == "subtract" {
                    newValue = ["\(tag)": (score - 1)] as [String: Any]
                }
                
                // Update the value of p1Score in firebase
                self.databaseRef!.child("scoreCards").child(autoId).child(targetScores).updateChildValues(newValue, withCompletionBlock: { (error, _) in
                    if error != nil {
                        print(error?.localizedDescription ?? "Failed to update score")
                    }
                    // print("Successfully \(op)ed score")
                    
                })
            }
        }) { (error) in
            print("Failed to get snapshot", error)
        }
    }
    
    func addScoreCard(golfCourseTextfield: String, p1Name: String, p2Name: String, p3Name: String, p4Name: String, completion: @escaping(Bool, Error?) -> Void) {
        databaseRef = Database.database().reference()
        databaseRef!.child("golfCourses").child(golfCourseTextfield).observe(.value) { (snapshot: DataSnapshot) in
            let snapshotValue = snapshot.value as? [String: Any]
            let holeParsIntArray = snapshotValue!["holePars"] as! [Int]
            let newScoreCardRef = self.databaseRef!.child("scoreCards").childByAutoId()
            // Set the date of the score card
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let todaysDate = formatter.string(from: date)
            
            let uid = Auth.auth().currentUser!.uid
            
            newScoreCardRef.setValue(["date": String(todaysDate), "golfCourseName": golfCourseTextfield,
                                      "holePars": holeParsIntArray,
                                      "p1Name": p1Name, "p2Name": p2Name,
                                      "p3Name": p4Name, "p4Name": p3Name,
                                      "p1Scores": holeParsIntArray, "p2Scores": holeParsIntArray,
                                      "p3Scores": holeParsIntArray, "p4Scores": holeParsIntArray,
                                      "createdByUID": uid, "status": "Round In Progress"])
            
            completion(true, nil)
        }
        
    }
    
    class func shared() -> Firebase {
        struct Singleton {
            private init() {}
            static var shared = Firebase()
        }
        return Singleton.shared
    }
    
}

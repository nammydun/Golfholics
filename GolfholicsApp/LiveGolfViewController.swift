
//
//  LiveGolfViewController.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 8/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

class LiveGolfViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Firebase database reference
    var databaseRef: DatabaseReference?
    var autoIds: [String] = []
    var autoId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        Firebase.shared().getAutoIds { (autoIds, error) in
            if error == nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.autoIds = autoIds!
                    self.tableView.insertRows(at: [IndexPath(row: self.autoIds.count-1, section: 0)], with: .automatic)
                })
            }
        }
    }
    
    @IBAction func addGameButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddGame", sender: self)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            toLoginViewController()
        } catch {
            print("unable to sign out: \(error)")
        }
    }
    
    func toLoginViewController() {
        let liveGolfViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        view.window?.rootViewController = liveGolfViewController
        view.window?.makeKeyAndVisible()
    }
    
}

extension LiveGolfViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveGolfTableViewCell") as! LiveGolfTableViewCell
        
        Firebase.shared().getScoreCard(autoId: autoIds[(indexPath as NSIndexPath).row]) { (scoreCard, error) in
            cell.todaysDateLabel.text = scoreCard?.date
            cell.golfCourseNameLabel.text = scoreCard?.golfCourseName
            cell.p1NameTopLabel.text = scoreCard?.p1Name
            cell.p1NameBottomLabel.text = scoreCard?.p1Name
            cell.p2NameTopLabel.text = scoreCard?.p2Name
            cell.p2NameBottomLabel.text = scoreCard?.p2Name
            cell.p3NameTopLabel.text = scoreCard?.p3Name
            cell.p3NameBottomLabel.text = scoreCard?.p3Name
            cell.p4NameTopLabel.text = scoreCard?.p4Name
            cell.p4NameBottomLabel.text = scoreCard?.p4Name
            cell.statusLabel.text = scoreCard?.status
            
            if scoreCard?.status == "Round Completed" {
                cell.statusLabel.textColor = UIColor.orange
            }
            
            // Player 1,2,3,4 Scores
            for i in 0...(scoreCard?.p1Scores.count)!-1 {
                cell.p1ScoresLabels[i].text = "\(scoreCard!.p1Scores[i])"
                cell.p2ScoresLabels[i].text = "\(scoreCard!.p2Scores[i])"
                cell.p3ScoresLabels[i].text = "\(scoreCard!.p3Scores[i])"
                cell.p4ScoresLabels[i].text = "\(scoreCard!.p4Scores[i])"
            }
            
            var p1Front9Scores = 0
            var p2Front9Scores = 0
            var p3Front9Scores = 0
            var p4Front9Scores = 0
            
            for i in 0...(scoreCard?.p1Scores.count)!-10 {
                p1Front9Scores = p1Front9Scores + (scoreCard?.p1Scores[i])!
                p2Front9Scores = p2Front9Scores + (scoreCard?.p2Scores[i])!
                p3Front9Scores = p3Front9Scores + (scoreCard?.p3Scores[i])!
                p4Front9Scores = p4Front9Scores + (scoreCard?.p4Scores[i])!
                cell.p1ScoreOutTotal.text = "\(p1Front9Scores)"
                cell.p2ScoreOutTotal.text = "\(p2Front9Scores)"
                cell.p3ScoreOutTotal.text = "\(p3Front9Scores)"
                cell.p4ScoreOutTotal.text = "\(p4Front9Scores)"
            }
            
            var p1Back9Scores = 0
            var p2Back9Scores = 0
            var p3Back9Scores = 0
            var p4Back9Scores = 0
            
            for i in 9...(scoreCard?.p1Scores.count)!-1 {
                p1Back9Scores = p1Back9Scores + (scoreCard?.p1Scores[i])!
                p2Back9Scores = p2Back9Scores + (scoreCard?.p2Scores[i])!
                p3Back9Scores = p3Back9Scores + (scoreCard?.p3Scores[i])!
                p4Back9Scores = p4Back9Scores + (scoreCard?.p4Scores[i])!
                cell.p1ScoreInTotal.text = "\(p1Back9Scores)"
                cell.p2ScoreInTotal.text = "\(p2Back9Scores)"
                cell.p3ScoreInTotal.text = "\(p3Back9Scores)"
                cell.p4ScoreInTotal.text = "\(p4Back9Scores)"
            }
            
            cell.p1ScoreTotal.text = "\(p1Front9Scores + p1Back9Scores)"
            cell.p2ScoreTotal.text = "\(p2Front9Scores + p2Back9Scores)"
            cell.p3ScoreTotal.text = "\(p3Front9Scores + p3Back9Scores)"
            cell.p4ScoreTotal.text = "\(p4Front9Scores + p4Back9Scores)"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Firebase.shared().deleteScoreCards(autoId: autoIds[(indexPath as NSIndexPath).row]) { (success, error) in
                if success == true {
                    self.autoIds.remove(at: indexPath.row)
                    if self.autoIds.count != 0 {
                        self.tableView.deleteRows(at: [IndexPath(row: self.autoIds.count-1, section: 0)], with: .automatic)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editScoreCardViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditScoreCardViewController") as! EditScoreCardViewController
        editScoreCardViewController.autoId = autoIds[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(editScoreCardViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Base on the actual image height
        return 230.0
    }
    
}

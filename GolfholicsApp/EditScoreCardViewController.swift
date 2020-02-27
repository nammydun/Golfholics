//
//  EditScoreCardViewController.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 15/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditScoreCardViewController: UIViewController {
    
    // Firebase database reference
    var databaseRef: DatabaseReference?
    var autoId = String()
    
    // Outlet
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var p1NameLabel: UILabel!
    @IBOutlet weak var p2NameLabel: UILabel!
    @IBOutlet weak var p3NameLabel: UILabel!
    @IBOutlet weak var p4NameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var p1TotalScoreLabel: UILabel!
    @IBOutlet weak var p2TotalScoreLabel: UILabel!
    @IBOutlet weak var p3TotalScoreLabel: UILabel!
    @IBOutlet weak var p4TotalScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        databaseRef = Database.database().reference()
        setUpLabels()
    }
    
    func setUpLabels() {
        Firebase.shared().getScoreCard(autoId: autoId) { (scoreCard, error) in
            let p1Scores = scoreCard?.p1Scores
            let p2Scores = scoreCard?.p2Scores
            let p3Scores = scoreCard?.p3Scores
            let p4Scores = scoreCard?.p4Scores
            
            // Set the total scores of each player
            let sumOfP1Scores = p1Scores!.reduce(0, +)
            let sumOfP2Scores = p2Scores!.reduce(0, +)
            let sumOfP3Scores = p3Scores!.reduce(0, +)
            let sumOfP4Scores = p4Scores!.reduce(0, +)
            
            // Set the date of the score card
            self.todaysDateLabel.text = scoreCard?.date
            
            // Set the name of the golf course
            self.golfCourseNameLabel.text = scoreCard?.golfCourseName
            
            // Set the players' names on score card
            self.p1NameLabel.text = scoreCard?.p1Name
            self.p2NameLabel.text = scoreCard?.p2Name
            self.p3NameLabel.text = scoreCard?.p3Name
            self.p4NameLabel.text = scoreCard?.p4Name
            
            self.p1TotalScoreLabel.text = "\(sumOfP1Scores)"
            self.p2TotalScoreLabel.text = "\(sumOfP2Scores)"
            self.p3TotalScoreLabel.text = "\(sumOfP3Scores)"
            self.p4TotalScoreLabel.text = "\(sumOfP4Scores)"
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        Firebase.shared().setCompleteRound(autoId: autoId) { (success, error) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Confirm to complete round?", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                    let liveGolfViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                    self.view.window?.rootViewController = liveGolfViewController
                    self.view.window?.makeKeyAndVisible()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}


//-------------------------------------------------------------------------------------------//


extension EditScoreCardViewController: UITableViewDelegate, UITableViewDataSource, EditScoreCardTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditScoreCardTableViewCell") as! EditScoreCardTableViewCell
        
        cell.cellDelegate = self
        cell.p1ScoreAddButton.tag = indexPath.row
        cell.p1ScoreSubtractButton.tag = indexPath.row
        cell.p2ScoreAddButton.tag = indexPath.row
        cell.p2ScoreSubtractButton.tag = indexPath.row
        cell.p3ScoreAddButton.tag = indexPath.row
        cell.p3ScoreSubtractButton.tag = indexPath.row
        cell.p4ScoreAddButton.tag = indexPath.row
        cell.p4ScoreSubtractButton.tag = indexPath.row
        
        Firebase.shared().getScoreCard(autoId: autoId) { (scoreCard, error) in
            let holePars = scoreCard?.holePars
            let p1Scores = scoreCard?.p1Scores
            let p2Scores = scoreCard?.p2Scores
            let p3Scores = scoreCard?.p3Scores
            let p4Scores = scoreCard?.p4Scores
            
            cell.holeLabel.text = "\((indexPath as NSIndexPath).row + 1)"
            cell.holeParLabel.text = "Par \(holePars![(indexPath as NSIndexPath).row])"
            cell.p1ScoreLabel.text = "\(p1Scores![(indexPath as NSIndexPath).row])"
            cell.p2ScoreLabel.text = "\(p2Scores![(indexPath as NSIndexPath).row])"
            cell.p3ScoreLabel.text = "\(p3Scores![(indexPath as NSIndexPath).row])"
            cell.p4ScoreLabel.text = "\(p4Scores![(indexPath as NSIndexPath).row])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Base on the actual image height
        return 126.0
    }
    
    func didPressButton(_ tag: Int, button: String) {
        if button == "p1ScoreAddButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p1Scores", op: "add")
        } else if button == "p1ScoreSubtractButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p1Scores", op: "subtract")
        } else if button == "p2ScoreAddButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p2Scores", op: "add")
        } else if button == "p2ScoreSubtractButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p2Scores", op: "subtract")
        } else if button == "p3ScoreAddButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p3Scores", op: "add")
        } else if button == "p3ScoreSubtractButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p3Scores", op: "subtract")
        } else if button == "p4ScoreAddButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p4Scores", op: "add")
        } else if button == "p4ScoreSubtractButtonTapped" {
            Firebase.shared().updateScore(autoId:autoId, tag: tag, targetScores: "p4Scores", op: "subtract")
        }
    }
    
}

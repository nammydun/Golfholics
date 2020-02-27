//
//  EditScoreCardTableViewCell.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 15/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditScoreCardTableViewCell: UITableViewCell {
    
    // Firebase database reference
    var databaseRef: DatabaseReference?
    var _refHandle: DatabaseHandle!
    
    var cellDelegate: EditScoreCardTableViewCellDelegate?
    
    @IBOutlet weak var holeLabel: UILabel!
    @IBOutlet weak var holeParLabel: UILabel!
    @IBOutlet weak var p1ScoreLabel: UILabel!
    @IBOutlet weak var p2ScoreLabel: UILabel!
    @IBOutlet weak var p3ScoreLabel: UILabel!
    @IBOutlet weak var p4ScoreLabel: UILabel!
    @IBOutlet weak var p1ScoreAddButton: UIButton!
    @IBOutlet weak var p2ScoreAddButton: UIButton!
    @IBOutlet weak var p3ScoreAddButton: UIButton!
    @IBOutlet weak var p4ScoreAddButton: UIButton!
    @IBOutlet weak var p1ScoreSubtractButton: UIButton!
    @IBOutlet weak var p2ScoreSubtractButton: UIButton!
    @IBOutlet weak var p3ScoreSubtractButton: UIButton!
    @IBOutlet weak var p4ScoreSubtractButton: UIButton!
    
    @IBAction func p1ScoreAddButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p1ScoreAddButtonTapped")
    }
    
    @IBAction func p2ScoreAddButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p2ScoreAddButtonTapped")
    }
    
    @IBAction func p3ScoreAddButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p3ScoreAddButtonTapped")
    }
    
    @IBAction func p4ScoreAddButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p4ScoreAddButtonTapped")
    }
    
    @IBAction func p1ScoreSubtractButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p1ScoreSubtractButtonTapped")
    }
    
    @IBAction func p2ScoreSubtractButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p2ScoreSubtractButtonTapped")
    }
    
    @IBAction func p3ScoreSubtractButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p3ScoreSubtractButtonTapped")
    }
    
    @IBAction func p4ScoreSubtractButtonTapped(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag, button: "p4ScoreSubtractButtonTapped")
    }
}

protocol EditScoreCardTableViewCellDelegate : class {
    func didPressButton(_ tag: Int, button: String)
}

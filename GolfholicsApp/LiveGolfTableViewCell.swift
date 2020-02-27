//
//  LiveGolfTableViewCell.swift
//  GolfholicsApp
//
//  Created by Nammy Dun on 15/11/2019.
//  Copyright © 2019 golfholics. All rights reserved.
//

import Foundation
import UIKit

class LiveGolfTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    
    @IBOutlet weak var p1NameTopLabel: UILabel!
    @IBOutlet weak var p2NameTopLabel: UILabel!
    @IBOutlet weak var p3NameTopLabel: UILabel!
    @IBOutlet weak var p4NameTopLabel: UILabel!
    @IBOutlet weak var p1NameBottomLabel: UILabel!
    @IBOutlet weak var p2NameBottomLabel: UILabel!
    @IBOutlet weak var p3NameBottomLabel: UILabel!
    @IBOutlet weak var p4NameBottomLabel: UILabel!
    
    @IBOutlet var p1ScoresLabels: [UILabel]!
    @IBOutlet weak var p1ScoreOutTotal: UILabel!
    @IBOutlet weak var p1ScoreInTotal: UILabel!
    @IBOutlet weak var p1ScoreTotal: UILabel!

    @IBOutlet var p2ScoresLabels: [UILabel]!
    @IBOutlet weak var p2ScoreOutTotal: UILabel!
    @IBOutlet weak var p2ScoreInTotal: UILabel!
    @IBOutlet weak var p2ScoreTotal: UILabel!

    @IBOutlet var p3ScoresLabels: [UILabel]!
    @IBOutlet weak var p3ScoreOutTotal: UILabel!
    @IBOutlet weak var p3ScoreInTotal: UILabel!
    @IBOutlet weak var p3ScoreTotal: UILabel!

    
    @IBOutlet var p4ScoresLabels: [UILabel]!
    @IBOutlet weak var p4ScoreOutTotal: UILabel!
    @IBOutlet weak var p4ScoreInTotal: UILabel!
    @IBOutlet weak var p4ScoreTotal: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
}

//
//  RecordRow.swift
//  UHL WatchKit Extension
//
//  Created by IJke Botman on 18/01/2018.
//  Copyright © 2018 IJke Botman. All rights reserved.
//

import WatchKit

class RecordRow: NSObject {
    // Assumes away team on top; home team on bottom
    @IBOutlet var awayGroup: WKInterfaceGroup!
    @IBOutlet var homeGroup: WKInterfaceGroup!
    @IBOutlet var awayLogo: WKInterfaceImage!
    @IBOutlet var homeLogo: WKInterfaceImage!
    @IBOutlet var awayNameLabel: WKInterfaceLabel!
    @IBOutlet var homeNameLabel: WKInterfaceLabel!
    @IBOutlet var awayScoreLabel: WKInterfaceLabel!
    @IBOutlet var homeScoreLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
}

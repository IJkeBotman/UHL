//
//  RecordInterfaceController.swift
//  UHL WatchKit Extension
//
//  Created by IJke Botman on 18/01/2018.
//  Copyright © 2018 IJke Botman. All rights reserved.
//

import WatchKit
import Foundation


class RecordInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let playedMatches = season.playedMatches
        
        table.setNumberOfRows(playedMatches.count, withRowType: "RecordRowType")
        
        for (index, match) in playedMatches.reversed().enumerated() {
            updateRow(at: index, with: match)
        }
        
        updateTitle()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateTitle() {
        self.setTitle(season.record)
    }
    
    func updateRow(at index: Int, with match: Match) {
        guard let row = table.rowController(at: index) as? RecordRow else {
            return
        }
        
        row.homeNameLabel.setText(match.home.name)
        row.homeLogo.setImageNamed(match.home.logoName)
        
        row.awayNameLabel.setText(match.away.name)
        row.awayLogo.setImageNamed(match.away.logoName)
        
        row.dateLabel.setText(match.date.mediumDate)
        
        guard let homeScore = match.score(for: match.home), let awayScore = match.score(for: match.away) else {
            return
        }
        
        row.homeScoreLabel.setText("\(homeScore)")
        row.awayScoreLabel.setText("\(awayScore)")
        
        
        var group: WKInterfaceGroup?
        var label: WKInterfaceLabel?
        
        if homeScore > awayScore {
            group = row.homeGroup
            label = row.homeScoreLabel
        } else if homeScore < awayScore {
            group = row.awayGroup
            label = row.awayScoreLabel
        }
        
        let imageName = ourTeam == match.winner ? "win-triangle" : "lose-triangle"
        
        let green = UIColor(red: 78 / 255.0, green: 216 / 255.0, blue: 102 / 255.0, alpha: 1.0)
        let red = UIColor(red: 255 / 255.0, green: 49 / 255.0, blue: 81 / 255.0, alpha: 1.0)
        let color = ourTeam == match.winner ? green : red
        
        group?.setBackgroundImageNamed(imageName)
        label?.setTextColor(color)
    }
    
    @IBAction func playNowButtonPressed() {
        let match = Match()
        season.matches.append(match)
        table.insertRows(at: [0], withRowType: "RecordRowType")
        updateRow(at: 0, with: match)
        updateTitle()
    }
    
    @IBAction func removeLastButtonPressed() {
        guard let match = season.playedMatches.last, let matchIndex = season.matches.index(of: match) else {
            return
        }
        season.matches.remove(at: matchIndex)
        table.removeRows(at: [0])
        updateTitle()
    }
}

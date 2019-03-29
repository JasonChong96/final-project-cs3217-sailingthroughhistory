//
//  GameParameter.swift
//  SailingThroughHistory
//
//  Created by henry on 17/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import Foundation

class GameParameter: GenericLevel, Codable {
    var playerParameters = [PlayerParameter]()
    var itemParameters = [ItemParameter]()
    var eventParameters = [EventParameter]()
    var teams = [Team]()
    var numOfTurn = GameConstants.numOfTurn
    var timeLimit = Int(GameConstants.playerTurnDuration)
    var map = Map()

    required init(teams: [String]) {
        for teamName in teams {
            self.teams.append(Team(name: teamName))
        }
    }

    func getNumOfTurn() -> Int {
        return numOfTurn
    }

    func getTimeLimit() -> Int {
        return timeLimit
    }

    func setNumOfTurn(_ num: Int) {
        self.numOfTurn = num
    }

    func setTimeLimit(_ num: Int) {
        self.timeLimit = num
    }
}

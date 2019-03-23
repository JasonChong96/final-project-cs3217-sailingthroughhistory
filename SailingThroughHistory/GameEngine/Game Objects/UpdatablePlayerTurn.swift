//
//  UpdatablePlayerTurn.swift
//  SailingThroughHistory
//
//  Created by Herald on 20/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class UpdatablePlayerTurn: GameObject, Updatable {
    var status: UpdatableStatus = .add
    private let gameState: GenericGameState

    init(gameState: GenericGameState) {
        self.gameState = gameState
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func update(weeks: Double) -> Bool {
        return false
    }

    func checkForEvent() -> GenericGameEvent? {
        return nil
    }
}

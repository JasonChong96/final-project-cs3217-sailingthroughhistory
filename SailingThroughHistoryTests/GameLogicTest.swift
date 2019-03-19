//
//  GameLogicTest.swift
//  SailingThroughHistoryTests
//
//  Created by Herald on 18/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import XCTest
@testable import SailingThroughHistory

class GameLogicTest: XCTestCase {

    func testSetGameSpeed() {
        let logic = GameLogic(gameState: GameState())
        var event = BaseGameEvent(eventType: EventType.informative(initiater: ""), timestamp: 1, message: "")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        logic.setGameSpeed(using: event)
        XCTAssertEqual(logic.getGameSpeed(), logic.fastestGameSpeed, "Wrong game speed!")
        event.timestamp = 1.1
        logic.setGameSpeed(using: event)
        XCTAssertEqual(logic.getGameSpeed(), logic.fastestGameSpeed, "Wrong game speed!")
        event.timestamp = 0
        logic.setGameSpeed(using: event)
        XCTAssertEqual(logic.getGameSpeed(), logic.slowestGameSpeed, "Wrong game speed!")
        event.timestamp = -0.1
        logic.setGameSpeed(using: event)
        XCTAssertEqual(logic.getGameSpeed(),
                       Double.lerp(0.1 * logic.forecastDuration, logic.slowestGameSpeed,
                                   logic.fastestGameSpeed), "Wrong game speed!")
        event.timestamp = 0.6
        logic.setGameSpeed(using: event)
        XCTAssertEqual(logic.getGameSpeed(),
                       Double.lerp(0.6 * logic.forecastDuration, logic.fastestGameSpeed,
                                   logic.slowestGameSpeed), "Wrong game speed!")

    }

    func testUpdateGameState() {
        let gameState = GameState()
        let logic = GameLogic(gameState: gameState)
        logic.updateGameState(deltaTime: 1.0)
        // TODO: Write test to check months and weeks have been updated correctly
        // TODO: Write test to check that player movement have been done correctly
        // Bonus: Write test to check that game speed is set to tolerable bounds
    }
}

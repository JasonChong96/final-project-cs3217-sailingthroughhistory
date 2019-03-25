//
//  GameState+TurnBasedGame.swift
//  SailingThroughHistory
//
//  Created by Herald on 18/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class EmotionEngine: GenericTurnBasedGame {
    let gameLogic: GameLogic

    var currentGameTime: Double = 0
    var largestTimeStep: Double = EngineConstants.largestTimeStep
    var forecastDuration: Double = EngineConstants.forecastDuration
    var daysToSeconds: Double = EngineConstants.weeksToSeconds

    // used for controls, pausing, speeding up
    var externalGameSpeed: Double = 1
    // used for emotion engine
    var fastestGameSpeed: Double = EngineConstants.fastestGameSpeed
    var slowestGameSpeed: Double = EngineConstants.slowestGameSpeed

    private var gameSpeed: Double = 1
    // used to compute the speed of the game
    private var nextEvent: GenericGameEvent

    init(gameLogic: GameLogic) {
        self.nextEvent = GameEvent(eventType: EventType.informative(initiater: ""),
                                   timestamp: 0, message: nil)
        self.gameLogic = gameLogic
    }

    func updateGameState(deltaTime: Double) -> GenericGameEvent? {
        var timeDifference = deltaTime
        while timeDifference * gameSpeed * externalGameSpeed > largestTimeStep {
            // we break it into multiple cycles
            timeDifference -= largestTimeStep / gameSpeed / externalGameSpeed
            let event = updateGame(largestTimeStep)
            setGameSpeed(using: nextEvent)
            if event != nil {
                return event
            }
        }
        return updateGame(timeDifference * gameSpeed * externalGameSpeed)
    }

    func getDrawableManager() -> DrawableManager {
        return gameLogic
    }
    func getTimeUpdatable() -> TimeUpdatable {
        return gameLogic
    }

    private func updateGame(_ deltaTime: Double) -> GenericGameEvent? {
        currentGameTime += deltaTime
        guard let event = gameLogic.updateForTime(deltaTime: deltaTime) else {
            gameLogic.invalidateCache() // just in case
            return nil
        }
        let eventTimeDifference = event.timestamp - currentGameTime
        if eventTimeDifference <= 0 {
            // event has started
            return event
        }
        // will be improving efficiency in next ieration
        if event.timestamp < currentGameTime {
            nextEvent = event
        }
        return nil
    }

    // interpolate the speed based on how close the event is to happening
    func setGameSpeed(using event: Timestampable) {
        let eventTimeDifference = event.timestamp - currentGameTime
        var alpha: Double = 0
        if eventTimeDifference >= 0 {
            alpha = 1 - ((forecastDuration - eventTimeDifference) / forecastDuration)
        } else {
            alpha = ((forecastDuration + eventTimeDifference) / forecastDuration)
        }
        alpha = Double.clamp(alpha, 0, 1)
        gameSpeed = Double.lerp(alpha, fastestGameSpeed, slowestGameSpeed)
    }

    // for testing
    func getGameSpeed() -> Double {
        return gameSpeed
    }
}
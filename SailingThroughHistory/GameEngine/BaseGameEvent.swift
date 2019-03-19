//
//  GameEvent.swift
//  SailingThroughHistory
//
//  Created by Herald on 18/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

struct BaseGameEvent: GameEvent {
    var eventType: EventType
    var timestamp: Double
    var message: String
}

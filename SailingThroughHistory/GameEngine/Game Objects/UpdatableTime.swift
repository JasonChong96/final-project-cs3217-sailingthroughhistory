//
//  UpdatableTime.swift
//  SailingThroughHistory
//
//  Created by Herald on 20/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class UpdatableTime: GameObject, Updatable {
    var status: UpdatableStatus = .add

    func update(weeks: Double) -> Bool {
        return false
    }
    
    func checkForEvent() -> GenericGameEvent? {
        return nil
    }
}

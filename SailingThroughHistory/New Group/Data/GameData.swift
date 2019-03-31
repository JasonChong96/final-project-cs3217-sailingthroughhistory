//
//  GameData.swift
//  SailingThroughHistory
//
//  Created by Herald on 30/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class GameData: UniqueObject, BaseGameObject {
    var operators: [GenericOperator] = []
    var evaluators: [GenericEvaluateOperator] = []

    var displayName: String
    var events: [Int : Observer] = [Int: Observer]()
    var objects: [String : Any?] = [String: Any?]()
    var fields: [String] = [
    "Players",
    "Map"
    ]

    init(displayName: String) {
        self.displayName = displayName
        super.init()
    }
}

//
//  DiceData.swift
//  SailingThroughHistory
//
//  Created by Herald on 31/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class DiceData: UniqueObject, BaseGameObject {
    enum DiceType {
        case uniform
    }

    var operators: [GenericOperator] = []
    var evaluators: [GenericEvaluateOperator] = []
    
    var displayName: String
    var events: [Int : Observer] = [Int: Observer]()
    var objects: [String : Any?] = [String: Any?]()
    var fields: [String] = [
        "dice type",
        "current roll",
        "max roll"
    ]
    
    init(displayName: String, diceType: DiceType, maxRoll: Int) {
        self.displayName = displayName
        super.init()
        _ = setField(field: fields[0], object: diceType)
        _ = setField(field: fields[1], object: 0)
        _ = setField(field: fields[2], object: maxRoll)
    }

    func setField(field: String, object: Any?) -> Bool {
        switch field {
        case fields[0]:
            guard let _ = object as? DiceType else {
                return false
            }
        case fields[1]:
            guard let _ = object as? Int else {
                return false
            }
        case fields[2]:
            guard let _ = object as? Int else {
                return false
            }
        default:
            return false
        }
        objects[field] = object
        return true
    }
}

//
//  Ship.swift
//  SailingThroughHistory
//
//  Created by henry on 17/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import Foundation
import RxSwift

class Ship {
    private var location: Variable<Node>
    private var items = [ItemType]()
    private var capacity = 0
    private var chassis: Upgrade?
    private var axuxiliaryUpgrade: Upgrade?
    
    public init(location: Node)
    {
        self.location = Variable(location)
    }
    
    public func getNodesInRange() -> [Node] {
        return []
    }
    
    public func move() {
        
    }
    
    private func computeMovement(roll: Int) -> Double {
        var multiplier = 1.0
        return Double(roll)
    }
    
    private func applyUpgradesModifiers(to multiplier: Double) -> Double {
        return multiplier
    }
    
    private func applyEnvironmentModifiers(to multiplier: Double) -> Double {
        return multiplier
    }
}

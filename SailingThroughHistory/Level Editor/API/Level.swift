//
//  Level.swift
//  SailingThroughHistory
//
//  Created by henry on 17/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import Foundation

protocol Level {
    var itemTypes: ItemParameter { get set }

    func getPlayers() -> [Player]
    func getMap() -> Map
}

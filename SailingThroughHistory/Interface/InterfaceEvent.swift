//
//  InterfaceEvent.swift
//  SailingThroughHistory
//
//  Created by Jason Chong on 15/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import UIKit

enum InterfaceEvent {
    case toggleUpgradesMenu(isVisible: Bool)
    case arriveAt(port: Port)
    case move(_: GameObject, toFrame: CGRect)
    case addObject(_: GameObject, atFrame: CGRect)
    case addPath(_: Path)
    case changeMonth(toMonth: String)
    case playerTurnStart
    case pauseAndShowAlert(titled: String, withMsg: String)
}

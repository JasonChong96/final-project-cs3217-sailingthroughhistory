//
//  Weather.swift
//  SailingThroughHistory
//
//  Created by Jason Chong on 14/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import UIKit

class Weather: Volatile {
    var windVelocity: Float = 0
    let strengths: [Float] = Default.Weather.strengths

    func applyVelocityModifier(to oldVelocity: Float, with modifier: Float) -> Float {
        if isActive {
            return oldVelocity + windVelocity
        } else {
            return oldVelocity
        }
    }

    /// Update wind velocity based on current month strength.
    func update(currentMonth: Int) {
        windVelocity = strengths[currentMonth / 4]
        isActive = windVelocity == 0
    }
}

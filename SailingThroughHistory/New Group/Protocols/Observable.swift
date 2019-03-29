//
//  Observable.swift
//  SailingThroughHistory
//
//  Created by Herald on 28/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

protocol Observable: class {
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
}

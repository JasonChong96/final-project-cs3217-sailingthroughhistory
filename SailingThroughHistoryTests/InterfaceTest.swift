//
//  InterfaceTest.swift
//  SailingThroughHistoryTests
//
//  Created by Jason Chong on 23/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import XCTest
@testable import SailingThroughHistory

class InterfaceTest: XCTestCase {
    private let bounds = CGRect.zero
    private let objectFrame = CGRect.zero
    private let frame2 = CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1))
    private lazy var object = GameObject(image: "", frame: objectFrame)
    private lazy var object2 = GameObject(image: "", frame: frame2)
    private lazy var interface = Interface(players: [], bounds: bounds)

    func testInit() {
        XCTAssertTrue(interface.players.isEmpty, "Interface initialized with no " +
            "players contain players.")
        XCTAssertEqual(bounds, interface.bounds, "Interface was not initialized" +
            "with the input bounds.")
    }

    func testAdd() {
        interface.add(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], objectFrame, "GameObject was not added properly.")
        interface.add(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], objectFrame, "GameObject was removed after being added again.")

        interface.add(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], objectFrame, "GameObject was removed after being added again.")
        XCTAssertEqual(interface.objectFrames[object2], frame2, "Second game object" +
            " was not added properly.")

        object.frame = frame2
        interface.add(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], frame2, "object frame was not updated after being added again.")
    }

    func testUpdatePosition() {
        interface.updatePosition(of: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertNil(interface.objectFrames[object], "Non existant game object was added after move.")

        interface.add(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)

        object.frame = frame2
        interface.updatePosition(of: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], frame2, "Frame was not updated properly.")

        interface.add(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)

        object2.frame = objectFrame
        interface.updatePosition(of: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object2], objectFrame, "Frame was not updated properly.")
        XCTAssertEqual(interface.objectFrames[object], frame2, "Wrong frame was updated")
    }

    func testRemove() {
        interface.add(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        interface.remove(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object], objectFrame, "Wrong object was affected by remove")

        interface.add(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        interface.remove(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertNil(interface.objectFrames[object2], "Object not removed properly")

        interface.remove(object: object)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertNil(interface.objectFrames[object], "Object not removed properly")
    }

    func testAddRemove() {
        interface.add(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        interface.remove(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        interface.add(object: object2)
        interface.broadcastInterfaceChanges(withDuration: 0)
        XCTAssertEqual(interface.objectFrames[object2], frame2, "Wrong object was affected by remove")

    }

    /// TODO: Tests for path.
}

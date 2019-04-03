//
//  GenericPlayer.swift
//  SailingThroughHistory
//
//  Created by henry on 18/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import Foundation

protocol GenericPlayer: class, Codable {
    var name: String { get }
    var team:  Team { get }
    var money: GameVariable<Int> { get }
    var currentCargoWeight: Int { get }
    var weightCapacity: Int { get }
    var state: GameVariable<PlayerState> { get }
    var node: Node? { get }
    var hasRolled: Bool { get }
    var deviceId: String { get }
    var map: Map? { get set }

    func getItemParameter(itemType: ItemType) -> ItemParameter?
    func addShipsToMap(map: Map)

    // update money
    func updateMoney(by amount: Int)

    // Subscribes
    func subscribeToItems(with observer: @escaping (GenericPlayer, [GenericItem]) -> Void)
    func subscribeToCargoWeight(with observer: @escaping (GenericPlayer, Int) -> Void)
    func subscribeToWeightCapcity(with observer: @escaping (GenericPlayer, Int) -> Void)
    func subscribeToMoney(with observer: @escaping (GenericPlayer, Int) -> Void)

    // Before moving
    func startTurn(speedMultiplier: Double, map: Map?)
    func buyUpgrade(upgrade: Upgrade)
    func setTax(port: Port, amount: Int)
    func roll() -> Int

    // Moving - Auto progress to End turn if cannot dock
    func move(nodeId: Int)
    func getPath(to nodeId: Int) -> [Int]
    func getNodesInRange(roll: Int) -> [Node]

    // After moving can choose to dock
    func canDock() -> Bool
    func dock()

    // Docked - End turn is manual here
    func getPurchasableItemParameters() -> [ItemParameter]
    func getMaxPurchaseAmount(itemParameter: ItemParameter) -> Int
    func buy(itemParameter: ItemParameter, quantity: Int)
    func sell(item: GenericItem)
    func sell(itemType: ItemType, quantity: Int)

    // End turn - supplies are removed here
    func endTurn()
}

func == (lhs: GenericPlayer, rhs: GenericPlayer?) -> Bool {
    return lhs.name == rhs?.name
}

func != (lhs: GenericPlayer, rhs: GenericPlayer?) -> Bool {
    return !(lhs == rhs)
}

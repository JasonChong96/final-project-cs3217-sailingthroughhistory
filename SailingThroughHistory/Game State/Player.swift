//
//  Player.swift
//  SailingThroughHistory
//
//  Created by henry on 17/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

import Foundation

class Player: GenericPlayer {
    let deviceId: String
    var hasRolled: Bool = false
    private var rollResult: Int = 0

    func roll() -> Int {
        if hasRolled {
            return rollResult
        }
        // roll something here
        return rollResult
    }

    let money = GameVariable(value: 0)
    let state = GameVariable(value: PlayerState.endTurn)
    var name: String
    var team: Team
    var node: Node? {
        return getNodesInRange(roll: 0).first
    }
    var map: Map?
    var currentNode: Node {
        return ship.location.value.start
    }

    private let ship: Ship
    private var gameState: GenericGameState?
    private var speedMultiplier = 1.0
    private var shipChassis: ShipChassis?
    private var auxiliaryUpgrade: AuxiliaryUpgrade?

    required init(name: String, team: Team, map: Map, node: Node, deviceId: String) {
        self.name = name
        self.team = team
        self.deviceId = deviceId
        ship = Ship(node: node, suppliesConsumed: [])
        ship.setOwner(owner: self)
        ship.setMap(map: map)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        team = try values.decode(Team.self, forKey: .team)
        money.value = try values.decode(Int.self, forKey: .money)
        ship = try values.decode(Ship.self, forKey: .ship)
        deviceId = try values.decode(String.self, forKey: .deviceId)

        ship.setOwner(owner: self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
        try container.encode(money.value, forKey: .money)
        try container.encode(ship, forKey: .ship)
        try container.encode(deviceId, forKey: .deviceId)
    }

    func getItemParameter(itemType: ItemType) -> ItemParameter? {
        let parameters = gameState?.itemParameters ?? []
        return parameters.first(where: { $0.itemType == itemType })
    }

    func addShipsToMap(map: Map) {
        ship.setMap(map: map)
    }

    func startTurn(speedMultiplier: Double, map: Map?) {
        self.speedMultiplier = speedMultiplier
        self.map = map
        state.value = PlayerState.moving
        ship.startTurn()
    }

    func buyUpgrade(upgrade: Upgrade) {
        ship.installUpgade(upgrade: upgrade)
    }

    // TODO: Next milestone
    func setTax(port: Port, amount: Int) {
        port.taxAmount = amount
    }

    func move(node: Node) {
        ship.move(node: node)
    }

    func getNodesInRange(roll: Int) -> [Node] {
        return ship.getNodesInRange(roll: roll, speedMultiplier: speedMultiplier, map: map)
    }

    func canDock() -> Bool {
        return ship.canDock()
    }

    func dock() {
        let port = ship.dock()
        port?.collectTax(from: self)
    }

    func getPurchasableItemParameters() -> [ItemParameter] {
        return ship.getPurchasableItemParameters()
    }

    func getMaxPurchaseAmount(itemParameter: ItemParameter) -> Int {
        return ship.getMaxPurchaseAmount(itemParameter: itemParameter)
    }

    func buy(itemParameter: ItemParameter, quantity: Int) {
        ship.buyItem(itemParameter: itemParameter, quantity: quantity)
    }

    func sell(item: GenericItem) {
        ship.sellItem(item: item)
    }

    func updateMoney(by amount: Int) {
        self.money.value += amount
        self.team.updateMoney(by: amount)
    }

    func endTurn() {
        ship.endTurn(speedMultiplier: speedMultiplier)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case team
        case money
        case ship
        case deviceId
    }
}

// MARK: - subscribes
extension Player {
    func getLocation() -> GameVariable<Location> {
        return ship.location
    }

    func subscribeToItems(with observer: @escaping ([GenericItem]) -> Void) {
        ship.subscribeToItems(with: observer)
    }

    func subscribeToCargoWeight(with observer: @escaping (Int) -> Void) {
        ship.subscribeToCargoWeight(with: observer)
    }

    func subscribeToWeightCapcity(with observer: @escaping (Int) -> Void) {
        ship.subscribeToWeightCapcity(with: observer)
    }

    private func preventPlayerBankruptcy(amount: Int) {
        //interface?.pauseAndShowAlert(titled: "Donations!", withMsg: "You have received \(-amount) amount of donations from your company. Try not to go negative again!")
        //interface?.broadcastInterfaceChanges(withDuration: 0.5)
        team.updateMoney(by: -amount)
        money.value = 0
    }
}

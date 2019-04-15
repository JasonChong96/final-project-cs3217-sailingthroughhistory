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
    let isGameMaster = false
    var hasRolled: Bool = false
    private var rollResult: Int = 0

    let numDieSides = 6
    let money = GameVariable(value: 0)
    let state = GameVariable(value: PlayerState.endTurn)
    var name: String
    var team: Team?
    var node: Node? {
        return map?.nodeIDPair[ship.nodeId]
    }
    var nodeIdVariable: GameVariable<Int> {
        return ship.nodeIdVariable
    }
    var map: Map? {
        didSet {
            guard let map = map else {
                return
            }
            ship.map = map
            if canDock() {
                do {
                    try dock()
                } catch {
                    fatalError("Unable to dock")
                }
            }
        }
    }
    var currentCargoWeight: Int {
        return ship.currentCargoWeight
    }
    var weightCapacity: Int {
        return ship.weightCapacity
    }

    // for events
    var playerShip: Ship? {
        return ship
    }
    let homeNode: Int

    var gameState: GenericGameState?
    private let ship: Ship
    private var speedMultiplier = 1.0
    private var shipChassis: ShipChassis?
    private var auxiliaryUpgrade: AuxiliaryUpgrade?

    init(name: String, team: Team, map: Map, node: Node, itemsConsumed: [GenericItem], deviceId: String) {
        self.name = name
        self.team = team
        self.map = map
        self.deviceId = deviceId
        self.homeNode = node.identifier
        ship = Ship(node: node, itemsConsumed: itemsConsumed)
        ship.owner = self
        ship.map = map
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        team = try values.decode(Team.self, forKey: .team)
        money.value = try values.decode(Int.self, forKey: .money)
        ship = try values.decode(Ship.self, forKey: .ship)
        deviceId = try values.decode(String.self, forKey: .deviceId)
        homeNode = try values.decode(Int.self, forKey: .homeNode)
        ship.owner = self
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
        try container.encode(money.value, forKey: .money)
        try container.encode(ship, forKey: .ship)
        try container.encode(deviceId, forKey: .deviceId)
        try container.encode(homeNode, forKey: .homeNode)
    }

    func getItemParameter(itemType: ItemType) -> ItemParameter? {
        let parameters = gameState?.itemParameters ?? []
        return parameters.first(where: { $0.value.itemType == itemType })?.value
    }

    func addShipsToMap(map: Map) {
        ship.map = map
    }

    func startTurn(speedMultiplier: Double, map: Map?) {
        self.speedMultiplier = speedMultiplier
        self.map = map
        hasRolled = false
        state.value = PlayerState.moving
        return ship.startTurn()
    }

    func buyUpgrade(upgrade: Upgrade) -> (Bool, InfoMessage?) {
        return ship.installUpgrade(upgrade: upgrade)
    }

    func roll() -> (Int, [Int]) {
        if !hasRolled {
            rollResult = Int.random(in: 1...numDieSides)
            hasRolled = true
        }
        return (rollResult, getNodesInRange(roll: rollResult).map({ $0.identifier }))
    }

    func move(nodeId: Int) {
        guard let node = map?.nodeIDPair[nodeId] else {
            return
        }
        ship.move(node: node)
    }

    func getPath(to nodeId: Int) -> [Int] {
        guard let map = map else {
            fatalError("Player is not on a map")
        }

        guard let toNode = map.nodeIDPair[nodeId] else {
            fatalError("To node does not exist")
        }

        return ship.node
            .getCompleteShortestPath(to: toNode, with: ship, map: map)
            .map { $0.identifier }
    }

    func getNodesInRange(roll: Int) -> [Node] {
        guard let map = map else {
            fatalError("Cannot check dock if map does not exist.")
        }
        return ship.getNodesInRange(roll: roll, speedMultiplier: speedMultiplier, map: map)
    }

    func canDock() -> Bool {
        guard map != nil else {
            fatalError("Cannot check dock if map does not exist.")
        }
        return ship.canDock()
    }

    func dock() throws {
        let port = try ship.dock()
        port.collectTax(from: self)
    }

    func getPirateEncounterChance() -> Double {
        guard let map = map,
            !(auxiliaryUpgrade is MercernaryUpgrade) else {
            return 0
        }
        let position = ship.node
        if position is Port {
            return 0
        }
        var chance = map.basePirateRate
        let pirateIslands = map.getPiratesIslands()

        for (pirateNode, pirateIsland) in pirateIslands {
            guard let distance = pirateNode.getNumNodesTo(to: position, map: map),
                distance <= pirateIsland.influence else {
                continue
            }
            chance = max(chance, pirateIsland.chance)
        }

        return chance
    }

    func getPurchasableItemTypes() -> [ItemType] {
        return ship.getPurchasableItemTypes()
    }

    func getMaxPurchaseAmount(itemParameter: ItemParameter) -> Int {
        return ship.getMaxPurchaseAmount(itemParameter: itemParameter)
    }

    func buy(itemType: ItemType, quantity: Int) throws {
        try ship.buyItem(itemType: itemType, quantity: quantity)
    }

    func sell(item: GenericItem) throws {
        try ship.sellItem(item: item)
    }

    func sell(itemType: ItemType, quantity: Int) throws {
        try ship.sell(itemType: itemType, quantity: quantity)
    }

    func setTax(port: Port, amount: Int) throws {
        let maxTaxAmount = gameState?.maxTaxAmount ?? 0
        guard amount <= maxTaxAmount else {
            throw PortAdminError.exceedMaxTax(maxTaxAmount: maxTaxAmount)
        }
        guard amount >= 0 else {
            throw PortAdminError.belowMinTax(minTaxAmount: 0)
        }
        guard team == port.owner else {
            throw PortAdminError.badPortOwnership
        }
        port.taxAmount.value = amount
    }

    func updateMoney(by amount: Int) {
        money.value += amount
        team?.updateMoney(by: amount)
        guard money.value >= 0 else {
            preventPlayerBankruptcy(amount: money.value)
            return
        }
    }

    func updateMoney(to amount: Int) {
        updateMoney(by: amount - money.value)
    }

    func canBuyUpgrade() -> Bool {
        return ship.isDocked
    }

    func endTurn() -> [InfoMessage] {
        hasRolled = false
        return ship.endTurn(speedMultiplier: speedMultiplier)
    }

    func canTradeAt(port: Port) -> Bool {
        return ship.isDocked && ship.nodeId == port.identifier
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case team
        case money
        case ship
        case deviceId
        case homeNode
    }
}

// MARK: - subscribes
extension Player {
    func subscribeToItems(with observer: @escaping (GenericPlayer, [GenericItem]) -> Void) {
        ship.subscribeToItems {
            observer(self, $0)
        }
    }

    func subscribeToCargoWeight(with observer: @escaping (GenericPlayer, Int) -> Void) {
        ship.subscribeToCargoWeight {
            observer(self, $0)
        }
    }

    func subscribeToWeightCapcity(with observer: @escaping (GenericPlayer, Int) -> Void) {
        ship.subscribeToWeightCapcity {
            observer(self, $0)
        }
    }

    func subscribeToMoney(with observer: @escaping (GenericPlayer, Int) -> Void) {
        money.subscribe {
            observer(self, $0)
        }
    }

    private func preventPlayerBankruptcy(amount: Int) {
        // TODO: Show some message?
        team?.updateMoney(by: -amount)
        money.value = 0
    }
}

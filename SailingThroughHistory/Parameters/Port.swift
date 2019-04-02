//
//  Port.swift
//  SailingThroughHistory
//
//  Created by Jason Chong on 14/3/19.
//  Copyright © 2019 Sailing Through History Team. All rights reserved.
//

class Port: Node {
    public var taxAmount = 0
    public var owner: Team? {
        didSet {
            self.ownerName = self.owner?.name
        }
    }
    public var ownerName: String?
    private var itemParameters: [ItemType: ItemParameter] = {
        var dictionary = [ItemType: ItemParameter]()
        ItemType.getAll().forEach {
            dictionary[$0] = ItemParameter(itemType: $0, displayName: $0.rawValue, weight: 0, isConsumable: true)
        }
        return dictionary
    }()
    // TODO: add item quantity editing in level editor
    var itemParametersSold = [ItemParameter]()

    private static let portNodeWidth: Double = 50
    private static let portNodeHeight: Double = 50

    init(team: Team, originX: Double, originY: Double) {
        guard let frame = Rect(originX: originX, originY: originY, height: Port.portNodeHeight,
                               width: Port.portNodeWidth) else {
                                fatalError("Port dimensions are invalid.")
        }
        owner = team
        super.init(name: team.name, frame: frame)
    }

    init(team: Team?, name: String, originX: Double, originY: Double) {
        guard let frame = Rect(originX: originX, originY: originY, height: Port.portNodeHeight,
                               width: Port.portNodeWidth) else {
                                fatalError("Port dimensions are invalid.")
        }

        super.init(name: name, frame: frame)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ownerName = try values.decode(String?.self, forKey: .ownerName)
        itemParameters = try values.decode([ItemType: ItemParameter].self, forKey: .itemParameters)
        itemParametersSold = try values.decode([ItemParameter].self, forKey: .itemsSold)
        let superDecoder = try values.superDecoder()
        try super.init(from: superDecoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(owner?.name, forKey: .ownerName)
        try container.encode(itemParameters, forKey: .itemParameters)
        try container.encode(itemParametersSold, forKey: .itemsSold)

        let superencoder = container.superEncoder()
        try super.encode(to: superencoder)
    }

    public func assignOwner(_ team: Team?) {
        owner = team
    }

    public func collectTax(from player: Player) {
        // Prevent event listeners from firing unneccessarily
        if player.team == owner {
            return
        }
        player.updateMoney(by: -taxAmount)
        owner?.updateMoney(by: taxAmount)
    }

    func getBuyValue(of type: ItemType) -> Int? {
        return itemParameters[type]?.getBuyValue()
    }

    func getSellValue(of type: ItemType) -> Int? {
        return itemParameters[type]?.getSellValue()
    }

    func setBuyValue(of type: ItemType, value: Int) {
        itemParameters[type]?.setBuyValue(value: value)
    }

    func setSellValue(of type: ItemType, value: Int) {
        itemParameters[type]?.setSellValue(value: value)
    }

    // Availability at ports
    func delete(_ type: ItemType) {
        itemParameters[type] = nil
    }

    func getItemParametersSold() -> [ItemParameter] {
        var itemParametersSold = [ItemParameter]()
        for itemParameter in itemParameters.values {
            if itemParametersSold.contains(where: { item in item.itemType == itemParameter.itemType }) {
                itemParametersSold.append(itemParameter)
            }
        }
        return itemParametersSold
    }

    func getAllItemParameters() -> [ItemParameter] {
        // default/placeholder for all items
        return Array(itemParameters.values)
    }

    private enum CodingKeys: String, CodingKey {
        case ownerName
        case itemParameters
        case itemsSold
    }
}

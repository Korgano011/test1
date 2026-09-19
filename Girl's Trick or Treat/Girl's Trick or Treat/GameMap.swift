//
//  GameMap.swift
//  Girl's Trick or Treat
//

import Foundation

struct LevelMap {
    let rooms: [Int: Room]
    let moveBudget: Int
    let startRoomID: Int
}

enum GameMap {
    static let startRoomID = 0

    private static let goodTreats = [
        "a lollipop", "a chocolate bar", "gummy candy", "a candy corn pack",
        "a caramel apple", "a juice box", "a sticker sheet", "a glow bracelet",
        "a peanut butter cup", "a bag of popcorn", "a fun-size candy bar", "a jelly bean pouch",
        "a pumpkin cookie", "a mini donut",
    ]
    private static let badTreats = [
        "a box of raisins", "a piece of celery", "a toothbrush", "a single sad pretzel",
        "a bar of soap", "a carrot stick",
    ]

    /// A place to collect a treat: a house door or a car trunk.
    private struct Stop {
        let id: Int
        let name: String
        let backExit: Direction
        let backID: Int
        let isTrunk: Bool
    }

    private final class Builder {
        var rooms: [Int: Room] = [:]
        var stops: [Stop] = []
        private var nextID = 1

        func newID() -> Int {
            defer { nextID += 1 }
            return nextID
        }

        func add(_ id: Int, _ name: String, _ description: String, _ exits: [Direction: Int] = [:]) {
            rooms[id] = Room(id: id, name: name, description: description, exits: exits, treat: nil)
        }

        func link(_ id: Int, _ direction: Direction, to target: Int) {
            rooms[id]?.exits[direction] = target
        }

        /// Builds a street running east with a house on the north side and one on the south
        /// side at every stop. Returns the first and last street room IDs.
        func street(name: String, houses: Int, entryID: Int, entryDirection: Direction) -> (first: Int, last: Int) {
            let stopCount = (houses + 1) / 2
            var previous = entryID
            var first = 0
            var houseNumber = 0
            for k in 1...stopCount {
                let id = newID()
                if k == 1 { first = id }
                let sides: [Direction] = (k * 2 <= houses) ? [.north, .south] : [.north]
                var exits: [Direction: Int] = [entryDirection: previous]
                for side in sides {
                    houseNumber += 1
                    let doorID = newID()
                    exits[side] = doorID
                    let opposite: Direction = side == .north ? .south : .north
                    add(doorID, "\(name), house \(houseNumber)", "", [opposite: id])
                    stops.append(Stop(id: doorID, name: "\(name), house \(houseNumber)", backExit: opposite, backID: id, isTrunk: false))
                }
                let sideText = sides.count == 2
                    ? "Houses with their porch lights on face each other, one to the north and one to the south."
                    : "One last house sits to the north."
                add(id, "\(name), block \(k)", "Jack-o-lanterns line both sidewalks. \(sideText)", exits)
                link(previous, entryDirection == .west ? .east : .west, to: id)
                previous = id
            }
            return (first, previous)
        }
    }

    /// Level 1: 8 houses (6 good, 2 bad) on both sides of Maple Street.
    /// Level 2: 12 trunks (8 good, 4 bad) at an amusement-park style trunk-or-treat.
    /// Level 3: 16 houses (10 good, 6 bad, random) starting at Grandma's, then two neighborhoods by car.
    static func build(level: Int) -> LevelMap {
        let b = Builder()
        let houseCount = 4 + level * 4
        let badCount = level * 2

        switch level {
        case 1:
            b.add(startRoomID, "Your Driveway", "You're at the end of your driveway with your treat bag, ready for level 1. Maple Street, with houses on both sides, heads east.")
            _ = b.street(name: "Maple Street", houses: houseCount, entryID: startRoomID, entryDirection: .west)
        case 2:
            buildTrunkOrTreat(b)
        default:
            buildGrandmas(b)
        }

        // Assign treats to every stop.
        let stops = b.stops
        let randomBad: Set<Int> = level >= 3 ? Set((0..<stops.count).shuffled().prefix(badCount)) : []
        let spacing = max(1, stops.count / badCount)
        let goodNames = level >= 3 ? goodTreats.shuffled() : goodTreats
        let badNames = level >= 3 ? badTreats.shuffled() : badTreats
        for (index, stop) in stops.enumerated() {
            let isBad = level >= 3 ? randomBad.contains(index) : index % spacing == 0 && index / spacing < badCount
            let treat: Treat = isBad ? .bad(badNames[index % badNames.count]) : .good(goodNames[index % goodNames.count])
            let giver = stop.isTrunk ? "A costumed driver leans out of the trunk" : "The door creaks open"
            let description = isBad
                ? "\(giver)... and drops \(treat.flavorText) in your bag. Yuck!"
                : (stop.isTrunk ? "A friendly driver in a costume hands you \(treat.flavorText) from the trunk!"
                                : "A friendly neighbor smiles and gives you \(treat.flavorText)!")
            b.rooms[stop.id] = Room(id: stop.id, name: stop.name, description: description,
                                    exits: [stop.backExit: stop.backID], treat: treat)
        }

        let extra = level == 3 ? 12 : 0 // car rides and walking back to Grandma's street
        let moveBudget = houseCount * 3 + level * 2 + extra
        return LevelMap(rooms: b.rooms, moveBudget: moveBudget, startRoomID: startRoomID)
    }

    /// A hub "midway" with four attractions; each has three trunks to visit.
    private static func buildTrunkOrTreat(_ b: Builder) {
        let hub = startRoomID
        b.add(hub, "Trunk-or-Treat Midway",
              "Lights twinkle across the parking lot, which looks like an amusement park. Attractions lie in every direction: a Ferris Wheel to the north, a Carousel to the south, a Haunted Hayride to the east, and a Fun House to the west.")
        let areas: [(String, String, Direction)] = [
            ("Ferris Wheel Row", "A glowing Ferris Wheel turns overhead", .north),
            ("Carousel Row", "A carousel plays spooky organ music", .south),
            ("Haunted Hayride Row", "A hay wagon creaks past, full of screaming kids", .east),
            ("Fun House Row", "A giggling clown face grins over the entrance", .west),
        ]
        let trunkExits: [Direction: [Direction]] = [
            .north: [.north, .east, .west], .south: [.south, .east, .west],
            .east: [.east, .north, .south], .west: [.west, .north, .south],
        ]
        let opposite: [Direction: Direction] = [.north: .south, .south: .north, .east: .west, .west: .east]
        let trunkThemes = ["a spider web trunk", "a graveyard trunk", "a pirate ship trunk",
                           "a candy land trunk", "a haunted forest trunk", "a space alien trunk"]
        var themeIndex = 0
        for (name, flavor, dir) in areas {
            let areaID = b.newID()
            let back = opposite[dir]!
            b.add(areaID, name, "\(flavor). Decorated cars are parked in a ring around you. Head back \(back.displayName.lowercased()) to the Midway.", [back: hub])
            b.link(hub, dir, to: areaID)
            for exit in trunkExits[dir]! {
                let trunkID = b.newID()
                let theme = trunkThemes[themeIndex % trunkThemes.count]
                themeIndex += 1
                let trunkName = "\(name), \(theme)"
                b.add(trunkID, trunkName, "")
                b.link(areaID, exit, to: trunkID)
                let trunkBack = opposite[exit]!
                b.rooms[trunkID]?.exits[trunkBack] = areaID
                b.stops.append(Stop(id: trunkID, name: trunkName, backExit: trunkBack, backID: areaID, isTrunk: true))
            }
        }
    }

    /// Grandma's street, then Grandma's car, which drives to two more neighborhoods.
    private static func buildGrandmas(_ b: Builder) {
        b.add(startRoomID, "Grandma's Porch",
              "You're on Grandma's front porch in your costume, treat bag in hand. Just like when she visited. Her street, with houses on both sides, heads east.")
        let grandma = b.street(name: "Grandma's Street", houses: 4, entryID: startRoomID, entryDirection: .west)

        let car = b.newID()
        b.add(car, "Grandma's Car",
              "You climb into Grandma's big old car. \"Buckle up, sweetheart,\" she says. She can drive north to Orchard Hill, south to Willow Lane, or back west to her street.",
              [.west: grandma.last])
        b.link(grandma.last, .east, to: car)
        b.rooms[grandma.last] = Room(id: grandma.last, name: b.rooms[grandma.last]!.name,
                                     description: b.rooms[grandma.last]!.description + " Grandma's car is parked to the east.",
                                     exits: b.rooms[grandma.last]!.exits, treat: nil)

        for (name, dir, count) in [("Orchard Hill", Direction.north, 6), ("Willow Lane", Direction.south, 6)] {
            let back: Direction = dir == .north ? .south : .north
            let lot = b.newID()
            b.add(lot, "\(name) Entrance", "Grandma pulls up at the start of \(name). \"Off you go, I'll wait in the car,\" she says. The street heads east; the car is \(back.displayName.lowercased()).", [back: car])
            b.link(car, dir, to: lot)
            _ = b.street(name: name, houses: count, entryID: lot, entryDirection: .west)
        }
    }
}

//
//  Room.swift
//  Girl's Trick or Treat
//

import Foundation

enum Treat {
    case good(String)
    case bad(String)

    var points: Int {
        switch self {
        case .good: return 1
        case .bad: return -1
        }
    }

    var flavorText: String {
        switch self {
        case .good(let name): return name
        case .bad(let name): return name
        }
    }
}

struct Room: Identifiable {
    let id: Int
    let name: String
    let description: String
    var exits: [Direction: Int]
    let treat: Treat?
}

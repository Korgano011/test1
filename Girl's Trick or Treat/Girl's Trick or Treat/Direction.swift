//
//  Direction.swift
//  Girl's Trick or Treat
//

import Foundation

enum Direction: String, CaseIterable, Identifiable {
    case north, south, east, west, up, down

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var shorthand: String {
        switch self {
        case .north: return "n"
        case .south: return "s"
        case .east: return "e"
        case .west: return "w"
        case .up: return "u"
        case .down: return "d"
        }
    }

    static func parse(_ input: String) -> Direction? {
        var word = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for prefix in ["go ", "walk ", "move "] {
            if word.hasPrefix(prefix) {
                word = String(word.dropFirst(prefix.count))
            }
        }
        for direction in Direction.allCases {
            if word == direction.rawValue || word == direction.shorthand {
                return direction
            }
        }
        return nil
    }
}

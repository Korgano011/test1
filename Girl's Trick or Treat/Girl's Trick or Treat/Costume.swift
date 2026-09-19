//
//  Costume.swift
//  Girl's Trick or Treat
//

import SwiftUI

enum Costume: String, CaseIterable, Identifiable {
    case witch, clown, geisha, cat

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var emoji: String {
        switch self {
        case .witch: return "🧙‍♀️"
        case .clown: return "🤡"
        case .geisha: return "👘"
        case .cat: return "🐱"
        }
    }

    var themeColor: Color {
        switch self {
        case .witch: return .purple
        case .clown: return .pink
        case .geisha: return .red
        case .cat: return .orange
        }
    }
}

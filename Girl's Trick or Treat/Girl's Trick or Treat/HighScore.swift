//
//  HighScore.swift
//  Girl's Trick or Treat
//

import Combine
import Foundation

struct HighScore: Codable, Identifiable {
    var id = UUID()
    let name: String
    let score: Int
    let level: Int
    let date: Date
}

final class HighScoreStore: ObservableObject {
    private static let storageKey = "girlsTrickOrTreatHighScores"
    private static let maxEntries = 10

    @Published private(set) var scores: [HighScore] = []

    init() {
        load()
    }

    func qualifies(_ score: Int) -> Bool {
        scores.count < Self.maxEntries || score > (scores.last?.score ?? Int.min)
    }

    func add(name: String, score: Int, level: Int) {
        let entry = HighScore(name: name, score: score, level: level, date: Date())
        scores.append(entry)
        scores.sort { $0.score > $1.score }
        if scores.count > Self.maxEntries {
            scores.removeLast(scores.count - Self.maxEntries)
        }
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([HighScore].self, from: data) else {
            return
        }
        scores = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(scores) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}

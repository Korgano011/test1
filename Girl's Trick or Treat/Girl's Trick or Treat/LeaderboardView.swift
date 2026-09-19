//
//  LeaderboardView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var gameState: GameState
    @ObservedObject var highScores: HighScoreStore

    var body: some View {
        VStack(spacing: 16) {
            Text("🎃 Top Trick-or-Treaters 🎃")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            if highScores.scores.isEmpty {
                Spacer()
                Text("No scores yet. Be the first!")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(Array(highScores.scores.enumerated()), id: \.element.id) { index, entry in
                        HStack {
                            Text("#\(index + 1)")
                                .font(.headline)
                                .frame(width: 40, alignment: .leading)
                            Text(entry.name)
                            Text("Lvl \(entry.level)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(entry.score) pts")
                                .font(.headline)
                        }
                    }
                }
                .listStyle(.plain)
            }

            Button("Play Again") {
                gameState.reset()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    LeaderboardView(gameState: GameState(level: 1), highScores: HighScoreStore())
}

//
//  NameEntryView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct NameEntryView: View {
    @ObservedObject var gameState: GameState
    @ObservedObject var highScores: HighScoreStore
    @State private var name: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🏆")
                .font(.system(size: 80))
            Text("Top 10 score! What's your name?")
                .font(.title2)
                .multilineTextAlignment(.center)
            TextField("Your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .padding(.horizontal, 40)
            Spacer()
            Button("Save") {
                let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                highScores.add(name: trimmed.isEmpty ? "Trick-or-Treater" : trimmed, score: gameState.score, level: gameState.level)
                gameState.scene = .leaderboard
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let state = GameState(level: 1)
    state.score = 7
    return NameEntryView(gameState: state, highScores: HighScoreStore())
}

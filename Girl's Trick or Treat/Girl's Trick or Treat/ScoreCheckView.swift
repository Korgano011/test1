//
//  ScoreCheckView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct ScoreCheckView: View {
    @ObservedObject var gameState: GameState
    @ObservedObject var highScores: HighScoreStore

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🧺")
                .font(.system(size: 80))
            Text("Mother checks your treats...")
                .font(.title2)
                .multilineTextAlignment(.center)
            Text("\(gameState.score) points")
                .font(.system(size: 56, weight: .bold))
            Spacer()
            Button("Continue") {
                if highScores.qualifies(gameState.score) {
                    gameState.scene = .nameEntry
                } else {
                    gameState.scene = .leaderboard
                }
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
    state.score = 5
    return ScoreCheckView(gameState: state, highScores: HighScoreStore())
}

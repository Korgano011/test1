//
//  LevelFlowView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct LevelFlowView: View {
    @StateObject private var gameState: GameState
    @ObservedObject var highScores: HighScoreStore

    init(level: Int, highScores: HighScoreStore) {
        _gameState = StateObject(wrappedValue: GameState(level: level))
        self.highScores = highScores
    }

    var body: some View {
        Group {
            switch gameState.scene {
            case .bedroom:
                BedroomView(gameState: gameState)
            case .costumeSelect:
                CostumeSelectView(gameState: gameState)
            case .makeup:
                MakeupView(gameState: gameState)
            case .transform:
                TransformView(gameState: gameState)
            case .playing:
                GameplayView(gameState: gameState)
            case .scoreCheck:
                ScoreCheckView(gameState: gameState, highScores: highScores)
            case .nameEntry:
                NameEntryView(gameState: gameState, highScores: highScores)
            case .leaderboard:
                LeaderboardView(gameState: gameState, highScores: highScores)
            }
        }
        .animation(.easeInOut, value: gameState.scene)
    }
}

extension GameScene: Equatable {}

#Preview {
    LevelFlowView(level: 1, highScores: HighScoreStore())
}

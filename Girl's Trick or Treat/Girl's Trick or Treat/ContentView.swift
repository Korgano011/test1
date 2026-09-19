//
//  ContentView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct ContentView: View {
    @StateObject private var highScores = HighScoreStore()

    var body: some View {
        TabView {
            Tab("Level 1", systemImage: "1.circle") {
                LevelFlowView(level: 1, highScores: highScores)
            }
            Tab("Level 2", systemImage: "2.circle") {
                LevelFlowView(level: 2, highScores: highScores)
            }
            Tab("Level 3", systemImage: "3.circle") {
                LevelFlowView(level: 3, highScores: highScores)
            }
        }
    }
}

#Preview {
    ContentView()
}

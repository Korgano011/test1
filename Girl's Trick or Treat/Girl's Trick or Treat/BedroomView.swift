//
//  BedroomView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct BedroomView: View {
    @ObservedObject var gameState: GameState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🛏️")
                .font(.system(size: 80))
            Text("Your Bedroom")
                .font(.largeTitle.bold())
            Text("It's Halloween! You wake up in your bedroom, ready for level \(gameState.level). Time to go downstairs and pick a costume!")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button("Go Downstairs") {
                gameState.scene = .costumeSelect
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BedroomView(gameState: GameState(level: 1))
}

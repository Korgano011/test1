//
//  TransformView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct TransformView: View {
    @ObservedObject var gameState: GameState
    @State private var transformed = false
    @State private var spin = 0.0

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()
                ZStack {
                    CostumeAvatar(costume: nil, size: 140)
                        .opacity(transformed ? 0 : 1)
                        .scaleEffect(transformed ? 0.3 : 1)
                    CostumeAvatar(costume: gameState.costume, size: 140)
                        .opacity(transformed ? 1 : 0)
                        .scaleEffect(transformed ? 1 : 0.3)
                }
                .rotationEffect(.degrees(spin))
                Text(transformed
                     ? "Ta-da! You're a \(gameState.costume?.displayName.lowercased() ?? "costume")!"
                     : "Here goes...")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                Spacer()
                Button("Go Trick-or-Treating!") {
                    gameState.startPlaying()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .opacity(transformed ? 1 : 0)
                .disabled(!transformed)
                Spacer()
            }
            .padding()

            if transformed {
                SparkleOverlay(color: gameState.costume?.themeColor ?? .yellow)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    transformed = true
                    spin = 360
                }
            }
        }
    }
}

#Preview {
    let state = GameState(level: 1)
    state.costume = .cat
    return TransformView(gameState: state)
}

//
//  MakeupView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct MakeupView: View {
    @ObservedObject var gameState: GameState
    @State private var brushOffset: CGFloat = -40

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                CostumeAvatar(costume: nil, size: 110)
                Text("💄")
                    .font(.system(size: 40))
                    .offset(x: brushOffset, y: -50)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: brushOffset)
            }
            Text("Mother is getting you ready...")
                .font(.title2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .onAppear {
            brushOffset = 40
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                gameState.finishMakeup()
            }
        }
        .onTapGesture {
            gameState.finishMakeup()
        }
    }
}

#Preview {
    let state = GameState(level: 1)
    state.costume = .witch
    return MakeupView(gameState: state)
}

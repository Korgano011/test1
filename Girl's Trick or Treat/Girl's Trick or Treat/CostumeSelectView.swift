//
//  CostumeSelectView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct CostumeSelectView: View {
    @ObservedObject var gameState: GameState

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Your Costume")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Costume.allCases) { costume in
                    Button {
                        gameState.chooseCostume(costume)
                    } label: {
                        VStack(spacing: 8) {
                            CostumeAvatar(costume: costume, size: 70)
                            Text(costume.displayName)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(costume.themeColor.opacity(0.2))
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CostumeSelectView(gameState: GameState(level: 1))
}

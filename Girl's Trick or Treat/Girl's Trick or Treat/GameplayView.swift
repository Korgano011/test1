//
//  GameplayView.swift
//  Girl's Trick or Treat
//

import SwiftUI

struct GameplayView: View {
    @ObservedObject var gameState: GameState
    @State private var commandText: String = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label("\(gameState.movesRemaining) moves left", systemImage: "figure.walk")
                Spacer()
                Label("\(gameState.score) points", systemImage: "star.fill")
            }
            .font(.headline)
            .padding(.horizontal)
            .padding(.top)

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(gameState.log.enumerated()), id: \.offset) { index, entry in
                            Text(entry)
                                .id(index)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onChange(of: gameState.log.count) {
                    if let last = gameState.log.indices.last {
                        withAnimation {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            if gameState.movesRemaining == 0 {
                Text("No more moves")
                    .font(.title.bold())
                    .foregroundStyle(.red)
                    .padding(.vertical, 8)
            } else if !gameState.availableDirections.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(gameState.availableDirections) { direction in
                            Button(direction.displayName) {
                                gameState.submit(command: direction.rawValue)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            HStack {
                TextField("Type a command (e.g. north)", text: $commandText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .onSubmit(sendCommand)
                Button("Go") {
                    sendCommand()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .disabled(gameState.movesRemaining == 0)
        }
    }

    private func sendCommand() {
        let trimmed = commandText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        gameState.submit(command: trimmed)
        commandText = ""
    }
}

#Preview {
    let state = GameState(level: 1)
    state.costume = .geisha
    state.startPlaying()
    return GameplayView(gameState: state)
}

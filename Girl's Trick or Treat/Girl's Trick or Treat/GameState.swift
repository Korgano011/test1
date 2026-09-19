//
//  GameState.swift
//  Girl's Trick or Treat
//

import Combine
import Foundation

enum GameScene {
    case bedroom, costumeSelect, makeup, transform, playing, scoreCheck, nameEntry, leaderboard
}

final class GameState: ObservableObject {
    let level: Int

    @Published var scene: GameScene = .bedroom
    @Published var costume: Costume?
    @Published var currentRoomID: Int
    @Published var movesRemaining: Int
    @Published var score: Int = 0
    @Published var log: [String] = []

    private var rooms: [Int: Room]
    private var visitedRoomIDs: Set<Int> = []

    init(level: Int) {
        self.level = level
        let map = GameMap.build(level: level)
        self.rooms = map.rooms
        self.currentRoomID = map.startRoomID
        self.movesRemaining = map.moveBudget
    }

    var currentRoom: Room? { rooms[currentRoomID] }

    var availableDirections: [Direction] {
        guard let room = currentRoom else { return [] }
        return Direction.allCases.filter { room.exits[$0] != nil }
    }

    func chooseCostume(_ costume: Costume) {
        self.costume = costume
        scene = .makeup
    }

    func finishMakeup() {
        scene = .transform
    }

    func startPlaying() {
        let map = GameMap.build(level: level)
        rooms = map.rooms
        currentRoomID = map.startRoomID
        movesRemaining = map.moveBudget
        score = 0
        visitedRoomIDs = []
        log = []
        if let room = currentRoom {
            log.append("\(room.name): \(room.description)")
            visitedRoomIDs.insert(room.id)
        }
        scene = .playing
    }

    func submit(command: String) {
        guard movesRemaining > 0, scene == .playing else { return }

        guard let direction = Direction.parse(command) else {
            log.append("Mother doesn't understand \"\(command)\". Try: \(availableDirections.map(\.displayName).joined(separator: ", ")).")
            return
        }

        guard let room = currentRoom, let destinationID = room.exits[direction] else {
            log.append("You can't go \(direction.displayName.lowercased()) from here.")
            return
        }

        currentRoomID = destinationID
        movesRemaining -= 1

        guard let destination = currentRoom else { return }
        var message = "\(destination.name): \(destination.description)"

        if let treat = destination.treat, !visitedRoomIDs.contains(destination.id) {
            score += treat.points
            let sign = treat.points > 0 ? "+1" : "-1"
            message += " You got \(treat.flavorText)! (\(sign))"
        }
        visitedRoomIDs.insert(destination.id)
        log.append(message)

        if movesRemaining == 0 {
            log.append("No more moves!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                guard let self, self.scene == .playing else { return }
                self.scene = .scoreCheck
            }
        }
    }

    func reset() {
        scene = .bedroom
        costume = nil
        log = []
    }
}

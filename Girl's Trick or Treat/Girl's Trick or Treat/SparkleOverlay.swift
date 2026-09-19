//
//  SparkleOverlay.swift
//  Girl's Trick or Treat
//

import SwiftUI

private struct Sparkle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let delay: Double
    let scale: CGFloat
}

struct SparkleOverlay: View {
    let color: Color
    @State private var animate = false

    private let sparkles: [Sparkle] = (0..<16).map { _ in
        Sparkle(
            x: .random(in: 0...1),
            y: .random(in: 0...1),
            delay: .random(in: 0...1),
            scale: .random(in: 0.6...1.4)
        )
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(sparkles) { sparkle in
                    Text("✨")
                        .font(.system(size: 24 * sparkle.scale))
                        .foregroundStyle(color)
                        .position(x: sparkle.x * proxy.size.width, y: sparkle.y * proxy.size.height)
                        .opacity(animate ? 1 : 0)
                        .scaleEffect(animate ? 1 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.9)
                                .repeatForever(autoreverses: true)
                                .delay(sparkle.delay),
                            value: animate
                        )
                }
            }
        }
        .onAppear { animate = true }
        .allowsHitTesting(false)
    }
}

#Preview {
    SparkleOverlay(color: .purple)
}

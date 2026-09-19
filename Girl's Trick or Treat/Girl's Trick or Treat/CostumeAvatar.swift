//
//  CostumeAvatar.swift
//  Girl's Trick or Treat
//

import SwiftUI

private struct WitchHat: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.8, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.2, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// A green-faced witch drawn with shapes, since an emoji's skin color can't be changed.
private struct GreenWitchView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            // Hair behind the face
            Circle()
                .fill(Color(white: 0.15))
                .frame(width: size * 0.78, height: size * 0.78)
                .offset(y: size * 0.12)
            // Green face
            Circle()
                .fill(Color(red: 0.42, green: 0.78, blue: 0.35))
                .frame(width: size * 0.62, height: size * 0.62)
                .offset(y: size * 0.14)
            // Eyes
            HStack(spacing: size * 0.14) {
                Circle().fill(.black).frame(width: size * 0.07, height: size * 0.07)
                Circle().fill(.black).frame(width: size * 0.07, height: size * 0.07)
            }
            .offset(y: size * 0.08)
            // Nose
            Circle()
                .fill(Color(red: 0.3, green: 0.62, blue: 0.25))
                .frame(width: size * 0.07, height: size * 0.07)
                .offset(y: size * 0.17)
            // Smile
            Text("‿")
                .font(.system(size: size * 0.22, weight: .bold))
                .foregroundStyle(.black)
                .offset(y: size * 0.24)
            // Hat
            WitchHat()
                .fill(Color(red: 0.25, green: 0.1, blue: 0.4))
                .frame(width: size * 0.62, height: size * 0.5)
                .offset(y: -size * 0.28)
            Capsule()
                .fill(Color(red: 0.25, green: 0.1, blue: 0.4))
                .frame(width: size * 0.85, height: size * 0.1)
                .offset(y: -size * 0.04)
            Rectangle()
                .fill(.yellow)
                .frame(width: size * 0.3, height: size * 0.05)
                .offset(y: -size * 0.09)
        }
        .frame(width: size, height: size)
    }
}

/// A geisha face drawn with shapes, since there is no geisha emoji.
private struct GeishaView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            // Hair bun and pins
            Circle()
                .fill(Color(white: 0.1))
                .frame(width: size * 0.34, height: size * 0.34)
                .offset(y: -size * 0.36)
            Capsule()
                .fill(.red)
                .frame(width: size * 0.05, height: size * 0.3)
                .rotationEffect(.degrees(35))
                .offset(x: size * 0.2, y: -size * 0.36)
            Circle()
                .fill(.yellow)
                .frame(width: size * 0.09, height: size * 0.09)
                .offset(x: size * 0.3, y: -size * 0.46)
            // Hair framing the face
            Circle()
                .fill(Color(white: 0.1))
                .frame(width: size * 0.8, height: size * 0.8)
                .offset(y: size * 0.05)
            // White painted face
            Ellipse()
                .fill(Color(red: 0.98, green: 0.95, blue: 0.92))
                .frame(width: size * 0.56, height: size * 0.66)
                .offset(y: size * 0.1)
            // Hairline
            Capsule()
                .fill(Color(white: 0.1))
                .frame(width: size * 0.56, height: size * 0.16)
                .offset(y: -size * 0.18)
            // Red-rimmed eyes
            HStack(spacing: size * 0.16) {
                Capsule().fill(.black).frame(width: size * 0.1, height: size * 0.03)
                Capsule().fill(.black).frame(width: size * 0.1, height: size * 0.03)
            }
            .offset(y: size * 0.06)
            HStack(spacing: size * 0.16) {
                Capsule().fill(.red).frame(width: size * 0.12, height: size * 0.02)
                Capsule().fill(.red).frame(width: size * 0.12, height: size * 0.02)
            }
            .offset(y: size * 0.03)
            // Rosy cheeks
            HStack(spacing: size * 0.26) {
                Circle().fill(.pink.opacity(0.5)).frame(width: size * 0.1, height: size * 0.1)
                Circle().fill(.pink.opacity(0.5)).frame(width: size * 0.1, height: size * 0.1)
            }
            .offset(y: size * 0.15)
            // Red lips
            Capsule()
                .fill(Color(red: 0.8, green: 0.05, blue: 0.1))
                .frame(width: size * 0.1, height: size * 0.05)
                .offset(y: size * 0.27)
        }
        .frame(width: size, height: size)
    }
}

/// Shows a costume (or the plain girl when `costume` is nil) at the given size.
struct CostumeAvatar: View {
    let costume: Costume?
    let size: CGFloat

    var body: some View {
        if costume == .witch {
            GreenWitchView(size: size)
        } else if costume == .geisha {
            GeishaView(size: size)
        } else {
            Text(costume?.emoji ?? "👧")
                .font(.system(size: size * 0.85))
                .frame(width: size, height: size)
        }
    }
}

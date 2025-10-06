//
//  ScannerCornersOverlay.swift
//  TuristAgent
//
//  Created by Joel Vargas on 05/10/25.
//

import SwiftUI

struct ScannerCornersOverlay: View {
    let cornerLength: CGFloat = 30
    let cornerRadius: CGFloat = 5
    let cornerThickness: CGFloat = 3
    let cornerColor: Color = .blue

    var body: some View {
        GeometryReader { geometry in
            let frameWidth = geometry.size.width
            let frameHeight = geometry.size.height

            Path { path in
                // Top-left corner
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: cornerLength, y: 0), radius: cornerRadius)
                path.addLine(to: CGPoint(x: cornerLength, y: 0))

                // Top-right corner
                path.move(to: CGPoint(x: frameWidth - cornerLength, y: 0))
                path.addArc(tangent1End: CGPoint(x: frameWidth, y: 0), tangent2End: CGPoint(x: frameWidth, y: cornerLength), radius: cornerRadius)
                path.addLine(to: CGPoint(x: frameWidth, y: cornerLength))

                // Bottom-left corner
                path.move(to: CGPoint(x: 0, y: frameHeight - cornerLength))
                path.addArc(tangent1End: CGPoint(x: 0, y: frameHeight), tangent2End: CGPoint(x: cornerLength, y: frameHeight), radius: cornerRadius)
                path.addLine(to: CGPoint(x: cornerLength, y: frameHeight))

                // Bottom-right corner
                path.move(to: CGPoint(x: frameWidth - cornerLength, y: frameHeight))
                path.addArc(tangent1End: CGPoint(x: frameWidth, y: frameHeight), tangent2End: CGPoint(x: frameWidth, y: frameHeight - cornerLength), radius: cornerRadius)
                path.addLine(to: CGPoint(x: frameWidth, y: frameHeight - cornerLength))
            }
            .stroke(cornerColor, lineWidth: cornerThickness)
        }
    }
}

#Preview {
    ScannerCornersOverlay()
        .frame(width: 250, height: 250)
}
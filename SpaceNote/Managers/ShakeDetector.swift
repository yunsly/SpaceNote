//
//  ShakeDetector.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftUI
import UIKit

struct ShakeDetector: UIViewRepresentable {
    var onShake: () -> Void

    func makeUIView(context: Context) -> ShakeUIView {
        let view = ShakeUIView()
        view.onShake = onShake
        return view
    }

    func updateUIView(_ uiView: ShakeUIView, context: Context) {}

    class ShakeUIView: UIView {
        var onShake: (() -> Void)?

        override var canBecomeFirstResponder: Bool { true }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            becomeFirstResponder()
        }

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                onShake?()
            }
        }
    }
}

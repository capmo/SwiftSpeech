//
//  RecordButton.swift
//
//
//  Created by Cay Zhang on 2020/2/16.
//

import Combine
import SwiftUI

public extension SwiftSpeech {
    /**
     An enumeration representing the state of recording. Typically used by a **View Component** and set by a **Functional Component**.
     - Note: The availability of speech recognition cannot be determined using the `State`
             and should be attained using `@Environment(\.isSpeechRecognitionAvailable)`.
     */
    enum State {
        /// Indicating there is no recording in progress.
        /// - Note: It's the default value for `@Environment(\.swiftSpeechState)`.
        case pending
        /// Indicating there is a recording in progress and the user does not intend to cancel it.
        case recording
        /// Indicating there is a recording in progress and the user intends to cancel it.
        case cancelling
    }
}

public struct RecordButton: View {
    @Environment(\.swiftSpeechState) var state: SwiftSpeech.State
    @SpeechRecognitionAuthStatus var authStatus
    @State var scale: CGFloat = 1

    var backgroundColor: Color {
        switch state {
        case .pending:
            return .clear
        case .recording:
            return .accentColor.opacity(0.2)
        case .cancelling:
            return .init(white: 0.1)
        }
    }

    public var body: some View {
        ZStack {
            background

            Image(systemName: state == .pending ? "mic.fill" : "square.fill")
                .foregroundColor(.accentColor)
                .padding(6)
                .transition(.opacity)
                .layoutPriority(2)
                .zIndex(1)
        }
    }

    @ViewBuilder
    var background: some View {
        if state == .recording {
            backgroundColor
                .zIndex(0)
                .clipShape(Circle())
                .environment(\.isEnabled, $authStatus)
                .scaleEffect(scale)
                .onAppear {
                    scale = 1
                    withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                        scale = 1.2
                    }
                }

        } else {
            EmptyView()
        }
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        SwiftSpeech.Demos.Basic()
    }
}

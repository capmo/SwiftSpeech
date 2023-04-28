//
//  Extensions.swift
//
//
//  Created by Cay Zhang on 2020/2/16.
//

import Combine
import Speech
import SwiftUI

public extension View {
    func onStartRecording(appendAction actionToAppend: @escaping (_ session: SwiftSpeech.Session) -> Void) ->
        ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(_ session: SwiftSpeech.Session) -> Void]>>
    {
        transformEnvironment(\.actionsOnStartRecording) { actions in
            actions.insert(actionToAppend, at: 0)
        } as! ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>>
    }

    func onStopRecording(appendAction actionToAppend: @escaping (_ session: SwiftSpeech.Session) -> Void) ->
        ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(_ session: SwiftSpeech.Session) -> Void]>>
    {
        transformEnvironment(\.actionsOnStopRecording) { actions in
            actions.insert(actionToAppend, at: 0)
        } as! ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>>
    }

    func onCancelRecording(appendAction actionToAppend: @escaping (_ session: SwiftSpeech.Session) -> Void) ->
        ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(_ session: SwiftSpeech.Session) -> Void]>>
    {
        transformEnvironment(\.actionsOnCancelRecording) { actions in
            actions.insert(actionToAppend, at: 0)
        } as! ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>>
    }
}

public extension View {
    func onStartRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session {
        onStartRecording { session in
            subject.send(session)
        }
    }

    func onStartRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session? {
        onStartRecording { session in
            subject.send(session)
        }
    }

    func onStopRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session {
        onStopRecording { session in
            subject.send(session)
        }
    }

    func onStopRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session? {
        onStopRecording { session in
            subject.send(session)
        }
    }

    func onCancelRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session {
        onCancelRecording { session in
            subject.send(session)
        }
    }

    func onCancelRecording<S: Subject>(sendSessionTo subject: S) -> ModifiedContent<Self, _EnvironmentKeyTransformModifier<[(SwiftSpeech.Session) -> Void]>> where S.Output == SwiftSpeech.Session? {
        onCancelRecording { session in
            subject.send(session)
        }
    }
}

public extension View {
    func swiftSpeechRecordOnHold(
        sessionConfiguration: SwiftSpeech.Session.Configuration = SwiftSpeech.Session.Configuration(),
        animation: Animation = SwiftSpeech.defaultAnimation,
        distanceToCancel: CGFloat = 50.0
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.RecordOnHold> {
        modifier(
            SwiftSpeech.ViewModifiers.RecordOnHold(
                sessionConfiguration: sessionConfiguration,
                animation: animation,
                distanceToCancel: distanceToCancel
            )
        )
    }

    func swiftSpeechRecordOnHold(
        locale: Locale,
        animation: Animation = SwiftSpeech.defaultAnimation,
        distanceToCancel: CGFloat = 50.0
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.RecordOnHold> {
        swiftSpeechRecordOnHold(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale), animation: animation, distanceToCancel: distanceToCancel)
    }

    func swiftSpeechToggleRecordingOnTap(
        sessionConfiguration: SwiftSpeech.Session.Configuration = SwiftSpeech.Session.Configuration(),
        animation: Animation = SwiftSpeech.defaultAnimation
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.ToggleRecordingOnTap> {
        modifier(SwiftSpeech.ViewModifiers.ToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: animation))
    }

    func swiftSpeechToggleRecordingOnTap(
        locale: Locale = .autoupdatingCurrent,
        animation: Animation = SwiftSpeech.defaultAnimation
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.ToggleRecordingOnTap> {
        swiftSpeechToggleRecordingOnTap(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale), animation: animation)
    }

    func onRecognize(
        includePartialResults isPartialResultIncluded: Bool = true,
        handleResult resultHandler: @escaping (SwiftSpeech.Session, SFSpeechRecognitionResult) -> Void,
        handleError errorHandler: @escaping (SwiftSpeech.Session, Error) -> Void
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.OnRecognize> {
        modifier(
            SwiftSpeech.ViewModifiers.OnRecognize(
                isPartialResultIncluded: isPartialResultIncluded,
                switchToLatest: false,
                resultHandler: resultHandler,
                errorHandler: errorHandler
            )
        )
    }

    func onRecognizeLatest(
        includePartialResults isPartialResultIncluded: Bool = true,
        handleResult resultHandler: @escaping (SwiftSpeech.Session, SFSpeechRecognitionResult) -> Void,
        handleError errorHandler: @escaping (SwiftSpeech.Session, Error) -> Void
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.OnRecognize> {
        modifier(
            SwiftSpeech.ViewModifiers.OnRecognize(
                isPartialResultIncluded: isPartialResultIncluded,
                switchToLatest: true,
                resultHandler: resultHandler,
                errorHandler: errorHandler
            )
        )
    }

    func onRecognizeLatest(
        includePartialResults isPartialResultIncluded: Bool = true,
        handleResult resultHandler: @escaping (SFSpeechRecognitionResult) -> Void,
        handleError errorHandler: @escaping (Error) -> Void
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.OnRecognize> {
        onRecognizeLatest(
            includePartialResults: isPartialResultIncluded,
            handleResult: { _, result in resultHandler(result) },
            handleError: { _, error in errorHandler(error) }
        )
    }

    func onRecognizeLatest(
        includePartialResults isPartialResultIncluded: Bool = true,
        update textBinding: Binding<String>
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.OnRecognize> {
        onRecognizeLatest(includePartialResults: isPartialResultIncluded) { result in
            textBinding.wrappedValue = result.bestTranscription.formattedString
        } handleError: { _ in }
    }

    func printRecognizedText(
        includePartialResults isPartialResultIncluded: Bool = true
    ) -> ModifiedContent<Self, SwiftSpeech.ViewModifiers.OnRecognize> {
        onRecognize(includePartialResults: isPartialResultIncluded) { _, result in
            print("[SwiftSpeech] Recognized Text: \(result.bestTranscription.formattedString)")
        } handleError: { _, _ in }
    }
}

public extension Subject where Output == SpeechRecognizer.ID?, Failure == Never {
    func mapResolved<T>(_ transform: @escaping (SpeechRecognizer) -> T) -> Publishers.CompactMap<Self, T> {
        return compactMap { id -> T? in
            if let recognizer = SpeechRecognizer.recognizer(withID: id) {
                return transform(recognizer)
            } else {
                return nil
            }
        }
    }

    func mapResolved<T>(_ keyPath: KeyPath<SpeechRecognizer, T>) -> Publishers.CompactMap<Self, T> {
        return compactMap { id -> T? in
            if let recognizer = SpeechRecognizer.recognizer(withID: id) {
                return recognizer[keyPath: keyPath]
            } else {
                return nil
            }
        }
    }
}

public extension SwiftSpeech {
    static func supportedLocales() -> Set<Locale> {
        SFSpeechRecognizer.supportedLocales()
    }
}

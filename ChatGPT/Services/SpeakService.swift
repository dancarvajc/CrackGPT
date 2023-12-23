//
//  SpeakService.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-07-23.
//

import AVKit
import Combine
import Foundation

protocol SpeakServiceProtocol {
    var isSpeaking: PassthroughSubject<Bool, Never> { get }

    func speakMessage(content: String)
    func stopSpeaking()
}

final class SpeakService: NSObject, SpeakServiceProtocol {
    var isSpeaking = PassthroughSubject<Bool, Never>()
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speakMessage(content: String) {
        stopSpeaking()
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
        let utterance = AVSpeechUtterance(string: content)
        utterance.voice = .init(language: "es-MX")
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension SpeakService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance) {
        isSpeaking.send(true)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didCancel _: AVSpeechUtterance) {
        isSpeaking.send(false)
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        #endif
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        isSpeaking.send(false)
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        #endif
    }
}

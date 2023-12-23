//
//  FeedbackGenerator.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 03-09-23.
//
#if os(iOS)
import UIKit

enum FeedbackGenerator {
    static func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

    static func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
#endif

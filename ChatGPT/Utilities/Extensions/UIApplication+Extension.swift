//
//  UIApplication+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-08-23.
//
#if os(iOS)
import UIKit

extension UIApplication {
    var activeWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow
    }
}
#endif

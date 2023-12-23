//
//  Extensions.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 22-04-23.
//
#if os(iOS)
import UIKit
#else
import AppKit
#endif
import Splash

public extension Theme {
    static func xcode(_ fontSize: CGFloat) -> Theme {
        #if os(iOS)
        let theme = Theme(font: Font(size: fontSize),
                          plainTextColor: UIColor(.Gray50),
                          tokenColors: [
                              .keyword: UIColor(.Pink500),
                              .string: UIColor(.Red500),
                              .type: UIColor(.Violet500),
                              .call: UIColor(.Gray50),
                              .number: UIColor(.LightBlue500),
                              .comment: UIColor(.Gray400),
                              .property: UIColor(.Violet500),
                              .dotAccess: UIColor(.Violet500),
                              .preprocessing: UIColor(.Orange500),
                          ],
                          backgroundColor: UIColor(.Gray900))
        #else
        let theme = Theme(font: Font(path: "/Library/Fonts/SF-Mono-Medium.otf", size: fontSize),
                          plainTextColor: NSColor(.Gray50),
                          tokenColors: [
                              .keyword: NSColor(.Pink500),
                              .string: NSColor(.Red500),
                              .type: NSColor(.Violet500),
                              .call: NSColor(.Gray50),
                              .number: NSColor(.LightBlue500),
                              .comment: NSColor(.Gray400),
                              .property: NSColor(.Violet500),
                              .dotAccess: NSColor(.Violet500),
                              .preprocessing: NSColor(.Orange500),
                          ],
                          backgroundColor: NSColor(.Gray900))
        #endif
        return theme
    }
}

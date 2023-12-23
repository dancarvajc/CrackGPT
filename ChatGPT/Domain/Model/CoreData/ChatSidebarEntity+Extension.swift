//
//  ChatSidebarEntity+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 16-04-23.
//

import Foundation

extension ChatSidebarEntity {
    var ID: String {
        get {
            return id_ ?? ""
        }
        set {
            id_ = newValue
        }
    }

    var title: String {
        get {
            return title_ ?? ""
        }

        set {
            title_ = newValue
        }
    }

    var date: Date {
        get {
            return date_ ?? Date.now
        }

        set {
            date_ = newValue
        }
    }
}

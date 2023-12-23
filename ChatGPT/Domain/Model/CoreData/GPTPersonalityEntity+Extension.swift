//
//  GPTPersonalityEntity+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 20-08-23.
//

import Foundation

extension GPTPersonalityEntity {
    var ID: String {
        get {
            return id_ ?? ""
        }
        set {
            id_ = newValue
        }
    }

    var name: String {
        get {
            return name_ ?? ""
        }
        set {
            name_ = newValue
        }
    }

    var personality: String {
        get {
            return personality_ ?? ""
        }
        set {
            personality_ = newValue
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

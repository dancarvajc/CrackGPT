//
//  GPTModel.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 17-07-23.
//

import Foundation
import OpenAI

enum GPTModel: CaseIterable, Identifiable {
    static var allCases: [GPTModel] {
        if let customModel = UserDefaults.standard.string(forKey: "customGPTModel"), !customModel.isEmpty {
            return [.gpt3, .gpt4, .gpt4Turbo, .other(customModel)]
        } else {
            return [.gpt3, .gpt4, .gpt4Turbo]
        }
    }

    var id: String { rawValue }

    case gpt4
    case gpt4Turbo
    case gpt3
    case other(String)

    init(rawValue: String) {
        switch rawValue {
        case "gpt-4":
            self = .gpt4
        case "gpt-4-1106-preview":
            self = .gpt4Turbo
        case "gpt-3.5-turbo":
            self = .gpt3
        default:
            self = .other(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .gpt4:
            return "gpt-4"
        case .gpt4Turbo:
            return "gpt-4-1106-preview"
        case .gpt3:
            return "gpt-3.5-turbo"
        case let .other(model):
            return model
        }
    }

    var maxTokens: Int {
        switch self {
        case .gpt4:
            return 8000
        case .gpt3:
            return 4000
        case .gpt4Turbo:
            return 110000
        default:
            return 10000
        }
    }

    var name: String {
        switch self {
        case .gpt4:
            return "GPT-4"
        case .gpt4Turbo:
            return "GPT-4-Turbo"
        case .gpt3:
            return "GPT-3"
        case let .other(model):
            return model
        }
    }

    static var `default`: Self {
        return .gpt4Turbo
    }
}

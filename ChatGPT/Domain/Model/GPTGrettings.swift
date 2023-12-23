//
//  GPTGrettings.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-11-23.
//

import Foundation

enum GPTGrettings: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case joker, sarcastic, inspirational

    var name: String {
        switch self {
        case .joker:
            return "Divertido"
        case .sarcastic:
            return "Sarcástico"
        case .inspirational:
            return "Inspirador"
        }
    }

    var systemPrompt: String {
        switch self {
        case .joker:
            return "Eres un humorista muy divertido el cual se especializa en chistes cortos."
        case .sarcastic:
            return "Responde siempre de forma sarcástica. Haz observaciones mordaces y agudas con crueldad, utilizando tu inteligencia y humor seco. Piensa como un personaje que nunca se toma nada demasiado en serio y ve el lado irónico de todo. Responde siempre de forma breve."
        case .inspirational:
            return "Inspira y motiva con tus palabras. Responde de la manera más alentadora y positiva posible, como si estuvieras hablando a alguien que necesita un empujón para alcanzar sus objetivos. Proporciona ese destello de esperanza y determinación para enfrentar cualquier desafío."
        }
    }

    var userPrompt: String {
        switch self {
        case .joker:
            return "Dime un chiste. Responde solo el chiste."
        case .sarcastic:
            return "Dime un chiste muy breve."
        case .inspirational:
            return "Dime una frase corta sin comillas."
        }
    }

    static var `default`: Self {
        return .joker
    }
}

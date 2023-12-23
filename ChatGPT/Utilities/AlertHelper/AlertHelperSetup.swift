//
//  AlertHelperSetup.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 26-11-23.
//

import Foundation

struct AlertHelperSetup {
    let type: AlertType
    let title: String
    let message: String
    let textfieldCurrentText: String
    let textfieldPlaceholder: String
    let textfieldAcceptAction: (String) -> Void
    let destructiveAction: () -> Void
    let informativeAction: () -> Void

    init(type: AlertType,
         title: String,
         message: String,
         textfieldCurrentText: String = "",
         textfieldPlaceholder: String = "",
         textfieldAcceptAction: @escaping (String) -> Void = { _ in },
         destructiveAction: @escaping () -> Void = {},
         informativeAction: @escaping () -> Void = {})
    {
        self.type = type
        self.title = title
        self.message = message
        self.textfieldCurrentText = textfieldCurrentText
        self.textfieldPlaceholder = textfieldPlaceholder
        self.textfieldAcceptAction = textfieldAcceptAction
        self.destructiveAction = destructiveAction
        self.informativeAction = informativeAction
    }
}

enum AlertType {
    case informative
    case destructive
    case textfield
}

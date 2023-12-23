//
//  AlertHelper.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-08-23.
//

#if os(iOS)
import UIKit

final class AlertHelper: NSObject {
    private var alert: UIAlertController!
    private var acceptAction: UIAlertAction!
    private var setup: AlertHelperSetup!
    static let shared = AlertHelper()
    override private init() {}

    func showAlert(setup: AlertHelperSetup) {
        self.setup = setup
        alert = UIAlertController(title: setup.title, message: setup.message, preferredStyle: .alert)
        switch setup.type {
        case .informative:
            prepareInformativeAlert()
        case .destructive:
            prepareDestructiveAlert()
        case .textfield:
            prepareTextfieldAlert()
        }
        UIWindow.topMostViewController?.present(alert, animated: true)
    }

    private func prepareInformativeAlert() {
        acceptAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            self?.setup.informativeAction()
        }
        alert.addAction(acceptAction)
    }

    private func prepareDestructiveAlert() {
        let destructiveAction = UIAlertAction(title: "Sí", style: .destructive) { [weak self] _ in
            self?.setup.destructiveAction()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in }
        alert.addAction(destructiveAction)
        alert.addAction(cancelAction)
    }

    private func prepareTextfieldAlert() {
        alert.addTextField { [weak self] textField in
            textField.placeholder = self?.setup.textfieldPlaceholder
            textField.text = self?.setup.textfieldCurrentText
            textField.clearButtonMode = .always
            textField.delegate = self
        }
        acceptAction = UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
            if let text = self?.alert.textFields?.first?.text {
                self?.setup.textfieldAcceptAction(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in }
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
    }
}

extension AlertHelper: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newStringInTextField = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? ""
        newStringInTextField = newStringInTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        if newStringInTextField.isEmpty {
            acceptAction.isEnabled = false
        } else {
            acceptAction.isEnabled = true
        }
        return true
    }
}
#endif

//
//  This file is part of the Scandit ShelfView Sample
//
//  Copyright (C) 2022- Scandit AG. All rights reserved.
//

import UIKit
import ScanditShelf

final class LoginViewController: UIViewController {
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var invalidCredentialsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let authentication = Authentication.shared

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        enableForm()
        usernameField.text = nil
        passwordField.text = nil
    }

    @IBAction private func onLogin(_ sender: Any) {
        disableForm()

        activityIndicator.startAnimating()

        authentication.login(
            username: usernameField.text ?? "", password: passwordField.text ?? ""
        ) { [weak self] result in
            guard let self = self else { return }

            self.activityIndicator.stopAnimating()
            switch result {
            case .success:
                self.perform(segue: .showStores)
            case .failure(let error):
                self.onInvalidCredentials()
                print(error)
            }
        }
    }

    private func disableForm() {
        loginButton.isEnabled = false
        usernameField.isEnabled = false
        passwordField.isEnabled = false
    }

    private func enableForm() {
        loginButton.isEnabled = true
        usernameField.isEnabled = true
        passwordField.isEnabled = true
    }

    private func onInvalidCredentials() {
        enableForm()
        showError()
    }

    private func showError() {
        invalidCredentialsLabel.alpha = 1
    }

    private func clearErrors() {
        invalidCredentialsLabel.alpha = 0
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        clearErrors()
        return true
    }
}

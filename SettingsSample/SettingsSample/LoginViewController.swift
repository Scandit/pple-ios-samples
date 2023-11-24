/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import ScanditShelf

final class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameField: UITextField!

    @IBOutlet private weak var passwordField: UITextField!

    @IBOutlet private weak var loginButton: UIButton!

    @IBOutlet private weak var invalidCredentialsLabel: UILabel!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var sdkVersionLabel: UILabel!

    private let authentication = Authentication.shared

    private var sdkVersion: String { ShelfVersion.version }

    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        enableForm()
        usernameField.text = nil
        passwordField.text = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sdkVersionLabel.text = sdkVersion
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if authentication.isLoggedIn {
            self.perform(segue: .showStores)
        }
    }

    @IBAction private func onLogin(_ sender: Any) {
        disableForm()

        activityIndicator.startAnimating()

        Task { @MainActor [self] in
            do {
                try await authentication.login(
                    username: usernameField.text ?? "", password: passwordField.text ?? ""
                )
                perform(segue: .showStores)
            } catch {
                onInvalidCredentials()
                showToast(message: error.localizedDescription)
            }

            activityIndicator.stopAnimating()
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

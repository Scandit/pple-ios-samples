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

extension UIViewController {

    func showToast(message: String) {
        DispatchQueue.main.async {
            let toast = self.makeToast()

            toast.show(message: message)
        }
    }

    private func makeToast() -> ToastView {
        let toast = ToastView()

        toast.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toast)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: toast.leadingAnchor, constant: -20),
            view.trailingAnchor.constraint(equalTo: toast.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toast.bottomAnchor, constant: 20)
        ])

        return toast
    }
}

final private class ToastView: UIView {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .black
        layer.cornerRadius = 10
        clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
    }

    func show(message: String) {
        let duration = 0.3
        alpha = 0

        label.text = message
        label.layoutIfNeeded()

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0) {
            self.alpha = 1
        }

        let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 3) {
            self.alpha = 0
        }

        animator.addCompletion { _ in
            self.removeFromSuperview()
        }
    }
}

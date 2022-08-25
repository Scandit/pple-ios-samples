import UIKit

enum Segue: String {
    case showStores
    case showCaptureView
    case unwindToLogin
}

extension UIViewController {
    func perform(segue: Segue, sender: Any? = nil) {
        performSegue(withIdentifier: segue.rawValue, sender: sender ?? self)
    }
}

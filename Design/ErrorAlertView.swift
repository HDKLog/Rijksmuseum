import UIKit

class ErrorAlertView: UIAlertController {

    convenience init(error: Error) {
        self.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
    }
}

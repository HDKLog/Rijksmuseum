import UIKit

class ErrorAlertView: UIAlertController {

    convenience init(error: Error) {
        self.init(title: DesignBook.Text.ErrorAlert.title, message: error.localizedDescription, preferredStyle: .alert)
        addAction(UIAlertAction(title:DesignBook.Text.ErrorAlert.Action.OK.title, style: .default))
    }
}

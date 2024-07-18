import UIKit

protocol ArtDetailsRouting {
    func routeToCollection()
}

class ArtDetailsRouter: ArtDetailsRouting {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func routeToCollection() {
        navigationController?.popViewController(animated: true)
    }

}

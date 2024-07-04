import UIKit

@MainActor
protocol ArtDetailsRouting {
    func routeToCollection()
}

class ArtDetailsRouter: ArtDetailsRouting {

    let navigationController: UINavigationController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func routeToCollection() {
        navigationController.popViewController(animated: true)
    }

}

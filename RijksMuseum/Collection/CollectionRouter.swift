import UIKit

protocol CollectionRouting {
    func routeToArtDetail(artId: String)
}

class CollectionRouter: CollectionRouting {

    let navigationController: UINavigationController!
    let artDetailsViewFactory: ArtDetailsViewFactory!

    init(navigationController: UINavigationController, artDetailsViewFactory: ArtDetailsViewFactory) {
        self.navigationController = navigationController
        self.artDetailsViewFactory = artDetailsViewFactory
    }

    func routeToArtDetail(artId: String) {
        let artDetailsView = artDetailsViewFactory.createArtDetailsView(for: artId)
        navigationController.pushViewController(artDetailsView, animated: true)
    }

}

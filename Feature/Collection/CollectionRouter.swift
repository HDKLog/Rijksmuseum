import UIKit

protocol CollectionRouting {
    func routeToArtDetail(artId: String)
}

class CollectionRouter: CollectionRouting {

    weak var navigationController: UINavigationController?
    let artDetailsViewFactory: ArtDetailsViewFactoring

    init(navigationController: UINavigationController, artDetailsViewFactory: ArtDetailsViewFactoring) {
        self.navigationController = navigationController
        self.artDetailsViewFactory = artDetailsViewFactory
    }

    func routeToArtDetail(artId: String) {
        let artDetailsView = artDetailsViewFactory.createArtDetailsView(for: artId)
        navigationController?.pushViewController(artDetailsView, animated: true)
    }

}

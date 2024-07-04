import UIKit

@MainActor
protocol CollectionViewFactoring {
    func createCollectionView() -> UIViewController
}

class CollectionViewFactory: CollectionViewFactoring {

    private let navigationController: UINavigationController!
    private let gateway: ArtGateway
    private let detailsViewFactory: ArtDetailsViewFactoring

    init(navigationController: UINavigationController!, gateway: ArtGateway, detailsViewFactory: ArtDetailsViewFactoring) {
        self.navigationController = navigationController
        self.gateway = gateway
        self.detailsViewFactory = detailsViewFactory
    }

    func createCollectionView() -> UIViewController {
        let interactor = CollectionInteractor(gateway: gateway)
        let view = CollectionViewController()
        let presenter = CollectionPresenter(view: view, interactor: interactor)
        let router = CollectionRouter(navigationController: navigationController, artDetailsViewFactory: detailsViewFactory)
        presenter.router = router
        view.presenter = presenter

        return view
    }

}

import UIKit

@MainActor
protocol ArtDetailsViewFactoring {
    func createArtDetailsView(for artId: String) -> UIViewController
}

class ArtDetailsViewFactory: ArtDetailsViewFactoring {

    private let navigationController: UINavigationController!
    private let gateway: ArtGateway

    init(navigationController: UINavigationController, gateway: ArtGateway) {
        self.navigationController = navigationController
        self.gateway = gateway
    }

    func createArtDetailsView(for artId: String) -> UIViewController {
        let interactor = ArtDetailsInteractor(gateway: gateway)
        let view = ArtDetailsViewController()
        let presenter = ArtDetailsPresenter(view: view, interactor: interactor, artId: artId)
        let router = ArtDetailsRouter(navigationController: navigationController)
        presenter.router = router
        view.presenter = presenter
        return view
    }
}

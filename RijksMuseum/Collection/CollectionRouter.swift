import UIKit

protocol CollectionRouting {
    func routeToArtDetail(artId: String)
}

protocol CollectionRoutingEndpoint {
    func loadArtDetail(artId: String)
}

class CollectionRouter: CollectionRouting {

    let rootView: UIViewController!
    let endView: UIViewController!
    let endpoint: CollectionRoutingEndpoint!

    init(rootView: UIViewController, endView: UIViewController, endpoint: CollectionRoutingEndpoint) {
        self.rootView = rootView
        self.endView = endView
        self.endpoint = endpoint
    }

    func routeToArtDetail(artId: String) {
        rootView.navigationController?.pushViewController(endView, animated: true)
        endpoint.loadArtDetail(artId: artId)
    }

}

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()

        let navigationController = UINavigationController()
        let service = Service()
        let gateway = RijksmuseumArtGateway(service: service)
        let artDetailsViewFactory = ArtDetailsViewFactory(navigationController: navigationController, gateway: gateway)
        let collectionViewFactory = CollectionViewFactory(navigationController: navigationController, gateway: gateway, detailsViewFactory: artDetailsViewFactory)

        let collectionView = collectionViewFactory.createCollectionView()

        navigationController.setViewControllers([collectionView], animated: false)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }


}


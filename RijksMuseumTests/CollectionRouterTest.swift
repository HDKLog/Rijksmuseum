import XCTest

@testable import RijksMuseum
final class CollectionRouterTest: XCTestCase {

    final class ArtDetailsViewFactory: ArtDetailsViewFactoring {

        var createArtDetailsViewCalled: Bool { createArtDetailsViewCalls > 0 }
        var createArtDetailsViewCalls: Int = 0
        var createArtDetailsViewClosure: (String) -> UIViewController = {_ in return UIViewController() }
        func createArtDetailsView(for artId: String) -> UIViewController {
            createArtDetailsViewCalls += 1
            return createArtDetailsViewClosure(artId)
        }
        

    }

    func makeSut(navigationController: UINavigationController = UINavigationController(), artDetailsViewFactory: ArtDetailsViewFactoring = ArtDetailsViewFactory()) -> CollectionRouter {
        CollectionRouter(navigationController: navigationController, artDetailsViewFactory: artDetailsViewFactory)
    }

    func test_collectionRouter_onRouteToArtDetail_tellsTellsFactoryTocreateArtDetailsView() {

        let artId = "artId"
        let factory = ArtDetailsViewFactory()
        let sut = makeSut(artDetailsViewFactory: factory)

        sut.routeToArtDetail(artId: artId)

        XCTAssertTrue(factory.createArtDetailsViewCalled)
    }

    func test_collectionRouter_onRouteToArtDetail_tellsTellsFactoryTocreateArtDetailsViewOnce() {

        let artId = "artId"
        let factory = ArtDetailsViewFactory()
        let sut = makeSut(artDetailsViewFactory: factory)

        sut.routeToArtDetail(artId: artId)

        XCTAssertEqual(factory.createArtDetailsViewCalls, 1)
    }

    func test_collectionRouter_onRouteToArtDetail_tellsTellsFactoryTocreateArtDetailsViewWithCorrectId() {

        let artId = "artId"
        var resultId: String? = nil
        let factory = ArtDetailsViewFactory()

        factory.createArtDetailsViewClosure = { artId in
            resultId = artId
            return UIViewController()
        }

        let sut = makeSut(artDetailsViewFactory: factory)

        sut.routeToArtDetail(artId: artId)

        XCTAssertEqual(resultId, artId)
    }
}

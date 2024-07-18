import XCTest

@testable import RijksMuseum
class ArtDetailsPresenterTest: XCTestCase {
    class View: ArtDetailsView {

        var configureCalled: Bool { configureCalls > 0 }
        var configureCalls: Int = 0
        var configureClosure: (ArtDetailsViewModel.InitialInfo) -> Void = {_ in }
        func configure(with model: ArtDetailsViewModel.InitialInfo) {
            configureCalls += 1
            configureClosure(model)
        }

        var updateDetailsCalled: Bool { updateDetailsCalls > 0 }
        var updateDetailsCalls: Int = 0
        var updateDetailsClosure: (ArtDetailsViewModel.ArtDetails) -> Void = {_ in }
        func updateDetails(with model: ArtDetailsViewModel.ArtDetails) {
            updateDetailsCalls += 1
            updateDetailsClosure(model)
        }

        var updateImageCalled: Bool { updateImageCalls > 0 }
        var updateImageCalls: Int = 0
        var updateImageClosure: (Data) -> Void = {_ in }
        func updateImage(with data: Data) {
            updateImageCalls += 1
            updateImageClosure(data)
        }

        var displayErrorCalled: Bool { displayErrorCalls > 0 }
        var displayErrorCalls: Int = 0
        var displayErrorClosure: (Error) -> Void = {_ in }
        func displayError(error: Error) {
            displayErrorCalls += 1
            displayErrorClosure(error)
        }


    }

    class Interactor: ArtDetailsInteracting {

        var loadArtDetailsCalled: Bool { loadArtDetailsCalls > 0 }
        var loadArtDetailsCalls: Int = 0
        var loadArtDetailsClosure: (String,  @escaping ArtDetailsResultHandler) -> Void = {_, _ in }
        func loadArtDetails(artId: String, completion: @escaping ArtDetailsResultHandler) {
            loadArtDetailsCalls += 1
            loadArtDetailsClosure(artId, completion)
        }

        var loadArtDetailsImageDataCalled: Bool { loadArtDetailsImageDataCalls > 0 }
        var loadArtDetailsImageDataCalls: Int = 0
        var loadArtDetailsImageDataClosure: (URL,  @escaping ArtDetailsImageResultHandler) -> Void = {_, _ in }
        func loadArtDetailsImageData(from url: URL, completion: @escaping ArtDetailsImageResultHandler) {
            loadArtDetailsImageDataCalls += 1
            loadArtDetailsImageDataClosure(url, completion)
        }


    }

    class Router: ArtDetailsRouting {
        var routeToCollectionCalled: Bool { routeToCollectionCalls > 0 }
        var routeToCollectionCalls: Int = 0
        var routeToCollectionClosure: () -> Void = { }
        func routeToCollection() {
            routeToCollectionCalls += 1
            routeToCollectionClosure()
        }


    }

    func makeSut(view: ArtDetailsView, interactor: ArtDetailsInteracting, router: ArtDetailsRouting? = nil, artId: String = "artId") -> ArtDetailsPresenter {
        let presenter = ArtDetailsPresenter(view: view, interactor: interactor, artId: artId)
        presenter.router = router
        return presenter
    }

    func test_artDetailsPresenter_onLoadView_configureView() {
        let view = View()
        let interactor = Interactor()

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadView()

        XCTAssertTrue(view.configureCalled)
    }

    func test_artDetailsPresenter_onLoadView_configureViewOnce() {
        let view = View()
        let interactor = Interactor()

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadView()

        XCTAssertEqual(view.configureCalls, 1)
    }

    func test_artDetailsPresenter_onLoadArt_loadsArtDetailsFromInteractor() {

        let view = View()
        let interactor = Interactor()

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertTrue(interactor.loadArtDetailsCalled)
    }

    func test_artDetailsPresenter_onLoadArt_loadsArtDetailsFromInteractorOnce() {

        let view = View()
        let interactor = Interactor()

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertEqual(interactor.loadArtDetailsCalls, 1)
    }

    func test_artDetailsPresenter_onLoadArt_loadsArtDetailsFromInteractorWithId() {

        var loadedId: String?
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { artId, _ in
            loadedId = artId
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertEqual(loadedId, loadedId)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessTellsViewToUpdateDetails() {

        let artDetails = ArtDetails.mocked
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(artDetails))
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertTrue(view.updateDetailsCalled)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessTellsViewToUpdateDetailsOnce() {

        let artDetails = ArtDetails.mocked
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(artDetails))
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertEqual(view.updateDetailsCalls, 1)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessTellsViewToUpdateDetailsWithModel() {

        let artId = "id"
        let artDetails = ArtDetails.mocked
        var loadedModel:ArtDetailsViewModel.ArtDetails?
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(artDetails))
        }

        view.updateDetailsClosure = { model in
            loadedModel = model
        }

        let sut = makeSut(view: view, interactor: interactor, artId: artId)

        sut.loadArt()

        XCTAssertEqual(loadedModel, artDetails.artDetailsViewModel)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsFailureTellsViewToDisplayError() {

        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.failure(.loading(error: .serviceError(.invalidQuery))))
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertTrue(view.displayErrorCalled)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessLoadsImage() {

        let artDetails = ArtDetails.mocked
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(artDetails))
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertTrue(interactor.loadArtDetailsImageDataCalled)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessWithLoadsImageSuccessUpdateViewImage() {

        let artDetails = ArtDetails.mocked
        let imageData = UIImage(named: "AppIcon")!.pngData()!
        var loadedImageData: Data?
        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(artDetails))
        }
        interactor.loadArtDetailsImageDataClosure = {_, completion in
            completion(.success(imageData))
        }

        view.updateImageClosure = { data in
            loadedImageData = data
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertEqual(loadedImageData, imageData)
    }

    func test_artDetailsPresenter_onLoadArt_loadArtDetailsSuccessAndLoadsImageFailureTellsViewToDisplayError() {

        let view = View()
        let interactor = Interactor()

        interactor.loadArtDetailsClosure = { _, completion in
            completion(.success(.mocked))
        }

        interactor.loadArtDetailsImageDataClosure = { _, completion in
            completion(.failure(.loading(error: .serviceError(.invalidQuery))))
        }

        let sut = makeSut(view: view, interactor: interactor)

        sut.loadArt()

        XCTAssertTrue(view.displayErrorCalled)
    }

    func test_artDetailsPresenter_onRoutBack_tellsRouterRouteToCollection() {

        let view = View()
        let interactor = Interactor()
        let router = Router()

        let sut = makeSut(view: view, interactor: interactor, router: router)

        sut.routBack()

        XCTAssertTrue(router.routeToCollectionCalled)
    }
}

extension ArtDetails {
    static var mocked : ArtDetails {
        ArtDetails(
            id: "id",
            title: "Title",
            description: "Desc",
            webImage: Image(
                guid: "guid",
                width: 2500,
                height: 2034,
                url: URL(
                    string: "https://lh3.googleusercontent.com/J-mxAE7CPu-DXIOx4QKBtb0GC4ud37da1QK7CzbTIDswmvZHXhLm4Tv2-1H3iBXJWAW_bHm7dMl3j5wv_XiWAg55VOM=s0"
                )
            )
        )
    }
}

extension ArtDetailsViewModel.ArtDetails: Equatable {
    public static func == (lhs: ArtDetailsViewModel.ArtDetails, rhs: ArtDetailsViewModel.ArtDetails) -> Bool {
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}

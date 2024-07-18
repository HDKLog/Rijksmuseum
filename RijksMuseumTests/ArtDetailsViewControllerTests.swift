import XCTest

@testable import RijksMuseum
class ArtDetailsViewControllerTests: XCTestCase {

    class Presenter: ArtDetailsPresenting {

        var loadViewCalled: Bool { loadViewCalls > 0 }
        var loadViewCalls: Int = 0
        var loadViewClosure:() -> Void = { }
        func loadView() {
            loadViewCalls += 1
            loadViewClosure()
        }

        var loadArtCalled: Bool { loadArtCalls > 0 }
        var loadArtCalls: Int = 0
        var loadArtClosure:() -> Void = { }
        func loadArt() {
            loadArtCalls += 1
            loadArtClosure()
        }

        var routBackCalled: Bool { routBackCalls > 0 }
        var routBackCalls: Int = 0
        var routBackClosure:() -> Void = { }
        func routBack() {
            routBackCalls += 1
            routBackClosure()
        }
    }

    func makeSut(presenter: ArtDetailsPresenting? = nil) -> ArtDetailsViewController {
        let sut = ArtDetailsViewController()
        sut.presenter = presenter
        return sut
    }

    func test_viewController_onViewDidLoad_callsLoadView() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()

        XCTAssertTrue(presenter.loadViewCalled)
    }

    func test_viewController_onViewWillAppear_callsLoadArt() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.beginAppearanceTransition(true, animated: true)

        XCTAssertTrue(presenter.loadViewCalled)
    }

    func test_viewController_onConfigure_setsBackButtonTitle() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.configure(with: ArtDetailsViewModel.InitialInfo.mocked)

        XCTAssertEqual(sut.navigationItem.leftBarButtonItem?.title, ArtDetailsViewModel.InitialInfo.mocked.backButtonTitle)
    }

    func test_viewController_onUpdateDetails_setsArtDetailsTitle() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.updateDetails(with: ArtDetailsViewModel.ArtDetails.mocked)

        XCTAssertEqual(sut.titleLabel.text, ArtDetailsViewModel.ArtDetails.mocked.title)
    }

    func test_viewController_onUpdateDetails_setsArtDetailsDescription() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.updateDetails(with: ArtDetailsViewModel.ArtDetails.mocked)

        XCTAssertEqual(sut.descriptionView.text, ArtDetailsViewModel.ArtDetails.mocked.description)
    }

    func test_viewController_updateImage_setsImageToImageView() {
        let data = UIImage(named: "AppIcon")!.pngData()!
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.updateImage(with: data)
        XCTAssertNotNil(sut.imageView.image)
    }

    func test_viewController_displayError_displayErrorLocalizedDescription() {
        let error = NSError(domain: "testDomain", code: 0)
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
        sut.displayError(error: error)

        let presentedController = sut.presentedViewController as? UIAlertController
        XCTAssertEqual(presentedController?.message, error.localizedDescription)
    }

    func test_viewController_onBackButtonTap_tellPresenterToRoutBack() {
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.configure(with: ArtDetailsViewModel.InitialInfo.mocked)
        let item = sut.navigationItem.leftBarButtonItem

        _ = item?.target?.perform(item?.action, with: nil)

        XCTAssertTrue(presenter.routBackCalled)
    }
}

extension ArtDetailsViewModel.InitialInfo {
    static var mocked: ArtDetailsViewModel.InitialInfo {
        ArtDetailsViewModel.InitialInfo(backButtonTitle: "Title")
    }
}

extension ArtDetailsViewModel.ArtDetails {
    static var mocked: ArtDetailsViewModel.ArtDetails {
        ArtDetailsViewModel.ArtDetails(title: "Title", description: "Description")
    }
}

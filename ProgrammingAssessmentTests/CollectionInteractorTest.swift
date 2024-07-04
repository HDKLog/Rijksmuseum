import XCTest

@testable import ProgrammingAssessment
final class CollectionInteractorTest: XCTestCase {

    class Service: ServiceLoading {

        var getDataCalled: Bool { getDataCalls > 0 }
        var getDataCalls: Int = 0
        var getDataClosure: (ServiceQuery, @escaping ServiceLoadingResultHandler) -> Void = { _, _ in }
        func getData(query: ServiceQuery, completion: @escaping ServiceLoadingResultHandler) {
            getDataCalls += 1
            getDataClosure(query, completion)
        }
    }

    func makeSut(service: ServiceLoading) -> CollectionInteractor {
        CollectionInteractor(service: service)
    }

    func test_collectionInteractor_onLoadCollection_tellsServiceToLoadCollection() {
        let service = Service()
        let sut = makeSut(service: service)

        sut.loadCollection(page: 0, count: 0) {_ in }

        XCTAssertTrue(service.getDataCalled)
    }

    func test_collectionInteractor_onLoadCollection_tellsServiceToLoadCollectionPage() {
        let pageToLoad = 1
        var serviceQuery: ServiceQuery?
        let service = Service()
        service.getDataClosure = { query, completion in
            serviceQuery = query
        }
        let sut = makeSut(service: service)

        sut.loadCollection(page: pageToLoad, count: 0) {_ in }

        XCTAssertTrue(serviceQuery?.getUrl()?.absoluteString.contains("p=1") == true)
    }

    func test_collectionInteractor_onLoadCollection_tellsServiceToLoadCollectionPageSize() {
        let pageSizeToLoad = 1
        var serviceQuery: ServiceQuery?
        let service = Service()
        service.getDataClosure = { query, completion in
            serviceQuery = query
        }
        let sut = makeSut(service: service)

        sut.loadCollection(page: 0, count: pageSizeToLoad) {_ in }

        XCTAssertTrue(serviceQuery?.getUrl()?.absoluteString.contains("ps=1") == true)
    }

    func test_collectionInteractor_onLoadCollection_onSuccessGivesCollectionPage() {
        let collectionData = try! JSONEncoder().encode(CollectionInfo.mocked)
        var collectionPageResult: CollectionLoadingResult?
        let service = Service()
        service.getDataClosure = { query, completion in
            completion(.success(collectionData))
        }
        let sut = makeSut(service: service)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.loadCollection(page: 0, count: 3) {
            collectionPageResult = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(collectionPageResult, .success(.mocked))
    }

    func test_collectionInteractor_onLoadCollection_onFailureGivesError() {
        let error = ServiceLoadingError.invalidQuery
        var collectionPageResult: CollectionLoadingResult?
        let service = Service()
        service.getDataClosure = { query, completion in
            completion(.failure(error))
        }
        let sut = makeSut(service: service)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.loadCollection(page: 0, count: 3) {
            collectionPageResult = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(collectionPageResult, .failure(.serviceError(error)))
    }

    func test_loadCollectionItemImageData_onLoadImage_tellsServiceToLoadUrl() {
        let url = CollectionInfo.mocked.collectionItems.first!.webImage.url!
        let urlString: String = {
            var str = url.absoluteString
            str.removeLast()
            return str
        }()
        var serviceQuery: ServiceQuery?
        let service = Service()
        service.getDataClosure = { query, completion in
            serviceQuery = query
        }
        let sut = makeSut(service: service)

        sut.loadCollectionItemImageData(from: url, scale: .thumbnail) { _ in }

        XCTAssertTrue(serviceQuery?.getUrl()?.absoluteString.contains(urlString) == true)
    }

    func test_loadCollectionItemImageData_onLoadImage_tellsServiceToLoadScale() {
        let url = CollectionInfo.mocked.collectionItems.first!.webImage.url!
        let scale = CollectionImageLoadingScale.thumbnail
        var serviceQuery: ServiceQuery?
        let service = Service()
        service.getDataClosure = { query, completion in
            serviceQuery = query
        }
        let sut = makeSut(service: service)

        sut.loadCollectionItemImageData(from: url, scale: scale) { _ in }

        XCTAssertTrue(serviceQuery?.getUrl()?.absoluteString.contains("s\(scale.rawValue)") == true)
    }

    func test_loadCollectionItemImageData_onLoadImage_onSuccessGivesImageData() {
        let url = CollectionInfo.mocked.collectionItems.first!.webImage.url!
        let imageData = Data(count: 2)
        var loadedImageResult: CollectionImageLoadingResult?
        let scale = CollectionImageLoadingScale.thumbnail
        let service = Service()
        service.getDataClosure = { query, completion in
            completion(.success(imageData))
        }
        let sut = makeSut(service: service)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.loadCollectionItemImageData(from: url, scale: scale) {
            loadedImageResult = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(loadedImageResult, .success(imageData))
    }

    func test_loadCollectionItemImageData_onLoadImage_onFailureGivesError() {
        let url = CollectionInfo.mocked.collectionItems.first!.webImage.url!
        let error = ServiceLoadingError.invalidQuery
        var loadedImageResult: CollectionImageLoadingResult?
        let scale = CollectionImageLoadingScale.thumbnail
        let service = Service()
        service.getDataClosure = { query, completion in
            completion(.failure(error))
        }
        let sut = makeSut(service: service)

        let expectation = XCTestExpectation(description: "\(#file) \(#function) \(#line)")
        sut.loadCollectionItemImageData(from: url, scale: scale) {
            loadedImageResult = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)

        XCTAssertEqual(loadedImageResult, .failure(.serviceError(error)))
    }
}

extension CollectionInfo {
    static var mocked: CollectionInfo {
        let image = CollectionInfo.Art.ImageInfo(
            guid: "bbd1fae8-4023-4859-8ed1-d38616aec96c",
            offsetPercentageX: 0,
            offsetPercentageY: 1,
            width: 5656,
            height: 4704,
            url: "https://lh3.googleusercontent.com/J-mxAE7CPu-DXIOx4QKBtb0GC4ud37da1QK7CzbTIDswmvZHXhLm4Tv2-1H3iBXJWAW_bHm7dMl3j5wv_XiWAg55VOM=s0")
        let arts = Array(repeating: CollectionInfo.Art(links: ["String" : "String"],
                                                       id: "en-SK-C-5",
                                                       objectNumber: "SK-C-5",
                                                       title: "The Night Watch",
                                                       hasImage: true,
                                                       principalOrFirstMaker: "Principal",
                                                       longTitle: "The Night Watch, Rembrandt van Rijn, 1642",
                                                       showImage: true,
                                                       permitDownload: true,
                                                       webImage: image,
                                                       headerImage: image,
                                                       productionPlaces: ["Place"]),
                         count: 3)

        return CollectionInfo(
            elapsedMilliseconds: 0,
            count: UInt64(arts.count),
            artObjects: arts)
    }
}

extension CollectionPage: Equatable {
    public static func == (lhs: CollectionPage, rhs: CollectionPage) -> Bool {
        lhs.title == rhs.title &&
        lhs.items == rhs.items
    }
}

extension CollectionPage.CollectionItem: Equatable {
    public static func == (lhs: CollectionPage.CollectionItem, rhs: CollectionPage.CollectionItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.webImage == rhs.webImage &&
        lhs.headerImage == rhs.headerImage
    }
}

extension CollectionPage.CollectionItem.Image: Equatable {
    public static func == (lhs: CollectionPage.CollectionItem.Image, rhs: CollectionPage.CollectionItem.Image) -> Bool {
        lhs.guid == rhs.guid &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.url == rhs.url
    }
}

extension CollectionLoadingError: Equatable {
    public static func == (lhs: CollectionLoadingError, rhs: CollectionLoadingError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

extension CollectionImageLoadingError: Equatable {
    public static func == (lhs: CollectionImageLoadingError, rhs: CollectionImageLoadingError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

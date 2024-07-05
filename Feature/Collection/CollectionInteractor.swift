import Foundation

enum CollectionError: Error {
    case loading(error: CollectionLoadingError)
}

enum CollectionImageDataError: Error {
    case loading(error: CollectionImageLoadingError)
}

typealias CollectionResult = Result<CollectionPage, CollectionError>
typealias CollectionResultHandler = (CollectionResult) -> Void

typealias CollectionImageDataResult = Result<Data, CollectionImageDataError>
typealias CollectionImageDataResultHandler = (CollectionImageDataResult) -> Void

protocol CollectionInteracting {
    func loadCollection(page: Int, count: Int, completion: @escaping CollectionResultHandler)
    func loadCollectionItemImageData(from url: URL, completion: @escaping CollectionImageDataResultHandler)
}

class CollectionInteractor: CollectionInteracting {

    let gateway: ArtGateway

    init(gateway: ArtGateway) {
        self.gateway = gateway
    }

    func loadCollection(page: Int, count: Int, completion: @escaping CollectionResultHandler) {

        gateway.loadCollection(page: page, count: count) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(info):
                    let title = "Page \(page)"
                    let collectionPage = CollectionPage(title: title, items: info.collectionItems)
                    completion(.success(collectionPage))
                case let .failure(error):
                    completion(.failure(.loading(error: error)))
                }
            }
        }
    }

    func loadCollectionItemImageData(from url: URL, completion: @escaping CollectionImageDataResultHandler) {
        gateway.loadCollectionImageData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(.loading(error: error)))
                }
            }
        }
    }
}

extension CollectionInfo {
    typealias CollectionItem = CollectionPage.CollectionItem


    var collectionItems: [CollectionItem] {
        artObjects.map {
            CollectionItem(
                id: $0.objectNumber,
                title: $0.title,
                description: $0.longTitle,
                webImage: $0.webImage?.collectionItemImage,
                headerImage: $0.headerImage?.collectionItemImage
            )
        }
    }
}

extension CollectionInfo.Art.ImageInfo {
    typealias Image = CollectionPage.CollectionItem.Image
    var collectionItemImage: Image {
        Image(
            guid: guid,
            width: width,
            height: height,
            url: url.flatMap { URL(string: $0) }
        )
    }
}

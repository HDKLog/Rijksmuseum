import Foundation

protocol CollectionPresenting {
    func loadCollection()

    func numberOfPages() -> Int
    func numberOfItems(on page: Int) -> Int
    
    func itemModel(at indexPath: IndexPath, completion: @escaping (CollectionViewCellModel) ->Void)
    func headerModel(on page: Int, completion: @escaping (CollectionViewHeaderModel) ->Void)
    func chooseItem(at indexPath: IndexPath)

    func loadNextPage()
}

class CollectionPresenter: CollectionPresenting {

    let view: CollectionView!
    let interactor: CollectionInteracting!
    var router: CollectionRouting?

    var currentPage: Int = 1
    let resultsOnPage: Int = 30

    var collectionPages: [CollectionPage] = []

    init(view: CollectionView, interactor: CollectionInteracting) {
        self.view = view
        self.interactor = interactor
    }

    func loadCollection() {
        view.configure(with: .loadingModel)
        interactor.loadCollection(page: currentPage, count: resultsOnPage) { [weak self] result in
            switch result {
            case let .success(pageInfo):
                self?.view.configure(with: .loadSuccessModel)
                self?.updateNext(page: pageInfo)
            case let .failure(error):
                self?.view.configure(with: .loadFailModel)
                self?.view.displayError(error: error)
            }
        }
    }

    func numberOfPages() -> Int {
        collectionPages.count
    }

    func numberOfItems(on page: Int) -> Int {
        collectionPages[page].items.count
    }

    func itemModel(at indexPath: IndexPath, completion: @escaping (CollectionViewCellModel) ->Void) {

        let page = indexPath.section
        let index = indexPath.row
        let item = collectionPages[page].items[index]
        guard let url = item.webImage?.url
        else {
            completion(CollectionViewCellModel(tileModel: .init(imageData: Data(), title: item.title)))
            return
        }
        
        interactor.loadCollectionItemImageData(from: url) {[weak self] result in
            switch result {
            case let .success(data):
                completion(CollectionViewCellModel(tileModel: .init(imageData: data, title: item.title)))
            case let .failure(error):
                self?.view.displayError(error: error)
                self?.itemModel(at: indexPath, completion: completion)
            }
        }
    }

    func headerModel(on page: Int, completion: @escaping (CollectionViewHeaderModel) ->Void) {
        completion(CollectionViewHeaderModel(title: collectionPages[page].title))
    }

    func chooseItem(at indexPath: IndexPath) {
        let page = indexPath.section
        let itemIndex = indexPath.row
        let item = collectionPages[page].items[itemIndex]
        router?.routeToArtDetail(artId: item.id)
    }

    func loadNextPage() {
        interactor.loadCollection(page: currentPage, count: resultsOnPage) { [weak self] result in
            switch result {
            case let .success(pageInfo):
                self?.updateNext(page: pageInfo)
            case let .failure(error):
                self?.view.displayError(error: error)
                self?.loadNextPage()
            }
        }
    }

    private func updateNext(page: CollectionPage) {
        collectionPages.append(page)
        view.updateCollection()
        currentPage += 1
    }
}

extension CollectionViewModel {
    static var loadingModel: CollectionViewModel {
        CollectionViewModel(title: "Collection", animatingLoad: true, firstScreenText: "Loading")
    }

    static var loadSuccessModel: CollectionViewModel {
        CollectionViewModel(title: "Collection", animatingLoad: false, firstScreenText: nil)
    }

    static var loadFailModel: CollectionViewModel {
        CollectionViewModel(title: "Collection", animatingLoad: false, firstScreenText: "Fail to load. Tap to retry")
    }
}

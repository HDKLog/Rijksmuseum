import UIKit
import SkeletonView

protocol ArtDetailsView {
    func configure(with model: ArtDetailsViewModel.InitialInfo)
    func updateDetails(with model: ArtDetailsViewModel.ArtDetails)
    func updateImage(with data: Data)
}

class ArtDetailsViewController: UIViewController, ArtDetailsView {
    var presenter: ArtDetailsPresenting?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "test_image")!
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.loadView()
    }

    private func setup() {
        view.backgroundColor = DesignBook.Color.Background.main.uiColor()
        setupImageView()
    }

    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2)
        ])
    }

    func configure(with model: ArtDetailsViewModel.InitialInfo) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "◀︎ \(model.backButtonTitle)",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToCollection))
        

    }

    func updateDetails(with model: ArtDetailsViewModel.ArtDetails) {

    }

    func updateImage(with data: Data) {
        imageView.image = UIImage(data: data)
    }

    @objc
    func backToCollection(sender: AnyObject) {
        presenter?.routBack()
    }
}

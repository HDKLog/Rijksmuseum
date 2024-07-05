import UIKit
import SkeletonView

@MainActor
protocol ArtDetailsView {
    func configure(with model: ArtDetailsViewModel.InitialInfo)
    func updateDetails(with model: ArtDetailsViewModel.ArtDetails)
    func updateImage(with data: Data)
    func displayError(error: Error)
}

class ArtDetailsViewController: UIViewController, ArtDetailsView {
    var presenter: ArtDetailsPresenting?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: DesignBook.Layout.Sizes.Text.Font.large)
        return label
    }()

    let descriptionView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: DesignBook.Layout.Sizes.Text.Font.medium)
        return label
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.loadView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.showAnimatedGradientSkeleton()
        contentView.showAnimatedGradientSkeleton()
        presenter?.loadArt()
    }

    private func setup() {
        setupViews()

        setupAnimation()
    }

    private func setupViews() {
        view.backgroundColor = DesignBook.Color.Background.main.uiColor
        setupScrollView()
        setupContentView()
        setupImageView()
        setupInfoViews()
    }


    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: DesignBook.Layout.Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -DesignBook.Layout.Spacing.medium),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -DesignBook.Layout.Spacing.small)
        ])
    }

    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/3)
        ])
    }

    private func setupInfoViews() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: DesignBook.Layout.Spacing.large),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        contentView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DesignBook.Layout.Spacing.medium),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }

    private func setupAnimation() {
        contentView.isSkeletonable = true

        titleLabel.skeletonTextNumberOfLines = .custom(1)
        titleLabel.lastLineFillPercent = 70
        titleLabel.isSkeletonable = true

        descriptionView.skeletonTextNumberOfLines = .custom(4)
        descriptionView.lastLineFillPercent = 70
        descriptionView.isSkeletonable = true

        imageView.isSkeletonable = true
    }

    func configure(with model: ArtDetailsViewModel.InitialInfo) {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: model.backButtonTitle,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToCollection))

    }

    func updateDetails(with model: ArtDetailsViewModel.ArtDetails) {
        contentView.hideSkeleton()
        titleLabel.text = model.title
        descriptionView.text = model.description
    }

    func updateImage(with data: Data) {
        imageView.image = UIImage(data: data)
        imageView.hideSkeleton()
    }

    func displayError(error: Error) {
        let alert = ErrorAlertView(error: error)
        self.present(alert, animated: true, completion: nil)
    }

    @objc
    func backToCollection(sender: AnyObject) {
        presenter?.routBack()
    }
}

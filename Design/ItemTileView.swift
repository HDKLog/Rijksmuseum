import UIKit
import SkeletonView


class ItemTileView: UIView {
    struct Model: Hashable {
        let imageData: Data
        let title: String
        var borderWidth: CGFloat = 1
        var borderColor: DesignBookColor = DesignBook.Color.Background.light
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = DesignBook.Color.Foreground.inverse.uiColor
        label.font = UIFont.systemFont(ofSize: DesignBook.Layout.Sizes.Text.Font.small)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentViews()
        setupSkeletonAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContentViews()
        setupSkeletonAnimation()
    }

    private func setupContentViews() {
        
        addSubview(imageView)
        setupImageViewConstraints()

        addSubview(descriptionLabel)
        setupDescriptionLabelConstraints()

    }

    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func setupDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: DesignBook.Layout.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignBook.Layout.Spacing.small),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignBook.Layout.Spacing.small),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DesignBook.Layout.Spacing.small)
        ])
    }

    private func setupSkeletonAnimation() {
        isSkeletonable = true

        imageView.isSkeletonable = true

        descriptionLabel.isSkeletonable = true
        descriptionLabel.skeletonTextNumberOfLines = .custom(1)
    }

    func configure(with model: Model?) {
        imageView.image = model.flatMap { UIImage(data: $0.imageData) }
        descriptionLabel.text = model?.title

        model.flatMap {
            layer.borderWidth = $0.borderWidth
            layer.borderColor = $0.borderColor.cgColor
        }
        setAnimation(enabled: model == nil)
    }

    private func setAnimation(enabled: Bool) {
        if enabled {
            showAnimatedGradientSkeleton()
        } else {
            hideSkeleton()
        }
    }
}

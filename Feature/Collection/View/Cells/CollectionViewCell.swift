import UIKit
import SkeletonView

class CollectionViewCell: UICollectionViewCell {

    static let reusableId = "CollectionViewCell"

    let itemTileView: ItemTileView = ItemTileView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupItemTileViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.contentView.addSubview(itemTileView)
    }

    private func setupItemTileViewConstraints() {
        itemTileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemTileView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemTileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemTileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemTileView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with model: CollectionViewCellModel) {
        contentView.hideSkeleton()
        itemTileView.configure(with: model.tileModel)
    }

    override func prepareForReuse() {
        contentView.showAnimatedGradientSkeleton()
        itemTileView.configure(with: nil)
    }
}

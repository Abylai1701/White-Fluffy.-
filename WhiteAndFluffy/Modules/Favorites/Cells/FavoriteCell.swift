import UIKit
import Kingfisher

class FavoriteCell: UITableViewCell {
    
    let image = UIImageView()
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        addSubview(image)

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.heightAnchor.constraint(equalToConstant: 300)
        ])

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 24),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        layer.cornerRadius = 8
        clipsToBounds = true
    }

    func configure(with photo: MyPhoto) {
        if let url = photo.imageUrl {
            if let url = URL(string: url) {
                image.kf.setImage(with: url)
            }
        }
        label.text = photo.username
    }
}

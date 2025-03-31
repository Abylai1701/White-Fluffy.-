//
//  PhotoCell.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 30.03.2025.
//

import Foundation
import Kingfisher

class PhotoCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.frame = bounds
    }
    
    func configure(with photo: UnsplashPhoto) {
        if let url = URL(string: photo.urls.regular) {
            imageView.kf.setImage(with: url)
        }
    }
}

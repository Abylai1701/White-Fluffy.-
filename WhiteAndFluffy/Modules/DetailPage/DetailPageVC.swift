//
//  DetailPageVC.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation
import UIKit
import Kingfisher

final class DetailPageVC: BaseController {
    
    //MARK: - Properties
    var photo: UnsplashPhoto
    var viewModel: DetailPageViewModelProtocol
    
    private lazy var backImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "back")
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        return view
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    private lazy var favoriteImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "favorite")
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFavourite)))
        return view
    }()
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    private lazy var countOfDownloadesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    //MARK: - Init
    init(photo: UnsplashPhoto, viewModel: DetailPageViewModelProtocol) {
        self.viewModel = viewModel
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.checkIfPhotoIsInCoreData(photo: photo)
        configure()
        setupViews()
    }
    
    private func bind() {
        viewModel.favoriteCheck
            .sink { isInCoreData in
                if isInCoreData {
                    self.favoriteImage.image = UIImage(named: "favorite_fill")
                } else {
                    self.favoriteImage.image = UIImage(named: "favorite")
                }
            }
            .store(in: &viewModel.cancellables)
    }
    @objc func tapBack() {
        viewModel.backToMain()
    }
    @objc func tapFavourite() {
        if viewModel.inCoreData {
            viewModel.removeFromFavorites(photo: photo)
        } else {
            viewModel.savePhoto(photo: photo) {
                self.showSuccessMessage()
            }
        }
    }
    //MARK: - SetupViews
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(backImage,
                         authorLabel,
                         favoriteImage,
                         coverImageView,
                         dateLabel,locationLabel,
                         countOfDownloadesLabel)
        backImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            backImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backImage.widthAnchor.constraint(equalToConstant: 24),
            backImage.heightAnchor.constraint(equalToConstant: 24)
        ])

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            favoriteImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteImage.widthAnchor.constraint(equalToConstant: 24),
            favoriteImage.heightAnchor.constraint(equalToConstant: 24)
        ])

        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: favoriteImage.bottomAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            coverImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        countOfDownloadesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countOfDownloadesLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            countOfDownloadesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
    }

    private func configure() {
        
        authorLabel.text = photo.user.username
        if let url = URL(string: photo.urls.regular) {
            coverImageView.kf.setImage(with: url)
        }

        if let formattedDate = viewModel.formatDate(from: photo.created_at.description) {
            dateLabel.text = "Дата создания: \(formattedDate)"
        } else {
            dateLabel.text = "Дата создания: Неизвестна"
        }
        
        if let location = photo.location?.name {
            locationLabel.text = "Местоположение: \(location)"
        } else {
            locationLabel.text = "Местоположение: Неизвестно"
        }
        
        if let count = photo.downloads {
            countOfDownloadesLabel.text = "Количество скачиваний: \(count)"
        } else {
            countOfDownloadesLabel.text = "Количество скачиваний: Неизвестно"
        }
    }
}

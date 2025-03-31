//
//  FavoritesVC.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation
import UIKit
import Combine

class FavoritesVC: BaseController {
    
    var viewModel: FavoritesViewModelProtocol
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "У вас нет избранных фотографий"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FavoriteCell.self,
                       forCellReuseIdentifier: FavoriteCell.cellId)
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPhotos()
    }
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        viewModel.photosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateEmptyLabelVisibility()
                self.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateEmptyLabelVisibility() {
        emptyLabel.isHidden = !viewModel.photos.isEmpty
    }
}
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteCell.cellId,
            for: indexPath) as! FavoriteCell
        cell.configure(with: viewModel.photos[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToDetail(photo: viewModel.photos[indexPath.section])
    }
}

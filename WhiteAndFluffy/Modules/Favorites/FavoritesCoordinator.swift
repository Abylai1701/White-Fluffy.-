//
//  FavoritesCoordinator.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation

protocol FavoritesCoordinatorProtocol {
    func navigateToDetail(photo: MyPhoto)
}

final class FavoritesCoordinator: FavoritesCoordinatorProtocol {
   
    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }
    
    
    func navigateToDetail(photo: MyPhoto) {
        let location = PhotoLocation(name: photo.locationName, city: nil, country: nil)
        let urls = PhotoURLs(raw: "", full: "", regular: photo.imageUrl!, small: "", thumb: "")
        let link = UserLinks(html: "")
        let profile = ProfileImage(large: nil)
        let user = User(name: "1", username: photo.username ?? "Неизвестный автор", links: link, profile_image: profile)
        
        let photo = UnsplashPhoto(id: photo.id!, urls: urls, user: user, created_at: photo.createdAt ?? "", location: location, downloads: Int(photo.downloads), description: nil, alt_description: nil, likes: 0)
        
        
        let coordinator = DetailPageCoordinator(router: router)
        let viewModel = DetailPageViewModel(coordinator: coordinator)
        let vc = DetailPageVC(photo: photo, viewModel: viewModel)
        router.push(vc, animated: true)
    }
}

import Foundation
import UIKit

protocol MainPageCoordinatorProtocol {
    func navigateToDetail(photo: UnsplashPhoto)
}

final class MainPageCoordinator: MainPageCoordinatorProtocol {
   
    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }
    
    func navigateToDetail(photo: UnsplashPhoto) {
        let coordinator = DetailPageCoordinator(router: router)
        let viewModel = DetailPageViewModel(coordinator: coordinator)
        let vc = DetailPageVC(photo: photo, viewModel: viewModel)
        router.push(vc, animated: true)
    }
}

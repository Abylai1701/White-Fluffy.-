import Foundation
import Alamofire
import Combine

protocol DetailPageViewModelProtocol: AnyObject {
    func savePhoto(photo: UnsplashPhoto,completion: @escaping (()->()))
    func removeFromFavorites(photo: UnsplashPhoto)
    var inCoreData: Bool { get set }
    func backToMain()
    func formatDate(from dateString: String) -> String?
    
    var cancellables: Set<AnyCancellable> { get set }
    var favoriteCheck: AnyPublisher<Bool, Never> { get }
    func checkIfPhotoIsInCoreData(photo: UnsplashPhoto)
}

final class DetailPageViewModel: DetailPageViewModelProtocol {
    var cancellables = Set<AnyCancellable>()
    
    private let _inCoreData = CurrentValueSubject<Bool, Never>(false)
    var favoriteCheck: AnyPublisher<Bool, Never> {
        _inCoreData.eraseToAnyPublisher()
    }
    
    var inCoreData: Bool {
        get { _inCoreData.value }
        set { _inCoreData.value = newValue }
    }
    
    private let coordinator: DetailPageCoordinatorProtocol
    private let networkService = UnsplashNetworkService()
    private let coreStore = CoreDataManager.shared
    
    
    init(coordinator: DetailPageCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Fetch Data
    
    func savePhoto(photo: UnsplashPhoto, completion: @escaping (()->())) {
        coreStore.savePhoto(photo) { [weak self] in
            guard let self else { return }
            self.inCoreData = true
            completion()
        }
    }
    
    func removeFromFavorites(photo: UnsplashPhoto) {
        coreStore.deletePhoto(by: photo.id) { [weak self] in
            guard let self else { return }
            self.inCoreData = false
        }
    }
    
    func backToMain() {
        coordinator.back()
    }
    
    func formatDate(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy 'года'"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        return outputFormatter.string(from: date)
    }
    
    // MARK: - Private Methods
    
    func checkIfPhotoIsInCoreData(photo: UnsplashPhoto) {
        coreStore.fetchPhotos { [weak self] photos in
            guard let self else { return }
            self.inCoreData = photos.contains { $0.id == photo.id }
        }
    }
}

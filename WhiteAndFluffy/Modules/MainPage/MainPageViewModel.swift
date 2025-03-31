import Combine
import Alamofire

protocol MainPageViewModelProtocol: AnyObject {
    var photos: [UnsplashPhoto] { get }
    var cancellables: Set<AnyCancellable> { get set }
    var photosPublisher: AnyPublisher<[UnsplashPhoto], Never> { get }
    
    func fetchRandomPhotos() async -> Bool
    func goToDetail(photo: UnsplashPhoto)
    
    func searchPhoto(value: String) async -> Bool
}

final class MainPageViewModel: MainPageViewModelProtocol {
    private let coordinator: MainPageCoordinatorProtocol
    private let networkService = UnsplashNetworkService()
    var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var photos: [UnsplashPhoto] = []
    
    var photosPublisher: AnyPublisher<[UnsplashPhoto], Never> {
        $photos.eraseToAnyPublisher()
    }
    
    init(coordinator: MainPageCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: - Fetch Data
    
    func fetchRandomPhotos() async -> Bool {
        do {
            let newPhotos = try await networkService.fetchRandomPhotos()
            DispatchQueue.main.async {
                self.photos = newPhotos
            }
            return true
        } catch {
            print("Error fetching photos: \(error.localizedDescription)")
            return false
        }
    }
    func searchPhoto(value: String) async -> Bool {
        do {
            let newPhotos = try await networkService.searchPhotos(query: value)
            DispatchQueue.main.async {
                self.photos = newPhotos
            }
            return true
        } catch {
            print("Error fetching photos: \(error.localizedDescription)")
            return false
        }
    }
    func goToDetail(photo: UnsplashPhoto) {
        coordinator.navigateToDetail(photo: photo)
    }
}

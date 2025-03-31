//
//  FavoritesViewModel.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation
import CoreData
import Combine

protocol FavoritesViewModelProtocol: AnyObject {
    var photos: [MyPhoto] { get }
    var cancellables: Set<AnyCancellable> { get set }
    var photosPublisher: AnyPublisher<[MyPhoto], Never> { get }
    func fetchPhotos()
    func goToDetail(photo: MyPhoto)
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
    private let coordinator: FavoritesCoordinatorProtocol
    private let coreStore = CoreDataManager.shared
    var cancellables = Set<AnyCancellable>()

    @Published private(set) var photos: [MyPhoto] = []
    var photosPublisher: AnyPublisher<[MyPhoto], Never> {
        $photos.eraseToAnyPublisher()
    }
    
    
    init(coordinator: FavoritesCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func fetchPhotos() {
        let context = coreStore.context
        let fetchRequest: NSFetchRequest<MyPhoto> = MyPhoto.fetchRequest()
        
        do {
            let photos = try context.fetch(fetchRequest)
            self.photos = photos
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }
    
    func goToDetail(photo: MyPhoto) {
        coordinator.navigateToDetail(photo: photo)
    }
}

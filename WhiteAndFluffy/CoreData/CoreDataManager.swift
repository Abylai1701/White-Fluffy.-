//
//  CoreDataManager.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation
import CoreData

protocol CoreDataProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    func saveContext(completion: @escaping () -> Void)
    func savePhoto(_ photo: UnsplashPhoto, completion: @escaping () -> Void)
    func fetchPhotos(completion: @escaping ([MyPhoto]) -> Void)
    func deletePhoto(by id: String, completion: @escaping () -> Void)
}

class CoreDataManager: CoreDataProtocol {
    
    static let shared = CoreDataManager(modelName: "WhiteAndFluffy")
    
    private let persistentContainer: NSPersistentContainer
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: Инициализатор для тестов
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(completion: @escaping () -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPhotos(completion: @escaping ([MyPhoto]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest: NSFetchRequest<MyPhoto> = MyPhoto.fetchRequest()
            do {
                let tasks = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Failed to fetch tasks: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    
    func savePhoto(_ photo: UnsplashPhoto, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let myPhoto = MyPhoto(context: self.context)
            myPhoto.id = photo.id
            myPhoto.downloads = Int32(photo.downloads ?? 0)
            myPhoto.createdAt = photo.created_at
            myPhoto.imageUrl = photo.urls.regular
            myPhoto.locationName = photo.location?.name
            myPhoto.username = photo.user.name
            DispatchQueue.main.async {
                self.saveContext(completion: completion)
            }
        }
    }
    
    func deletePhoto(by id: String, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchRequest: NSFetchRequest<MyPhoto> = MyPhoto.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                if let photoToDelete = try self.context.fetch(fetchRequest).first {
                    self.context.delete(photoToDelete)
                    
                    DispatchQueue.main.async {
                        self.saveContext {
                            print("Deleted photo with id: \(id)")
                            completion()
                        }
                    }
                } else {
                    print("Photo with id: \(id) not found.")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } catch {
                print("Failed to delete photo: \(error.localizedDescription)")
                
                self.context.rollback()
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}

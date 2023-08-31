//
//  CoreDataService.swift
//  TravelGenie
//
//  Created by summercat on 2023/08/22.
//

import CoreData
import Foundation

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private lazy var persistentContainer: NSPersistentContainer = {        
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage \(error)")
            }
        }
        
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: Internal
    
    func save(entityName: String, values: [String: Any]) throws -> NSManagedObject? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return nil
        }

        let managedObject = NSManagedObject(entity: entityDescription, insertInto: context)
        values.forEach { (key, value) in
            managedObject.setValue(value, forKey: key)
        }
        try self.saveContext()
        
        return managedObject
    }
    
    func fetch<T>(request: NSFetchRequest<T>, predicate: NSPredicate? = nil) throws -> [T] {
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        let data = try context.fetch(request)
        
        return data
    }
    
    func deleteChat(
        with id: UUID,
        completion: @escaping (Result<Bool, Error>) -> Void)
    {
        let request: NSFetchRequest = ChatEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let targetObjects = try context.fetch(request)
            targetObjects.forEach {
                context.delete($0)
            }
            try saveContext()
            completion(.success(true))
        } catch {
            completion(.failure(StorageError.noResultForID))
        }
    }
    
    // MARK: Private
    
    private func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw StorageError.coreDataSaveFailure(error)
            }
        }
    }
}

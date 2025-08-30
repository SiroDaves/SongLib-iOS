//
//  CoreDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SongLib")
        
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("❌ Failed to load Core Data stack: \(error)")
            }

            if let dbPath = description.url?.path {
                print("📦 Core Data SQLite DB path:\n\(dbPath)")
            } else {
                print("⚠️ Could not determine Core Data DB path")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func nextId(context: NSManagedObjectContext, entity: String) -> Int32 {
        let fetch: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: entity)
        fetch.resultType = .dictionaryResultType
        
        let expression = NSExpressionDescription()
        expression.name = "maxId"
        expression.expression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: "id")])
        expression.expressionResultType = .integer64AttributeType
        fetch.propertiesToFetch = [expression]
        
        do {
            if let result = try context.fetch(fetch).first,
               let maxId = result["maxId"] as? Int32 {
                return maxId + 1
            }
        } catch {
            print("⚠️ Error fetching max id: \(error)")
        }
        
        return 1
    }
}

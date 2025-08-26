//
//  ListedDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class ListedDataManager {
    private let coreDataManager: CoreDataManager
        
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save record to Core Data
    func saveListed(_ listed: Listed) {
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CDListed> = CDListed.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", listed.id as CVarArg)
                
                let existingRecords = try self.context.fetch(fetchRequest)
                let cdListed: CDListed
                
                if let existingRecord = existingRecords.first {
                    cdListed = existingRecord
                } else {
                    cdListed = CDListed(context: self.context)
                }
                
                cdListed.id = listed.id
                cdListed.parentId = listed.parentId
                cdListed.songId = Int32(listed.songId)
                cdListed.title = listed.title
                cdListed.createdAt = listed.createdAt
                
                try self.context.save()
            } catch {
                print("❌ Failed to save listedes: \(error)")
            }
        }
    }
    
    // Fetch all records from Core Data
    func fetchListeds() -> [Listed] {
        let fetchRequest: NSFetchRequest<CDListed> = CDListed.fetchRequest()
        do {
            let cdListedes = try context.fetch(fetchRequest)
            return cdListedes.compactMap { cdListed in
                return Listed(
                    id: cdListed.id!,
                    title: cdListed.title ?? "",
                    createdAt: cdListed.createdAt!
                )
            }
        } catch {
            print("❌ Failed to fetch listedes: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchListed(withId id: UUID) -> Listed? {
        let fetchRequest: NSFetchRequest<CDListed> = CDListed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdListed = results.first else { return nil }
            
            return Listed(
                id: cdListed.id!,
                title: cdListed.title ?? "",
                createdAt: cdListed.createdAt!
            )
        } catch {
            print("❌ Failed to fetch listed: \(error)")
            return nil
        }
    }
    
    // Delete a record by ID
    func deleteListed(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDListed> = CDListed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listedId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let listedToDelete = results.first {
                context.delete(listedToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete listed: \(error)")
        }
    }
    
    func deleteAllListeds() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDListed.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listeds deleted successfully")
        } catch {
            print("❌ Failed to delete listeds: \(error)")
        }
    }
}

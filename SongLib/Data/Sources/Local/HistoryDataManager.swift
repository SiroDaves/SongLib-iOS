//
//  HistoryDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class HistoryDataManager {
    private let coreDataManager: CoreDataManager
        
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save record to Core Data
    func saveHistory(_ history: History) {
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", history.id as CVarArg)
                
                let existingRecords = try self.context.fetch(fetchRequest)
                let cdHistory: CDHistry
                
                if let existingRecord = existingRecords.first {
                    cdHistory = existingRecord
                } else {
                    cdHistory = CDHistry(context: self.context)
                }
                
                cdHistory.id = history.id
                cdHistory.songId = Int32(history.songId)
                cdHistory.createdAt = history.createdAt
                
                try self.context.save()
            } catch {
                print("❌ Failed to save historyes: \(error)")
            }
        }
    }
    
    // Fetch all records from Core Data
    func fetchHistories() -> [History] {
        let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
        do {
            let cdHistoryes = try context.fetch(fetchRequest)
            return cdHistoryes.compactMap { cdHistory in
                return History(
                    id: cdHistory.id!,
                    songId: Int(cdHistory.songId),
                    createdAt: cdHistory.createdAt!
                )
            }
        } catch {
            print("❌ Failed to fetch historyes: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchHistory(withId id: UUID) -> History? {
        let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdHistory = results.first else { return nil }
            
            return History(
                id: cdHistory.id!,
                songId: Int(cdHistory.songId),
                createdAt: cdHistory.createdAt!
            )
        } catch {
            print("❌ Failed to fetch history: \(error)")
            return nil
        }
    }
    
    // Delete a record by ID
    func deleteHistory(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "historyId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let historyToDelete = results.first {
                context.delete(historyToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
    func deleteAllHistories() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDHistry.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All histories deleted successfully")
        } catch {
            print("❌ Failed to delete histories: \(error)")
        }
    }
}

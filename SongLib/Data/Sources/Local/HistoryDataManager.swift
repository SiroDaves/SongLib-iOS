//
//  HistoryDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class HistoryDataManager {
    private let cdManager: CoreDataManager
        
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        return cdManager.viewContext
    }
    
    func saveHistory(songId: Int) {
        context.perform {
            do {
                let cdHistory = CDHistry(context: self.context)
                cdHistory.id = self.cdManager.nextId(context: self.context, entity: "CDHistry")
                cdHistory.songId = Int32(songId)
                cdHistory.createdAt = Date()
                
                try self.context.save()
            } catch {
                print("❌ Failed to save history: \(error)")
            }
        }
    }
    
    func fetchHistories() -> [History] {
        let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
        do {
            let cdHistoryes = try context.fetch(fetchRequest)
            return cdHistoryes.compactMap { cdHistory in
                return History(
                    id: Int(cdHistory.id),
                    songId: Int(cdHistory.songId),
                    createdAt: cdHistory.createdAt!
                )
            }
        } catch {
            print("❌ Failed to fetch historyes: \(error)")
            return []
        }
    }
    
    func fetchHistory(withId id: UUID) -> History? {
        let fetchRequest: NSFetchRequest<CDHistry> = CDHistry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdHistory = results.first else { return nil }
            
            return History(
                id: Int(cdHistory.id),
                songId: Int(cdHistory.songId),
                createdAt: cdHistory.createdAt!
            )
        } catch {
            print("❌ Failed to fetch history: \(error)")
            return nil
        }
    }
    
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

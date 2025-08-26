//
//  SearchDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class SearchDataManager {
    private let coreDataManager: CoreDataManager
        
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save record to Core Data
    func saveSearch(_ search: Search) {
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", search.id as CVarArg)
                
                let existingRecords = try self.context.fetch(fetchRequest)
                let cdSearch: CDSearch
                
                if let existingRecord = existingRecords.first {
                    cdSearch = existingRecord
                } else {
                    cdSearch = CDSearch(context: self.context)
                }
                
                cdSearch.id = search.id
                cdSearch.title = search.title
                cdSearch.createdAt = search.createdAt
                
                try self.context.save()
            } catch {
                print("❌ Failed to save searches: \(error)")
            }
        }
    }
    
    // Fetch all records from Core Data
    func fetchSearches() -> [Search] {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        do {
            let cdSearches = try context.fetch(fetchRequest)
            return cdSearches.compactMap { cdSearch in
                return Search(
                    id: cdSearch.id!,
                    title: cdSearch.title ?? "",
                    createdAt: cdSearch.createdAt!
                )
            }
        } catch {
            print("❌ Failed to fetch searches: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchSearch(withId id: UUID) -> Search? {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSearch = results.first else { return nil }
            
            return Search(
                id: cdSearch.id!,
                title: cdSearch.title ?? "",
                createdAt: cdSearch.createdAt!
            )
        } catch {
            print("❌ Failed to fetch search: \(error)")
            return nil
        }
    }
    
    // Delete a record by ID
    func deleteSearch(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let searchToDelete = results.first {
                context.delete(searchToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete search: \(error)")
        }
    }
    
    func deleteAllSearches() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSearch.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All searches deleted successfully")
        } catch {
            print("❌ Failed to delete searches: \(error)")
        }
    }
}

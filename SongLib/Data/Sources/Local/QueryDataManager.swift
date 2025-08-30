//
//  QueryDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class QueryDataManager {
    private let cdManager: CoreDataManager
        
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        return cdManager.viewContext
    }
    
    func saveQuery(_ title: String) {
        context.perform {
            do {
                let cdQuery = CDQuery(context: self.context)
                cdQuery.id = self.cdManager.nextId(context: self.context, entity: "CDQuery")
                cdQuery.title = title
                cdQuery.created = Date()
                
                try self.context.save()
            } catch {
                print("❌ Failed to save queries: \(error)")
            }
        }
    }
    
    func fetchQueries() -> [Query] {
        let fetchRequest: NSFetchRequest<CDQuery> = CDQuery.fetchRequest()
        do {
            let cdQueries = try context.fetch(fetchRequest)
            return cdQueries.compactMap { cdQuery in
                return Query(
                    id: Int(cdQuery.id),
                    title: cdQuery.title ?? "",
                    created: cdQuery.created!
                )
            }
        } catch {
            print("❌ Failed to fetch queries: \(error)")
            return []
        }
    }
    
    func fetchQuery(withId id: Int) -> Query? {
        let fetchRequest: NSFetchRequest<CDQuery> = CDQuery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdQuery = results.first else { return nil }
            
            return Query(
                id: Int(cdQuery.id),
                title: cdQuery.title ?? "",
                created: cdQuery.created!
            )
        } catch {
            print("❌ Failed to fetch query: \(error)")
            return nil
        }
    }
    
    func deleteQuery(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDQuery> = CDQuery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let queryToDelete = results.first {
                context.delete(queryToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete query: \(error)")
        }
    }
    
    func deleteAllQueries() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDQuery.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All queries deleted successfully")
        } catch {
            print("❌ Failed to delete queries: \(error)")
        }
    }
}

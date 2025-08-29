//
//  SongViewDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class SongViewDataManager {
    private let cdManager: CoreDataManager
        
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        return cdManager.viewContext
    }
    
    func saveView(_ songId: Int) {
        context.perform {
            do {
                let cdView = CDSongView(context: self.context)
                cdView.id = self.cdManager.nextId(context: self.context, entity: "CDSongView")
                cdView.song = Int32(songId)
                cdView.created = Date()
                
                try self.context.save()
            } catch {
                print("❌ Failed to save view: \(error)")
            }
        }
    }
    
    func fetchViews() -> [SongView] {
        let fetchRequest: NSFetchRequest<CDSongView> = CDSongView.fetchRequest()
        do {
            let cdViewes = try context.fetch(fetchRequest)
            return cdViewes.compactMap { cdView in
                return SongView(
                    id: Int(cdView.id),
                    song: Int(cdView.song),
                    created: cdView.created!
                )
            }
        } catch {
            print("❌ Failed to fetch song views: \(error)")
            return []
        }
    }
    
    func fetchView(withId id: Int) -> SongView? {
        let fetchRequest: NSFetchRequest<CDSongView> = CDSongView.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdView = results.first else { return nil }
            
            return SongView(
                id: Int(cdView.id),
                song: Int(cdView.song),
                created: cdView.created!
            )
        } catch {
            print("❌ Failed to fetch song view: \(error)")
            return nil
        }
    }
    
    func deleteView(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSongView> = CDSongView.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let viewToDelete = results.first {
                context.delete(viewToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete song view: \(error)")
        }
    }
    
    func deleteAllViews() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSongView.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All song views deleted successfully")
        } catch {
            print("❌ Failed to delete song views: \(error)")
        }
    }
}

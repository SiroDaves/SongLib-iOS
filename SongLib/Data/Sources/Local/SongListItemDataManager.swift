//
//  SongListItemDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 30/08/2025.
//

import CoreData

class SongListItemDataManager {
    private let cdManager: CoreDataManager
    
    init(cdManager: CoreDataManager = .shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        cdManager.viewContext
    }
    
    func saveListItem(_ parent: Int, song: Int) {
        context.perform {
            do {
                let cdListItem = CDSongListItem(context: self.context)
                cdListItem.id = self.cdManager.nextId(context: self.context, entity: "CDSongListItem")
                cdListItem.parent = Int32(parent)
                cdListItem.song = Int32(song)
                cdListItem.created = Date()
                cdListItem.modified = Date()
                
                try self.context.save()
                print("✅ New list item \(song) saved")
            } catch {
                print("❌ Failed to save list item \(error)")
            }
        }
    }
    
    func fetchListItems(with parent: Int = 0) -> [SongListItem] {
        let request: NSFetchRequest<CDSongListItem> = CDSongListItem.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %d", parent)

        do {
            let cdListItems = try context.fetch(request)
            return cdListItems.compactMap(mapCDListItem)
        } catch {
            print("❌ Failed to fetch items: \(error)")
            return []
        }
    }

    func fetchListItem(with id: Int) -> SongListItem? {
        do {
            guard let cdListItem = try fetchCDListItem(with: id) else { return nil }
            return SongListItem(
                id: Int(cdListItem.id),
                parent: Int(cdListItem.parent),
                song: Int(cdListItem.song),
                created: cdListItem.created!,
                modified: cdListItem.modified!
            )
        } catch {
            print("❌ Failed to fetch item with ID \(id): \(error)")
            return nil
        }
    }
    
    func updateListItem(_ item: SongListItem) {
        context.perform {
            do {
                guard let cdListItem = try self.fetchCDListItem(with: item.id) else {
                    print("⚠️ SongListItem with ID \(item.id) not found.")
                    return
                }
                cdListItem.parent = Int32(item.parent)
                cdListItem.song = Int32(item.song)
                cdListItem.modified = Date()
                try self.context.save()
            } catch {
                print("❌ Failed to update item \(item.id): \(error)")
            }
        }
    }
    
    func deleteListItem(with id: Int) {
        context.perform {
            do {
                guard let cdListItem = try self.fetchCDListItem(with: id) else { return }
                self.context.delete(cdListItem)
                try self.context.save()
            } catch {
                print("❌ Failed to delete item with ID \(id): \(error)")
            }
        }
    }
    
    func deleteAllListItems() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSongListItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All items deleted successfully")
        } catch {
            print("❌ Failed to delete items: \(error)")
        }
    }
    
    func deleteListItems(with id: Int) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSongListItem.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All items deleted successfully")
        } catch {
            print("❌ Failed to delete items: \(error)")
        }
    }
    
    private func mapCDListItem(_ cdListItem: CDSongListItem) -> SongListItem? {
        return SongListItem(
            id: Int(cdListItem.id),
            parent: Int(cdListItem.parent),
            song: Int(cdListItem.song),
            created: cdListItem.created!,
            modified: cdListItem.modified!,
        )
    }
    
    private func fetchCDListItem(with id: Int) throws -> CDSongListItem? {
        let request: NSFetchRequest<CDSongListItem> = CDSongListItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id )
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchOrCreateCDListItem(with id: Int) throws -> CDSongListItem {
        if let existing = try fetchCDListItem(with: id) {
            return existing
        } else {
            return CDSongListItem(context: context)
        }
    }
}

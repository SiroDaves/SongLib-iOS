//
//  ListingDataManager.swift
//  ListingLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class SongListingDataManager {
    private let cdManager: CoreDataManager
    
    init(cdManager: CoreDataManager = .shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        cdManager.viewContext
    }
    
    func saveListing(_ parent: Int, title: String) {
        context.perform {
            do {
                let cdListing = CDSongListing(context: self.context)
                cdListing.id = self.cdManager.nextId(context: self.context, entity: "CDSongListing")
                cdListing.parent = Int32(parent)
                cdListing.title = title
                cdListing.created = Date()
                cdListing.modified = Date()
                
                try self.context.save()
                print("✅ New listing \(title) saved")
            } catch {
                print("❌ Failed to save listing: \(error)")
            }
        }
    }
    
    func fetchListings(with parent: Int = 0) -> [SongListing] {
        let request: NSFetchRequest<CDSongListing> = CDSongListing.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %d", parent)

        do {
            let cdListings = try context.fetch(request)
            return cdListings.compactMap(mapCDListing)
        } catch {
            print("❌ Failed to fetch listings: \(error)")
            return []
        }
    }

    func fetchListing(with id: Int) -> SongListing? {
        do {
            guard let cdListing = try fetchCDListing(with: id) else { return nil }
            return SongListing(
                id: Int(cdListing.id),
                parent: Int(cdListing.parent),
                title: cdListing.title!,
                created: cdListing.created!,
                modified: cdListing.modified!
            )
        } catch {
            print("❌ Failed to fetch listing with ID \(id): \(error)")
            return nil
        }
    }
    
    func updateListing(_ listing: SongListing) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(with: listing.id) else {
                    print("⚠️ SongListing with ID \(listing.id) not found.")
                    return
                }
                cdListing.title = listing.title
                cdListing.modified = Date()
                try self.context.save()
            } catch {
                print("❌ Failed to update listing \(listing.id): \(error)")
            }
        }
    }
    
    func deleteListing(with id: Int) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(with: id) else { return }
                self.context.delete(cdListing)
                try self.context.save()
            } catch {
                print("❌ Failed to delete listing with ID \(id): \(error)")
            }
        }
    }
    
    func deleteAllListings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSongListing.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listings deleted successfully")
        } catch {
            print("❌ Failed to delete listings: \(error)")
        }
    }
    
    func deleteListings(with id: Int) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSongListing.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listings deleted successfully")
        } catch {
            print("❌ Failed to delete listings: \(error)")
        }
    }
    
    private func mapCDListing(_ cdListing: CDSongListing) -> SongListing? {
        let songCount = fetchChildListingCount(for: Int(cdListing.id))
        return SongListing(
            id: Int(cdListing.id),
            parent: Int(cdListing.parent),
            title: cdListing.title ?? "Untitled listing",
            created: cdListing.created!,
            modified: cdListing.modified!,
            songCount: songCount
        )
    }
    
    private func fetchChildListingCount(for parent: Int) -> Int {
        let request: NSFetchRequest<CDSongListItem> = CDSongListItem.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %d", parent)
        do {
            return try context.count(for: request)
        } catch {
            print("❌ Failed to count child listings for parent \(parent): \(error)")
            return 0
        }
    }

    private func fetchCDListing(with id: Int) throws -> CDSongListing? {
        let request: NSFetchRequest<CDSongListing> = CDSongListing.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id )
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchOrCreateCDListing(with id: Int) throws -> CDSongListing {
        if let existing = try fetchCDListing(with: id) {
            return existing
        } else {
            return CDSongListing(context: context)
        }
    }
}

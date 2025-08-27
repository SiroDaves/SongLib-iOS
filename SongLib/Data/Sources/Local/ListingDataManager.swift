//
//  ListingDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class ListingDataManager {
    private let coreDataManager: CoreDataManager
        
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // Access to the view context
    private var context: NSManagedObjectContext {
        return coreDataManager.viewContext
    }
    
    // Save record to Core Data
    func saveListing(_ listing: Listing) {
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<CDListing> = CDListing.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", listing.id as CVarArg)
                
                let existingRecords = try self.context.fetch(fetchRequest)
                let cdListing: CDListing
                
                if let existingRecord = existingRecords.first {
                    cdListing = existingRecord
                } else {
                    cdListing = CDListing(context: self.context)
                }
                
                cdListing.id = listing.id
                cdListing.parentId = listing.parentId
                cdListing.songId = Int32(listing.songId)
                cdListing.title = listing.title
                cdListing.createdAt = listing.createdAt
                
                try self.context.save()
            } catch {
                print("❌ Failed to save listings: \(error)")
            }
        }
    }
    
    // Fetch all records from Core Data
    func fetchListings() -> [Listing] {
        let fetchRequest: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        do {
            let cdListings = try context.fetch(fetchRequest)
            return cdListings.compactMap { cdListing in
                return Listing(
                    id: cdListing.id!,
                    parentId: cdListing.parentId!,
                    songId: Int(cdListing.songId),
                    title: cdListing.title ?? "",
                    createdAt: cdListing.createdAt!,
                    updatedAt: cdListing.updatedAt!
                )
            }
        } catch {
            print("❌ Failed to fetch listings: \(error)")
            return []
        }
    }
    
    // Fetch a single record by ID
    func fetchListing(withId id: UUID) -> Listing? {
        let fetchRequest: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdListing = results.first else { return nil }
            
            return Listing(
                id: cdListing.id!,
                parentId: cdListing.parentId!,
                songId: Int(cdListing.songId),
                title: cdListing.title ?? "Untitled Listing",
                createdAt: cdListing.createdAt!,
                updatedAt: cdListing.updatedAt!
            )
        } catch {
            print("❌ Failed to fetch listing: \(error)")
            return nil
        }
    }
    
    func updateListing(_ listing: Listing) {
        context.perform {
            do {
                guard let cdListing = try self.fetchListing(withId: listing.id) else {
                    print("⚠️ Listing with ID \(listing.id) not found.")
                    return
                }
                cdListing.parentId = listing.parentId
                cdListing.title = listing.title
                cdListing.songId = listing.songId
                try self.context.save()
            } catch {
                print("❌ Failed to update listing \(listing.id): \(error)")
            }
        }
    }
    
    // Delete a record by ID
    func deleteListing(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listingId == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let listingToDelete = results.first {
                context.delete(listingToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete listing: \(error)")
        }
    }
    
    func deleteAllListings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDListing.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listings deleted successfully")
        } catch {
            print("❌ Failed to delete listings: \(error)")
        }
    }
}
